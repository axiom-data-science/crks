package com.axiomalaska.integratedlayers.events
{
	import com.axiomalaska.models.SpatialBounds;
	
	import flash.events.Event;
	
	public class MapZoomEvent extends Event
	{
		
		public static const ZOOM_TO_EXTENT:String = 'zoom_to_extent';
		public static const HIGHLIGHT_EXTENT:String = 'highlight_extent';
		public static const REMOVE_EXTENT:String = 'remove_extent';
		public static const HIGHLIGHT_AND_ZOOM_TO_EXTENT:String = 'highlight_and_zoom_to_extent';
		
		
		public var bounds:SpatialBounds;
		
		public function MapZoomEvent($type:String, $bounds:SpatialBounds)
		{
			super($type, true);
			bounds = $bounds;
		}
	}
}