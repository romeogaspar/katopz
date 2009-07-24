package{	import flash.display.*;	import flash.events.*;	import flash.geom.*;		import open3d.materials.BitmapMaterial;	import open3d.objects.Plane;	import open3d.render.Layer;	import open3d.utils.LoaderUtil;	import open3d.view.SimpleView;	[SWF(width="800",height="600",backgroundColor="#000000",frameRate="30")]	public class ExOceanSurface extends SimpleView	{		private var plane:Plane;		private var textureBitmap:BitmapData;		private var heightMap:BitmapData;		private var perlinNoiseFallOff:BitmapData;		private var gradBmp:BitmapData;		private var perlinNoiseOffset:Array = new Array(2);		private var paletteArray:Array = [];		private var nw:Number;		private var nh:Number;		private var numOctaves:Number;		private var randSeed:Number;		//use to test speed		private var origin:Point = new Point();		private var aa:Number = 0.2;		private var bb:Number = 0.2;		private var isReady:Boolean = false;				private var oceanLayer:Sprite;				override protected function create():void		{			isReady = false;			LoaderUtil.load("assets/seaGradAlpha.png", onLoad);						oceanLayer = new Layer();			addChild(oceanLayer);		}		private function onLoad(event:Event):void		{			if (event.type != Event.COMPLETE)				return;			var bt:Bitmap = Bitmap(event.target.content);			bt.smoothing = true;			gradBmp = bt.bitmapData;			init3D();		}		private function init3D():void		{			//----------------------------------------			// create heighMaps			var heightMapWidth:Number = 100;			heightMap = new BitmapData(heightMapWidth, heightMapWidth, false, 0);			textureBitmap = heightMap.clone();			for (var ra:uint = 0; ra < 256; ra++)			{				paletteArray[ra] = gradBmp.getPixel32(10, 255 - ra);			}			// create textures						var textureMaterial:BitmapMaterial = new BitmapMaterial(textureBitmap);			// create terrain			plane = new Plane(800, 800, textureMaterial, 32, 32);			plane.rotationX = -45;			plane.layer = oceanLayer;			plane.z = 100;			renderer.addChild(plane);			generateTerrain();			isReady = true;		}		private function generateTerrain(e:Event = null):void		{			nw = heightMap.width * .66;			nh = heightMap.height * .66;			numOctaves = 3;			randSeed = Math.random() * 1000;			perlinNoiseOffset = [new Point(), new Point()];			updateLevels();		}		private function updateLevels():void		{			perlinNoiseOffset[0].x -= 2 * aa;			perlinNoiseOffset[1].x -= 1.5 * aa;			nw = heightMap.width * bb;			nh = heightMap.height * bb;			heightMap.perlinNoise(nw, nh, numOctaves, randSeed, true, false, 4, false, perlinNoiseOffset);			textureBitmap.paletteMap(heightMap, heightMap.rect, origin, paletteArray, paletteArray, paletteArray);			textureBitmap.copyPixels(textureBitmap, textureBitmap.rect, origin, perlinNoiseFallOff, origin, false);						var gridX:Number = 1 + 32;			var gridY:Number = 1 + 32;			var iW:Number = heightMap.width / gridX;			var iH:Number = heightMap.height / gridY;			var k:int = 0;			for (var ix:int = 0; ix < gridX; ix++)			{				for (var iy:int = 0; iy < gridY; iy++)				{					var elevation:Number = Number(heightMap.getPixel(ix * iW, heightMap.height - iy * iH));					plane.setVertices(k++, "z", Math.min(0xFF, Math.max(1, elevation)) / 5);				}			}		}		override protected function draw():void		{			if (isReady)				updateLevels();		}	}}