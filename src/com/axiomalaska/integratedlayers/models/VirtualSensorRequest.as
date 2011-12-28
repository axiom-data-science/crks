package com.axiomalaska.integratedlayers.models
{
	import com.axiomalaska.models.ResultSet;
	import com.axiomalaska.crks.dto.RasterLayer;
	
	import mx.collections.ArrayCollection;

	[Bindable]
	public class VirtualSensorRequest
	{
		public var virtual_sensor_location:VirtualSensorLocation;
		public var layer:RasterLayer;
		public var loading:Boolean = true;
		public var results:ArrayCollection;
		public var result_set:ResultSet;
	}
}