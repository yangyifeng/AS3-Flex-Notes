package net
{
	import flash.errors.IOError;
	import flash.utils.Dictionary;
	import flash.utils.ByteArray;
	
	public class GCommon
	{
		public static var SORT_NUMERIC_ASC:int = 0;	//按数字升序排列
		public static var SORT_NUMERIC_DSC:int = 0;	//按数字降序排列
		
		//容器移除元素
		public static function vector_remove(vector:*, element:*):void
		{
			var idx:int = vector.indexOf(element);
			
			if (idx == -1)
			{
				return;
			}
			
			vector.splice(idx, 1);
		}
		//清除容器
		public static function vector_clear(vector:*):void
		{
			vector.splice(0, vector.length);
		}
		//容器升序排序
		public static function vector_sort(vector:*, type:int):void
		{
			switch (type)
			{
			case SORT_NUMERIC_ASC:
				{
					function compare_0(x:int, y:int):int
					{
						if (x < y)
						{
							return -1;
						}
						else
						if (x == y)
						{
							return 0;
						}
						
						return 1;
					}
					
					vector.sort(compare_0);
				}
				break;
			case SORT_NUMERIC_DSC:
				{
					function compare_1(x:int, y:int):int
					{
						if (x < y)
						{
							return 1;
						}
						else
						if (x == y)
						{
							return 0;
						}
						
						return -1;
					}
					
					vector.sort(compare_1);	
				}
				break;
			default:
				break;
			}
		}
		//深拷贝对象
		public static function clone(src:*):*
		{
			var tmp:ByteArray = new ByteArray();
			
			tmp.writeObject(src);
			
			tmp.position = 0;
			
			var des:* = tmp.readObject();
			
			tmp = null;
			
			return des;
		}
		//转为无符号整数
		public static function int2uint(num:int):int
		{
			if (num >= 0 )
			{
				return num;
			}
			
			var resp:uint = Math.abs(num) | (1 << 7);
			
			return resp;
		}
		public static function str_hash(str:String):int
		{
			var num:int = 0;
			
			var i:int;
			
			var len:int = str.length;
			
			for (i = 0; i < len; i++)
			{
				num = 31 * num + str.charCodeAt(i);
				num = (num & 0x7FFFFFFF);
			}
			
			return num;
		}
		//可能包含汉字
		public static function str_len(str:String):int
		{
			var tmp:ByteArray = new ByteArray();
			
			tmp.writeMultiByte(str, "utf8");
			
			return tmp.length;
		}
		//utf8数据转为unicode
		public static function utf8ToUnicode(data:String):String
		{
			var str:String = "";
			
			var i:int;
			
			var len:int = data.length;
			
			for (i = 0; i < len; i++)
			{
				if (data.charCodeAt(i) > 255)
				{
					str += ("\\u" + String(data.charCodeAt(i).toString(16)));
				}
				else
				{
					str += data.charAt(i);
				}
			}
			
			return str;
		}
		//拷贝文件
		public static function copy_file(src:String, des:String):Boolean
		{/*
			//文件保存，air使用
			import flash.filesystem.File;
			import flash.net.FileReference;
			
			var src_file:File = new File(src);
			
			var des_file_0:File = new File(des);
			
			var des_file_1:File = new File(des + "_tmp");
			
			try
			{
				//目标文件已存在
				des_file_0.copyTo(des_file_1, true);
				
				des_file_1.deleteFile();
				
				src_file = null;
				
				des_file_0 = null;
				
				des_file_1 = null;
				
				return false;
			}
			catch (error:IOError)
			{
			}
			
			try
			{
				src_file.copyTo(des_file_0, true);
				
				src_file = null;
				
				des_file_0 = null;
				
				des_file_1 = null;
			}
			catch (error:IOError)
			{
			}
			*/
			return true;
		}
		//删除文件
		public static function delete_file(path:String):Boolean
		{/*
			import flash.filesystem.File;
			
			var file:File = new File(path);
			
			try
			{
				file.deleteFile();
				
				file = null;
			}
			catch (error:IOError)
			{
				return false;
			}
			*/
			return true;
		}
		private static var date:Date = new Date();
		public static function now():int
		{
			return Math.floor(date.getTime() / 1000);
		}
		public function GCommon()
		{
		}
	}
}