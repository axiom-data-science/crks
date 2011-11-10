package com.axiomalaska.integratedlayers.events
{
	import flash.events.Event;
	
	public class LayerPanelEvent extends Event
	{
		
		public static const LAYER_PANEL_ACTIVATE:String = 'layer_panel_activate';
		public static const LAYER_PANEL_DEACTIVATE:String = 'layer_panel_deactivate';
		
		public function LayerPanelEvent($type:String)
		{
			super($type, true);
		}
	}
}