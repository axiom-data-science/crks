package com.axiomalaska.map.types.google.overlay.WMS
{
	import com.google.maps.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	
	
	// extend TileLayerBase class to provide custom loaders
	public class Relief extends TileLayerBase {
		
		public var url:String = 'http://maps-for-free.com/layer/relief/';
		public var minResolution:Number;
		public var maxResolution:Number;
		
		//private var offset:Number=16777216;
		//private var radius:Number=offset / Math.PI; 
		
		// constructor
		public function Relief(url:String = null,
									  alpha:Number=Alpha.OPAQUE,
									  minResolution:Number = 2,
									  maxResolution:Number = 11,
									  copyright:String=null) 
		{
			
			// store properties
			if(url){
				this.url = url;
			}
			this.minResolution = minResolution;
			this.maxResolution = maxResolution;
			
			
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
			//if (zoom < minResolution) return new Loader();
			//if (zoom > maxResolution) return new Loader();
			
			// add X,Y,Z parameter for gwms.ashx connector
			//z" + b + "/row" + a.y + "/" + b + "_" + a.x + "-" + a.y + ".gif"
			var url:String = this.url;
			//url+= '/' + tilePos.x.toString() + "/" + tilePos.y.toString() + "/" + zoom.toString();   
			//http://www.maps-for-free.com/layer/relief/z5/row9/5_12-9.jpg
			url += 'z' + zoom + '/row' + tilePos.y + '/' + zoom +  '_' + tilePos.x + '-' + tilePos.y + '.jpg';
			
			//trace('TILE URL = ' + url);
			
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