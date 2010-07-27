package 
{
	import flash.display.*;
	
	public final class ResourceManager
	{
		[Embed(source="../media/brownplane.png")]
		public static var BrownPlane:Class;
		public static var BrownPlaneGraphics:GraphicsResource = new GraphicsResource(new BrownPlane(), 3, 20);
		
		[Embed(source="../media/smallgreenplane.png")]
		public static var SmallGreenPlane:Class;
		public static var SmallGreenPlaneGraphics:GraphicsResource = new GraphicsResource(new SmallGreenPlane(), 3, 20);
		
		[Embed(source="../media/smallblueplane.png")]
		public static var SmallBluePlane:Class;
		public static var SmallBluePlaneGraphics:GraphicsResource = new GraphicsResource(new SmallBluePlane(), 3, 20);
		
		[Embed(source="../media/smallwhiteplane.png")]
		public static var SmallWhitePlane:Class;
		public static var SmallWhitePlaneGraphics:GraphicsResource = new GraphicsResource(new SmallWhitePlane(), 3, 20);
		
		[Embed(source="../media/bigexplosion.png")]
		public static var BigExplosion:Class;
		public static var BigExplosionGraphics:GraphicsResource = new GraphicsResource(new BigExplosion(), 7, 20);
		
		[Embed(source="../media/smallisland.png")]
		public static var SmallIsland:Class;
		public static var SmallIslandGraphics:GraphicsResource = new GraphicsResource(new SmallIsland());
		
		[Embed(source="../media/bigisland.png")]
		public static var BigIsland:Class;
		public static var BigIslandGraphics:GraphicsResource = new GraphicsResource(new BigIsland());
		
		[Embed(source="../media/volcanoisland.png")]
		public static var VolcanoIsland:Class;
		public static var VolcanoIslandGraphics:GraphicsResource = new GraphicsResource(new VolcanoIsland());
		
		[Embed(source="../media/twobullets.png")]
		public static var TwoBullets:Class;
		public static var TwoBulletsGraphics:GraphicsResource = new GraphicsResource(new TwoBullets());
		
		[Embed(source="../media/cloud.png")]
		public static var Cloud:Class;
		public static var CloudGraphics:GraphicsResource = new GraphicsResource(new Cloud());
	}
}