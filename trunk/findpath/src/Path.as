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
		private var paths:Array;
		private var tmppath:Array;
		private var spreadOrder:Array = [0,0,0,0,0,0,0];
		private var linepath:Array;
		
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
		
		public function init(data:Array):void
		{
			this.datas = data;
			tmppath = [];
			linepath = [];
			var i:int;
			var len:int = datas.length;
			for(i=0;i<len;i++)
			{
				tmppath.push(0);
				linepath.push(0);
			}
		}
		
		private function getPath(from:int, to:int, wayflag:Boolean = true):Array
		{
			var path:Array = [];
			var tmp:int;
			var next:int;
			//tmppath = [];
			var i:int;
			var len:int = datas.length;
			for(i=0;i<len;i++)
			{
				tmppath[i] = 0;
			}
			next = from;
			path.push(next);
			tmppath[next] = 1;
			var newway:int;
			var last:int;
			var lasttimes:int;
			while(next != to)
			{
				tmp = getNext(next, to);
				if(tmp != -1)
				{
					next = tmp;
					path.push(next);
					tmppath[next] = 1;
				}
				else
				{
					setSpread(getWay(next, to), wayflag);
					for(i=0;i<8;i++)
					{
						newway = towards(next, spreadOrder[i]);
						if(isIndexOK(newway))
						{
							tmppath[newway] = 1;
							break;
						}
					}
					if(i==8)
					{
						if(path.length > 1)
						{
							next = path[path.length - 2];
							path.pop();
							//tmppath.pop();
						}
						if(last == next)
						{
							lasttimes++;
							if(lasttimes == 10)
							{
								path.splice(1, path.length - 1);
								break;
							}
						}
						else
						{
							lasttimes = 0;
						}
						last = next;
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
			var linetotal:int;
			var len:int = path.length - 1;
			for(i=0;i<len;i++)
			{
				for(j=len-1;j>i;j--)
				{
					if(j - i > 1)
					{
						linetotal = getLinePath(path[i], path[j], j-i);
						if(linetotal > 1)
						{
							if(linetotal < j - i || calPath(linepath, 0, linetotal - 1) < calPath(path, i, j))
							{
								path.splice(i, j-i+1);
								for(k=0;k<linetotal;k++)
								{
									path.splice(i+k, 0, linepath[k]);
								}
								len = path.length - 1;
								i = -1;
								break;
							}
						}
					}
				}
			}
		}
		
		/**计算两点间的直线可行通路，返回通路长度**/
		private function getLinePath(from:int, to:int, minlen:int):int
		{
			var fromx:int = from % bgXgrids;
			var fromy:int = Math.floor(from / bgXgrids);
			var tox:int = to % bgXgrids;
			var toy:int = Math.floor(to / bgXgrids);
			var linetotal:int;
			var arr:Array = linepath;
			var i:int;
			var offset:int;
			var diff:int;
			var index:int;
			var len:int;
			
			/*var next:int = from;
			arr[linetotal++] = next;
			var tmp:int;
			while(next != to)
			{
				next = getNextLine(next, to);
				arr[linetotal++] = next;
				if(next == -1)
				{
					isok = false;
					break;
				}
			}*/
			
			
			
			if(fromx == tox)
			{
				diff = toy - fromy;
				len = Math.abs(diff);
				if(len >= minlen)
				{
					return 0;
				}
				offset = diff > 0 ? 1 : -1;
				for(i=0;i<=len;i++)
				{
					index = (fromy + offset * i) * bgXgrids + fromx;
					arr[linetotal++] = index;
					if(datas[index] == 1)
					{
						return 0;
					}
				}
			}
			else if(fromy == toy)
			{
				diff = tox - fromx;
				len = Math.abs(diff);
				if(len >= minlen)
				{
					return 0;
				}
				offset = diff > 0 ? 1 : -1;
				for(i=0;i<=len;i++)
				{
					index = (from + offset * i);
					arr[linetotal++] = index;
					if(datas[index] == 1)
					{
						return 0;
					}
				}
			}
			else if(Math.abs( (toy - fromy) / (tox - fromx) ) == 1)
			{
				var diffx:int = tox - fromx;
				var diffy:int = toy - fromy;
				len = Math.abs(diff);
				if(len >= minlen)
				{
					return 0;
				}
				var offsetx:int = diffx > 0 ? 1 : -1;
				var offsety:int = diffy > 0 ? 1 : -1;
				for(i=0;i<=len;i++)
				{
					index = (fromy + offsety * i) * bgXgrids + fromx + offsetx * i;
					arr[linetotal++] = index;
					if(datas[index] == 1)
					{
						return 0;
					}
				}
			}
			else
			{
				
			}
			return linetotal;
		}
		
		/**根据起点和终点得到的最佳下一点**/
		private function getNextLine(index:int, to:int):int
		{
			var next:int;
			var way:int = getWay(index, to);
			next = towards(index, way);
			if(next > -1 && next < datas.length && datas[next] == 0)
			{
				return next;
			}
			return -1;
		}
		
		/**以某个方向为中心的扩散顺序**/
		private function setSpread(way:int, flag:Boolean):void
		{
			var i:int;
			if(flag)
			{
				spreadOrder[i++] = absway(way-1);
				spreadOrder[i++] = absway(way+1);
				spreadOrder[i++] = absway(way-2);
				spreadOrder[i++] = absway(way+2);
				spreadOrder[i++] = absway(way-3);
				spreadOrder[i++] = absway(way+3);
			}
			else
			{
				spreadOrder[i++] = absway(way+1);
				spreadOrder[i++] = absway(way-1);
				spreadOrder[i++] = absway(way+2);
				spreadOrder[i++] = absway(way-2);
				spreadOrder[i++] = absway(way+3);
				spreadOrder[i++] = absway(way-3);
			}
			spreadOrder[i++] = absway(way+4);
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
		
		/**某个点是否可达**/
		private function isIndexOK(index:int):Boolean
		{
			if(index > -1 && index < datas.length &&  
				datas[index] == 0 && tmppath[index] == 0)
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