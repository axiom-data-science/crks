package com.axiomalaska.map.events
{
	import com.axiomalaska.map.interfaces.ILayer;
	
	import flash.events.Event;
	
	public class AxiomLayerEvent extends Event
	{
		
		public static const AXIOM_LAYER_START_TILE_LOAD:String = 'axiom_layer_start_tile_load';
		public static const AXIOM_LAYER_END_TILE_LOAD:String = 'axiom_layer_end_tile_load';
		
		public var layer:ILayer;
		
		public function AxiomLayerEvent($type:String, $layer:ILayer)
		{
			super($type,true);
			layer = $layer;
		}
	}
}