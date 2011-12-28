package com.axiomalaska.integratedlayers.events
{
	import com.axiomalaska.crks.interfaces.IMetaDataItem;
	
	import flash.events.Event;
	
	public class HelpEvent extends Event
	{
		
		public static const LOAD_METADATA_AT_STARTUP:String = 'load_metadata_at_startup';
		public static const SHOW_APPLICATION_HELP:String = 'show_applicaton_help';
		public static const SHOW_HELP_CONTENT:String = 'show_help_content';
		public static const CLOSE_HELP_WINDOW:String = 'close_help_window';
		public static const SHOW_APPLICATION_HELP_ON_LOAD:String = 'show_application_help_on_load';
		public static const HIDE_APPLICATION_HELP_ON_LOAD:String = 'hide_application_help_on_load';
		
		
		public var meta_data_item:IMetaDataItem;
		
		public function HelpEvent($type:String, $meta_data_item:IMetaDataItem = null)
		{
			super($type, true);
			meta_data_item = $meta_data_item;
		}
	}
}