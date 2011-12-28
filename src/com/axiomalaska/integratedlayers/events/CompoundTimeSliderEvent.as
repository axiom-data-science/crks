package com.axiomalaska.integratedlayers.events
{
	import com.axiomalaska.models.Temporal;
	
	import flash.events.Event;
	
	public class CompoundTimeSliderEvent extends Event
	{
		
		public static const COMPLEX_TIME_SLIDER_SLIDING_START:String = 'complex_time_slider_sliding_start';
		public static const COMPLEX_TIME_SLIDER_SLIDING_UPDATE:String = 'complex_time_slider_sliding_update';
		public static const COMPLEX_TIME_SLIDER_SLIDING_COMPLETE:String = 'complex_time_slider_sliding_complete';
		
		public static const BOUNDED_TIME_SLIDER_SLIDING_COMPLETE:String = 'bounded_time_slider_sliding_complete';
		public static const SLICE_TIME_SLIDER_SLIDING_COMPLETE:String = 'slice_time_slider_sliding_complete';
		
		public var bounded:Temporal;
		public var slice:Date;
		
		public function CompoundTimeSliderEvent($type:String, $bounded:Temporal, $slice:Date)
		{
			super($type, true);
			bounded = $bounded;
			slice = $slice;
			
		}
	}
}