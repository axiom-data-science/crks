package com.axiomalaska.integratedlayers.events
{
	import com.axiomalaska.crks.helpers.HelpMetaData;
	
	import flash.events.Event;
	
	public class HelpDataEvent extends Event
	{
		
		public static const GET_META_DATA:String = 'get_meta_data';
		
		public var help_meta_data:HelpMetaData;
		
		public function HelpDataEvent($type:String, $help_meta_data:HelpMetaData)
		{
			super($type, true);
			help_meta_data = $help_meta_data;
		}
	}
}