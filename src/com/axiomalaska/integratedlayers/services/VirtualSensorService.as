package com.axiomalaska.integratedlayers.services
{
	import com.axiomalaska.models.DimensionRequestValue;
	import com.axiomalaska.models.Spatial;
	import com.axiomalaska.models.Temporal;
	import com.axiomalaska.models.VariableType;
	
	import config.AppSettings;
	
	import mx.messaging.Channel;
	import mx.messaging.ChannelSet;
	import mx.messaging.channels.AMFChannel;
	import mx.rpc.AsyncToken;
	import mx.rpc.remoting.RemoteObject;
	
	import org.swizframework.utils.services.MockDelegateHelper;

	public class VirtualSensorService
	{
		
		private var cs:ChannelSet = new ChannelSet();
		private var amf:Channel = new AMFChannel('NetCDF',AppSettings.domain + '/virtualsensor/messagebroker/amf2/');
		private var ro:RemoteObject = new RemoteObject();
		
		private var mockHelper:MockDelegateHelper;
		
		public function VirtualSensorService():void{
			cs.addChannel(amf);
			ro.channelSet = cs;
			ro.showBusyCursor = true;
			ro.destination = 'NetCDFService';
			
		}
		
		public function getVirtualSensorData($layer_id:int,$spatial:Spatial,$time_bounds:Temporal = null):AsyncToken{
			var _params:Array = [];
			
			var lat_drv:DimensionRequestValue = new DimensionRequestValue();
			lat_drv.name = 'lat';
			lat_drv.startDoubleValue = $spatial.latlon.latitude;
			lat_drv.endDoubleValue = $spatial.latlon.latitude;
			lat_drv.valueType = VariableType.DOUBLE;
			_params.push(lat_drv);
			
			var lon_drv:DimensionRequestValue = new DimensionRequestValue();
			lon_drv.name = 'lon';
			lon_drv.startDoubleValue = $spatial.latlon.longitude;
			lon_drv.endDoubleValue = $spatial.latlon.longitude;
			lon_drv.valueType = VariableType.DOUBLE;
			_params.push(lon_drv);
			
			if(!$spatial.elevation){
				$spatial.elevation = 0;
			}
			
			if(!isNaN($spatial.elevation)){
				var d_drv:DimensionRequestValue = new DimensionRequestValue();
				d_drv.name = 'depth';
				d_drv.startDoubleValue = Math.abs($spatial.elevation);
				d_drv.endDoubleValue = Math.abs($spatial.elevation);
				d_drv.valueType = VariableType.DOUBLE;
				_params.push(d_drv);
			}
			
			if($time_bounds){
				var t_drv:DimensionRequestValue = new DimensionRequestValue();
				t_drv.name = 'time';
				t_drv.startDateValue = $time_bounds.startdate;
				t_drv.endDateValue = $time_bounds.enddate;
				t_drv.valueType = VariableType.DATE;
				_params.push(t_drv);
				//trace('START DATE = ' + $time_bounds.startdate.toString());
				//trace('END DATE = ' + $time_bounds.enddate.toString());
			}
			
			trace('LAYER ID = ' + $layer_id + ' LAT = ' + $spatial.latlon.latitude + ' LON = ' + $spatial.latlon.longitude);
			
			
			return ro.getDatasetValues($layer_id,_params);
		}
		
		
		
		
	}
}