package com.axiomalaska.map.types.google.base_layers
{
	import com.axiomalaska.map.types.google.overlay.WMS.GinaTileLayer;
	import com.google.maps.MapType;
	import com.google.maps.MapTypeOptions;
	import com.google.maps.interfaces.IMapType;
	import com.google.maps.interfaces.IProjection;
	
	public class GINAMapType extends MapType implements IMapType
	{
		public function GINAMapType($name:String = 'Gina Best')
		{
			var ginaLayer:GinaTileLayer = new GinaTileLayer('http://swmha.gina.alaska.edu/tilesrv/bdl/tile', 1.0);
			super([ginaLayer], MapType.NORMAL_MAP_TYPE.getProjection(),$name);
		}
	}
}