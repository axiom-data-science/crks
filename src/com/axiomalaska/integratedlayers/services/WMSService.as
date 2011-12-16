package com.axiomalaska.integratedlayers.services
{
	import mx.rpc.AsyncToken;
	import mx.rpc.http.HTTPService;

	public class WMSService
	{
		public var remoteObject:HTTPService = new HTTPService();
		
		public function callService($call:String):AsyncToken{
			remoteObject.showBusyCursor = true;
			remoteObject.url = $call;
			trace($call);
			return remoteObject.send();
		}
	}
}