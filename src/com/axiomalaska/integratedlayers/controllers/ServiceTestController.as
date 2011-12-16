package com.axiomalaska.integratedlayers.controllers
{
	import com.axiomalaska.crks.dto.AmfDataService;
	
	import com.axiomalaska.integratedlayers.models.AMFResultObject;
	
	import mx.controls.Alert;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import org.swizframework.utils.services.ServiceHelper;
	
	import com.axiomalaska.integratedlayers.services.DataLayerService;
	
	import com.axiomalaska.integratedlayers.views.test.ServiceTesterResultLayout;

	public class ServiceTestController extends BaseController
	{
		
		[Inject]
		public var serviceHelper:ServiceHelper;
		
		[Inject("dataLayerService")]
		public var dataLayerService:DataLayerService;
		
		[Inject("resultObject")]
		public var resultObject:AMFResultObject;
		
		
		[EventHandler("ServiceEvent.CALL_SERVICE", properties="amf_service")]
		public function callService($amf_service:AmfDataService):void{
			serviceHelper.executeServiceCall(dataLayerService.getLayerData($amf_service),onServiceResult,handleError,[$amf_service]);
		}
		
		override public function handleError($evt:FaultEvent):void{
			var str:String = "faultString: " + $evt.fault.faultString + "\n" + "faultDetail: " + $evt.fault.faultDetail;
			Alert.show(str);
		}
		
		public function onServiceResult($evt:ResultEvent,$amf_service:AmfDataService):void{
			var p:ServiceTesterResultLayout = new ServiceTesterResultLayout();
			p.openWindow();
			p.result = $evt.result.toString();
			resultObject.result = $evt.result;
			resultObject.has_result = true;
		}
		

	}
}