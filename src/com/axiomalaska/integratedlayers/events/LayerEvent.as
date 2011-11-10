package com.axiomalaska.integratedlayers.events
{
	import com.axiomalaska.crks.dto.Layer;
	
	import flash.events.Event;
	
	public class LayerEvent extends Event
	{
		
		public static const LOAD_LAYER:String = 'load_layer';
		public static const LOAD_STICKY_LAYER:String = 'load_sticky_layer';
		public static const UNLOAD_LAYER:String = 'unload_layer';
		
		public static const LAYER_LOADED:String = 'layer_loaded';
		public static const LAYER_UNLOADED:String = 'layer_unloaded';
		
		public static const LOAD_DATA_LAYER:String = 'load_data_layer';
		public static const LOAD_VECTOR_LAYER:String = 'load_vector_layer';
		public static const LOAD_RASTER_LAYER:String = 'load_raster_layer';
		
		public static const SHOW_LAYER_TOOLS:String = 'show_layer_tools';
		public static const HIDE_LAYER_TOOLS:String = 'hide_layer_tools';
		
		public var layer:Layer;
		
		public function LayerEvent($type:String, $layer:Layer = null)
		{
			super($type, true);
			layer = $layer;
		}
	}
}