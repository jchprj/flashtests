package
{
	import flash.geom.Point;

	public class MathUtils
	{
		public function MathUtils()
		{
		}
		
		public static function getGridPoint(param1:Point) : Point
		{
			var left:Number = Map.gridXY.x;
			var top:Number = Map.gridXY.y;
			var gridPoint:Point = new Point();
			gridPoint.x = Math.floor((2 * (param1.y - top) + (param1.x - left)) / (1 * 2));
			gridPoint.y = Math.floor((2 * (param1.y - top) - (param1.x - left)) / (1 * 2));
			return gridPoint;
		}
		
		public static function getRealPoint(param1:Point) : Point
		{
			var left:Number;
			var top:Number;
			if(Map.gridXY)
			{
				left = Map.gridXY.x;
				top = Map.gridXY.y;
			}
			var realPoint:Point = new Point();
			realPoint.y = Math.floor( (param1.x + param1.y)/2 + top);
			realPoint.x = Math.floor( (param1.x - param1.y) + left);
			return realPoint;
		}
	}
}