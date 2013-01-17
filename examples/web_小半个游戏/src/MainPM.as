package
{
	import com.common.ModuleGC;
	
	import flash.display.Stage;
	import flash.system.ApplicationDomain;
	
	import mx.core.IVisualElement;
	import mx.events.ModuleEvent;
	import mx.modules.IModuleInfo;
	import mx.modules.ModuleManager;
	
	import spark.components.Group;
	import spark.components.Label;
	
	public class MainPM
	{
		public var moduleContainer:Group;//模块容器
		public var onProgessShow:Group;//挡板
		public var onProgessPercent:Label;//显示百分进度
		public var onProgessText:Label;//显示加载信息
		public var currentModuleName:String;
		public var _moduleInfo:IModuleInfo;
		public var moduleArr:Object = new Object();//模块数组
		
		public function MainPM(moduleContainer:Group, onProgessShow:Group,onProgessPercent:Label,onProgessText:Label)
		{
			this.moduleContainer = moduleContainer;
			this.onProgessShow = onProgessShow;
			this.onProgessPercent = onProgessPercent;
			this.onProgessText = onProgessText;
		}
		
		//开始加载模块
		public function loadModule(moduleName:String, loadingText:String, currentDomain:ApplicationDomain):void
		{			
			this.currentModuleName = moduleName;

			onProgessShow.visible = true; //打开挡板
			onProgessText.text = loadingText;
			
			_moduleInfo = ModuleManager.getModule(moduleName + "?" + Math.random());
			_moduleInfo.addEventListener(ModuleEvent.READY, 	moduleOnReadyHandler);
			_moduleInfo.addEventListener(ModuleEvent.PROGRESS,	moduleOnProgessHandler);
			_moduleInfo.load(currentDomain);
		}
		//加载进度
		public function moduleOnProgessHandler (event:ModuleEvent):void
		{    
			onProgessPercent.text = Math.round(event.bytesLoaded / event.bytesTotal * 100) + "%";
		}
		//加载完成
		public function moduleOnReadyHandler(event:ModuleEvent):void
		{
			moduleArr[currentModuleName] = _moduleInfo.factory.create();			
			moduleContainer.addElement(moduleArr[currentModuleName] as IVisualElement);
			_moduleInfo.unload();
			_moduleInfo.release();
			ModuleGC.gc();
			
			onProgessShow.visible = false; //关闭挡板
		}		
		/*
			从显示列表中删除模块
			doit = true,从moduleArr中彻底删除
		*/
		public function removeModule(doit:Boolean, moduleName:String):void
		{
			for(var key:String in moduleArr)
			{
				if(key == moduleName)
				{
					moduleContainer.removeElement(moduleArr[moduleName] as IVisualElement);
					if(doit == true)
					{
						moduleArr[moduleName] = null;
					}
					break;
				}
			}
		}
		//彻底删除所有模块
		public function removeAllModule():void
		{
			for(var key:String in moduleArr)
			{
				moduleArr[key] = null;
			}
			moduleContainer.removeAllElements();
		}
	}
}