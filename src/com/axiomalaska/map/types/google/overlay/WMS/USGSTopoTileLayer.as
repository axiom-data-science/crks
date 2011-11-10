package com.axiomalaska.map.types.google.overlay.WMS
{
	import com.google.maps.*;
	import com.google.maps.interfaces.IProjection;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	
	
	// extend TileLayerBase class to provide custom loaders
	public class USGSTopoTileLayer extends TileLayerBase {
		
		public var url:String;
		public var minResolution:Number=5;
		public var maxResolution:Number=17;
		public var epsg:Number;
		
		//offset from upper left to origin of coordinate system that map uses
		private var offset:Number=16777216;
		private var radius:Number=offset / Math.PI; 
		
		// constructor
		public function USGSTopoTileLayer(url:String,
											 alpha:Number=Alpha.OPAQUE,
											 minResolution:Number = 1,
											 maxResolution:Number = 17,
											 copyright:String=null) 
		{
			
			// store properties
			this.url = url;
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
			if (zoom < minResolution) return new Loader();
			if (zoom > maxResolution) return new Loader();
			
			var tileIndexLL:Point = new Point(256*tilePos.x, 256*(tilePos.y+1));
			var tileIndexUR:Point = new Point(256*(tilePos.x+1), 256*(tilePos.y));
			
			//var z:Number = this.maxResolution - zoom;
			//var z:Number = zoom;
			
			//trace('zoom = ' + z);
			
			//z = 3;
			
			// convert LL, UR to LatLng
			//var LL:LatLng = new LatLng(YToL(z,tileIndexLL.y),XToL(z,tileIndexLL.x));
			//var UR:LatLng = new LatLng(YToL(z,tileIndexUR.y),XToL(z,tileIndexUR.x));
			
			// add WMS parameters
			/*var url:String = this.url;
			url+= "?REQUEST=GetMap&SERVICE=WMS&VERSION=1.1.1&LAYERS=DRG&FORMAT=image/jpeg&BGCOLOR=0xFFFFFF&TRANSPARENT=TRUE&SRS=EPSG:4326&";
			url+= "&BBOX=" + LL.lng().toString() + "," + LL.lat().toString() + "," + UR.lng().toString() + "," + UR.lat().toString();
			url+= "&WIDTH=256&HEIGHT=256&REASPECT=false&STYLES=";
			*/
			
			
			
			var url:String = this.url;
			url+= "?REQUEST=GetMap&SERVICE=WMS&VERSION=1.1.1&LAYERS=DRG&FORMAT=image/jpeg&BGCOLOR=0xFFFFFF&TRANSPARENT=TRUE&SRS=EPSG:4326&";
			url += "&BBOX=" + getBBox(4326,tilePos,zoom);
			//url+= "&BBOX=" + LL.lng().toString() + "," + LL.lat().toString() + "," + UR.lng().toString() + "," + UR.lat().toString();
			url+= "&WIDTH=256&HEIGHT=256&REASPECT=false&STYLES=";			
			
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
		
		
		private function getBBox($epsg:Number,$tile:Point,$zoom:int):String{
			
			//
			//var tileSize:Number = this.getMapType().getTileSize();
			var tileSize:Number = 256;//gMap.getCurrentMapType().getTileSize();
			var fauxZoom:Number = $zoom - ( tileSize / 256 ) + 1;
			
			var bbox:String;
			
			switch( $epsg ){
				case 900913:			
					var initialResolution:Number = 2 * Math.PI * 6378137 / tileSize;  // == 156543.0339 for 256
					var res:Number = initialResolution / ( 1 << fauxZoom );
					var originShift:Number = Math.PI * 6378137; // == 20037508.34
					
					$tile.y = (( 1 << fauxZoom ) - $tile.y - 1); // TMS
					
					bbox = [
						($tile.x * tileSize * res - originShift)
						,($tile.y * tileSize * res - originShift)
						,(($tile.x + 1) * tileSize * res - originShift)
						,(($tile.y + 1) * tileSize * res - originShift)
					].join(',');  			
					break;
				case 4326:
					var southWestPixel:Point = new Point(
						$tile.x * tileSize
						,( $tile.y + 1 ) * tileSize
					); 
					var northEastPixel:Point = new Point(
						( $tile.x + 1 ) * tileSize
						, $tile.y * tileSize
					); 		 
					
					var projection:IProjection = MapType.NORMAL_MAP_TYPE.getProjection();
					//var projection:IProjection = this.getMapType().getProjection();
					
					
					var southWestCoords:LatLng = projection.fromPixelToLatLng( southWestPixel, $zoom, false);
					var northEastCoords:LatLng = projection.fromPixelToLatLng( northEastPixel, $zoom, false ); 
					
					
					
					// = G_NORMAL_MAP.getProjection().fromPixelToLatLng( southWestPixel, zoom, false); 
					//var northEastCoords = G_NORMAL_MAP.getProjection().fromPixelToLatLng( northEastPixel, zoom, false ); 		 
					
					bbox = [
						southWestCoords.lng()
						,southWestCoords.lat()
						,northEastCoords.lng()
						,northEastCoords.lat()
					].join(',');
					break;
				default:
					bbox = [
						0
						,0
						,0
						,0
					].join(',');  						
					break;
			}
			return bbox;
		}
		
		
		
		
		
	}
}