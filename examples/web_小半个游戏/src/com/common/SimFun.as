package com.common
{
	import com.common.Ccontect;
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	import mx.controls.Alert;
	import mx.controls.Image;
	import mx.core.IFlexDisplayObject;
	import mx.events.EffectEvent;
	import mx.managers.PopUpManager;
	
	import spark.components.Label;
	import spark.effects.Fade;
	
	public class SimFun
	{
		//城镇名，临时使用
		public static var cityArr:Object = {102:"容桂",103:"虎门",104:"古镇",105:"三角",106:"中山",107:"三乡",108:"唐家",109:"珠海",110:"澳门",111:"横琴"};
		
		//从地址获取信息
		public static function URLGet(url:String, callback:Function):void
		{
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.load(new URLRequest(url));
			urlLoader.addEventListener(Event.COMPLETE, callback);
		}
		
		//渐隐渐现
		public static function FadeEffect(obj:Object, tOrF:Boolean, effect_end_fn:Function):void
		{
			var fade:Fade = new Fade(obj);
			if(tOrF == true)
			{
				fade.alphaFrom = 0;
				fade.alphaTo = 1;
			}
			else
			{
				fade.alphaFrom = 1;
				fade.alphaTo = 0;				
			}
			fade.addEventListener(EffectEvent.EFFECT_END, function():void{effect_end_fn();});
			fade.duration = 500;
			fade.play();			
		}
		//调试
		public static function traceObject(obj:*,level:int=0,output:String=""):*
		{
			var tabs:String = "";
			for(var i:int=0; i<=level; i++, tabs+="\t"){
				for(var child:* in obj){
					output += tabs +"["+ child +"] => "+obj[child];
					var childOutput:String=traceObject(obj[child], level+1);
					if(childOutput!=''){
						output+=' {\n'+childOutput+tabs +'}';
					}
					output += "\n";
				}
				return output;
			}
		}
		//运输倒计时
		public static function timeRunDown(box:Label, time:Number, maintain_time:Number, fault_time:Number, timer:Timer, callBack:Function):void
		{
			var s_hour:Number, s_minute:Number, s_second:Number, s_remain:Number;
			var show_maintain:Number = time - maintain_time;
			var stop_fault:Number = time - fault_time;			
			
			timer.addEventListener(TimerEvent.TIMER, function(event:TimerEvent):void{ 
				var k:int = box.parent.getChildIndex(box);
				time--;
				if(time < 0)
				{
					callBack();
					timer.removeEventListener(TimerEvent.TIMER, arguments.callee);  
					timer.stop();  
					timer = null;
					box.visible = false;
					//显示点击交易					
					box.parent.getChildAt(k+1).visible = true;
				}
				else if(time == stop_fault)
				{
					Alert.show("你的交通工具需要维修啦！");
					box.parent.getChildAt(k+2).visible = true;
					box.parent.getChildAt(k+2).alpha = 1;
					(box.parent.getChildAt(k+2) as Image).enabled = true;
					(box.parent.getChildAt(k+2) as Image).buttonMode = true;
					box.parent.getChildAt(k+3).visible = false;
					timer.stop();
				}
				else
				{
					if(time == show_maintain)
					{
						Alert.show("你的交通工具需要保养啦！");
						box.parent.getChildAt(k+3).visible = true;
						box.parent.getChildAt(k+3).alpha = 1;
						(box.parent.getChildAt(k+3) as Image).enabled = true;
						(box.parent.getChildAt(k+3) as Image).buttonMode = true;
					}
					s_hour   = Math.floor(time / 3600);
					s_remain = Math.floor(time % 3600);			  
					s_minute = Math.floor(s_remain / 60);
					s_second = Math.floor(s_remain % 60);
					box.text = SimFun.formatNumber(s_hour,4) + ":" + SimFun.formatNumber(s_minute,2) + ":" + SimFun.formatNumber(s_second,2);
				}			
			});
			timer.start();
		}
		//停止所有运输倒计时()
		public static function stopAllRunDown(timerArr:Array):void
		{
			for(var i:int=0; i< timerArr.length; i++)
			{
				timerArr[i].removeEventListener(TimerEvent.TIMER, arguments.callee);  
				timerArr[i].stop();
				timerArr[i].reset();
				timerArr.splice(i,1);
				i--;				
			}
		}
		//格式化数字
		public static function formatNumber(number:Number, numdig:Number):String
		{
			var num:String = number.toString();
			var output:String = "";			
			for(var i:int=0; i< numdig-num.length; i++)
			{
				output += "0";
			}
			return output+num;
		}
		//弹出窗口(查看车辆具体信息)
		public static function openWindow(mc:IFlexDisplayObject,parent:DisplayObject):void
		{
			PopUpManager.addPopUp(mc,parent);
			PopUpManager.centerPopUp(mc);
			mc.alpha = 0;
			mc.y = -100;
			TweenLite.to(mc, 0.5, {x:0,y:0,alpha:1,ease:Back.easeInOut});
		}
		//关闭弹出窗口(查看车辆具体信息)
		public static function closeOpenWindow(mc:IFlexDisplayObject):void
		{
			TweenLite.to(mc, 0.5, {x:0,y:-100,alpha:0,ease:Back.easeInOut, onComplete:function():void{PopUpManager.removePopUp(mc);}});
		}
		//弹出窗口（使用卡片）
		public static function useCardWindow(mc:IFlexDisplayObject,parent:DisplayObject):void
		{
			PopUpManager.addPopUp(mc,parent);
			PopUpManager.centerPopUp(mc);
			mc.alpha = 0;
			mc.scaleX = 0.8;
			mc.scaleY = 1;
			TweenLite.to(mc, 0.5, {scaleX:1, scaleY:1,alpha:1, ease:Back.easeInOut});
			TweenLite.delayedCall(2,SimFun.closeUseCardWindow,[mc]);
		}
		//关闭弹出窗口（使用卡片）
		public static function closeUseCardWindow(mc:IFlexDisplayObject):void
		{
			TweenLite.to(mc, 0.5, {scaleX:1.2, scaleY:1,alpha:0, ease:Back.easeInOut,onComplete:function():void{PopUpManager.removePopUp(mc);}});
		}
		//点击地图弹出城市内容窗口
		public static function openCityWindow(mc:IFlexDisplayObject,parent:DisplayObject):void
		{
			PopUpManager.addPopUp(mc,parent);
			PopUpManager.centerPopUp(mc);
			mc.alpha = 0;
			mc.x = 100;
			TweenLite.to(mc, 0.5, {x:0,y:0,alpha:1,ease:Back.easeInOut});
		}
		//关闭点击地图弹出的城市内容窗口
		public static function closeOpenCityWindow(mc:IFlexDisplayObject):void
		{
			TweenLite.to(mc, 0.5, {x:-100,y:0,alpha:0,ease:Back.easeInOut, onComplete:function():void{PopUpManager.removePopUp(mc);}});
		}
		
		//将秒转化为时间格式
		public static function secondsToTimeFormat(time:Number):String
		{
			var s_hour:Number, s_minute:Number, s_second:Number, s_remain:Number;
			s_hour   = Math.floor(time / 3600);
			s_remain = Math.floor(time % 3600);			  
			s_minute = Math.floor(s_remain / 60);
			s_second = Math.floor(s_remain % 60);
			return SimFun.formatNumber(s_hour,4) + ":" + SimFun.formatNumber(s_minute,2) + ":" + SimFun.formatNumber(s_second,2);
		}
		
		//弹出窗口(结算获取金钱)
		public static function getMoneyWindow(mc:IFlexDisplayObject,parent:DisplayObject, _x:int, _y:int):void
		{
			PopUpManager.addPopUp(mc,parent);
			PopUpManager.centerPopUp(mc);
			mc.alpha = 1;
			mc.x = _x - 50;
			mc.y = _y - 20;
			TweenLite.to(mc, 4, {alpha:0, y:_y-80, onComplete:function():void{PopUpManager.removePopUp(mc);}});			
		}		
		
		//返回带符号的值的字符串
		public static function numberBack(_val:Number):String
		{
			var returnvalue:String;
			if(_val >=0 )
			{
				returnvalue = "+" + String(_val);
			}
			else
			{
				returnvalue = String(_val);
			}
			return returnvalue;
		}
	}
}