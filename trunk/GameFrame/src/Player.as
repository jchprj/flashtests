package
{
	import flash.events.*;
	import flash.geom.*;
	
	import mx.core.*;

	public class Player extends AnimatedGameObject
	{
		private static var clickedPlayer:Player;
		
		private var speed:int = 3;
		private var way:Point = new Point;
		private var target:Point;
		
		public function Player()
		{			
			
		}
		
		public function startupPlayer():void
		{
			super.startupAnimatedGameObject(ResourceManager.PlayerGraphics[0], new Point(Math.random() * Application.application.width, Math.random() * Application.application.height / 2), ZOrders.PlayerZOrder);
			this.collisionName = CollisionIdentifiers.PLAYER;
		}
		
		override public function shutdown():void
		{
			super.shutdown();
		}
		
		override public function enterFrame(dt:Number):void
		{
			super.enterFrame(dt);
			
			if(target != null && clickedPlayer == this)
			{
				way.x = 0;
				way.y = 0;
				if(target.x > position.x && Math.abs(position.x - target.x) >= speed)
				{
					way.x = speed;
				}
				if(target.x < position.x && Math.abs(position.x - target.x) >= speed)
				{
					way.x = -speed;
				}
				if(target.y > position.y && Math.abs(position.y - target.y) >= speed)
				{
					way.y = speed;
				}
				if(target.y < position.y && Math.abs(position.y - target.y) >= speed)
				{
					way.y = -speed;
				}
				if(way.y != 0)
				{
					graphics = ResourceManager.PlayerGraphics[way.y > 0 ? 0 : 12];
				}
				else
				{
					graphics = ResourceManager.PlayerGraphics[way.x > 0 ? 8 : 4];
				}
				if(Math.abs(position.x - target.x) >= speed || Math.abs(position.y - target.y) >= speed)
				{
					if(Math.abs(position.x - target.x) >= speed)
					{
						position.x += way.x;
					}
					if(Math.abs(position.y - target.y) >= speed)
					{
						position.y += way.y;
					}
				}
				else
				{
					graphics = ResourceManager.PlayerGraphics[0];
					target = null;
					way.x = 0;
					way.y = 0;
				}
			}
			
			// keep player on the screen
			if (position.x < 0)
				position.x = 0;
			if (position.x > Application.application.width - graphics.bitmap.width / graphics.frames)
				position.x = Application.application.width - graphics.bitmap.width / graphics.frames;
			if (position.y < 0)
				position.y = 0;
			if (position.y > Application.application.height - graphics.bitmap.height )
				position.y = Application.application.height - graphics.bitmap.height ;	
			
		}
		
		override public function mouseMove(event:MouseEvent):void
		{
			// move player to mouse position			
		}
		
		override public function mouseDown(event:MouseEvent):void
		{
			var point:Point = new Point(event.localX, event.localY);
			if(this.CollisionArea.containsPoint(point))
			{
				clickedPlayer = this;
				target = null;
				way.x = 0;
				way.y = 0;
			}
			else
			{
				target = point;
			}
		}
		
		override public function mouseUp(event:MouseEvent):void
		{
			
		}
		
		override public function collision(other:GameObject):void
		{
			//Level.Instance.levelEnd = true;
			this.shutdown();
		}
	}
}