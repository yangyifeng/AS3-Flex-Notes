//消息元素类，供逻辑对象使用

package net
{
	import net.IMsgInstance;
	import net.IBaseObject;
	
	import flash.utils.Dictionary;
	
	public class CMsgObject implements IBaseObject, IMsgInstance
	{
		protected var m_n_handle:int = -1; //句柄
		
		protected var m_str_class:String = "CMsgObject";
		
		private static var m_dict_handle_instances:Dictionary = new Dictionary(); //handle与实例映射关系表
		
		private static var m_vec_handles:Vector.<int> = new Vector.<int>(); //保存handle
		
		private static var m_dict_event_target_handles:Dictionary = new Dictionary(); //事件目标与handle映射关系表
		
		private var m_c_event_target:* = null; //默认无事件目标
		
		protected var m_func_msg_callback:Function = null; //消息回调函数
		
		private var m_dict_msg_form:Dictionary = new Dictionary();	//消息注册表
		
		protected var m_n_id:int = -1;	//对象ID
		
		protected var m_n_sid:int = -1; //对象源ID
		
		protected var m_str_name:String = ""; //对象名称
		
		public function CMsgObject()
		{
			var size:int = m_vec_handles.length;
			
			//查找空缺位置
			var idx:int = m_vec_handles.indexOf(-1);
			
			if (idx != -1)
			{
				m_n_handle = idx;
				
				m_vec_handles[m_n_handle] = m_n_handle;
			}
			else
			{
				m_n_handle = size;
				
				m_vec_handles.push(m_n_handle);
			}
			
			m_dict_handle_instances[m_n_handle] = this;
		}
		//析构函数
		public function _del():void
		{
			clear_msgs();
			
			m_c_event_target = null;
			
			m_func_msg_callback = null;
			
			m_dict_msg_form = null;	
			
			m_vec_handles[m_n_handle] = -1;
			
			delete m_dict_handle_instances[m_n_handle];
		}
		public function register_mouse(ident:* = null):void
		{
//			GMsgIns.msg_mgr.register_mouse(m_n_handle);
		}
		public function unregister_mouse(ident:* = null):void
		{
//			GMsgIns.msg_mgr.register_mouse(m_n_handle);
		}
		public function mouse_registered(ident:* = null):Boolean
		{
//			return GMsgIns.msg_mgr.mouse_registered(m_n_handle);
			return false;
		}
		public function register_keyboard(ident:* = null):void
		{
//			GMsgIns.msg_mgr.register_keyboard(m_n_handle);
		}
		public function unregister_keyboard(ident:* = null):void
		{
//			GMsgIns.msg_mgr.unregister_keyboard(m_n_handle);
		}
		public function keyboard_registered(ident:* = null):Boolean
		{
//			return GMsgIns.msg_mgr.keyboard_registered(m_n_handle);
			return false;
		}
		public function set_timer(type:int, times:int, ident:* = null):void
		{
//			GMsgIns.msg_mgr.set_timer(type, times, m_n_handle);
		}
		public function kill_timer(ident:* = null):void
		{
//			GMsgIns.msg_mgr.kill_timer(m_n_handle);
		}
		public function timer_set(ident:* = null):Boolean
		{
//			return GMsgIns.msg_mgr.timer_set(m_n_handle);
			return false;
		}
		public function clear_msgs():void
		{
			//移除消息
			if (mouse_registered())
			{
				unregister_mouse();
			}
			
			if (keyboard_registered())
			{
				unregister_keyboard();
			}
			
			if (timer_set())
			{
				kill_timer();
			}
		}
		//设置消息回调函数
		public function set_msg_callback(callback:Function):void
		{
			m_func_msg_callback = callback;
		}
		//注册项
		public function register_msg_func(msg_id:int, func:Function):void
		{
			if (func == null)
			{
				return;
			}
			
			m_dict_msg_form[msg_id] = func;	
		}
		//注销项
		public function unregister_msg_func(msg_id:int):void
		{
			if (typeof(m_dict_msg_form[msg_id]) == "undefined")
			{
				return;
			}
			
			delete m_dict_msg_form[msg_id];
		}
		public function message(msg_id:int, event:*, target:*):void
		{
			//先回调
			if (m_func_msg_callback != null)
			{
				m_func_msg_callback(msg_id, event, target);
			}
			
			if (typeof(m_dict_msg_form[msg_id]) != "undefined")
			{
				m_dict_msg_form[msg_id](event, target);
			}
		}
		public function custom_message(msg_type:int, msg_info:String, from_handle:int = -1):void
		{
		}
		//删除所有静态成员信息
		public static function dispose():void
		{
			m_dict_handle_instances = null;
			
			m_vec_handles = null;
			
			m_dict_event_target_handles = null;
		}
		//根据handle获取实例
		public static function get_instance_by_handle(handle:int):CMsgObject
		{
	        if (typeof(m_dict_handle_instances[handle]) == "undefined")
	        {
	                return null;
	        }
			
			return m_dict_handle_instances[handle];
		}
		//获取handle
		public function get_handle():int
		{
			return m_n_handle;
		}
		//获取类别
		public function get_class():String
		{
			return m_str_class;
		}
		//检测handle是否合法
		public static function is_handle_valid(handle:int):Boolean
		{
			return typeof(m_dict_handle_instances[handle]) != "undefined";
		}
		//映射事件目标
		public function map_event_target(target:*):void
		{
			m_dict_event_target_handles[target] = m_n_handle;
			
			m_c_event_target = target;
		}
		//取消映射事件目标
		public function unmap_event_target(target:*):void
		{
			if (typeof(m_dict_event_target_handles[target]) == "undefined")
			{
			        return;
			}
			
			delete m_dict_event_target_handles[target];
			
			m_c_event_target = null;
		}
		//是否有事件目标
		public function get_event_target():*
		{
			return m_c_event_target;
		}
		//获取事件目标对应的handle
		public static function get_handle_by_event_target(target:*):int
		{
			if (typeof(m_dict_event_target_handles[target]) == "undefined")
			{
			        return -1;
			}
			
			return m_dict_event_target_handles[target];
		}
		//设置ID
		public function set_id(id:int):void
		{
			m_n_id = id;
		}
		//获取ID
		public function get_id():int
		{
			return m_n_id;
		}
		//设置源ID
		public function set_sid(sid:int):void
		{
			m_n_sid = sid;
		}
		//获取源ID
		public function get_sid():int
		{
			return m_n_sid;
		}
		//设置名称
		public function set_name(name:String):void
		{
			m_str_name = name;
		}
		//获取名称
		public function get_name():String
		{
			return m_str_name;
		}
	}
}