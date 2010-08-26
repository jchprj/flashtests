package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.*;
	import flash.filters.GlowFilter;
	import flash.geom.*;
	
	import mx.core.*;

	public class Player extends AnimatedGameObject
	{
		/**当前选择的player，静态变量**/
		private static var clickedPlayer:Player;
		
		/**每帧移动步长**/
		private var speed:int = 3;
		/**移动方向**/
		private var way:Point = new Point;
		/**移动目标点**/
		private var target:Point;
		/**player形象下标**/
		private var resourceIndex:int;
		/**当前player形象下标**/
		private var currentIndex:int;
		/**鼠标移上标志**/
		private var moveover:Boolean;
		
		public function Player()
		{			
			
		}
		
		public function startupPlayer(index:int):void
		{
			currentIndex = index;
			resourceIndex = index;
			super.startupAnimatedGameObject(ResourceManager.PlayerGraphics[index], new Point(Math.random() * Application.application.width, Math.random() * Application.application.height), ZOrders.PlayerZOrder);
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
					currentIndex = way.y > 0 ? resourceIndex : (resourceIndex+12);
					graphics = ResourceManager.PlayerGraphics[currentIndex];
				}
				else if(way.x != 0)
				{
					currentIndex = way.x > 0 ? (resourceIndex+8): (resourceIndex+4);
					graphics = ResourceManager.PlayerGraphics[currentIndex];
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
					currentIndex = resourceIndex;
					graphics = ResourceManager.PlayerGraphics[currentIndex];
					target = null;
					way.x = 0;
					way.y = 0;
				}
			}
			
			//position.x+=speed;
			
			// keep player on the screen
			if (position.x < 0)
			{
				position.x = 0;
				//speed = -speed;
			}
			if (position.x > Application.application.width - graphics.bitmap.width / graphics.frames)
			{
				position.x = Application.application.width - graphics.bitmap.width / graphics.frames;
				//speed = -speed;
			}
			if (position.y < 0)
			{
				position.y = 0;
			}
			if (position.y > Application.application.height - graphics.bitmap.height )
			{
				position.y = Application.application.height - graphics.bitmap.height ;
			}
			
		}
		
		override public function mouseMove(event:MouseEvent):void
		{	
			var point:Point = new Point(event.localX, event.localY);
			if(this.CollisionArea.containsPoint(point))
			{
				if(moveover == false)
				{
					var bitmapdata:BitmapData =  new BitmapData(graphics.bitmap.width,  graphics.bitmap.height, true, 0x00000000);
					bitmapdata.draw(graphics.bitmap);//.bitmap.clone();
					//trace(graphics.bitmap.rect);
					bitmapdata.applyFilter(bitmapdata, graphics.bitmap.rect, new Point(0, 0), new GlowFilter(0xFFF000, 1, 9, 9));
					graphics = new GraphicsResource(new Bitmap(bitmapdata), 3, 6);
					moveover = true;
				}
			}
			else
			{
				moveover = false;
				graphics = ResourceManager.PlayerGraphics[currentIndex];
			}
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