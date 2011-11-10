package com.axiomalaska.map.types.google.event
{
	import flash.events.Event;
	
	public class PositionOverlayEvent extends Event
	{
		public static const POSITION_OVERLAY_EVENT : String = "positionOverlayEvent";
		
		public var zoomChange : Boolean;
		
		
		public function PositionOverlayEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event {
			
			var e : PositionOverlayEvent = new PositionOverlayEvent( type );
			e.zoomChange = zoomChange;
			return e;
			
		}
		
	}
}