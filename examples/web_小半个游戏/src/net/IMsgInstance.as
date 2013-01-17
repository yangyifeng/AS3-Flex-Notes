package net
{
	import flash.utils.Dictionary;

	public interface IMsgInstance
	{
		//消息接口
		function message(msg_id:int, event:*, target:*):void;
		//注册鼠标
		function register_mouse(ident:* = null):void;
		//注销鼠标
		function unregister_mouse(ident:* = null):void;
		//鼠标是否已注册
		function mouse_registered(ident:* = null):Boolean;
		//注册键盘
		function register_keyboard(ident:* = null):void;
		//注销键盘
		function unregister_keyboard(ident:* = null):void;
		//键盘是否已注册
		function keyboard_registered(ident:* = null):Boolean;
		//设置定时器
		function set_timer(type:int, times:int, ident:* = null):void;
		//杀死定时器
		function kill_timer(ident:* = null):void;
		//定时器是否设置
		function timer_set(ident:* = null):Boolean;
	}
}