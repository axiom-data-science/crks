package com.axiomalaska.map
{
	import com.axiomalaska.map.interfaces.ILatLon;
	import com.axiomalaska.models.KeyedData;
	
	[Bindable]
	[RemoteClass(alias="MapAssets.LatLon")]
	public class LatLon extends KeyedData implements ILatLon
	{
		
		private var _latitude:Number;
		private var _longitude:Number;
		
		public function LatLon($latitude:Number = NaN,$longitude:Number = NaN)
		{
			if(!isNaN($latitude)){
				_latitude = $latitude;
			}
			if(!isNaN($longitude)){
				_longitude = $longitude;
			}
		}
		
		public function get latitude():Number{return _latitude;}
		public function set latitude($latitude:Number):void{_latitude = $latitude;}
		
		public function get longitude():Number{return _longitude;}
		public function set longitude($longitude:Number):void{_longitude = $longitude;}
		
		public function lat():Number{return latitude;}
		public function lon():Number{return longitude;}
	}
}