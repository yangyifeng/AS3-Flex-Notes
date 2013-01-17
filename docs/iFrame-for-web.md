iFrame-for-web
==============

在 Flex 的桌面项目中，可以使用 HTML 控件来做一个小浏览器，但是在 web 项目中，则比较麻烦，不过使用 flex-iframe 库，也可以达到差不多的效果。

### 使用方法

* 先在 libs 文件夹中加入库文件 flex-iframe-1.5.1.swc
* 在主文件的命名控件加上声明 xmlns:code="http://code.google.com/p/flex-iframe/"
* 然后就可以用了。


**examples:**

```
<?xml version="1.0" encoding="utf-8"?>
<s:Application xmlns:fx="http://ns.adobe.com/mxml/2009" 
			   xmlns:s="library://ns.adobe.com/flex/spark" 
			   xmlns:mx="library://ns.adobe.com/flex/mx"
			   xmlns:code="http://code.google.com/p/flex-iframe/"
			   width="800" height="800">
	
	<code:IFrame id="frm" width="342" height="509" x="34" y="143" source="http://www.google.com/" horizontalCenter="0" verticalCenter="0" />
</s:Application>

```