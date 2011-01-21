package
{
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	
	public class MapEditor extends Sprite
	{
		private var drawBtn:PushButton;
		private var output:Label;
		
		public function MapEditor()
		{
			super();
			drawBtn = new PushButton(this, 50, 100, "DRAW");
			output = new Label(null, 0, 0);
			output.height = 200;
			addChild(output);
			output.filters = [new GlowFilter(0xFFFFFF, 1, 2, 2, 15)];
			EventCenter.addEventListener("trace", onTrace);
		}
		
		private function onTrace(s:String):void
		{
			output.text = s;
		}
	}
}