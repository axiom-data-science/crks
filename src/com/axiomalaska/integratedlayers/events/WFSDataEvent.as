package com.axiomalaska.integratedlayers.events
{
	import flash.events.Event;
	
	import com.axiomalaska.integratedlayers.models.WFSRequest;
	
	public class WFSDataEvent extends Event
	{
		
		
		public static const WFS_REQUEST_FEATURE_COUNT:String = 'wfs_request_feature_count';
		
		public var wfs_request:WFSRequest;
		public function WFSDataEvent($type:String, $wfs_request:WFSRequest)
		{
			super($type, true);
			wfs_request = $wfs_request;
		}
	}
}