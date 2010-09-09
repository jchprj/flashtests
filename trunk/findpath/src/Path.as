package
{
	public class Path
	{
		private static var _instance:Path;
		
		public var bgXgrids:int = 100;
		public var bgYgrids:int = 100;
		
		/**地图障碍数据**/
		public var datas:Array;
		/**寻路路径数据**/
		private var tmppath:Array;
		
		public var modifyflag:Boolean;
		
		public function Path()
		{
		}
		
		public static function get instance():Path
		{
			if(_instance == null)
			{
				_instance = new Path;
			}
			return _instance;
		}
		
		private function getPath(from:int, to:int, flag:Boolean = true):Array
		{
			var path:Array = [];
			var tmp:int;
			var next:int;
			tmppath = [];
			next = from;
			path.push(next);
			tmppath.push(next);
			var i:int;
			var newway:int;
			var last:int;
			var lasttimes:int;
			var spread:Array;
			while(next != to)
			{
				if(last == next)
				{
					lasttimes++;
					if(lasttimes == 10)
					{
						break;
					}
				}
				else
				{
					lasttimes = 0;
				}
				last = next;
				tmp = getNext(next, to);
				if(tmp != -1)
				{
					next = tmp;
					path.push(next);
					tmppath.push(next);
				}
				else
				{
					spread = spreadNext(getWay(next, to), flag);
					for(i=0;i<8;i++)
					{
						newway = towards(next, spread[i]);
						if(isIndexOK(newway))
						{
							tmppath.push(newway);
							break;
						}
					}
					if(i==8)
					{
						if(path.length > 1)
						{
							next = path[path.length - 2];
							path.pop();
						}
					}
					else
					{
						next = newway;
						path.push(next);
					}
				}
			}
			if(modifyflag)
			{
				checkPath(path);
			}
			return path;
		}
		
		/**优化路线，判断任意两点是否有可行直线路线**/
		private function checkPath(path:Array):void
		{
			var i:int;
			var j:int;
			var k:int;
			var pathx:Array;
			for(i=0;i<path.length - 1;i++)
			{
				for(j=i+1;j<path.length;j++)
				{
					pathx = getLinePath(path[i], path[j]);
					if(pathx.length > 1 && calPath(pathx) < calPath(path, i, j))
					{
						path.splice(i, j-i+1);
						for(k=0;k<pathx.length;k++)
						{
							path.splice(i+k, 0, pathx[k]);
						}
						i = -1;
						break;
					}
				}
			}
		}
		
		/**计算两点间的直线可行通路**/
		private function getLinePath(from:int, to:int):Array
		{
			var fromx:int = from % bgXgrids;
			var fromy:int = Math.floor(from / bgXgrids);
			var tox:int = to % bgXgrids;
			var toy:int = Math.floor(to / bgXgrids);
			var arr:Array = [];
			var i:int;
			var offset:int;
			var diff:int;
			var isok:Boolean = true;
			var index:int;
			if(fromx == tox)
			{
				diff = toy - fromy;
				offset = diff / Math.abs(diff);
				for(i=0;i<=Math.abs(diff);i++)
				{
					index = (fromy + offset * i) * bgXgrids + fromx;
					arr.push(index);
					if(datas[index] == 1)
					{
						isok = false;
					}
				}
			}
			if(fromy == toy)
			{
				diff = tox - fromx;
				offset = diff / Math.abs(diff);
				for(i=0;i<=Math.abs(diff);i++)
				{
					index = (from + offset * i);
					arr.push(index);
					if(datas[index] == 1)
					{
						isok = false;
					}
				}
			}
			if(Math.abs( (toy - fromy) / (tox - fromx) ) == 1)
			{
				var diffx:int = tox - fromx;
				var diffy:int = toy - fromy;
				var offsetx:int = diffx / Math.abs(diffx);
				var offsety:int = diffy / Math.abs(diffy);
				for(i=0;i<=Math.abs(diffx);i++)
				{
					index = (fromy + offsety * i) * bgXgrids + fromx + offsetx * i;
					arr.push(index);
					if(datas[index] == 1)
					{
						isok = false;
					}
				}
			}
			if(isok == false)
			{
				arr.splice(0, arr.length);
			}
			return arr;
		}
		
		/**以某个方向为中心的扩散顺序**/
		private function spreadNext(way:int, flag:Boolean):Array
		{
			var arr:Array = [];
			if(flag)
			{
				arr.push(absway(way-1));
				arr.push(absway(way+1));
				arr.push(absway(way-2));
				arr.push(absway(way+2));
				arr.push(absway(way-3));
				arr.push(absway(way+3));
			}
			else
			{
				arr.push(absway(way+1));
				arr.push(absway(way-1));
				arr.push(absway(way+2));
				arr.push(absway(way-2));
				arr.push(absway(way+3));
				arr.push(absway(way-3));
			}
			arr.push(absway(way+4));
			return arr;
		}
		
		private function absway(way:int):int
		{
			var w:int = way;
			if(w < 0)
			{
				w += 8;
			}
			if(way > 7)
			{
				w -= 8;
			}
			return w;
		}
		
		/**根据起点和终点得到的最佳下一点**/
		private function getNext(index:int, to:int):int
		{
			var next:int;
			var way:int = getWay(index, to);
			next = towards(index, way);					
			if(isIndexOK(next))
			{
				return next;
			}
			return -1;
		}
		
		/**根据起点和终点返回朝向**/
		private function getWay(from:int, to:int):int
		{
			if(from == to)
			{
				return -1;
			}
			var fromx:int = from % bgXgrids;
			var fromy:int = Math.floor(from / bgXgrids);
			var tox:int = to % bgXgrids;
			var toy:int = Math.floor(to / bgXgrids);
			if(fromx == tox)
			{
				return toy > fromy ? 5 : 1;
			}
			else if(fromy == toy)
			{
				return tox > fromx ? 3 : 7;
			}
			else if(toy < fromy)
			{
				return fromx > tox ? 0 : 2;
			}
			else
			{
				return fromx > tox ? 6 : 4; 
			}
		}
		
		/**返回当前下标的8个朝向的下标
		 * 0  1  2
		 * 7  i  3
		 * 6  5  4
		 * **/
		private function towards(index:int, way:int):int
		{
			var xx:int = index % bgXgrids;
			var yy:int = Math.floor(index / bgXgrids);
			if(xx == 0 && (way == 0 || way == 7 || way == 6))
			{
				return -1;
			}
			if(xx == (bgXgrids - 1) && (way == 2 || way == 3 || way == 4))
			{
				return -1;
			}
			if(yy == 0 && (way == 0 || way == 1 || way == 2))
			{
				return -1;
			}
			if(yy == (bgYgrids - 1) && (way == 6 || way == 5 || way == 4))
			{
				return -1;
			}
			switch(way)
			{
				case 0:
					return index - bgXgrids - 1;
					break;
				case 1:
					return index - bgXgrids;
					break;
				case 2:
					return index - bgXgrids + 1;
					break;
				case 7:
					return index - 1;
					break;
				case 3:
					return index + 1;
					break;
				case 6:
					return index + bgXgrids - 1;
					break;
				case 5:
					return index + bgXgrids;
					break;
				case 4:
					return index + bgXgrids + 1;
					break;
			}
			return -1;
		}
		
		/**某个点是否已经尝试过**/
		private function hasMoved(index:int):Boolean
		{
			var i:int;
			for(i=0;i<tmppath.length;i++)
			{
				if(tmppath[i] == index)
				{
					return true;
				}
			}
			return false;
		}
		
		/**某个点是否可达**/
		private function isIndexOK(index:int):Boolean
		{
			if(index > -1 && index < datas.length &&  
				datas[index] == 0 && hasMoved(index) == false)
			{
				return true;
			}
			return false;
		}
		
		/**计算路径长度**/
		private function calPath(arr:Array, start:int = 0, end:int = 0):Number
		{
			if(end == 0)
			{
				end = arr.length - 1;
			}
			var len:Number = 0;
			var i:int;
			var fromx:int;
			var fromy:int;
			var tox:int;
			var toy:int;
			for(i=start+1;i<end+1;i++)
			{
				fromx = arr[i-1] % bgXgrids;
				fromy = Math.floor(arr[i-1] / bgXgrids);
				tox = arr[i] % bgXgrids;
				toy = Math.floor(arr[i] / bgXgrids);
				if(fromx == tox || fromy == toy)
				{
					len += 1;
				}
				else
				{
					len += 1.414;
				}
			}
			return len;
		}
		
		public function find(fromp:int, top:int):Array
		{
			var arr:Array = getPath(fromp, top);
			if(arr.length > 1)
			{
				var arr1:Array = getPath(fromp, top, false);
				if(calPath(arr1) < calPath(arr))
				{
					arr = arr1;
				}
			}
			return arr;
		}
	}
}