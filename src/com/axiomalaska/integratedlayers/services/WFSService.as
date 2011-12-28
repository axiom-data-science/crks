package com.axiomalaska.integratedlayers.services
{
	import mx.rpc.AsyncToken;
	import mx.rpc.http.HTTPService;

	public class WFSService
	{
		public var remoteObject:HTTPService = new HTTPService();

		public function callService($call:String):AsyncToken{
			remoteObject.showBusyCursor = true;
			remoteObject.url = $call;
			return remoteObject.send();
		}
		
		
	}
}