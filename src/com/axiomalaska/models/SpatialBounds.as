package com.axiomalaska.models
{
	import com.axiomalaska.map.LatLon;
	
	[Bindable]
	[RemoteClass(alias="MapAssets.SpatialBounds")]
	public class SpatialBounds extends KeyedData
	{
		
		public var south_west:LatLon;
		public var north_east:LatLon;
		
		public function SpatialBounds(south_west_latitude:Number = NaN,south_west_longitude:Number = NaN,north_east_latitude:Number = NaN,north_east_longitude:Number = NaN):void{
			if(!isNaN(south_west_latitude) && !isNaN(south_west_longitude)){
				south_west = new LatLon(south_west_latitude,south_west_longitude);
			}
			if(!isNaN(north_east_latitude) && !isNaN(north_east_longitude)){
				north_east = new LatLon(north_east_latitude,north_east_longitude);
			}
			
		}
		
		public function noWrap():SpatialBounds{
			var l1:Number = south_west.longitude;
			var l2:Number = north_east.longitude;
			if(l1 > 0){
				l1 = - 180 - (180-l1);
			}
			if(l2 > 0){
				l2 = - 180 - (180-l2);
			}
			
			return new SpatialBounds(south_west.latitude,l1,north_east.latitude,l2);
			
		}
		
		public function toBBOXString():String{
			if(south_west && north_east){
				
				var lat1:Number = south_west.latitude;
				var lat2:Number = north_east.latitude;
				var lon1:Number = south_west.longitude;
				var lon2:Number = north_east.longitude;
				
				if(lon1 > 0){
					lon1 = - 180 - (180-lon1);
				}
				if(lon2 > 0){
					lon2 = - 180 - (180-lon2);
				}
				
				var minLat:Number = lat1;
				var minLong:Number = lon1;
				var maxLat:Number = lat2;
				var maxLong:Number = lon2;
				
				if(lat1 > lat2){
					minLat = lat2	;
					maxLat = lat1;
				}
				
				if(lon1 > lon2){
					minLong = lon2;
					maxLong = lon1;
				}
				
				return minLong + ',' + minLat + ',' + maxLong + ',' + maxLat;
			}else{
				trace('Err: SpatialBounds southwest latlon or northeast latlon is undefined');
				return '';
			}
		}
	}
}