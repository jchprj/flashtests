package
{
	import flash.display.Graphics;
	import flash.utils.setTimeout;

	public class DrawCurve
	{
		private var gra:Graphics;
		private var maskgra:Graphics;
		private var pt1:Object;
		private var pt2:Object;
		private var pt0:Object;
		private var pt3:Object;
		private var i:Number;
		
		public function DrawCurve(gra:Graphics, maskgra:Graphics)
		{
			this.gra = gra;
			this.maskgra = maskgra;
		}
		
		private function setPoints(pt0:Object,pt3:Object):void
		{
			gra.clear();
			
			var dd:Number = Math.sqrt(Math.pow((pt3.y - pt0.y),2) + Math.pow((pt3.x - pt0.x),2));
			var xx:Number = (pt0.x + pt3.x)/2;
			var yy:Number = (pt0.y + pt3.y)/2;
			var k1:Number = (pt3.y - pt0.y) / (pt3.x - pt0.x);
			var k:Number = - 1 / k1;
			var a:Number = yy - xx * k;
			drawLine(k, a);
			
			dd = dd / 10;
			var angle:Number = Math.atan(k);
			var hh:Number = dd * Math.sin(angle);
			var ww:Number = dd * Math.cos(angle);
			var newxx:Number = xx + ww;
			var newyy:Number = yy + hh;
			var pp:Object = {x:newxx, y:newyy};
			
			this.pt0 = pt0;
			this.pt1 = pp;
			this.pt2 = pp;
			this.pt3 = pt3;
			gra.lineStyle(3, 0x00FF00, 1);//绿色
			gra.moveTo(pt0.x, pt0.y);
			gra.lineTo(pt0.x+1, pt0.y+1);
			gra.lineStyle(3, 0x0000FF, 1);//蓝色
			gra.moveTo(pt1.x, pt1.y);
			gra.lineTo(pt1.x+1, pt1.y+1);
			gra.lineStyle(3, 0xFFF000, 1);//黄色
			gra.moveTo(pt2.x, pt2.y);
			gra.lineTo(pt2.x+1, pt2.y+1);
			gra.lineStyle(3, 0xFF0000, 1);//红色
			gra.moveTo(pt3.x, pt3.y);
			gra.lineTo(pt3.x+1, pt3.y+1);
			gra.lineStyle(1, 0x0, 1);
		}
		
		public function cubic_curve(pt0:Object,pt3:Object):void
		{
			setPoints(pt0, pt3);
			//drawMask();
			gra.moveTo(pt0.x, pt0.y);
			i = 0;
			drawPoint();
		}
		
		private function drawMask():void
		{
			maskgra.clear();
			maskgra.beginFill(0x0);
			maskgra.moveTo(pt0.x, pt0.y);
			var sx:Number = Math.min(pt0.x, pt3.x);
			var sy:Number = Math.min(pt0.y, pt3.y);
			var i:int;
			var j:int;
			for(i=0; i*3 < Math.abs(pt3.x-pt0.x);i++)
			{
				for(j=0;j*3<Math.abs(pt3.y-pt0.y);j++)
				{
					if(j%2)
					{
						maskgra.drawRect(i*3+sx, j*3+sy, 3, 3);
					}
				}
			}
			maskgra.endFill();
		}
		
		private function drawPoint():void
		{
			var pos_x:Number;
			var pos_y:Number;
			pos_x=Math.pow(i,3)*(pt3.x+3*(pt1.x-pt2.x)-pt0.x)
				+3*Math.pow(i,2)*(pt0.x-2*pt1.x+pt2.x)
				+3*i*(pt1.x-pt0.x)+pt0.x;
			pos_y=Math.pow(i,3)*(pt3.y+3*(pt1.y-pt2.y)-pt0.y)
				+3*Math.pow(i,2)*(pt0.y-2*pt1.y+pt2.y)
				+3*i*(pt1.y-pt0.y)+pt0.y;
			if(int(i*100)%10<5)
			{
				gra.lineTo(pos_x,pos_y);
			}
			else
			{
				gra.moveTo(pos_x,pos_y);
			}
			i+=2/100;
			if(i<=1)
			{
				setTimeout(drawPoint, 10);
			}
		}
		
		private function drawLine(k:Number, a:Number):void
		{
			var x1:Number = 0;
			var y1:Number = k * x1 + a;
			var x2:Number = 1000;
			var y2:Number = k * x2 + a;
			//var y2:Number = 0;
			//var x2:Number = (y2 - a) / k;
			gra.lineStyle(1, 0x0, 1);
			gra.moveTo(x1, y1);
			gra.lineTo(x2, y2);
		}
	}
}