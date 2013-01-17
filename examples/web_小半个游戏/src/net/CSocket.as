//网络套接字

package net
{
	
	import com.adobe.protocols.dict.Dict;
	
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;
	
	import net.CMsgObject;
	import net.GCommon;
	import net.GMsgCom;
	import net.IBaseObject;
	
	public class CSocket extends CMsgObject implements IBaseObject
	{
		private var PAK_IDENT_BEGIN:String = "(";
		private var PAK_IDENT_END:String   = ")";
		
		private var m_str_host:String = "";
		
		private var m_n_port:int = 0;
		
		private var m_c_socket:Socket = null;
		
		private var m_n_conn_timer:int = -1;
		
		private var m_b_connected:Boolean = false;
		
		private var m_b_connecting:Boolean = false;
		
		private var m_n_retry_count:int = 0;
		
		private var m_vec_unsent_commands:Vector.<Array> = new Vector.<Array>();
		
		private var m_n_heart_beat_timer:int = -1;
		
		private var m_n_heart_timeout_timer:int = -1;
		
		private var m_str_curr_data:String = "";
		
		private var m_str_remain_data:String = "";
		
//		private var m_ec:CLibInit = null;
//		private var m_ecobj:* = null;
//		private var m_ekey:String = "aaaadddd";

		
		public function CSocket()
		{
//			m_ec = new CLibInit;
//			m_ecobj = m_ec.init();
		}
		//析构函数
		override public function _del():void
		{
			if (m_c_socket != null)
			{
				close();
				
				m_c_socket.removeEventListener(Event.CONNECT, 						connect_handler);
				m_c_socket.removeEventListener(Event.CLOSE, 						close_handler);
				m_c_socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, 	security_error_handler);
				m_c_socket.removeEventListener(IOErrorEvent.IO_ERROR, 			   	io_error_handler);
				m_c_socket.removeEventListener(ProgressEvent.SOCKET_DATA, 			socket_data_handler);
				
				m_c_socket = null;
			}
			
			m_vec_unsent_commands = null;
			
			super._del();
		}
		//连接
		public function connect(host:String, port:int, retry_call:Boolean = false):void
		{
			//正在进行相同连接操作,返回
			if (m_b_connecting && m_str_host == host && m_n_port == port && !retry_call)
			{
				return;	
			}
			
			m_str_host = host;
			
			m_n_port = port;
			
			if (m_c_socket == null)
			{
				m_c_socket = new Socket();
				
				m_c_socket.addEventListener(Event.CONNECT, 						connect_handler);
				m_c_socket.addEventListener(Event.CLOSE, 						close_handler);
				m_c_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, 	security_error_handler);
				m_c_socket.addEventListener(IOErrorEvent.IO_ERROR, 			   	io_error_handler);
				m_c_socket.addEventListener(ProgressEvent.SOCKET_DATA, 			socket_data_handler);
			}
			else
			{
				close(retry_call);
			}
			
			if (m_n_conn_timer != -1)
			{
				GMsgCom.clear_ms_timer(m_n_conn_timer);
				
				m_n_conn_timer = -1;
			}
			
			//启动定时器
			m_n_conn_timer = GMsgCom.set_ms_timer(GNetCfg.NET_TIMEOUT * 1000, 1, connect_timeout);
			
			m_b_connected = false;
			
			m_b_connecting = true;
			
			if (!retry_call)
			{
				m_n_retry_count = 0;
			}
			
			//连接服务器
			m_c_socket.connect(host, port);
		}
		//关闭
		public function close(retry_call:Boolean = false):void
		{
			try
			{
				m_c_socket.close();
			}
			catch (error:Error)
			{
			}
			
			if (m_n_conn_timer != -1)
			{
				GMsgCom.clear_ms_timer(m_n_conn_timer);
				
				m_n_conn_timer = -1;
			}
			
			m_b_connected = false;
			
			m_b_connecting = false;
			
			if (retry_call)
			{
				return;
			}
			
			m_n_retry_count = 0;
		}
		//连接超时
		private function connect_timeout(parameters:* = null):void
		{
			m_n_conn_timer = -1;
			
			//已达最大重试次数，放弃
			if (m_n_retry_count == GNetCfg.NET_RETRY_NUM)
			{
				m_b_connecting = false;
				
				m_n_retry_count = 0;
				
				//通知已关闭
				message(GNetCfg.MSG_NET_CLOSED, null, null);
				
				return;
			}
			
			//重试连接
			connect(m_str_host, m_n_port, true);
			
			//累加重试次数
			m_n_retry_count++;
		}
		//心脏跳动
		private function heart_beat(parameters:* = null):void
		{
			//向服务端发送心跳请求
			var heart_data:String = '{"cookie":GNetIns.cookie,"msg_id":GNetCfg.MSG_NET_HEART_BEAT,"content":{}}';
			
//			heart_data = m_ecobj.set_decode(heart_data,heart_data.length,m_ekey);
			
			try
			{
				socket_write_short(GCommon.str_len(heart_data) + 2);
				
				m_c_socket.writeMultiByte(heart_data, "utf8");
				
//				m_c_socket.writeUTFBytes(heart_data);
				
				m_c_socket.flush();
			}
			catch (error:Error)
			{
				trace("心跳出错了!!!");
			}
		}
		//心脏回应
		private function heart_resp():void
		{
			if (m_n_heart_timeout_timer == -1)
			{
				return;
			}
			
			GMsgCom.clear_ms_timer(m_n_heart_timeout_timer);
			
			m_n_heart_timeout_timer = GMsgCom.set_ms_timer(GNetCfg.NET_HEART_BEAT_INTERVAL * 1300, 1, heart_timeout);
		}
		//心脏回应超时
		private function heart_timeout(parameters:* = null):void
		{
			m_n_heart_timeout_timer = -1;
			
			//清除心跳计时器
			if (m_n_heart_beat_timer != -1)
			{
				GMsgCom.clear_ms_timer(m_n_heart_beat_timer);
				
				m_n_heart_beat_timer = -1;
			}
			
			//自动重连
			connect(m_str_host, m_n_port);
		}
		//连接处理
		private function connect_handler(event:Event):void
		{
			if (m_n_conn_timer != -1)
			{
				GMsgCom.clear_ms_timer(m_n_conn_timer);
				
				m_n_conn_timer = -1;
			}
			
			m_b_connected = true;
			
			m_b_connecting = false;
			
			m_n_retry_count = 0;
			
			//清空数据
			m_str_curr_data = "";
			
			m_str_remain_data = "";
			
			//启动心跳计时
			heart_beat();
			
			m_n_heart_beat_timer = GMsgCom.set_ms_timer(GNetCfg.NET_HEART_BEAT_INTERVAL * 1000, 0, heart_beat);
			
			m_n_heart_timeout_timer = GMsgCom.set_ms_timer(GNetCfg.NET_HEART_BEAT_INTERVAL * 1300, 1, heart_timeout);
			
			//发送之前未成功的指令
			var i:int;
			
			var len:int = m_vec_unsent_commands.length;
			
			var net_closed:Boolean = false;
			
			for (i = 0; i < len; i++)
			{
				var command:Array = m_vec_unsent_commands[i];
				
				//超时指令，不发送
				if (GCommon.now() >= command[1])
				{
					continue;
				}
				
				try
				{
					socket_write_short(GCommon.str_len(command[0]) + 2);
					
					m_c_socket.writeMultiByte(command[0], "utf8");
				}
				catch (error:Error)
				{
					net_closed = true;
				}
			}
			
			if (net_closed)
			{
				//断线了	,重连
				connect(m_str_host, m_n_port);
				
				return;
			}
			
			//发送数据
			m_c_socket.flush();
			
			GCommon.vector_clear(m_vec_unsent_commands);
			
			//连接成功
			message(GNetCfg.MSG_NET_CONNECTED, event, null);
		}
		//关闭处理
		private function close_handler(event:Event):void
		{
		}
		//安全错误
		private function security_error_handler(event:Event):void
		{
			close();
			
			message(GNetCfg.MSG_NET_SECURITY_ERROR, event, null);
		}
		//IO错误
		private function io_error_handler(event:Event):void
		{
		}
		private function socket_write_short(value:int):void
		{
			m_c_socket.writeByte(value << 24 >> 24);
			m_c_socket.writeByte(value << 16 >> 24);
		}
		private function socket_read_short():int
		{
			var value0:int = m_c_socket.readUnsignedByte();
			var value1:int = m_c_socket.readUnsignedByte();
			
			return value1 << 8 | value0;
		}
		//发送数据
		public function send_data(msg_id:int, content:*):void
		{
			//同时发送cookie
			var data:String = '{"cookie":GNetIns.cookie, "msg_id":msg_id, "content":content}';
			
			data = GCommon.utf8ToUnicode(data);
//			data = m_ecobj.set_decode(data,data.length,m_ekey);
			
			try
			{
				socket_write_short(GCommon.str_len(data) + 2);
				
				m_c_socket.writeMultiByte(data, "utf8");
				
				m_c_socket.flush();
			}
			catch (error:Error)
			{
				//发送出错，则加入未发送列表
				m_vec_unsent_commands.push([data, GCommon.now() + GNetCfg.COMMAND_OVERDUE_TIME]);
				
				//启动重连
				connect(m_str_host, m_n_port);
			}
		}
		//接受数据处理
		private function socket_data_handler(event:ProgressEvent):void
		{
			if (!m_c_socket.connected)
			{
				return;
			}
			
			function parse_content():void
			{
				var struct:* = JSON.parse(m_str_curr_data);
				
				m_str_curr_data = "";
				
				if (typeof(struct["cookie"]) != "undefined")
				{
					//更新cookie信息
					var cookie:Object = struct["cookie"];
					
					var key:String;
					
					for (key in cookie)
					{
						GNetIns.cookie[key] = cookie[key];
					}
				}
				
				var msg_id:int = struct["msg_id"];
				
				if (msg_id == GNetCfg.MSG_NET_HEART_BEAT)
				{
					//心跳包回应
					heart_resp();
				}
				else
				{
					//调用函数
					message(msg_id, event, struct["content"]);
				}
			}
			
			while (m_c_socket.bytesAvailable)
			{
				m_str_curr_data += m_c_socket.readMultiByte(m_c_socket.bytesAvailable, "utf8");
			}
			
			if (!m_str_curr_data.length)
			{
				return;
			}
//			m_str_curr_data = m_ecobj.set_encode(m_str_curr_data,m_str_curr_data.length,m_ekey);
			
			function parse_data():void
			{
				if (m_str_curr_data.charAt(0) != PAK_IDENT_BEGIN)
				{
					return;
				}
				
				var end_idx:int = m_str_curr_data.indexOf(PAK_IDENT_END);
				
				if (end_idx == -1)
				{
					return;
				}
				
				var recv_data_len:int = m_str_curr_data.length;
				
				var remain_data_len:int = recv_data_len - end_idx - 1;
				
				if (remain_data_len)
				{
					m_str_remain_data = m_str_curr_data.substr(end_idx + 1, remain_data_len);
				}
				
				m_str_curr_data = m_str_curr_data.substr(1, end_idx - 1);
				
				parse_content();
				
				if (!remain_data_len)
				{
					return;
				}
				
				m_str_curr_data = m_str_remain_data;
				
				//递归解析数据
				parse_data();
			}
			
			parse_data();
		}
	}
}