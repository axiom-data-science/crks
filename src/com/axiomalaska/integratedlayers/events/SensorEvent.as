package com.axiomalaska.integratedlayers.events
{
	import com.axiomalaska.integratedlayers.models.DataRequest;
	import com.axiomalaska.integratedlayers.models.SensorRequest;
	import com.axiomalaska.integratedlayers.models.layers.data.stations_layer.Sensor;
	import com.axiomalaska.integratedlayers.models.layers.data.stations_layer.Station;
	
	import flash.events.Event;
	
	public class SensorEvent extends Event
	{
		
		public static const REQUEST_SENSOR_DATA:String = 'request_sensor_data';
		public static const REMOVE_SENSOR_DATA:String = 'remove_sensor_data';
		
		public var station:Station;
		public var sensor:Sensor;
		public var extra_params:Object;
		public var update_state:Boolean;
		
		[Bindable]
		public var data_request:DataRequest = new DataRequest();
		
		public function SensorEvent($type:String, $station:Station = null, $sensor:Sensor = null,$update_state:Boolean = false,$extra_params:Object = null)
		{
			super($type, true);
			station = $station;
			sensor = $sensor;
			if($extra_params){
				extra_params = $extra_params;
			}
			
			update_state = $update_state;
		}
	}
}