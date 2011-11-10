package com.axiomalaska.events
{
	import com.axiomalaska.models.Temporal;
	
	import flash.events.Event;
	
	public class TimeSpanSliderEvent extends Event
	{
		
		public static const TIME_SLIDER_SLIDING_START:String = 'time_slider_sliding_start';
		public static const TIME_SLIDER_SLIDING_UPDATE:String = 'time_slider_sliding_update';
		public static const TIME_SLIDER_SLIDING_COMPLETE:String = 'time_slider_sliding_complete';
		
		public var timespan:Temporal;
		
		public function TimeSpanSliderEvent($type:String, $timespan:Temporal)
		{
			super($type, true);
			timespan = $timespan;
		}
	}
}