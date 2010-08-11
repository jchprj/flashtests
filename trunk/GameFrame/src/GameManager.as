package
{
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;
	import mx.core.Application;

	public class GameManager
	{
		protected static var instance:GameManager = null;
		protected var bgElementGraphics:ArrayCollection = new ArrayCollection();
		
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
			
			bgElementGraphics.addItem(ResourceManager.BgGraphic);
		}
		
		public function startup():void
		{
			new Player().startupPlayer(0);
			new Player().startupPlayer(1);
			new Player().startupPlayer(2);
			new Player().startupPlayer(3);
			new Player().startupPlayer(16);
			
			var graphics:GraphicsResource = bgElementGraphics.getItemAt(0) as GraphicsResource;
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