package {
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**      * 图形缓冲范例子弹类      * Author:D5Power      * www.d5power.com www.webgamei.com      */
	public class zidan {
		/**          * 子弹的图形素材          */
		private	var doc: BitmapData;
		/**          * x坐标          */
		private	var x: uint;
		/**          * y坐标          */
		private	var y: uint;
		/**          * x轴速度          */
		private	var speed_x: uint = 3;
		/**          * y轴速度          */
		private	var speed_y: uint = 3;
		/**          * 子弹构造函数          * @param   _doc        子弹素材          * @param   _buffer     主场景缓冲区          */
		public function zidan(_doc: BitmapData, _buffer: BitmapData) {
			doc = _doc;
		}
		/**          * 设置子弹的位置          */
		public function set Pos(p: Point) : void {
			x = p.x;
			y = p.y;
		}
		/**          * 渲染函数，当子弹超出屏幕边界则反弹          */
		public function render(buffer: BitmapData) : void {
			x += speed_x;
			//y += speed_y;
			if (x > main.W || x < 0) {
				speed_x = -speed_x;
			}
			if (y > main.H || y < 0) {
				speed_y = -speed_y;
			}
			// 将子弹的素材按照数据的标准位置，复制到缓冲区 
			var r:Rectangle = new Rectangle(0,0,doc.width-3,doc.height);
			buffer.copyPixels(doc,r,new Point(x,y),null,null,true);
		}
	}
} 
			