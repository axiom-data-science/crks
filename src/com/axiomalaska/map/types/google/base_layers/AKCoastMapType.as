package com.axiomalaska.map.types.google.base_layers
{
	import com.axiomalaska.map.types.google.overlay.WMS.AlaskaCoastTileLayer;
	import com.google.maps.MapType;
	import com.google.maps.MapTypeOptions;
	import com.google.maps.interfaces.IMapType;
	import com.google.maps.interfaces.IProjection;
	
	import config.AppSettings;
	
	public class AKCoastMapType extends MapType implements IMapType
	{
		public function AKCoastMapType($name:String = 'AK Coast')
		{
			var AKCoast:AlaskaCoastTileLayer = new AlaskaCoastTileLayer(AppSettings.domain + '/geoserver/gwc/service/gmaps', 1.0, 1, 17);			
			super([AKCoast], MapType.NORMAL_MAP_TYPE.getProjection(),$name);
		}
		
		
	}
}