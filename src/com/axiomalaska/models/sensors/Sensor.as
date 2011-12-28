package com.axiomalaska.models.sensors
{
	import com.axiomalaska.models.KeyedData;

	[Bindable]
	[RemoteClass(alias="MapAssets.Sensor")]
	public class Sensor extends KeyedData
	{
		
		public var id:String;
		public var label:String;
		public var selected:Boolean;
		public var children:Array;
		/*public var depth:Number;
		public var lat:Number;
		public var lon:Number;
		
		public var contactid:int;
		public var contact:Contact;
		
		
		public var sensortypeid:int;
		public var sensor_type:SensorType;
		
		public var sourceid:int;
		public var source:Source;
		
		public var statusid:int;
		public var status:Status;
		
		public var parameters:Object = new Object();
		
		public var startdate:Date;
		public var enddate:Date;*/
		
		
		
	}
}