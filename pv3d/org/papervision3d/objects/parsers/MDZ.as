package org.papervision3d.objects.parsers{	import com.cutecoma.game.core.IClip3D;	import com.sleepydesign.events.SDEvent;	import flash.events.Event;	import flash.events.ProgressEvent;	import flash.net.URLLoader;	import flash.net.URLLoaderDataFormat;	import flash.net.URLRequest;	import flash.utils.ByteArray;	import flash.utils.Dictionary;	import flash.utils.Endian;	import flash.utils.getTimer;	import mx.graphics.codec.PNGEncoder;	import nochump.util.zip.ZipEntry;	import nochump.util.zip.ZipFile;	import org.papervision3d.core.animation.*;	import org.papervision3d.core.animation.channel.*;	import org.papervision3d.core.geom.TriangleMesh3D;	import org.papervision3d.core.geom.renderables.*;	import org.papervision3d.core.math.NumberUV;	import org.papervision3d.core.proto.DisplayObjectContainer3D;	import org.papervision3d.core.proto.MaterialObject3D;	import org.papervision3d.core.render.data.RenderSessionData;	import org.papervision3d.events.FileLoadEvent;	import org.papervision3d.materials.BitmapFileMaterial;	import org.papervision3d.objects.DisplayObject3D;	/**	 * File loader for the MDZ file format. (MD2, PNG, MD2, PNG,...) in zip format.	 * @author katopz@sleepydesign.com	 */	public class MDZ extends DisplayObject3D implements IAnimationDataProvider, IAnimatable, IClip3D	{		public var meshes:Vector.<MD2>;		protected var file:String;		protected var loader:URLLoader;		protected var loadScale:Number;		protected var _fps:int;		protected var _autoPlay:Boolean;		private var _materials:Dictionary;		private function parse(data:*):void		{			var i:int = 0;			var _zipFile:ZipFile = new ZipFile(data);			var _entry:ZipEntry;			var _fileType:String;			var _fileName:String;			_materials = new Dictionary(true);			// material			for (i = 0; i < _zipFile.entries.length; i++)			{				_entry = _zipFile.entries[i];				_fileType = _entry.name.slice(_entry.name.indexOf("."));				_fileName = _entry.name.split(_fileType)[0];				if (_fileType == ".png")				{					var _bmpByteArray:ByteArray = _zipFile.getInput(_entry);					_materials[_fileName] = _bmpByteArray;				}			}			// mesh			for (i = 0; i < _zipFile.entries.length; i++)			{				_entry = _zipFile.entries[i];				_fileType = _entry.name.slice(_entry.name.indexOf("."));				_fileName = _entry.name.split(_fileType)[0];				if (_fileType == ".md2")				{					var _md2ByteArray:ByteArray = _zipFile.getInput(_entry);					var _md2:MD2 = new MD2(_autoPlay);					_md2.load(_md2ByteArray, new BitmapFileMaterial(), 30, loadScale);					BitmapFileMaterial(_md2.material).loadBytes(_materials[_md2.textureName]);					onSuccess(_md2);				}			}			// gc			_materials = null;		}		private function onSuccess(model:MD2):void		{			if (!meshes)				meshes = new Vector.<MD2>();			meshes.fixed = false;			meshes.push(model);			meshes.fixed = true;			model.rotationZ = -90;			addChild(model);		}		public function get fps():uint		{			return _fps;		}		public function play(clip:String = null):void		{			for each (var md2:MD2 in meshes)				md2.play(clip);		}		public function stop():void		{			for each (var md2:MD2 in meshes)				md2.stop();		}		public function getAnimationChannelByName(name:String):AbstractChannel3D		{			return meshes[0].getAnimationChannelByName(name);		}		public function getAnimationChannels(target:DisplayObject3D = null):Array		{			return meshes[0].getAnimationChannels(target);		}		public function getAnimationChannelsByClip(name:String):Array		{			return meshes[0].getAnimationChannelsByClip(name);		}		public function load(asset:*, material:MaterialObject3D = null, fps:int = 30, scale:Number = 1):void		{			this.loadScale = scale;			this._fps = fps;			this.visible = false;			this.material = material || MaterialObject3D.DEBUG;			if (asset is ByteArray)			{				this.file = "";				parse(asset as ByteArray);			}			else			{				this.file = String(asset);				loader = new URLLoader();				loader.dataFormat = URLLoaderDataFormat.BINARY;				loader.addEventListener(Event.COMPLETE, loadCompleteHandler);				loader.addEventListener(ProgressEvent.PROGRESS, loadProgressHandler);				try				{					loader.load(new URLRequest(this.file));				}				catch (e:Error)				{					//PaperLogger.error("error in loading MD2 file (" + this.file + ")");				}			}		}		public override function project(parent:DisplayObject3D, renderSessionData:RenderSessionData):Number		{			for each (var md2:MD2 in meshes)				md2.project(parent, renderSessionData);			return super.project(parent, renderSessionData);		}		protected function loadCompleteHandler(event:Event):void		{			var loader:URLLoader = event.target as URLLoader;			var data:ByteArray = loader.data;			parse(data);			var md2:MD2;			// reset			for each (md2 in meshes)				md2.stop();			for each (md2 in meshes)				md2.play();			visible = true;		}		protected function loadProgressHandler(event:ProgressEvent):void		{			dispatchEvent(event);		}		public function MDZ(autoPlay:Boolean = true):void		{			super();			_autoPlay = autoPlay;		}	}}