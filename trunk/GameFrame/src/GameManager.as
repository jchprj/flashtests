package
{
	import flash.geom.Point;
	
	import mx.core.Application;

	public class GameManager
	{
		protected static var instance:GameManager = null;
		protected var bgElementGraphics:Array = new Array();
		
		static public function get Instance():GameManager
		{
			if ( instance == null )
				instance = new GameManager();
			return instance;
		}
		
		public function GameManager()
		{
			if ( GameManager.instance != null )
				throw new Error( "Only one Singleton instance should be instantiated" );
			
			bgElementGraphics.push(ResourceManager.BgGraphic);
		}
		
		public function startup():void
		{
			var indexes:Array = [0,1,2,3,16,17,18,19];
			for(var i:int=0;i<int(Application.application.num.text);i++)
			{
				new Player().startupPlayer(indexes[Math.floor(Math.random()*8)]);
			}
			
			var graphics:GraphicsResource = bgElementGraphics[0] as GraphicsResource;
			var backgroundLevelElement:BackgroundLevelElement =  BackgroundLevelElement.pool.ItemFromPool as BackgroundLevelElement;
			backgroundLevelElement.startupBackgroundLevelElement(
				graphics, 
				new Point(0, 0),
				ZOrders.BackgoundZOrder,
				50);
		}
		
		public function shutdown():void
		{
			
		}
		
		public function enterFrame(dt:Number):void
		{
			// add a background element
		}
	}
}