package com.common
{
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	
	import mx.controls.Image;
	
	import spark.components.HGroup;
	
	public class PrintNumber extends Sprite
	{
		[Embed(source="images/number/0.gif")]public var num0:Class;
		[Embed(source="images/number/1.gif")]public var num1:Class;
		[Embed(source="images/number/2.gif")]public var num2:Class;
		[Embed(source="images/number/3.gif")]public var num3:Class;
		[Embed(source="images/number/4.gif")]public var num4:Class;
		[Embed(source="images/number/5.gif")]public var num5:Class;
		[Embed(source="images/number/6.gif")]public var num6:Class;
		[Embed(source="images/number/7.gif")]public var num7:Class;
		[Embed(source="images/number/8.gif")]public var num8:Class;
		[Embed(source="images/number/9.gif")]public var num9:Class;		
		
		public function PrintNumber(box:HGroup,value:Number)
		{
			if(typeof(box) != "undefined")
			{
				box.removeAllElements();
				var valueArr:Array = String(value).split("");				
				for(var i:int=0; i<valueArr.length; i++)
				{
					var imgElem:Image = new Image();
					imgElem.source = changeNum(valueArr[i]);
					imgElem.filters = [new GlowFilter(0xFFFFFF,0.7)]
					box.addElement(imgElem);
				}
			}
		}
		private function changeNum(value:String):Class
		{
			switch(value)
			{					
				case "1":
					return num1;
					break;
				case "2":
					return num2;
					break;
				case "3":
					return num3;
					break;
				case "4":
					return num4;
					break;
				case "5":
					return num5;
					break;
				case "6":
					return num6;
					break;
				case "7":
					return num7;
					break;
				case "8":
					return num8;
					break;
				case "9":
					return num9;
					break;
				default:
					return num0;
					break;					
			}
		}
	}
}