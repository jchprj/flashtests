package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.getTimer;
	
	import mx.core.Application;

	public class TestPath extends Sprite 
	{ 
		private const MAP_WIDTH : int = 100; 
		private const MAP_HEIGHT : int = 100; 
		
		private var screen : Bitmap; 
		private var playPoint : Point; 
		private var map : Array; 
		
		private var path : Array; 
		private var debugText:TextField; 
		
		public function TestPath() 
		{ 
			
			screen = new Bitmap(new BitmapData(MAP_WIDTH,MAP_HEIGHT)); 
			screen.scaleX = screen.scaleY = 5;
			
			addChild(screen);
			
			debugText = new TextField(); 
			debugText.y = 500;
			addChild(debugText); 

			this.reset();
			
			addEventListener(MouseEvent.CLICK, clickHandler); 
			addEventListener(Event.ENTER_FRAME, enterframeHandler); 
		} 
		
		private function reset() : void 
		{ 
			this.map = []; 
			var datas:Array = new Array;
			
			for (var j : int = 0; j < MAP_HEIGHT; j++) 
			{ 
				map[j] = []; 
				for (var i : int = 0; i < MAP_WIDTH; i++) 
				{ 
					var isBlock : Boolean = Math.random() < 0.3; 
					map[j][i] = isBlock; 
					datas.push(isBlock?1:0);
					screen.bitmapData.setPixel(i,j,isBlock ? 0x000000 : 0xFFFFFF); 
				} 
			} 
			Application.application.datas = datas;
			this.playPoint = new Point(); 
			screen.bitmapData.setPixel(0,0,0xFF0000); 
			
		} 
		
		private function convertPath():void
		{
			var i:int;
			var fromx:int;
			var fromy:int;
			for(i=0;i<path.length;i++)
			{
				fromx = path[i] % MAP_WIDTH;
				fromy = Math.floor(path[i] / MAP_WIDTH);
				path[i] = new Point(fromx, fromy);
			}
		}
		
		private function clickHandler(event : MouseEvent) : void 
		{ 
			var t:int = getTimer(); 
			var fromp:int = int(playPoint.y)*MAP_WIDTH + int(playPoint.x);
			var top:int = int(screen.mouseY)*MAP_WIDTH + int(screen.mouseX);
			this.path = Application.application.find(fromp, top);//this.aStar.find(playPoint.clone(), new Point(int(screen.mouseX),int(screen.mouseY)));//获得行走路径 
			convertPath();
			
			if (!this.path || path.length == 0 || path.length == 1) 
				debugText.text = "无法到达"; 
			else 
				debugText.text = "本次用时:"+ (getTimer() - t)+"ms"; 
		} 
		
		private function enterframeHandler(event : Event) : void 
		{ 
			if (this.path == null || this.path.length == 0 || path.length == 1) 
				return; 
			
			screen.bitmapData.setPixel(playPoint.x,playPoint.y,0xFFFFFF); 
			playPoint = this.path.shift() as Point; 
			screen.bitmapData.setPixel(playPoint.x,playPoint.y,0xFF0000); 
			
		} 
	} 
	
}