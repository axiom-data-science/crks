package com.axiomalaska.integratedlayers.events
{
	import com.axiomalaska.map.overlay.WMS;
	
	import flash.events.Event;
	
	import com.axiomalaska.integratedlayers.models.WMSGetInfoData;
	import com.axiomalaska.integratedlayers.models.WMSRequest;
	
	public class WMSDataEvent extends Event
	{
		public static const WMS_INFO_MODE_START:String = 'wms_info_mode_start';
		public static const WMS_INFO_MODE_END:String = 'wms_info_mode_end';
		public static const WMS_POINT_FEATURE_INFO_REQUEST:String = 'wms_point_feature_info_request';
		public static const WMS_POINT_FEATURE_REMOVE_POINT:String = 'wms_point_feature_remove_point';
		
		public var wms_info:WMSGetInfoData;
		
		public function WMSDataEvent($type:String, $wms_info:WMSGetInfoData = null)
		{
			super($type, true);
			wms_info = $wms_info;
		}
	}
}