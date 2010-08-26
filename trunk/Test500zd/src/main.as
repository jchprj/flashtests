package {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;

	/**      * 图形缓冲范例主场景      * Author:D5Power      * www.d5power.com www.webgamei.com      */
	public class main extends Sprite {
		
		[Embed(source="p11.png")]
		public static var zidan_doc:Class;
		
		/**          * 缓冲区          */
		private	var buffer: BitmapData;
		/**          * 子弹序列          */
		private	var objects: Array;
		/**          * 场景宽度          */
		public static var W: uint = 1000;
		/**          * 场景高度          */
		public static var H: uint = 600;
		public function main(num:int) {
			// 声明缓冲区
			buffer = new BitmapData(W,H,true,0x00000000);
			objects = new Array();             
			// 获取子弹素材           
			// 本例用FLASH开发，因此zidan_doc实际为库中导出的BitmapData类
			var tmpzd:Bitmap = Bitmap(new zidan_doc()); 
			var doc:BitmapData = new BitmapData(tmpzd.width, tmpzd.height, true, 0x00000000);
			doc.draw(tmpzd);
			tmpzd.bitmapData.dispose();                     
			// 渲染侦听  
			addEventListener(Event.ENTER_FRAME,render);                      
			// 声明500个子弹，添加到子弹序列中
			for(var i:uint=0;i<num;i++)             
			{             
				var zd:zidan = new zidan(doc,buffer);  
				var rand_x:uint = Math.floor(Math.random()*W);     
				var rand_y:uint = Math.floor(Math.random()*H);        
				zd.Pos = new Point(rand_x,rand_y);             
				addObjects(zd);            
			}                          
			// 以缓冲区填充场景       
			graphics.beginBitmapFill(buffer);          
			graphics.drawRect(0,0,buffer.width,buffer.height);     
			graphics.endFill();         
		}                 
		/**          * 向子弹序列中添加对象          * @param   o          */  
		private function addObjects(o:zidan):void         
		{             
			objects.push(o);
		}                  
		/**          * 渲染          * @param   e          */  
		private function render(e:Event):void
		{           
			buffer.fillRect(buffer.rect,0); 
			// 循环全部子弹序列，渲染每个子弹    
			for each(var zd:zidan in objects) 
			{                
				zd.render(buffer);
			}                  
		}      
	}    
}
			