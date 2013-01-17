package com.common
{
	/**
	 * 强制进行垃圾回收 
	 * 
	 */
	import flash.net.LocalConnection;

	public class ModuleGC
	{
		public function ModuleGC()
		{
		}
		/**
		 * 垃圾清理
		 * 使用localconnection使得fp内部出现异常，并触发fp的gc
		 */
		public static function gc():void
		{
			try {
				new LocalConnection().connect("ModuleGC");
				new LocalConnection().connect("ModuleGC");
			}catch (e:Error) {
				
			}
		}

	}
}