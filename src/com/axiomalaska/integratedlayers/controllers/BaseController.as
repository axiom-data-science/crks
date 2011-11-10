package com.axiomalaska.integratedlayers.controllers
{
	import flash.events.IEventDispatcher;
	
	import mx.controls.Alert;
	import mx.rpc.Fault;
	import mx.rpc.events.FaultEvent;

	public class BaseController
	{
		[Dispatcher]
		public var dispatcher:IEventDispatcher;
		
		public function handleError($evt:FaultEvent):void{
			Alert.show("Error: " + $evt.fault.faultString);
		}
	}
}