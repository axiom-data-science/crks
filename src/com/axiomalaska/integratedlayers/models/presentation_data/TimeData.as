package com.axiomalaska.integratedlayers.models.presentation_data
{
	import com.axiomalaska.models.Temporal;
	
	[Bindable]
	public class TimeData
	{
		
		public var maximum_date:Date;
		public var minimum_date:Date;
		
		public var time_bounds:Temporal = new Temporal();
		public var time_slice:Date = new Date();
		
		public var time_span_active:Boolean;
		public var time_slice_active:Boolean;
		
		public var has_changed:Boolean;
		
	}
}