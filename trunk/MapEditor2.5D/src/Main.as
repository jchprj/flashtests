package
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	[SWF(backgroundColor="0x000000",width="1000",height="600",frameRate="30")]
	public class Main extends Sprite
	{
		private var bg:Sprite;
		private var mapGrid:MapGrid;
		private var mapEditor:MapEditor;
		
		public function Main()
		{
			bg = new Sprite;
			addChild(bg);
			
			mapGrid = new MapGrid;
			addChild(mapGrid);
			
			mapEditor = new MapEditor;
			addChild(mapEditor);
			
			var ld:Loader = new Loader;
			ld.load(new URLRequest("map79.jpg"));
			bg.addChild(ld);
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function onMouseDown(e:MouseEvent):void
		{
			mapGrid.startDraw();
		}
		private function onMouseUp(e:MouseEvent):void
		{
			mapGrid.stopDraw();
		}
	}
}