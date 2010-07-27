package
{
	import flash.events.*;
	import flash.geom.*;
	import flash.media.*;
	import flash.net.*;
	import flash.utils.*;
	
	import mx.collections.ArrayCollection;
	import mx.core.*;
	
	public class Level
	{
		protected static var instance:Level = null;
		
		protected static const TimeBetweenLevelElements:Number = 2;
		protected static const TimeBetweenEnemies:Number = 3;
		protected static const TimeBetweenClouds:Number = 2.5;
		protected static const TimeToLevelEnd:Number = 2;
		
		protected var timeToNextLevelElement:Number = 0;
		protected var levelElementGraphics:ArrayCollection = new ArrayCollection();
		protected var timeToNextEnemy:Number = 0;
		protected var enemyElementGraphics:ArrayCollection = new ArrayCollection();
		protected var timeToNextCloud:Number = 0;
		protected var timeToLevelEnd:Number = 0;
		public var levelEnd:Boolean = false;

		static public function get Instance():Level
		{
			if ( instance == null )
				instance = new Level();
			return instance;
		}
		
		public function Level(caller:Function = null )
		{
			if ( Level.instance != null )
			throw new Error( "Only one Singleton instance should be instantiated" );
			
			levelElementGraphics.addItem(ResourceManager.SmallIslandGraphics);
			levelElementGraphics.addItem(ResourceManager.BigIslandGraphics);
			levelElementGraphics.addItem(ResourceManager.VolcanoIslandGraphics); 
			
			enemyElementGraphics.addItem(ResourceManager.SmallBluePlaneGraphics);
			enemyElementGraphics.addItem(ResourceManager.SmallGreenPlaneGraphics);
			enemyElementGraphics.addItem(ResourceManager.SmallWhitePlaneGraphics);
		}
		
		public function startup():void
		{
			timeToNextLevelElement = 0;
			new Player().startupPlayer();
			timeToLevelEnd = TimeToLevelEnd;
			levelEnd = false;
		}
		
		public function shutdown():void
		{
			
		}
		
		public function enterFrame(dt:Number):void
		{
			// add a background element
			timeToNextLevelElement -= dt;

			if (timeToNextLevelElement <= 0)
			{
				timeToNextLevelElement = TimeBetweenLevelElements;
				var graphics:GraphicsResource = levelElementGraphics.getItemAt(MathUtils.randomInteger(0, levelElementGraphics.length)) as GraphicsResource;
				var backgroundLevelElement:BackgroundLevelElement =  BackgroundLevelElement.pool.ItemFromPool as BackgroundLevelElement;
				backgroundLevelElement.startupBackgroundLevelElement(
					graphics, 
					new Point(Math.random() * Application.application.width, -graphics.bitmap.height),
					ZOrders.BackgoundZOrder,
					50);
			}
			
			// add an emeny
			timeToNextEnemy -= dt;
			
			if (timeToNextEnemy <= 0)
			{
				timeToNextEnemy = TimeBetweenEnemies;
				var enemygraphics:GraphicsResource = enemyElementGraphics.getItemAt(MathUtils.randomInteger(0, enemyElementGraphics.length)) as GraphicsResource;
				var enemy:Enemy = Enemy.pool.ItemFromPool as Enemy;
				enemy.startupBasicEnemy(
					enemygraphics, 
					new Point(Math.random() * Application.application.width, -enemygraphics.bitmap.height),
					55);
			}
			
			// add cloud
			timeToNextCloud -= dt;
			
			if (timeToNextCloud <= dt)
			{
				timeToNextCloud = TimeBetweenClouds;
				var cloudBackgroundLevelElement:BackgroundLevelElement = BackgroundLevelElement.pool.ItemFromPool as BackgroundLevelElement;
				cloudBackgroundLevelElement.startupBackgroundLevelElement(
					ResourceManager.CloudGraphics, 
					new Point(Math.random() * Application.application.width, -ResourceManager.CloudGraphics.bitmap.height),
					ZOrders.CloudsBelowZOrder,
					75);
			}
			
			if (levelEnd)
				timeToLevelEnd -= dt;
				
			if (timeToLevelEnd <= 0)
				Application.application.currentState = "MainMenu";	
		}
	}
}