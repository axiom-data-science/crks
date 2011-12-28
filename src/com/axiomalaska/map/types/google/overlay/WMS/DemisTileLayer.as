package com.axiomalaska.map.types.google.overlay.WMS
{

	import com.google.maps.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	
	
	// extend TileLayerBase class to provide custom loaders
	public class DemisTileLayer extends TileLayerBase {
		
		public var url:String;
		public var map:String;
		public var minResolution:Number=5;
		public var maxResolution:Number=17;
		
		private var offset:Number=16777216;
		private var radius:Number=offset / Math.PI; 
		
		// constructor
		public function DemisTileLayer(url:String,
									   map:String="SAMPLE",
									   alpha:Number=Alpha.OPAQUE,
									   minResolution:Number = 5,
									   maxResolution:Number = 17,
									   copyright:String=null) 
		{
			
			// store properties
			this.url = url;
			this.map = map;
			this.minResolution = minResolution;
			this.maxResolution = maxResolution;
			this.map = map;
			
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
			
			// min & max zoom are ignored by the (1.7a) API, so check these !
			if (zoom < minResolution) return new Loader();
			if (zoom > maxResolution) return new Loader();
			
			// add X,Y,Z parameter for gwms.ashx connector
			var url:String = this.url;
			if (this.map != null) url+= "?MAP=" + this.map + "&X=" + tilePos.x.toString() + "&Y=" + tilePos.y.toString() + "&Z=" + zoom.toString();            
			
			trace('TILE URL = ' + url);
			
			// return loader for this url
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			loader.load(new URLRequest(url));
			return loader;    
			
		}
		
		public function ioErrorHandler(event:IOErrorEvent):void {
			trace("WmsTileLayer: IO Error !", event.text)
		}
		
	} // DemisTileLayer
	
	
}

