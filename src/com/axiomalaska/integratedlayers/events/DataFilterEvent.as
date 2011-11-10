package com.axiomalaska.integratedlayers.events
{
	import com.axiomalaska.integratedlayers.models.layers.data.stations_layer.Filterable;
	
	import flash.events.Event;
	
	public class DataFilterEvent extends Event
	{
		
		public static const HIGHLIGHT_FILTERABLE:String = 'highlight_filterable';
		public static const UNHIGHLIGHT_FILTERABLE:String = 'unhighlight_filterable';
		public static const RUN_FILTER:String = 'run_filter';
		public static const UNCHECKALL_BUT_SELECTED:String = 'uncheck_all_but_selected';
		
		public var filterable:Filterable;
		
		
		public function DataFilterEvent($type:String, $filterable:Filterable = null)
		{
			super($type, true);
			filterable = $filterable;
		}
	}
}