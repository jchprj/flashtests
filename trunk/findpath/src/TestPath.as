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
		public var  MAP_WIDTH : int = 100; 
		public var  MAP_HEIGHT : int = 100; 
		
		private var screen : Bitmap; 
		private var playPoint : Point; 
		private var map : Array; 
		
		private var path : Array; 
		
		public var setflag:int = 2;
		public var mouseflag:Boolean;
		
		public function TestPath() 
		{ 
			this.reset();
			
			addEventListener(MouseEvent.CLICK, clickHandler); 
			addEventListener(Event.ENTER_FRAME, enterframeHandler); 
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown); 
			addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		} 
		
		public function reset(level:Number = 0.3) : void 
		{ 
			if(screen)
			{
				screen.bitmapData.dispose();
				removeChild(screen);
			}
			screen = new Bitmap(new BitmapData(MAP_WIDTH,MAP_HEIGHT)); 
			screen.scaleX = screen.scaleY = 5;
			addChild(screen);
			
			this.map = []; 
			var datas:Array = [];
			
			for (var j : int = 0; j < MAP_HEIGHT; j++) 
			{ 
				map[j] = []; 
				for (var i : int = 0; i < MAP_WIDTH; i++) 
				{ 
					var isBlock : Boolean = Math.random() < level; 
					map[j][i] = isBlock; 
					datas.push(isBlock?1:0);
					screen.bitmapData.setPixel(i,j,isBlock ? 0x000000 : 0xFFFFFF); 
				} 
			} 
			Path.instance.datas = datas;
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
			if(setflag != 2 || 
				screen.mouseX < 0 || screen.mouseX > MAP_WIDTH - 1 ||
				screen.mouseY < 0 || screen.mouseY > MAP_HEIGHT - 1)
			{
				return;
			}
			var t:int = getTimer(); 
			var fromp:int = int(playPoint.y)*MAP_WIDTH + int(playPoint.x);
			var top:int = int(screen.mouseY)*MAP_WIDTH + int(screen.mouseX);
			Path.instance.modifyflag = Application.application.modifybtn.selected;
			this.path = Path.instance.find(fromp, top);//this.aStar.find(playPoint.clone(), new Point(int(screen.mouseX),int(screen.mouseY)));//获得行走路径
			
			Application.application.pathstr.text = this.path.toString();
			convertPath();
			
			if (!this.path || path.length == 0 || path.length == 1) 
				Application.application.timetxt.text = "无法到达:"+ (getTimer() - t)+"ms"; 
			else 
				Application.application.timetxt.text = "本次用时:"+ (getTimer() - t)+"ms"; 
		} 
		
		private function onMouseDown(e:MouseEvent):void
		{
			mouseflag = true;
		}
		
		private function onMouseMove(e:MouseEvent):void
		{
			var index:int = int(screen.mouseY)*MAP_WIDTH + int(screen.mouseX);
			if(setflag == 3 && mouseflag)
			{
				setDatas(index, 1);
			}
			if(setflag == 4 && mouseflag)
			{
				setDatas(index, 0);
			}
		}
		
		private function enterframeHandler(event : Event) : void 
		{
			if (this.path == null || this.path.length == 0 || path.length == 1) 
				return; 
			
			screen.bitmapData.setPixel(playPoint.x,playPoint.y,0xFFFFFF); 
			playPoint = this.path.shift() as Point; 
			screen.bitmapData.setPixel(playPoint.x,playPoint.y,0xFF0000); 
			
		} 
		
		private function setDatas(index:int, value:int):void
		{
			Path.instance.datas[index] = value;
			var fromx:int;
			var fromy:int;
			fromx = index % MAP_WIDTH;
			fromy = Math.floor(index / MAP_WIDTH);
			screen.bitmapData.setPixel(fromx,fromy,value==1?0x000000:0xFFFFFF); 
		}
	} 
	
}