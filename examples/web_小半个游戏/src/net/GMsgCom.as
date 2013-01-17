//公共接口

package net
{
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	public class GMsgCom
	{
		//设置毫秒计时器
		public static function set_ms_timer(milliseconds:int, repeat_count:int = 0, callback:Function = null, parameters:* = null):int
		{
			var handle:int = -1;
			
			var count:int = 0;
			
			function timer_handler():void
			{
				if (repeat_count)
				{
					count++;
					
					//计数满
					if (count == repeat_count)
					{
						clearInterval(handle);
						
						handle = -1;
					}
				}
				
				if (callback == null && count == 0)
				{
					return;
				}
				
				callback(parameters);
			}
			
			handle = setInterval(timer_handler, milliseconds);
			
			return handle;
		}
		public static function clear_ms_timer(handle:int):void
		{
			clearInterval(handle);
		}
		public function GMsgCom()
		{
		}
	}
}