package com.axiomalaska.map.types.google.event
{

	import flash.display.BitmapData;
	import flash.events.Event;
	
	public class BitmapMarkerEvent extends Event
	{
		public var id:String;
		public var bitmap_data:BitmapData;
		public var x:Number;
		public var y:Number;
		
		public static const MARKER_OVER:String = 'markerOver';
		public static const MARKER_OFF:String = 'markerOff';
		public static const MARKER_SELECT:String = 'markerSelect';
		
		public function BitmapMarkerEvent($type:String,$id:String = null,$bitmap_data:BitmapData = null,$x:Number = NaN,$y:Number = NaN)
		{
			id = $id;
			bitmap_data = $bitmap_data;
			if(!isNaN($x)){
				x = $x;
			}
			if(!isNaN($y)){
				y = $y;
			}
			//trace('setting id ' + $id);
			super($type,true);
		}
	}
}