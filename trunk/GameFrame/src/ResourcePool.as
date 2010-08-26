package
{
	import mx.collections.*;
	
	public class ResourcePool
	{
		protected var pool:Array = new Array();
		protected var newObject:Function = null;
		
		public function ResourcePool(newObject:Function)
		{
			this.newObject = newObject;
		}
		
		public function get ItemFromPool():GameObject
		{
			for each (var item:GameObject in pool)
			{
				if (!item.inuse)
					return item; 
			}
			
			var newItem:GameObject = newObject();
			pool.push(newItem);
			return newItem;
		}
	}
}