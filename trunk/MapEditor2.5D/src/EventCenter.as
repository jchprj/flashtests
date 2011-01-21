package 
{
	public class EventCenter
	{
		private static var _instance:EventCenter;
		private var events:Array = [];
		
		private static function get instance():EventCenter
		{
			if(_instance == null)
			{
				_instance = new EventCenter(new Helper());
			}
			return _instance;
		}
		
		public function EventCenter(sing:Helper)
		{
		}
		
		
		public static function addEventListener(e:String, callback:Function):void
		{
			instance.events.push({event:e, callback:callback});
		}
		
		public static function hasEventListener(e:String, callback:Function = null):Boolean
		{
			var i:int;
			for(i=0;i<instance.events.length;i++)
			{
				if(instance.events[i].event == e && 
					(instance.events[i].callback == callback || callback == null))
				{
					return true;
				}
			}
			return false;
		}
		
		public static function removeEventListener(e:String, callback:Function = null):void
		{
			var i:int;
			for(i=0;i<instance.events.length;i++)
			{
				if(instance.events[i].event == e && 
					(instance.events[i].callback == callback || callback == null))
				{
					instance.events.splice(i, 1);
					i--;
				}
			}
		}
		
		public static function dispachEvent(e:String, data:Object = null):void
		{
			var i:int;
			if(instance.events)
			{
				for(i=0;i<instance.events.length;i++)
				{
					if(instance.events[i].event == e)
					{
						if(data == null)
						{
							instance.events[i].callback.call(null);
						}
						else
						{
							instance.events[i].callback.call(null, data);
						}
					}
				}
			}
		}
	}
}

//单例强迫器
class Helper 
{}