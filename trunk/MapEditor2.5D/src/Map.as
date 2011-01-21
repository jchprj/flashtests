package
{
	import flash.geom.Point;

	public class Map
	{
		
		public static var gridXY:Point;
		
		private static var tracearr:Array = new Array;
		
		public function Map()
		{
		}
		
		public static function trace(...args):void
		{
			var i:int;
			var s:String = "";
			for(i=0;i<args.length;i++)
			{
				s += args[i].toString() + ", ";
			}
			if(s != "")
			{
				s = s.substr(0, s.length - 2);
			}
			tracearr.push(s);
			if(tracearr.length > 30)
			{
				tracearr.shift();
			}
			var str:String = tracearr.join("\n");
			EventCenter.dispachEvent("trace", str);
		}
	}
}