package com.axiomalaska.integratedlayers.events
{
	import com.axiomalaska.map.interfaces.IMapFeature;
	import com.axiomalaska.models.sensors.Station;
	
	import flash.events.Event;
	
	public class MarkerEvent extends Event
	{
		
		public static const MARKER_ADDED:String = 'marker_added';
		public static const MARKER_REMOVED:String = 'marker_removed';
		public static const MARKER_OVER:String = 'marker_over';
		public static const MARKER_OFF:String = 'marker_off';
		public static const MARKER_CLICK:String = 'marker_click';
		
		public var data:Object;
		public var marker:IMapFeature;
		
		public function MarkerEvent($type:String, $marker:IMapFeature, $data:Object = null)
		{
			super($type,true,true);
			data = $data;
			marker = $marker;
		}
		
		override public function clone():Event
		{
			return new MarkerEvent(type,marker,data);
		}
		
		
	}
}