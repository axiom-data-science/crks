package com.axiomalaska.integratedlayers.models.layers.data.stations_layer
{
	[Bindable]
	[RemoteClass(alias="com.axiom.services.netcdf.data.Sensor")]	
	public class Sensor extends Filterable
	{
		public var sensorType:String;
	}
}
