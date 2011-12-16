package com.axiomalaska.map.overlay
{
	import com.axiomalaska.map.LatLon;
	import com.axiomalaska.map.interfaces.ILatLon;
	import com.axiomalaska.map.interfaces.IWMS;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.errors.IOError;
	import flash.events.IOErrorEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	
	public class WMS implements IWMS
	{
		private var _name:String;
		private var _layerNames:String;
		private var _epsg:String;
		private var _format:String;
		private var _bgcolor:String;
		private var _styles:String;
		private var _size:Number;
		private var _tiled:Boolean;
		private var _transparent:Boolean;
		private var _useCache:Boolean;
		private var _params:Object = new Object();
		private var _url:String;
		private var _isBaseLayer:Boolean;
		
		
		
		public function WMS($name:String = '',$url:String = '',$layerNames:String = '', $isBaseLayer:Boolean = false, $epsg:String = '', $params:Object = null)
		{
			name = $name;
			url = $url;
			layerNames = $layerNames;
			isBaseLayer = $isBaseLayer
			epsg = $epsg;
			if($params){
				params = $params;
			}
			for(var p:String in params){
				if(this.hasOwnProperty(p)){
					this[p] = params[p];
				}
			}
		}

		public function get name():String{return _name;}
		public function set name($name:String):void{_name = $name;}	
		
		public function get layerNames():String{return _layerNames;}
		public function set layerNames($layerNames:String):void{_layerNames = $layerNames;}		
		
		public function get url():String{return _url;}
		public function set url($url:String):void{_url = $url;}
		
		public function get epsg():String{return _epsg;}
		public function set epsg($epsg:String):void{_epsg = $epsg}
		
		public function get format():String{return _format;}
		public function set format($format:String):void{_format = $format}
		
		public function get size():Number{return _size;}
		public function set size($size:Number):void{_size = $size}
		
		public function get bgcolor():String{return _bgcolor;}
		public function set bgcolor($bgcolor:String):void{_bgcolor = $bgcolor;}

		public function get styles():String{return _styles;}
		public function set styles($styles:String):void{_styles = $styles;}	
		
		public function get tiled():Boolean{return _tiled;}
		public function set tiled($tiled:Boolean):void{_tiled = $tiled;}
		
		public function get transparent():Boolean{return _transparent;}
		public function set transparent($transparent:Boolean):void{_transparent = $transparent;}

		public function get isBaseLayer():Boolean{return _isBaseLayer;}
		public function set isBaseLayer($isBaseLayer:Boolean):void{_isBaseLayer = $isBaseLayer;}		
		
		public function get useCache():Boolean{return _useCache;}
		public function set useCache($useCache:Boolean):void{_useCache = $useCache}
		
		public function get params():Object{return _params;}
		public function set params($params:Object):void{_params = $params}
		

		public function makeURL($boundingBox:String):String{
			
			return null;
		}
		
		
		public function loadTile($tilePosition:Point,$zoom:Number):DisplayObject
		{
			
			//url = createURL($tilePosition);
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			loader.load(new URLRequest(url));
			return loader; 
		}
		
		private function ioErrorHandler($evt:IOErrorEvent):void{
			//handle error
			trace("WmsTileLayer: IO Error !", $evt.text)
		}
		
		

	}
}