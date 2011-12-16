
package com.axiomalaska.models
{
	import com.axiomalaska.models.Contact;
	import com.axiomalaska.models.sensors.SensorType;
	import com.axiomalaska.models.sensors.Source;
	import com.axiomalaska.models.Temporal;
	import com.axiomalaska.models.sensors.Source;
	import com.axiomalaska.models.sensors.SensorType;
	
	[RemoteClass(alias="MapAssets.Transect")]
	public class Transect
	{
		public var id:int;
		public var contact:Contact;
		public var label:String;
		public var description:String;
		public var source:Source;
		public var funding_source:Source;
		public var summary:String;
		public var website:String;
		public var transect_lines:Object;
		public var temporal:Temporal;
		public var sensor_type:SensorType;
	}
}