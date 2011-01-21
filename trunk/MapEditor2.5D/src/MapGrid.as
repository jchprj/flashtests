package
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class MapGrid extends Sprite
	{
		private var gridBg:Sprite;
		private	var gridPoint:Sprite = new Sprite;
		
		private var setGridFlag:Boolean;
		
		private var gridLen:int;
		private	var lineDistance:int = 30;
		
		private var lastXi:int = -1;
		private var lastYi:int = -1;
		
		public function MapGrid()
		{
			super();
			this.graphics.beginFill(0x0, 0);
			this.graphics.drawRect(0, 0, 1000, 600);
			this.graphics.endFill();
			this.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			
			gridBg = new Sprite;
			addChild(gridBg);
			gridBg.addEventListener(MouseEvent.MOUSE_MOVE, onMoveGridbg);
			gridPoint = new Sprite;
			gridBg.addChild(gridPoint);
		}
		
		private function onMoveGridbg(e:MouseEvent):void
		{
			if(Sprite(e.currentTarget) != Sprite(e.target) )
			{
				return;
			}
			var point:Point = MathUtils.getGridPoint(new Point(e.localX, e.localY ));
			drawGrid(Map.gridXY, false);
			
			var xi:int = point.x / lineDistance;
			var yi:int = point.y / lineDistance;
			Map.trace(xi, yi);
			if((lastXi != -1 || lastYi != -1) && (lastXi != xi || lastYi != yi))
			{
			}
			point = MathUtils.getRealPoint(new Point(xi * lineDistance, yi * lineDistance));
			gridPoint.x = point.x - Map.gridXY.x;
			gridPoint.y = point.y - Map.gridXY.y;
			//trace(point.x, point.x - Map.gridXY.x);
			if(lastXi == -1)
			lastXi = xi;
			lastYi = yi;
		}
		
		private function fillGrid():void
		{
			gridPoint.graphics.clear();
			var point:Point;
			var xi:int = 0;
			var yi:int = 0;
			gridPoint.graphics.lineStyle(1, 0xFFFFFF, 0.7);
			gridPoint.graphics.beginFill(0xFFFFFF, 0.7);
			point = MathUtils.getRealPoint(new Point(xi * lineDistance, yi * lineDistance));
			gridPoint.graphics.moveTo(point.x, point.y)
			point = MathUtils.getRealPoint(new Point(xi * lineDistance + lineDistance, yi * lineDistance));
			gridPoint.graphics.lineTo(point.x, point.y)
			point = MathUtils.getRealPoint(new Point(xi * lineDistance + lineDistance, (yi + 1) * lineDistance));
			gridPoint.graphics.lineTo(point.x, point.y)
			point = MathUtils.getRealPoint(new Point(xi * lineDistance, (yi + 1) * lineDistance));
			gridPoint.graphics.lineTo(point.x, point.y)
			point = MathUtils.getRealPoint(new Point(xi * lineDistance, yi * lineDistance));
			gridPoint.graphics.lineTo(point.x, point.y)
			gridPoint.graphics.endFill();
		}
		
		public function startDraw():void
		{
			setGridFlag = true;
			Map.gridXY = new Point(stage.mouseX, stage.mouseY);
			gridBg.graphics.clear();
			gridPoint.visible = false;
		}
		
		public function stopDraw():void
		{
			setGridFlag = false;
			fillGrid();
			gridPoint.visible = true;
		}
		
		private function onMouseMove(e:MouseEvent):void
		{
			if(setGridFlag)
			{
				var currentPoint:Point = new Point(stage.mouseX, stage.mouseY);
				//trace(getGridPoint(currentPoint, 200, 50));
				drawGrid(currentPoint);
			}
		}
		
		public function drawGrid(currentPoint:Point, clearFlag:Boolean = true):void
		{
			
			var distance:Number = currentPoint.y - Map.gridXY.y;
			if(clearFlag)
			{
				gridBg.graphics.clear();
			}
			gridBg.graphics.lineStyle(1, 0xFF0000, 1);
			var xx:int = Map.gridXY.x;
			var yy:int = Map.gridXY.y;
			var point:Point;
			
			var i:int;
			gridLen = distance / lineDistance;
			distance = gridLen * lineDistance;
			for(i=0;i<=gridLen;i++)
			{
				point = MathUtils.getRealPoint(new Point(0, lineDistance*i));
				gridBg.graphics.moveTo(point.x, point.y)
				point = MathUtils.getRealPoint(new Point(distance, lineDistance*i));
				gridBg.graphics.lineTo(point.x, point.y)
				
				point = MathUtils.getRealPoint(new Point(lineDistance*i, 0));
				gridBg.graphics.moveTo(point.x, point.y)
				point = MathUtils.getRealPoint(new Point(lineDistance*i, distance));
				gridBg.graphics.lineTo(point.x, point.y)
			}
			gridBg.graphics.beginFill(0x0, 0.05);
			point = MathUtils.getRealPoint(new Point(0, 0));
			gridBg.graphics.moveTo(point.x, point.y)
			point = MathUtils.getRealPoint(new Point(distance, 0));
			gridBg.graphics.lineTo(point.x, point.y)
			point = MathUtils.getRealPoint(new Point(distance, distance));
			gridBg.graphics.lineTo(point.x, point.y)
			point = MathUtils.getRealPoint(new Point(0, distance));
			gridBg.graphics.lineTo(point.x, point.y)
			point = MathUtils.getRealPoint(new Point(0, 0));
			gridBg.graphics.lineTo(point.x, point.y)
			gridBg.graphics.endFill();
		}
		
	}
}