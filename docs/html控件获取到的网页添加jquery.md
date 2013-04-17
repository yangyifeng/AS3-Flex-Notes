html 控件获取到的网页添加jquery
==============

实现这个功能，非常兴奋！因为需要做一个简单的采集和分析，windows 应用中的 html 控件可以很简单的实现自动登录、获取页面 html 内容的功能，但是要提取内容分析就比较麻烦了，如果能使用比较熟悉的 jquery 的话，就很简单了，尝试了一下，结果还真的实现了这个功能。

```
<fx:Script>
		<![CDATA[
			
			public var jsWindow:Object;
			
			private function pageLoaded():void
			{
				jsWindow = pageWindow.domWindow;
				
				var script:Object = jsWindow.document.createElement("script");
				script.src = 'http://code.jquery.com/jquery-1.9.1.min.js';
				
				script.onload = function():void {
					//在这里面，就可以为所欲为了！
					jsWindow.jQuery("div").each(function():void{
						trace(jsWindow.jQuery(this).html());
					});
					trace(jsWindow.jQuery('.labela').html());
				};
				
				jsWindow.document.head.appendChild(script);
			}
		]]>
	</fx:Script>
	
	<mx:HTML width="100%" height="100%" 
			 id="pageWindow" location="http://localhost/other/test_jquery/test.html"
			 complete="pageLoaded()" />
```