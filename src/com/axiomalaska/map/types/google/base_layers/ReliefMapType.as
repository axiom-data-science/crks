package com.axiomalaska.map.types.google.base_layers
{
	import com.axiomalaska.map.types.google.overlay.WMS.Relief;
	import com.google.maps.MapType;
	import com.google.maps.MapTypeOptions;
	import com.google.maps.interfaces.IMapType;
	import com.google.maps.interfaces.IProjection;
	
	public class ReliefMapType extends MapType implements IMapType
	{
		public function ReliefMapType($name:String = 'Relief Layer')
		{
			var reliefLayer:Relief = new Relief();
			super([reliefLayer], MapType.NORMAL_MAP_TYPE.getProjection(),$name);
			
		}
	}
}