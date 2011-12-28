package com.axiomalaska.integratedlayers.services
{
	
	import com.axiomalaska.integratedlayers.models.RequestValue;
	import com.axiomalaska.crks.dto.AmfDataService;
	
	import mx.messaging.Channel;
	import mx.messaging.ChannelSet;
	import mx.messaging.channels.AMFChannel;
	import mx.rpc.AbstractOperation;
	import mx.rpc.AsyncToken;
	import mx.rpc.remoting.RemoteObject;
	
	import org.swizframework.utils.services.MockDelegateHelper;
	
	public class DataLayerService
	{	
		private var mockHelper:MockDelegateHelper;	
		public function DataLayerService():void{			
			mockHelper = new MockDelegateHelper(true);
		}
		
		public function getLayerData($amf_info:AmfDataService,$showBusy:Boolean = false):AsyncToken{
			var ro:RemoteObject = new RemoteObject();
			
			var sid:int;
			var stid:int;
			for each(var rv:RequestValue in $amf_info.arguments){
				if(rv.name == 'sensorId'){
					sid = rv.intValue;
				}
				if(rv.name == 'stationId'){
					stid = rv.intValue;
				}
			}
			
			var url_str:String = '';
			if(sid && stid){
				url_str = '?st=' + stid + '&sen=' + sid;
			}
			
			var amf:Channel = new AMFChannel($amf_info.service_id,$amf_info.url + url_str);
			var cs:ChannelSet = new ChannelSet();
			cs.addChannel(amf);
			ro.channelSet = cs;
			ro.showBusyCursor = $showBusy;
			ro.destination = $amf_info.destination;
			ro.source = $amf_info.source;
			var token:AbstractOperation = ro.getOperation($amf_info.method);
			
			if($amf_info.arguments){
				return token.send($amf_info.arguments);
			}else{
				return token.send();
			}

		}
		
		public function getMockLayerData($result_type:String):AsyncToken{
			return mockHelper.createMockResult({},2);
		}
		
		public function getSensorData($amf_info:AmfDataService):AsyncToken{
			
			var cs:ChannelSet = new ChannelSet();
			var amf:Channel = new AMFChannel('observation-sensors',$amf_info.url);
			var ro:RemoteObject = new RemoteObject();
			cs.addChannel(amf);
			ro.channelSet = cs;
			ro.destination = $amf_info.destination;
			return ro.getSensorObservationsDefaultDate($amf_info.arguments.stationId,$amf_info.arguments.sensorId);

			
		}
		
		public function getApplicationDataTest():AsyncToken{
			return mockHelper.createMockResult({data:'this is the data'});
			
		}
		
	}
}