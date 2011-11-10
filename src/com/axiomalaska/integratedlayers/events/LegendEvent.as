package com.axiomalaska.integratedlayers.events
{
	import com.axiomalaska.crks.interfaces.ILegendItem;
	
	import flash.events.Event;
	
	public class LegendEvent extends Event
	{
		
		public static const LOAD_LEGEND_ITEM:String = 'load_legend_item';
		public static const UNLOAD_LEGEND_ITEM:String = 'unload_legend_item';
		public static const REMOVE_ALL_LEGEND:String = 'remove_all_legend_items';
		public static const LEGEND_REORDER_COMPLETE:String = 'legend_reorder_complete';
		
		public var legend_item:ILegendItem;
		
		public function LegendEvent($type:String, $legend_item:ILegendItem)
		{
			super($type, true);
			legend_item = $legend_item;
			
		}
	}
}