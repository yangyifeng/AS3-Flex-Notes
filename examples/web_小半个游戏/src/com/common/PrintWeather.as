package com.common
{
	import flash.display.Sprite;	
	import mx.controls.Image;
	
	public class PrintWeather extends Sprite
	{
		/*
		1	酷热
		2	晴天
		3	多云
		4	阴天
		5	小雨
		6	大雨
		7	暴雨
		8	台风
		9	小雪
		10	大雪*/
		[Embed(source="images/weather/tianqi01.gif")]public var wea01:Class;
		[Embed(source="images/weather/tianqi02.gif")]public var wea02:Class;
		[Embed(source="images/weather/tianqi03.gif")]public var wea03:Class;
		[Embed(source="images/weather/tianqi04.gif")]public var wea04:Class;
		[Embed(source="images/weather/tianqi05.gif")]public var wea05:Class;
		[Embed(source="images/weather/tianqi06.gif")]public var wea06:Class;
		[Embed(source="images/weather/tianqi07.gif")]public var wea07:Class;
		[Embed(source="images/weather/tianqi08.gif")]public var wea08:Class;
		[Embed(source="images/weather/tianqi09.gif")]public var wea09:Class;
		[Embed(source="images/weather/tianqi10.gif")]public var wea10:Class;
		
		public function PrintWeather(image:Image,weather:Number)
		{
			switch(weather)
			{
				case 1:
					image.source = wea01;
					break;
				case 2:
					image.source = wea02;
					break;
				case 3:
					image.source = wea03;
					break;
				case 4:
					image.source = wea04;
					break;
				case 5:
					image.source = wea05;
					break;
				case 6:
					image.source = wea06;
					break;
				case 7:
					image.source = wea07;
					break;
				case 8:
					image.source = wea08;
					break;
				case 9:
					image.source = wea09;
					break;
				default:
					image.source = wea10;
					break;
				
			}
		}
	}
}