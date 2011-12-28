package com.axiomalaska.integratedlayers.services
{
	import com.axiomalaska.crks.dto.Layer;
	import com.axiomalaska.crks.dto.OgcLayer;
	import com.axiomalaska.crks.dto.VectorLayer;
	import com.axiomalaska.integratedlayers.models.WFSRequest;
	
	import config.AppSettings;
	
	import mx.collections.ArrayCollection;
	import mx.messaging.Channel;
	import mx.messaging.ChannelSet;
	import mx.messaging.channels.AMFChannel;
	import mx.rpc.AsyncToken;
	import mx.rpc.remoting.RemoteObject;
	
	import org.swizframework.utils.services.MockDelegateHelper;

	public class ApplicationService
	{		
		private var _ro:RemoteObject;
		private var crks_service:String = 'CrksService';
		private var wfs_service:String = 'WfsProxy';
		private var mockHelper:MockDelegateHelper = new MockDelegateHelper(true);
		
		private function get ro():RemoteObject{
			if( _ro == null ){
				var amf:Channel = new AMFChannel('crks-amf', AppSettings.domain + AppSettings.crks_service_path + '/messagebroker/amf');			
				var cs:ChannelSet = new ChannelSet();
				cs.addChannel(amf);
				_ro = new RemoteObject();
				_ro.channelSet = cs;
				_ro.showBusyCursor = true;				
			}
			
			return _ro;
		}
		
		
		public function getApplicationData($portal_id:int):AsyncToken{
			ro.destination = crks_service;
			return ro.getPortalData($portal_id);
		}
		
		public function getPortalMeta($portal_id:int):AsyncToken{
			ro.destination = crks_service;
			return ro.getPortal($portal_id);
		}
		
		
		public function getLonelyLayerGroup ($layer_group_id:int):AsyncToken{
			ro.destination = crks_service;
			return ro.getLonelyLayerGroup($layer_group_id);
		}
		
		public function getLonelyModule ($module_id:int):AsyncToken{
			ro.destination = crks_service;
			return ro.getLonelyModule($module_id);
		}
		
		public function getLayer($layer_id:int,$include_sld:Boolean = false):AsyncToken{
			ro.destination = crks_service;
			return ro.getLayer($layer_id,$include_sld);
		}
		
		public function getRasterTimeAndElevationStrata($layer_id:int):AsyncToken{
			ro.destination = crks_service;
			return ro.getRasterTimeAndElevationStrata($layer_id);
		}
		
		
		
		public function getApplicationDataTest():AsyncToken{
			return mockHelper.createMockResult({data:'this is the data'});	
		}
		
		public function getWfsFeatureCount($wfs_request:WFSRequest):AsyncToken{
			
			var layerNames:ArrayCollection = new ArrayCollection();
			var dateProps:ArrayCollection = new ArrayCollection();
			for each(var l:VectorLayer in $wfs_request.layers){
				layerNames.addItem(l.ogcName);
				dateProps.addItem(l.timeProperty);
			}
			
			ro.destination = wfs_service;
			return ro.getFeatureCount(
				$wfs_request.geoserver_domain.replace(/wms$/,'wfs'),//wfsUrl
				layerNames,//layerNames
				dateProps,//dateProps
				$wfs_request.spatial_bounds.south_west.longitude,//swLng
				$wfs_request.spatial_bounds.south_west.latitude,//swLat
				$wfs_request.spatial_bounds.north_east.longitude,//neLng
				$wfs_request.spatial_bounds.north_east.latitude,//neLat
				$wfs_request.time_bounds.startdate,//startDate
				$wfs_request.time_bounds.enddate//endDate
			);
			
		}
		
		
	}
}