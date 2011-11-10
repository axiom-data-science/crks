package com.axiomalaska.map.events
{
	import com.axiomalaska.map.LatLon;
	import com.google.maps.LatLngBounds;
	
	import flash.events.Event;
	
	public class BoundingBoxEvent extends Event
	{
		
		public static const BOUNDING_BOX_MODE_START:String = 'bounding_box_mode_start';
		public static const BOUNDING_BOX_MODE_END:String = 'bounding_box_mode_end';
		public static const BOUNDING_BOX_DRAW_START:String = 'bounding_box_draw_start';
		public static const BOUNDING_BOX_DRAW_END:String = 'bounding_box_draw_end';
		public static const BOUNDING_BOX_CLOSE:String = 'bounding_box_close';
		
		public var corner1:LatLon;
		public var corner2:LatLon;
		
		public function BoundingBoxEvent($type:String, $corner1:LatLon = null, $corner2:LatLon = null)
		{
			if($corner1){
				corner1 = $corner1;
			}
			
			if($corner2){
				corner2 = $corner2;
			}
			
			super($type,true);
		}
	}
}