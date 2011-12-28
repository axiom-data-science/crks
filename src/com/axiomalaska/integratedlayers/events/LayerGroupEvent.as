package com.axiomalaska.integratedlayers.events
{
	import com.axiomalaska.crks.dto.LayerGroup;
	
	import flash.events.Event;
	
	public class LayerGroupEvent extends Event
	{
		public static const LOAD_LAYER_GROUP:String = 'load_layer_group';
		public static const UNLOAD_LAYER_GROUP:String = 'unload_layer_group';
		public static const SHOW_LAYER_GROUP_HELP:String = 'show_layer_group_help';
		public static const REMOVE_ALL_LAYER_GROUPS:String = 'remove_all_layer_groups';
		public static const HIDE_ALL_LAYER_GROUPS:String = 'hide_all_layer_groups';
		public static const SHOW_ALL_LAYER_GROUPS:String = 'show_all_layer_groups';
		
		public var layer_group:LayerGroup;
		
		public function LayerGroupEvent($type:String, $layer_group:LayerGroup = null)
		{
			super($type, true);
			layer_group = $layer_group;
			
		}
	}
}