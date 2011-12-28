package com.axiomalaska.map.types.google.projections
{
	import com.google.maps.LatLng;
	import com.google.maps.ProjectionBase;
	
	import flash.geom.Point;
	
	public class PolarProjection extends ProjectionBase
	{
		
		private var zvector:Number = 1;//-1 for antarctic?
		
		public function PolarProjection()
		{
			super();
		}
		
		
		override public function fromLatLngToPixel($latlng:LatLng, zoom:Number):Point {
			
			var lat:Number = Math.PI/180 * $latlng.lat();
			var lon:Number = Math.PI/180 * $latlng.lng();
			
			var s1:Number = Math.cos(lat)/(1.0 + this.zvector * Math.sin(lat));
			var s2:Number = 256 / 2 * Math.pow(2,zoom);
			var x:Number = ( Math.sin(lon) * s1 + 1 ) * s2;
			var y:Number = ( this.zvector * Math.cos(lon) * s1 + 1 ) * s2;
			return new Point(x,y);
			
			/*
			if (!gLatLng || isNaN(gLatLng.lat()) || isNaN(gLatLng.lng())) {
			return null;
			}
			var coords:Array=this.forward([gLatLng.lng(), gLatLng.lat()]);
			var res:Number=this.getUnitsPerPixel(zoom);
			var px:Number=(coords[0] - (this.tileInfo_.origin.x as Number)) / res;
			var py:Number=((this.tileInfo_.origin.y as Number) - coords[1]) / res;
			return new Point(px, py);
			
			
			
			var px:Number = 0;
			var py:Number = 0;
			
			return new Point(px, py);
			*/
		}
		
		
		override public function fromPixelToLatLng(pixel:Point, zoom:Number, unbound:Boolean=false):LatLng {
			/*
			if (zoom == 17) {
			this.magic = ! this.magic;
			if( this.magic ) {
			return new GLatLng(90,180);
			} else {
			return new GLatLng(-90,-180);
			}
			}
			*/
			var s2:Number = 256 / 2 * Math.pow(2,zoom);
			var x:Number = pixel.x / s2 - 1;
			var y:Number = pixel.y / s2 - 1;
			if ( x == 0 && y == 0 ){ 
				return new LatLng(90,0);
			}
			var z:Number = this.zvector * Math.min( 2.0 / ( x*x + y*y + 1 ) - 1.0, 1.0 );
			var lon:Number = 180/Math.PI * Math.atan2( x, this.zvector * y );
			var lat:Number = 180/Math.PI * Math.asin( z );
			return new LatLng(lat,lon);
			
			
			
			/*
			if (pixel === null) {
			return null;
			}
			var res:Number=this.getUnitsPerPixel(zoom);
			var x:Number=pixel.x * res + (this.tileInfo_.origin.x as Number);
			var y:Number=(this.tileInfo_.origin.y as Number) - pixel.y * res;
			var ll:Array=this.reverse([x, y]);
			//trace('' + x + ', ' + y + ' --> ' + ll[1] + ', ' + ll[0] + ', z' + zoom);
			
			var ll:LatLng = new LatLng(0,0);
			return ll;*/
		}
		
		override public function tileCheckRange(tile:Point, zoom:Number, tilesize:Number):Boolean {
			return true;
		}
		
		override public function getWrapWidth($zoom:Number):Number{
			
			return Number.MAX_VALUE;
			
		}
		
		
		
	}
}