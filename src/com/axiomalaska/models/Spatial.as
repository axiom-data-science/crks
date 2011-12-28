package com.axiomalaska.models
{
	import com.axiomalaska.interfaces.IKeyableData;
	import com.axiomalaska.map.LatLon;

	[Bindable]
	[RemoteClass(alias="MapAssets.Spatial")]
	public class Spatial extends KeyedData
	{
		
		public var id:String;
		public var foreign_id:String;
		public var lat:Number;
		public var lon:Number;
		public var depth:Number;
		public var elevation:Number;
		public var label:String;
		public var points:Array;
		public var type:String = SpatialType.POINT;
		public var encoded_polygon:EncodedPolygon;
		
		
		//public var latlon:LatLon;
		
		private var _latlon:LatLon;
		
		public function set latlon($latlon:LatLon):void{
			_latlon = $latlon;
			lat = _latlon.latitude;
			lon = _latlon.longitude;
		}
		public function get latlon():LatLon{
			if(!_latlon){
				return new LatLon(lat,lon);
			}else{
				return _latlon;
			}
		}
		
		
		public function set latitude($latitude:Number):void{lat = $latitude;}
		public function get latitude():Number{return lat;}
		
		public function set longitude($longitude:Number):void{lon = $longitude;}
		public function get longitude():Number{return lon;}
	}
}