package modules
{
	import com.common.ModuleGC;
	import com.common.SimFun;
	
	import component.map_city;
	import component.map_country;
	import component.map_town;
	
	import mx.collections.ArrayCollection;
	import mx.core.UIComponent;
	
	import spark.components.Group;
	
	public class GameModulePM
	{		
		public function GameModulePM()
		{
		}
		
		/**
		 * 加载地图
		 * game_mapbg:地图装载容器
		 * num:传递进来需要加载的地图 
		 * */
		public function loadMap(game_mapbg:Group, num:Number):void
		{
			var mapContent:UIComponent;
			game_mapbg.removeAllElements();
			if(num == 1)
			{
				mapContent = new map_town();
			}
			else if(num==2)
			{
				mapContent = new map_city();
			}
			else
			{
				mapContent = new map_country();
			}
			game_mapbg.x = 0;
			game_mapbg.y = 0;
			game_mapbg.addElement(mapContent);
			ModuleGC.gc();
		}
		/**
		 *车位串号，从0开始，一共6位
		 *前两位是车辆序号(00-99)，第三位是类型号码(0,1,2,3),后3位车辆类型(010 ~ 100 汽车位，011 ~ 101 火车位 ...)			
		 * */
		
		/**
		 * 处理当前返回的5个队列
		 * now_car_detail: 模块中now_car_detail数组，保存当前5个车位队列
		 * now_car_page: 当前显示第几页车位，用于计算car_order. 
		 * car_stop_stat:0:需要购买车位，1:需要买车，2:有车，空闲，3:有车，正在拉货
		 * target: 服务器返回的target json对象
		 * */
		public function deal_five_quque(now_car_detail:ArrayCollection, now_car_page:Number, target:*):ArrayCollection
		{
			now_car_detail.removeAll();
			now_car_detail = new ArrayCollection([
				{car_stop_stat:0,car_order:(now_car_page-1)*5+0,seat_id:"",car_pic:"",car_goods:"",car_city:"",car_time:"",stat_oiles:0,stat_maintain:0,stat_fault:0, curr_status:0},
				{car_stop_stat:0,car_order:(now_car_page-1)*5+1,seat_id:"",car_pic:"",car_goods:"",car_city:"",car_time:"",stat_oiles:0,stat_maintain:0,stat_fault:0, curr_status:0},
				{car_stop_stat:0,car_order:(now_car_page-1)*5+2,seat_id:"",car_pic:"",car_goods:"",car_city:"",car_time:"",stat_oiles:0,stat_maintain:0,stat_fault:0, curr_status:0},
				{car_stop_stat:0,car_order:(now_car_page-1)*5+3,seat_id:"",car_pic:"",car_goods:"",car_city:"",car_time:"",stat_oiles:0,stat_maintain:0,stat_fault:0, curr_status:0},
				{car_stop_stat:0,car_order:(now_car_page-1)*5+4,seat_id:"",car_pic:"",car_goods:"",car_city:"",car_time:"",stat_oiles:0,stat_maintain:0,stat_fault:0, curr_status:0}
			]);
			//获取数组长度
			var getCallBackLength:Number = 0;
			for(var keyLength:String in target.queue_list)
			{
				getCallBackLength += 1;
			}					
			//有车位					
			if(getCallBackLength != 0)
			{
				var seat_order:Number = 0;//车位序号
				var seat_id_last_three_num:String = "";//最后三位
				for(var seat_id:String in target.queue_list)
				{
					seat_order = Number(seat_id.substr(0,2));
					//根据串号判断该车位是否有车
					seat_id_last_three_num = seat_id.substr(3,3);					
					//需要买车
					if(seat_id_last_three_num == "000")
					{
						for(var i:int=0; i<now_car_detail.length; i++)
						{
							if(now_car_detail[i].car_order == seat_order)
							{
								now_car_detail[i].car_stop_stat = 1;
								now_car_detail[i].seat_id = seat_id;
								break;
							}
						}								
					}
					//有车
					else
					{
						//有车，空闲
						if(typeof(target.queue_list[seat_id].goods_id) == "undefined")
						{
							//车图片  路径 + seat_id_last_three_num									
							for(var j:int=0; j<now_car_detail.length; j++)
							{
								if(now_car_detail[j].car_order == seat_order)
								{
									now_car_detail[j].car_stop_stat = 2;
									now_car_detail[j].seat_id = seat_id;									
									now_car_detail[j].car_pic = "images/j_sub/qiche1.gif";
									break;
								}
							}
						}
						//拉货中
						else
						{
							for(var k:int=0; k<now_car_detail.length; k++)
							{
								if(now_car_detail[k].car_order == seat_order)
								{
									now_car_detail[k].car_stop_stat = 3;
									now_car_detail[k].seat_id = seat_id;
									now_car_detail[k].car_pic = "images/j_sub/qiche1.gif";
									now_car_detail[k].car_goods = "images/goods/"+ target.queue_list[seat_id].goods_id +".png";
									now_car_detail[k].car_city = SimFun.cityArr[target.queue_list[seat_id].leave_city]+"--"+SimFun.cityArr[target.queue_list[seat_id].arrive_city];
									now_car_detail[k].car_time = target.queue_list[seat_id].remain_time;
									
									now_car_detail[k].stat_oiles = target.queue_list[seat_id].status.oiles;
									now_car_detail[k].stat_maintain = target.queue_list[seat_id].status.maintain;
									now_car_detail[k].stat_fault = target.queue_list[seat_id].status.fault;
									now_car_detail[k].curr_status = target.queue_list[seat_id].status.curr_status;
									break;
								}
							}
						}//---end 拉货中								
					}//--end 有车
				}						
			}//--end 有车位
			
			return now_car_detail;
		}
		
		
		
	}
}