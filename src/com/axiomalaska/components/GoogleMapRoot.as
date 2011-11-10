package com.axiomalaska.components
{
	import org.openscales.core.Util;
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.layer.osm.*;
	
	/**
	 * Mapnik OpenStreetMap layer
	 *
	 * More informations on
	 * http://wiki.openstreetmap.org/index.php/Mapnik
	 */
	public class GoogleMapRoot extends OSM
	{
		public function GoogleMapRoot(name:String,
								isBaseLayer:Boolean = false,
								visible:Boolean = true, 
								projection:String = null,
								proxy:String = null)
		{
			//TERRAIN
			//var url :String = "http://mt1.google.com/vt/lyrs=t@125,r@126&hl=en&src=api&";
			//SATELITE
			//var url:String = "http://khm0.google.com/kh/v=60&s=Galileo&"
			//DEFAULT
			var url:String = "http://mt0.google.com/vt/lyrs=m@126&hl=en&src=api&s=Gal&"
			
			//var alturls : Array = [	"http://e.tah.openstreetmap.org/Tiles/maplint/",
			//"http://f.tah.openstreetmap.org/Tiles/maplint/"];
			
			super(name, url, isBaseLayer, visible, projection, proxy);
			
			//this.altUrls = alturls;
			
			this.generateResolutions(19, OSM.DEFAULT_MAX_RESOLUTION);
		}
		
		override public function getURL(bounds:Bounds):String
		{

			var res:Number = this.map.resolution;
			var x:Number = Math.round((bounds.left - this.maxExtent.left) / (res * this.tileWidth));
			var y:Number = Math.round((this.maxExtent.top - bounds.top) / (res * this.tileHeight));
			var z:Number = this.map.zoom;
			var limit:Number = Math.pow(2, z);
			
			if (y < 0 || y >= limit ||x < 0 || x >= limit) {
				return OSM.MISSING_TILE_URL;
			} else {
				x = ((x % limit) + limit) % limit;
				y = ((y % limit) + limit) % limit;
				var url:String = this.url;
				var path:String = 'z=' + z + "&x=" + x + "&y=" + y;
				if (this.altUrls != null) {
					url = this.selectUrl(this.url + path, this.getUrls());
				}
				return url + path;
			}
		}		
		
		
	}
}