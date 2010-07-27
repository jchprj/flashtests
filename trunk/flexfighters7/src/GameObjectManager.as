package
{
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	
	import mx.collections.*;
	import mx.core.*;
	
	public class GameObjectManager
	{
		// double buffer
		public var backBuffer:BitmapData;
		// colour to use to clear backbuffer with 
		public var clearColor:uint = 0xFF0043AB;
		// static instance 
		protected static var instance:GameObjectManager = null;
		// the last frame time 
		protected var lastFrame:Date;
		// a collection of the GameObjects 
		protected var gameObjects:ArrayCollection = new ArrayCollection();
		// a collection where new GameObjects are placed, to avoid adding items 
		// to gameObjects while in the gameObjects collection while it is in a loop
		protected var newGameObjects:ArrayCollection = new ArrayCollection();
		// a collection where removed GameObjects are placed, to avoid removing items 
		// to gameObjects while in the gameObjects collection while it is in a loop
		protected var removedGameObjects:ArrayCollection = new ArrayCollection();
		protected var collisionMap:Dictionary = new Dictionary();
		
		static public function get Instance():GameObjectManager
		{
			if ( instance == null )
			instance = new GameObjectManager();
			return instance;
		}
		
		public function GameObjectManager()
		{
			if ( instance != null )
				throw new Error( "Only one Singleton instance should be instantiated" ); 
				
			backBuffer = new BitmapData(Application.application.width, Application.application.height, false);
		}
		
		public function startup():void
		{
			lastFrame = new Date();			
		}
		
		public function shutdown():void
		{
			shutdownAll();
		}
		
		public function enterFrame():void
		{
			// Calculate the time since the last frame
			var thisFrame:Date = new Date();
			var seconds:Number = (thisFrame.getTime() - lastFrame.getTime())/1000.0;
	    	lastFrame = thisFrame;
	    	
	    	removeDeletedGameObjects();
	    	insertNewGameObjects();
	    	
	    	Level.Instance.enterFrame(seconds);
	    	
	    	checkCollisions();
	    	
	    	// now allow objects to update themselves
			for each (var gameObject:GameObject in gameObjects)
			{
				if (gameObject.inuse) 
					gameObject.enterFrame(seconds);
			}
	    	
	    	drawObjects();
		}
		
		public function click(event:MouseEvent):void
		{
			for each (var gameObject:GameObject in gameObjects)
			{
				if (gameObject.inuse) gameObject.click(event);
			}
		}
		
		public function mouseDown(event:MouseEvent):void
		{
			for each (var gameObject:GameObject in gameObjects)
			{
				if (gameObject.inuse) gameObject.mouseDown(event);
			}
		}
		
		public function mouseUp(event:MouseEvent):void
		{
			for each (var gameObject:GameObject in gameObjects)
			{
				if (gameObject.inuse) gameObject.mouseUp(event);
			}
		}
		
		public function mouseMove(event:MouseEvent):void
		{
			for each (var gameObject:GameObject in gameObjects)
			{
				if (gameObject.inuse) gameObject.mouseMove(event);
			}
		}
		
		protected function drawObjects():void
		{
			backBuffer.fillRect(backBuffer.rect, clearColor);
			
			// draw the objects
			for each (var gameObject:GameObject in gameObjects)
			{
				if (gameObject.inuse) 
					gameObject.copyToBackBuffer(backBuffer);
			}
		}
				
		public function addGameObject(gameObject:GameObject):void
		{
			newGameObjects.addItem(gameObject);
		}
		
		public function removeGameObject(gameObject:GameObject):void
		{
			removedGameObjects.addItem(gameObject);
		}
		
		protected function shutdownAll():void
		{
			// don't dispose objects twice
			for each (var gameObject:GameObject in gameObjects)
			{
				var found:Boolean = false;
				for each (var removedObject:GameObject in removedGameObjects)
				{
					if (removedObject == gameObject)
					{
						found = true;
						break;
					}
				}
				
				if (!found)
					gameObject.shutdown();
			}
		}
		
		protected function insertNewGameObjects():void
		{
			for each (var gameObject:GameObject in newGameObjects)
			{
				for (var i:int = 0; i < gameObjects.length; ++i)
				{
					if (gameObjects.getItemAt(i).zOrder > gameObject.zOrder ||
						gameObjects.getItemAt(i).zOrder == -1)
						break;
				}

				gameObjects.addItemAt(gameObject, i);
			}
			
			newGameObjects.removeAll();
		}
		
		protected function removeDeletedGameObjects():void
		{
			// insert the object acording to it's z position
			for each (var removedObject:GameObject in removedGameObjects)
			{
				var i:int = 0;
				for (i = 0; i < gameObjects.length; ++i)
				{
					if (gameObjects.getItemAt(i) == removedObject)
					{
						gameObjects.removeItemAt(i);
						break;
					}
				}
				
			}
			
			removedGameObjects.removeAll();
		}
		
		public function addCollidingPair(collider1:String, collider2:String):void
		{
			if (collisionMap[collider1] == null)			
				collisionMap[collider1] = new Array();
				
			if (collisionMap[collider2] == null)
				collisionMap[collider2] = new Array();
								
			collisionMap[collider1].push(collider2);
			collisionMap[collider2].push(collider1);
		}
		
		protected function checkCollisions():void
		{
	    	for (var i:int = 0; i < gameObjects.length; ++i)
			{
				var gameObjectI:GameObject = gameObjects.getItemAt(i) as GameObject;
				
				for (var j:int = i + 1; j < gameObjects.length; ++j)
				{
					var gameObjectJ:GameObject = gameObjects.getItemAt(j) as GameObject;
					
					// early out for non-colliders
					var collisionNameNotNothing:Boolean = gameObjectI.collisionName != CollisionIdentifiers.NONE;
					// objects can still exist in the gameObjects collection after being disposed, so check
					var bothInUse:Boolean = gameObjectI.inuse && gameObjectJ.inuse;
					// make sure we have an entry in the collisionMap
					var collisionMapEntryExists:Boolean = collisionMap[gameObjectI.collisionName] != null;
					// make sure the two objects are set to collide
					var testForCollision:Boolean = collisionMapEntryExists && collisionMap[gameObjectI.collisionName].indexOf(gameObjectJ.collisionName) != -1
					
					if ( collisionNameNotNothing &&					
						 bothInUse &&		
						 collisionMapEntryExists &&
						 testForCollision)
					{
						if (gameObjectI.CollisionArea.intersects(gameObjectJ.CollisionArea))
						{
							gameObjectI.collision(gameObjectJ);
							gameObjectJ.collision(gameObjectI);
						}
					}					
				}
			}
		}
	}
}