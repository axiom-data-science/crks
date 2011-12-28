package com.axiomalaska.integratedlayers.events
{
	import flash.events.Event;
	
	
	import com.axiomalaska.crks.utilities.ApplicationState;
	
	public class ApplicationStateEvent extends Event
	{
		
		public static const UPDATE_APPLICATION_STATE_PROPERTY:String = 'update_application_state_property';
		public static const UPDATE_APPLICATION_STATE:String = 'update_application_state';
		
		public var application_state:ApplicationState;
		public var application_state_string:String;
		
		
		
		public function ApplicationStateEvent($type:String, $application_state:ApplicationState = null, $applicaton_state_string:String = null)
		{
			super($type, true);
			application_state = $application_state;
			application_state_string = $applicaton_state_string;
		}
	}
}