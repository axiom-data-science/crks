package com.axiomalaska.map.types.google
{
	import com.axiomalaska.map.features.MapFeature;
	import com.axiomalaska.map.interfaces.ILatLon;
	import com.axiomalaska.map.interfaces.IMapFeature;
	import com.axiomalaska.utilities.Style;
	
	public class GoogleMapFeature extends MapFeature implements IMapFeature
	{
		public function GoogleMapFeature($latlon:ILatLon, $data:Object=null, $style:Style=null)
		{
			super($latlon, $data, $style);
		}
	}
}