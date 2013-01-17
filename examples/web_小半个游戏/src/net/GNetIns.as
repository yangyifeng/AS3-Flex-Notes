package net
{
	import flash.utils.Dictionary;
	import net.CSocket;
	
	public class GNetIns
	{	
		public static var gm_socket:CSocket = new CSocket();

		//游戏服务器套接字
//		public static var gm_socket:CSocket = new CSocket();
		
		//聊天服务器套接字
//		public static var gc_socket:CSocket = new CSocket();
		
		//客户端cookie
		public static var cookie:Object = {};
		
		public static function _del():void
		{

			
//			gm_socket = null;

//			gc_socket = null;
		}
		public function GNetIns()
		{
		}			
	}
	
}