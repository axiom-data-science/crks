package com.axiomalaska.integratedlayers.events
{
	import flash.events.Event;
	
	public class ApplicationEvent extends Event
	{
		public static const APPLICATION_READY:String = 'application_ready';
		
		public function ApplicationEvent($type:String)
		{
			super($type, true);
		}
	}
}