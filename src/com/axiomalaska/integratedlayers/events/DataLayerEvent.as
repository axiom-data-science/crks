package com.axiomalaska.integratedlayers.events
{
	import com.axiomalaska.map.interfaces.ILayer;
	
	import flash.events.Event;
	
	public class DataLayerEvent extends Event
	{
		
		public static const UPDATE_DATA_LAYER_VIEW:String = 'update_data_layer_view';
		public static const UPDATE_SCALAR_SELECTED_REALTIME_SENSOR:String = 'update_scalar_selected_realtime_sensor';
		public static const UPDATE_VECTOR_SELECTED_REALTIME_SENSOR:String = 'update_vector_selected_realtime_sensor';
		public static const REMOVE_SCALAR_SELECTED_REALTIME_SENSOR:String = 'remove_scalar_selected_realtime_sensor';
		public static const REMOVE_VECTOR_SELECTED_REALTIME_SENSOR:String = 'remove_vector_selected_realtime_sensor';
		public static const RELOAD_ACTIVE_REALTIME_SENSORS:String = 'reload_active_realtime_sensors';
		
		public var layer:ILayer;
		
		public function DataLayerEvent($type:String,$layer:ILayer = null)
		{
			super($type,true);
			layer = $layer;
		}
	}
}