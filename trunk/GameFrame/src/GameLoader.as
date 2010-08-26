package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;

	public class GameLoader
	{
		private static var _instance:GameLoader;
		
		public static function get instance():GameLoader
		{
			if(_instance == null)
			{
				_instance = new GameLoader;
			}
			return _instance;
		}
		
		private var ld:Loader = new Loader;
		
		public function GameLoader()
		{
		}
		
		public function loadBmp():void
		{
			ld.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoad);
			ld.load(new URLRequest("gif.png"));
		}
		
		private function onLoad(e:Event):void
		{
			var w:int=4;
			var h:int=8;
			var ww:int=120;
			var hh:int=35;
			var bitmap:Bitmap = Bitmap(ld.content);
			var bitmapData:BitmapData = BmpProcess.transparent(BmpProcess.rank(bitmap,1,1).shift(),1,1);
			bitmap.bitmapData.dispose();
			bitmap = new Bitmap(bitmapData);
			var mc:Array = BmpProcess.rank(bitmap,w,h);
			
			var i:int;
			for(i=0;i<mc.length;i++)
			{
				ResourceManager.PlayerGraphics.push(new GraphicsResource(new Bitmap(BitmapData(mc[i])), 3, 6));
			}
			ld.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoad);
			ld.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadBg);
			ld.load(new URLRequest("bg.jpg"));
		}
		
		private function onLoadBg(e:Event):void
		{
			ResourceManager.BgGraphic = new GraphicsResource(Bitmap(ld.content));
			ld.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadBg);
		}
	}
}