package
{
	import away3dlite.animators.BonesAnimator;
	import away3dlite.animators.MovieMesh;
	import away3dlite.core.base.Object3D;
	import away3dlite.core.exporters.MD2Exporter;
	import away3dlite.core.utils.Debug;
	import away3dlite.events.Loader3DEvent;
	import away3dlite.loaders.Collada;
	import away3dlite.loaders.Loader3D;
	import away3dlite.loaders.MD2;
	import away3dlite.materials.BitmapFileMaterial;
	import away3dlite.templates.BasicTemplate;
	
	import flash.geom.Vector3D;
	import flash.utils.*;

	[SWF(backgroundColor="#CCCCCC", frameRate="30", width="800", height="600")]
	public class ExMD2Exporter extends BasicTemplate
	{
		private var collada:Collada;
		private var loader3D:Loader3D;
		
		private var model:Object3D;
		private var skinAnimation:BonesAnimator;

		override protected function onInit():void
		{
			Debug.active = false;
			camera.y = -500;
			camera.lookAt(new Vector3D());

			collada = new Collada();
			collada.scaling = 5;

			loader3D = new Loader3D();
			loader3D.loadGeometry("assets/30_box_smooth_translate.dae", collada);
			loader3D.addEventListener(Loader3DEvent.LOAD_SUCCESS, onSuccess);
			scene.addChild(loader3D);
			
			/*
			var md2:MD2 = new MD2();
			md2.scaling = 5;
			md2.material = new BitmapFileMaterial("assets/yellow.jpg");
			loader3D = new Loader3D();
			loader3D.addEventListener(Loader3DEvent.LOAD_SUCCESS, onSuccess);
			loader3D.loadGeometry("assets/tri.md2", md2);
			scene.addChild(loader3D);
			*/
			
			//alpha = 0;
		}

		private function onSuccess(event:Loader3DEvent):void
		{
			model = loader3D.handle;
			model.x = 100;

			//skinAnimation = model.animationLibrary.getAnimation("default").animation as BonesAnimator;

			var _md2Exporter:MD2Exporter = new MD2Exporter(model, onConvertComplete);
			//_md2Exporter.addEventListener(Loader3DEvent.LOAD_SUCCESS, onConvertComplete);
		}

		private function onConvertComplete(model:MovieMesh):void
		{
			//var model:MovieMesh = event.loader.handle as MovieMesh;
			scene.addChild(model);
			//model.play("walk");
		}

		override protected function onPreRender():void
		{
			//update the collada animation
			if (skinAnimation)
				skinAnimation.update(getTimer() / 1000);

			scene.rotationY++;
		}
	}
}