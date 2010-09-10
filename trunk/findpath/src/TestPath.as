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
	
	import ghostcat.algorithm.traversal.AStar;
	import ghostcat.algorithm.traversal.MapModel;
	import ghostcat.algorithm.traversal.Traversal;
	
	import mx.core.Application;

	public class TestPath extends Sprite 
	{ 
		public var  MAP_WIDTH : int = 100; 
		public var  MAP_HEIGHT : int = 100; 
		
		private var screen : Bitmap; 
		private var lines:Sprite;
		private var playPoint : Point; 
		private var map : Array; 
		
		private var path : Array; 
		
		public var setflag:int = 2;
		public var mouseflag:Boolean;
		
		private var aStar : Traversal; 
		private var mapModel : MapModel; 
		
		public function TestPath() 
		{ 
			this.mapModel = new MapModel(); 
			this.reset();
			lines = new Sprite;
			addChild(lines);
			
			addEventListener(MouseEvent.CLICK, clickHandler); 
			addEventListener(Event.ENTER_FRAME, enterframeHandler); 
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown); 
			addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		} 
		
		public function reset(level:Number = 0.3, setdatas:Array = null) : void 
		{ 
			if(screen)
			{
				screen.bitmapData.dispose();
				removeChild(screen);
			}
			screen = new Bitmap(new BitmapData(MAP_WIDTH,MAP_HEIGHT)); 
			screen.scaleX = screen.scaleY = 5;
			addChildAt(screen, 0);
			
			this.map = []; 
			var datas:Array;
			
			if(setdatas == null)
			{
				datas = [];
			}
			else
			{
				datas = setdatas;
			}
			var isBlock : Boolean
			var k:int;
			for (var j : int = 0; j < MAP_HEIGHT; j++) 
			{ 
				map[j] = []; 
				for (var i : int = 0; i < MAP_WIDTH; i++) 
				{ 
					isBlock = Math.random() < level; 
					if(setdatas == null)
					{
						datas.push(isBlock?1:0);
					}
					else
					{
						setdatas[k] = int(setdatas[k]);
						datas[k] = setdatas[k];
						isBlock = setdatas[k]; 
					}
					map[j][i] = isBlock; 
					screen.bitmapData.setPixel(i,j,isBlock ? 0x000000 : 0xFFFFFF); 
					k++;
				} 
			} 
			screen.bitmapData.setPixel(0,0,0xFF0000); 
			this.playPoint = new Point(); 
			
			Path.instance.init(datas);
			this.mapModel.map = this.map;//创建地图数据 
			this.aStar = new AStar(this.mapModel);//根据数据生成A*类 
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
			if(setflag == 5)
			{
				var pos:int = int(screen.mouseY)*MAP_WIDTH + int(screen.mouseX);
				if(Path.instance.datas[pos] == 0)
				{
					screen.bitmapData.setPixel(playPoint.x,playPoint.y,0xFFFFFF); 
					playPoint = new Point(int(screen.mouseX),int(screen.mouseY)); 
					screen.bitmapData.setPixel(playPoint.x,playPoint.y,0xFF0000);
				}
			}
			if(setflag != 2 || 
				screen.mouseX < 0 || screen.mouseX > MAP_WIDTH ||
				screen.mouseY < 0 || screen.mouseY > MAP_HEIGHT)
			{
				return;
			}
			var t:int = getTimer(); 
			var fromp:int = int(playPoint.y)*MAP_WIDTH + int(playPoint.x);
			var top:int = int(screen.mouseY)*MAP_WIDTH + int(screen.mouseX);
			Application.application.startpos.text = fromp.toString();
			Application.application.endpos.text = top.toString();
			Path.instance.modifyflag = Application.application.modifybtn.selected;
			if(Application.application.abtn.selected)
			{
				this.path = this.aStar.find(playPoint.clone(), new Point(int(screen.mouseX),int(screen.mouseY)));//获得行走路径
			}
			else
			{
				this.path = Path.instance.find(fromp, top);//this.aStar.find(playPoint.clone(), new Point(int(screen.mouseX),int(screen.mouseY)));//获得行走路径
				convertPath();
			}
			if(this.path)
			{
				Application.application.pathstr.text = this.path.toString();
			}
			else
			{
				Application.application.pathstr.text = "";
			}
			
			lines.graphics.clear();
			lines.graphics.lineStyle(1, 0xFF0000);
			lines.graphics.moveTo(playPoint.x*5+2.5, playPoint.y*5+2.5);
			
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
			if (this.path == null || this.path.length == 0) 
				return; 
			
			screen.bitmapData.setPixel(playPoint.x,playPoint.y,0xFFFFFF); 
			playPoint = this.path.shift() as Point; 
			screen.bitmapData.setPixel(playPoint.x,playPoint.y,0xFF0000); 
			var index:int = int(playPoint.y)*MAP_WIDTH + int(playPoint.x);
			Application.application.currentpos.text = index.toString();
			lines.graphics.lineTo(playPoint.x*5+2.5, playPoint.y*5+2.5);
		} 
		
		private function setDatas(index:int, value:int):void
		{
			var fromx:int;
			var fromy:int;
			fromx = index % MAP_WIDTH;
			fromy = Math.floor(index / MAP_WIDTH);
			if(fromx > -1 && fromx < MAP_WIDTH && fromy > -1 && fromy < MAP_HEIGHT)
			{
				Path.instance.datas[index] = value;
				screen.bitmapData.setPixel(fromx,fromy,value==1?0x000000:0xFFFFFF); 
			
				this.map[fromy][fromx] = value == 1?true:false;
				this.mapModel.map = this.map;//创建地图数据 
				this.aStar = new AStar(this.mapModel);//根据数据生成A*类
			}
		}
	} 
	
}