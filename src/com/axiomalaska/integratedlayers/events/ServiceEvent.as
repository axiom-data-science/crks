package com.axiomalaska.integratedlayers.events
{
	import com.axiomalaska.crks.dto.AmfDataService;
	
	import flash.events.Event;
	
	public class ServiceEvent extends Event
	{
		
		public static const CALL_SERVICE:String = 'call_service';
		
		public var amf_service:AmfDataService;
		
		public function ServiceEvent($type:String, $amf_service:AmfDataService)
		{
			super($type, true);
			amf_service = $amf_service;
		}
	}
}