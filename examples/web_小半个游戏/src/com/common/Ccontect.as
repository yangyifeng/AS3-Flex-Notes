package com.common
{
	import mx.controls.Alert;
	
	import net.CSocket;
	import net.GNetCfg;
	import net.GNetIns;
	
	public class Ccontect
	{
		public static var MSG_NET_USER_LOGIN:int 				= 0x11;		//登录		
		public static var MSG_NET_USER_REG:int 				= 0x31;		//注册角色
		public static var MSG_NET_USER_INF:int 				= 0x30;		//用户基本信息
		public static var MSG_NET_USER_ORDER:int 				= 0x32;		//排名
		public static var MSG_NET_USER_WEATHER:int 			= 0x33;		//天气
		public static var MSG_NET_USER_CHANGE:int 			= 0x34;		//切换用户
		public static var MSG_NET_SEND_ENDED:int 				= 0x00;		//切换用户完成
		public static var MSG_NET_USER_LOGOUT:int 			= 0x10;		//退出登陆协议号
		public static var MSG_NET_SHOW_QUEUE:int 				= 0x40;		//获取队列信息
		public static var MSG_NET_BUY_PARK:int 				= 0x01;		//购买车位
		public static var MSG_NET_SHOW_VEHICLES:int			= 0x41;		//get 运输工具
		public static var MSG_NET_BUY_VEHICLES:int			= 0x42;		//BUY 运输工具
		public static var MSG_NET_SHOW_CARDS:int				= 0x43;		//卡片列表
		public static var MSG_NET_BUY_CARDS:int				= 0x44;		//buy cards
		public static var MSG_NET_USE_CARDS:int				= 0x45;		//use cards
		public static var MSG_NET_GET_CITYINFOS:int			= 0x50;		//取城镇信息
		public static var MSG_NET_GET_FREE_QUEUE:int			= 0x51;		//取空闲工具
		public static var MSG_NET_CREATE_QUEUE:int			= 0x46;		//建立交易
		public static var MSG_NET_COMPLETE_QUEUE:int			= 0x47;		//完成交易
		public static var MSG_NET_SHOW_VEHICLES_INFOS:int		= 0x48;		//get 单个运输工具相关信息
		public static var MSG_NET_RENAME_VEHICLES:int			= 0x49;		//车辆改名
		public static var MSG_NET_DICE_VEHICLES:int			= 0x52;		//车辆丢弃
		public static var MSG_NET_SHOW_QUEUEINFOS:int			= 0x53;		//交易详情
		public static var MSG_NET_MODI_QUEUE:int				= 0x54;		//交易修改
		public static var MSG_NET_GET_CITYINFOS_BY_MODI:int	= 0x55;		//改道信息
		
		public function Ccontect(sip:String,sport:int,connectCallBack:Function, closedCallBack:Function, netTimeoutCallBack:Function)
		{
			GNetIns.gm_socket.connect(sip,sport);
			GNetIns.gm_socket.register_msg_func(GNetCfg.MSG_NET_CONNECTED, 		connectCallBack);
			GNetIns.gm_socket.register_msg_func(GNetCfg.MSG_NET_CLOSED, 		closedCallBack);
			//GNetIns.gm_socket.register_msg_func(GNetCfg.MSG_NET_SECURITY_ERROR, net_security_error_handler);
			//GNetIns.gm_socket.register_msg_func(GNetCfg.NET_TIMEOUT, 			netTimeoutCallBack);
		}
		/*
		private function net_connected_handler(event:*, target:*):void	{
		trace("已连接");
		}*/
		/*
		private function net_closed_handler(event:*, target:*):void	{
			Alert.show("暂时链接不上服务器");
		}*/
		/*
		private function net_security_error_handler(event:*, target:*):void	{
			trace("网络安全错误: "+event.text);
		}*/
		/*
		private function net_timeout_handler(event:*, target:*):void	{
			Alert.show("网络超时: "+event.text);
		}*/
		
		//登录
		public static function c2s_login(name:String,usertype:Number):void
		{
			GNetIns.gm_socket.send_data			( MSG_NET_USER_LOGIN,		{"name":name,"usertype":usertype});
		}
		//退出
		public static function c2s_loginout(uid:Number):void
		{
			GNetIns.gm_socket.send_data			( MSG_NET_USER_LOGOUT,		{"uid":uid});
		}		
		//创建角色
		public static function c2s_regist(username:String,rolename:String,usertype:Number,sex:Number,picture:String):void
		{
			GNetIns.gm_socket.send_data			( MSG_NET_USER_REG,			{"username":username,"rolename":rolename,"usertype":usertype,"sex":sex,"picture":picture});
		}		
		//用户基本信息
		public static function c2s_userinfo(uid:Number,target_uid:Number):void
		{
			GNetIns.gm_socket.send_data			( MSG_NET_USER_INF,			{"uid":uid,"target_uid":target_uid});
		}
		//排名
		public static function c2s_userorder(uid:Number,target_uid:Number):void
		{
			GNetIns.gm_socket.send_data			( MSG_NET_USER_ORDER,		{"uid":uid,"target_uid":target_uid});
		}
		//天气
		public static function c2s_userweather(uid:Number,target_uid:Number):void
		{
			GNetIns.gm_socket.send_data			( MSG_NET_USER_WEATHER,		{"uid":uid,"target_uid":target_uid});
		}
		//切换用户
		public static function c2s_userchange(uid:Number,target_uid:Number):void
		{
			GNetIns.gm_socket.send_data			( MSG_NET_USER_CHANGE,		{"uid":uid,"target_uid":target_uid});
		}
		//获取队列信息
		public static function c2s_showqueue(category:Number,page:Number,target_uid:Number):void
		{
			GNetIns.gm_socket.send_data			( MSG_NET_SHOW_QUEUE,		{"category":category,"page":page,"target_uid":target_uid});
		}
		//购买车位
		public static function c2s_buypark(category:Number,number:Number,target_uid:Number):void
		{
			GNetIns.gm_socket.send_data			( MSG_NET_BUY_PARK,		{"category":category,"number":number,"target_uid":target_uid});
		}
		//get 运输工具
		public static function c2s_getvehicles(seat_id:String,target_uid:Number):void
		{
			GNetIns.gm_socket.send_data			( MSG_NET_SHOW_VEHICLES,		{"seat_id":seat_id,"target_uid":target_uid});
		}
		//BUY 运输工具
		public static function c2s_buyvehicles(seat_id:String, car_id:String, buy_type:Number, target_uid:Number):void
		{
			
			GNetIns.gm_socket.send_data			( MSG_NET_BUY_VEHICLES,		{"seat_id":seat_id,"car_id":car_id,"buy_type":buy_type,"target_uid":target_uid});
		}
		//buy cards
		public static function c2s_buycards(card_id:Number, card_num:Number, buy_type:Number, target_uid:Number):void
		{
			GNetIns.gm_socket.send_data			( MSG_NET_BUY_CARDS,		{"card_id":card_id,"card_num":card_num,"buy_type":buy_type,"target_uid":target_uid});
		}
		//use cards
		public static function c2s_usecards(uid:Number, target_uid:Number, card_id:Number, seat_id:String, weat:Number, luck:Number, beau_id:Number, card_num:Number):void
		{
			GNetIns.gm_socket.send_data			( MSG_NET_USE_CARDS,		{"uid":uid,"target_uid":target_uid,"card_id":card_id,"seat_id":seat_id,"weat":weat,"luck":luck,"beau_id":beau_id,"card_num":card_num});
		}
		//取城镇信息
		public static function c2s_getcityinfos(city_id:Number, seat_id:String):void
		{
			GNetIns.gm_socket.send_data			( MSG_NET_GET_CITYINFOS,		{"city_id":city_id, "seat_id":seat_id});
		}
		//取空闲工具
		public static function c2s_getfreequeue(uid:Number, car_type:String, city_id:Number, good_id:Number):void
		{
			GNetIns.gm_socket.send_data			( MSG_NET_GET_FREE_QUEUE,		{"uid":uid, "car_type":car_type, "city_id":city_id, "good_id":good_id});
		}
		//建立交易
		public static function c2s_getcreatequeue(uid:Number,target_uid:Number,seat_id:String, good_id:Number, good_count:Number, leave_city:Number, arrive_city:Number):void
		{
			GNetIns.gm_socket.send_data			( MSG_NET_CREATE_QUEUE,		{"uid":uid,"target_uid":target_uid, "seat_id":seat_id, "good_id":good_id, "good_count":good_count, "leave_city":leave_city, "arrive_city":arrive_city});
		}
		//完成交易
		public static function c2s_completequeue(uid:Number,target_uid:Number,seat_id:String):void
		{
			GNetIns.gm_socket.send_data			( MSG_NET_COMPLETE_QUEUE,		{"uid":uid,"target_uid":target_uid, "seat_id":seat_id});
		}
		//单个运输工具相关信息
		public static function c2s_showvehiclesinfos(uid:Number,target_uid:Number,seat_id:String):void
		{
			GNetIns.gm_socket.send_data			( MSG_NET_SHOW_VEHICLES_INFOS,		{"uid":uid,"target_uid":target_uid, "seat_id":seat_id});
		}
		//车辆改名
		public static function c2s_renamevehicles(uid:Number,target_uid:Number,seat_id:String,name:String):void
		{
			GNetIns.gm_socket.send_data			( MSG_NET_RENAME_VEHICLES,		{"uid":uid,"target_uid":target_uid, "seat_id":seat_id, "name":name});
		}
		//车辆丢弃
		public static function c2s_dicevehicles(uid:Number,target_uid:Number,seat_id:String):void
		{
			GNetIns.gm_socket.send_data			( MSG_NET_DICE_VEHICLES,		{"uid":uid,"target_uid":target_uid, "seat_id":seat_id});
		}
		//交易详情
		public static function c2s_showqueueinfos(uid:Number,target_uid:Number,seat_id:String):void
		{
			GNetIns.gm_socket.send_data			( MSG_NET_SHOW_QUEUEINFOS,		{"uid":uid,"target_uid":target_uid, "seat_id":seat_id});
		}
		//交易修改
		public static function c2s_modiqueue(uid:Number,target_uid:Number,seat_id:String, arrive_city:Number, card_id:Number):void
		{
			GNetIns.gm_socket.send_data			( MSG_NET_MODI_QUEUE,		{"uid":uid,"target_uid":target_uid, "seat_id":seat_id, "arrive_city":arrive_city, "card_id":card_id});
		}
		//改道信息
		public static function c2s_getcityinfosbymodi(uid:Number,target_uid:Number,city_id:Number, seat_id:String, good_id:Number):void
		{
			GNetIns.gm_socket.send_data			( MSG_NET_GET_CITYINFOS_BY_MODI,		{"uid":uid,"target_uid":target_uid, "city_id":city_id, "seat_id":seat_id, "good_id":good_id});
		}
	}
}