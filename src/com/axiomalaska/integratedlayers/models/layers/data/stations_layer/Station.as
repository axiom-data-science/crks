package com.axiomalaska.integratedlayers.models.layers.data.stations_layer
{
	import com.axiomalaska.crks.dto.AmfDataService;
	import com.axiomalaska.integratedlayers.models.RequestValue;
	import com.axiomalaska.models.VariableType;
	
	import config.AppSettings;
	
	import mx.collections.ArrayCollection;

	[Bindable]
	[RemoteClass(alias="com.axiom.services.netcdf.data.Station")]	
	public class Station extends Filterable
	{
		public var dataAvailable:Boolean;
		public var startDate:Date;
		public var endDate:Date;
		public var latitude:Number;
		public var longitude:Number;
		public var source:Source;
		public var sourceId:int;
		public var sensors:Array;
		public var sensorIds:Array;
		
		public function createSensorAMFServiceRequest($sensor:Sensor,$priority:Boolean = true,$extra_params:Object = null,$proxyCt:int = NaN):AmfDataService{

			var svc:AmfDataService = new AmfDataService();
			//svc.url = AppSettings.domain + '/sensorobservations/messagebroker/amf2';
			svc.url = AppSettings.domain + '/stationsensorservice/messagebroker/amf2';
			svc.destination = 'StationSensorService';
			

			
			//svc.destination = 'SensorObservationsService';
			
			svc.method = 'getObservations1';
			svc.arguments = new ArrayCollection();
			
			var sensArg:RequestValue = new RequestValue();
			//sensArg.intValue = 8;
			sensArg.intValue = $sensor.id;
			sensArg.name = 'sensorId';
			sensArg.valueType = VariableType.INT;
			(svc.arguments as ArrayCollection).addItem(sensArg);
			
			var stArg:RequestValue = new RequestValue();
			//stArg.intValue = 2531;
			stArg.intValue = id;
			stArg.name = 'stationId';
			stArg.valueType = VariableType.INT;
			(svc.arguments as ArrayCollection).addItem(stArg); 
			
			

			
			if($extra_params){
				
				if($extra_params.hasOwnProperty('mostRecent') && $extra_params.mostRecent === true){
					var mrArg:RequestValue = new RequestValue();
					mrArg.name = 'mostRecent';
					(svc.arguments as ArrayCollection).addItem(mrArg); 
				}
				
				if($extra_params.hasOwnProperty('pastHours')){
					var ptArg:RequestValue = new RequestValue();
					ptArg.name = 'pastHours';
					ptArg.valueType = VariableType.INT;
					ptArg.intValue = $extra_params.pastHours;
					(svc.arguments as ArrayCollection).addItem(ptArg); 
				}
				
				if($extra_params.hasOwnProperty('startDate')){
					var sdArg:RequestValue = new RequestValue();
					sdArg.name = 'startTime';
					sdArg.valueType = VariableType.DATE;
					sdArg.dateValue = $extra_params.startTime;
					(svc.arguments as ArrayCollection).addItem(sdArg); 
				}
				
			}
			
			
			
			return svc;
		}
		
	}
}