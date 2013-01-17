透明底的png的碰撞测试
==============



```
<?xml version="1.0" encoding="utf-8"?>
<s:Application xmlns:fx="http://ns.adobe.com/mxml/2009"
                  xmlns:s="library://ns.adobe.com/flex/spark"
                  xmlns:mx="library://ns.adobe.com/flex/mx" minWidth="955" minHeight="600" creationComplete="app()">
     <fx:Declarations>
          <!-- 将非可视元素（例如服务、值对象）放在此处 -->
     </fx:Declarations>
    
     <fx:Script>
          <![CDATA[
               import com.Itrace;
              
               import flash.filters.GlowFilter;
              
               public var itrace:Itrace;
              
              
               private var test1:BitmapData;
               private var test2:BitmapData;
              
               private var bitmap:Bitmap;
               private var bitmap2:Bitmap;
              
              
              
               public function app():void
               {
                    itrace = new Itrace();
                   
                    test1=new BitmapData(bigpic.width,bigpic.height,true,0);
                    test1.draw(bigpic);
                    bitmap=new Bitmap(test1);
                    bigpic.source=bitmap;
                   
                   
                    test2=new BitmapData(smallpic.width,smallpic.height,true,0);                   
                    test2.draw(smallpic);              
                    bitmap2=new Bitmap(test2);
                    smallpic.source=bitmap2;
               }
              
               private function mouseMove(event:MouseEvent):void
               {                   
                    if(test1.hitTest(new Point(bigpic.x,bigpic.y),255,test2,new Point(smallpic.x,smallpic.y),255))
                    {
                         itrace.traceString("hit");
                         bigpic.filters =  [new GlowFilter()];
                    }
                    else
                    {
                         bigpic.filters =  [];
                    }
               }
              
               private function start():void
               {
                    smallpic.x = stage.mouseX - smallpic.width;
                    smallpic.y = stage.mouseY - smallpic.height;
                    smallpic.startDrag();
                    stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
               }
              
               private function stop():void
               {
                    smallpic.stopDrag();                   
                    stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
               }
          ]]>
     </fx:Script>
    
    
    
     <s:Image x="86" y="14" source="assets/body.png" id="bigpic"/>
    
     <s:Image x="559" y="257" source="assets/logo.png" id="smallpic" />
    
     <s:Button x="559" y="511" label="开始" click="start()"/>
     <s:Button x="697" y="511" label="结束" click="stop()"/>
    
</s:Application>
```