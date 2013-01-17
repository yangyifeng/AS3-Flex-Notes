package com.common
{
	import flash.display.Sprite;
	
	import mx.controls.Image;
	
	import spark.components.HGroup;
	
	public class PrintLuck extends Sprite
	{
		//运气分为11级，从0~10，用5颗星来表示，如3级为一颗半星。
		[Embed(source="images/ico/xing0.png")]public var xing0:Class;
		[Embed(source="images/ico/xingban.png")]public var xingban:Class;
		[Embed(source="images/ico/xing1.png")]public var xing1:Class;
		
		public function PrintLuck(box:HGroup, value:Number)
		{
			var x1:Image = new Image();
			var x2:Image = new Image();
			var x3:Image = new Image();
			var x4:Image = new Image();
			var x5:Image = new Image();
			
			switch(value)
			{				
				case 1:
					x1.source = xingban;
					x2.source = xing0;
					x3.source = xing0;
					x4.source = xing0;
					x5.source = xing0;
					break;
				case 2:
					x1.source = xing1;
					x2.source = xing0;
					x3.source = xing0;
					x4.source = xing0;
					x5.source = xing0;
					break;
				case 3:
					x1.source = xing1;
					x2.source = xingban;
					x3.source = xing0;
					x4.source = xing0;
					x5.source = xing0;
					break;
				case 4:
					x1.source = xing1;
					x2.source = xing1;
					x3.source = xing0;
					x4.source = xing0;
					x5.source = xing0;
					break;
				case 5:
					x1.source = xing1;
					x2.source = xing1;
					x3.source = xingban;
					x4.source = xing0;
					x5.source = xing0;
					break;
				case 6:
					x1.source = xing1;
					x2.source = xing1;
					x3.source = xing1;
					x4.source = xing0;
					x5.source = xing0;
					break;
				case 7:
					x1.source = xing1;
					x2.source = xing1;
					x3.source = xing1;
					x4.source = xingban;
					x5.source = xing0;
					break;
				case 8:
					x1.source = xing1;
					x2.source = xing1;
					x3.source = xing1;
					x4.source = xing1;
					x5.source = xing0;
					break;
				case 9:
					x1.source = xing1;
					x2.source = xing1;
					x3.source = xing1;
					x4.source = xing1;
					x5.source = xingban;
					break;
				case 10:
					x1.source = xing1;
					x2.source = xing1;
					x3.source = xing1;
					x4.source = xing1;
					x5.source = xing1;
					break;
				default:
					x1.source = xing0;
					x2.source = xing0;
					x3.source = xing0;
					x4.source = xing0;
					x5.source = xing0;
					break;
			}
			box.removeAllElements();
			box.addElement(x1);
			box.addElement(x2);
			box.addElement(x3);
			box.addElement(x4);
			box.addElement(x5);
		}
	}
}