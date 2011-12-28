package com.axiomalaska.map.types.google.overlay
{
	import com.axiomalaska.map.types.google.event.PositionOverlayEvent;
	import com.google.maps.LatLng;
	import com.google.maps.PaneId;
	import com.google.maps.interfaces.IMap;
	import com.google.maps.interfaces.IPane;
	import com.google.maps.overlays.OverlayBase;
	
	import flash.geom.Point;
	
	public class OverlayPositionWatcher extends OverlayBase
	{
		public static const POSITION_OVERLAY_FIRED_EVENT : String = "positionOverlayFiredEvent";
		
		public function OverlayPositionWatcher()
		{
			super();
		}
		
		override public function positionOverlay(arg0:Boolean):void {
			
			trace('CALLING');
			
			var e : PositionOverlayEvent = new PositionOverlayEvent( PositionOverlayEvent.POSITION_OVERLAY_EVENT );
			e.zoomChange = arg0;
			dispatchEvent( e );
			
		}
		
		override public function getDefaultPane(arg0:IMap):IPane {
			return ( arg0.getPaneManager().getPaneById( PaneId.PANE_OVERLAYS ) );
		}
		
		public function getPointForLatLng( position : LatLng ) : Point {
			
			if ( pane ) {    
				return pane.fromLatLngToPaneCoords( position );
			} else {
				return null;
			}
			
		}
		
	}
}