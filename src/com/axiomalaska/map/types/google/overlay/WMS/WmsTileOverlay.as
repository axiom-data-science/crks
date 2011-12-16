package com.axiomalaska.map.types.google.overlay.WMS
{
	// WMS tiled layer 
	//
	// use this class to add a (Demis) WMS layer only to a specific MapType.
	// to overlay a wms on all map types, use WmsTileLayerOverlay instead 
	//
	// based on code provided by Javier de la Torre:
	// http://biodivertido.blogspot.com/2008/08/wms-overlays-in-google-maps-for-flash.html
	//
	// NOTE: for best performance with DemisWMS, instead of this class you should use DemisTileOverlay
	// NOTE: the Cache parameter is specific for DemisWMS, to use this class with other WMS, set Cache = null
	// 
		
	import com.axiomalaska.map.overlay.WMS;
	import com.google.maps.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	
	
	// extend TileLayerBase class to load WMS images
	public class WmsTileOverlay extends TileLayerBase {
		
		public var urlWms:String;
		public var minResolution:Number=5;
		public var maxResolution:Number=17;		
		private var cache:String=null;
		private var wms:WMS;

		
		// constructor
		public function WmsTileOverlay(urlWms:String,
									 name:String,
									 layers:String,
									 epsg:String,
									 alpha:Number=Alpha.OPAQUE,
									 minResolution:Number = 5,
									 maxResolution:Number = 17,
									 cache:String=null,
									 copyright:String=null) 
		{
			// remove BBOX, WIDTH, HEIGHT from URL ?
			var args:Array = urlWms.split("&")
			for (var i:int = 0; i < args.length; i++) {
				var arg:String = args[i].toLowerCase();
				if (arg.indexOf("bbox") == 0) args.splice(i,1);
				if (arg.indexOf("width") == 0) args.splice(i,1);
				if (arg.indexOf("height") == 0) args.splice(i,1);
			}
			this.urlWms = args.join("&");
			
			// store properties
			this.minResolution = minResolution;
			this.maxResolution = maxResolution;
			this.cache = cache;
			this.wms = new WMS(name,urlWms,layers,false,epsg);
			
			
			// Add a custom copyright that will apply to the entire map layer.
			var copyrightCollection:CopyrightCollection = new CopyrightCollection();
			if (copyright != null) {
				copyrightCollection.addCopyright(new Copyright("CustomCopyright",
					new LatLngBounds(new LatLng(-90, -180), new LatLng(90, 180)),
					minResolution,
					copyright,
					maxResolution,
					true));
			}      
			// call TileLayerBase constructor
			super(copyrightCollection, minResolution, maxResolution, alpha);
		}
		
		public override function loadTile(tilePos:Point, zoom:Number):DisplayObject {
			
			//wms.zoom = zoom;
			return wms.loadTile(tilePos,zoom);
			
		}
		
		
	} // WmsTileLayer
		

}

