package net
{
	public class GNetCfg
	{
		//网络消息ID定义
		public static var MSG_NET_CONNECTED:int	   = 300; //已连接
		public static var MSG_NET_CLOSED:int	  	   = 301; //已断开
		public static var MSG_NET_HEART_BEAT:int     = 302; //心跳
		public static var MSG_NET_SECURITY_ERROR:int = 303; //网络安全错误
		
		public static var NET_TIMEOUT:int   = 1; //网络超时
		public static var NET_RETRY_NUM:int = 3; //网络重试次数
		
		public static var NET_HEART_BEAT_INTERVAL:int = 30; //心跳间隔
		
		public static var COMMAND_OVERDUE_TIME:int = 300; //指令失效时间
		
		public function GNetCfg()
		{
		}
	}
}