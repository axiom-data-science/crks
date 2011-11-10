package com.axiomalaska.integratedlayers.events
{
	import flash.events.Event;
	
	import com.axiomalaska.integratedlayers.models.VirtualSensorLocation;
	import com.axiomalaska.integratedlayers.models.VirtualSensorRequest;
	
	public class VirtualSensorEvent extends Event
	{
		public static const VIRTUAL_SENSOR_MODE_START:String = 'virtual_sensor_mode_start';
		public static const VIRTUAL_SENSOR_REQUEST_DATA:String = 'virtual_sensor_request_data';
		public static const VIRTUAL_SENSOR_MODE_END:String = 'virtual_sensor_mode_end';
		public static const VIRTUAL_SENSOR_REMOVE_SENSOR:String = 'virtual_sensor_remove_sensor';
		
		public var virtual_sensor_request:VirtualSensorRequest;
		
		public function VirtualSensorEvent($type:String,$virtual_sensor_request:VirtualSensorRequest = null)
		{
			super($type,true);
			virtual_sensor_request = $virtual_sensor_request;
		}
	}
}