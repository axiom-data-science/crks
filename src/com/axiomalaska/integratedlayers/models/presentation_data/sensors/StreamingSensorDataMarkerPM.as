package com.axiomalaska.integratedlayers.models.presentation_data.sensors
{
	
	import com.axiomalaska.integratedlayers.models.layers.data.stations_layer.RealTimeDataMarker;
	import com.axiomalaska.integratedlayers.models.layers.data.stations_layer.ResultSetRow;
	import com.axiomalaska.integratedlayers.models.layers.data.stations_layer.Sensor;
	import com.axiomalaska.integratedlayers.models.layers.data.stations_layer.Station;
	import com.axiomalaska.integratedlayers.models.layers.data.stations_layer.StationsDataLayer;
	import com.axiomalaska.integratedlayers.models.presentation_data.MapData;
	import com.axiomalaska.integratedlayers.services.DataLayerService;
	import com.axiomalaska.integratedlayers.utilities.ResultSetHelper;
	import com.axiomalaska.integratedlayers.utilities.UnitConverter;
	import com.axiomalaska.map.types.google.GoogleMap;
	import com.axiomalaska.map.types.google.overlay.SimpleMarker;
	import com.axiomalaska.models.ResultSet;
	import com.axiomalaska.models.VariableDataDescriptorIndexType;
	import com.axiomalaska.models.VariableDescriptorType;
	import com.google.maps.Color;
	import com.google.maps.LatLng;
	import com.google.maps.LatLngBounds;
	import com.google.maps.Map;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.formatters.NumberFormatter;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import org.swizframework.events.BeanEvent;
	import org.swizframework.utils.services.ServiceHelper;

	public class StreamingSensorDataMarkerPM
	{
		[Dispatcher]
		public var dispatcher:IEventDispatcher;
		
		[Inject]
		public var sensorData:SensorLegendPM;
		
		[Inject]
		public var stationDataLayer:StationsDataLayer;
		
		[Inject]
		public var mapData:MapData;
		
		[Inject("dataLayerService")]
		public var dataLayerService:DataLayerService;
		
		[Inject]
		public var serviceHelper:ServiceHelper;
		
		[Inject]
		public var sensorLayerData:SensorLegendPM;
		
		private var nf:NumberFormatter = new NumberFormatter();
		
		
		private var timer:Timer = new Timer(1000 * 60);

		
		[PreDestroy]
		public function onDestroy():void{
			dispatcher.dispatchEvent(new BeanEvent(BeanEvent.TEAR_DOWN_BEAN,this));
		}
		
		
		private function settupTimer():void{
			trace('setting up timer');
			if(!timer.running){
				timer.addEventListener(TimerEvent.TIMER,onTimer);
			}
			timer.start();
		}
		
		private function removeTimer():void{
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER,onTimer);
		}
		
		private function onTimer($evt:TimerEvent):void{
			var now:Date = new Date();
			for each(var marker:RealTimeDataMarker in active_markers){
				
				if(marker.scalarDataTimeStamp){
					if((now.time - marker.scalarDataTimeStamp.time) > (sensorLayerData.poll_timeout * 60 * 1000)){
						marker.scalarDataPending = true;
					}
				}
				
				if(marker.vectorDataTimeStamp){
					if((now.time - marker.vectorDataTimeStamp.time) > (sensorLayerData.poll_timeout * 60 * 1000)){
						marker.vectorDataPending = true;
					}
				}
				
				
				requestDataForMarker(marker);
			}
		}

		
		
		[EventHandler("DataLayerEvent.UPDATE_VECTOR_SELECTED_REALTIME_SENSOR")]
		public function onUpdateVectorSensor():void{
			clearActiveVectorVisualizations();
			if(sensorLayerData.vector_realtime_active){
				onUpdateDataLayerView();
			}
		}
		
		
		[EventHandler("DataLayerEvent.UPDATE_SCALAR_SELECTED_REALTIME_SENSOR")]
		public function onUpdateScalarSensor():void{
			clearActiveScalarVisualizations();
			if(sensorLayerData.scalar_realtime_active){
				onUpdateDataLayerView();
			}
		}
		
		
		[EventHandler("DataLayerEvent.UPDATE_DATA_LAYER_VIEW")]
		public function onUpdateDataLayerView():void{
			
			updateVisibleStationsList();
			trace('VISIBLE STATIONS LENGTH: ' + visible_stations.length);
			
			if(visible_stations.length < Number(sensorLayerData.visible_sensor_limit)){
				requestDataOnVisibleStationList();
			}
			
			visible_stations = new Vector.<Station>;
			
			
		}
		
		
		[EventHandler("DataLayerEvent.RELOAD_ACTIVE_REALTIME_SENSORS")]
		public function onReloadActiveSensors():void{
			trace(active_markers.length);
			for each(var marker:RealTimeDataMarker in active_markers){
				if(marker.scalarDataTimeStamp){
					marker.scalarDataPending = true;
				}
				if(marker.vectorDataTimeStamp){
					marker.vectorDataPending = true;
				}
				requestDataForMarker(marker);
			}
		}
		
		

		
		
		/*  */
		public function clearActiveVectorVisualizations():void{
			var marker:RealTimeDataMarker;
			var to_remove:Vector.<RealTimeDataMarker> = new Vector.<RealTimeDataMarker>;
			for each(marker in active_markers){
				marker.clearVectorData();				
				if(!marker.active){
					to_remove.push(marker);
				}
			}
			for each(marker in to_remove){
				removeFromActiveMarkersList(marker);
			}
		}
		
		
		
		public function clearActiveScalarVisualizations():void{
			var marker:RealTimeDataMarker;
			var to_remove:Vector.<RealTimeDataMarker> = new Vector.<RealTimeDataMarker>;
			for each(marker in active_markers){
				marker.clearScalarData();
				if(!marker.active){
					to_remove.push(marker);
				}
			}
			for each(marker in to_remove){
				removeFromActiveMarkersList(marker);
			}
			
		}
		
		private function updateVisibleStationsList():void{
			
			visible_stations = new Vector.<Station>;
			
			var ma:Map = (mapData.map as GoogleMap).map;
			var ll1:LatLng = ma.fromViewportToLatLng(new Point(0,(mapData.map as GoogleMap).height),true);
			var ll2:LatLng = ma.fromViewportToLatLng(new Point((mapData.map as GoogleMap).width,0),true);
			var bnds:LatLngBounds = new LatLngBounds(ll1,ll2);
			
			for(var station_id:String in stationDataLayer.marker_map){
				
				var st:Station = stationDataLayer.stations_map[station_id];
				var m:RealTimeDataMarker = stationDataLayer.marker_map[station_id];
				var bool:Boolean = false;
				

				if(
					m.visible && 
					(
						(st.sensors.indexOf(sensorLayerData.selected_scalar_preview_sensor) >= 0) || 
						(st.sensors.indexOf(sensorLayerData.selected_vector_preview_sensor) >= 0)
					)
					
				){
					var ll3:LatLng = new LatLng(m.latlon.latitude,m.latlon.longitude,true)
					bool = bnds.containsLatLng(ll3);
				}
				
				
				if(bool){
					
					if(
						st.sensors.indexOf(sensorLayerData.selected_scalar_preview_sensor) >= 0 &&
						!m.scalarDataLoading && 
						!m.scalarDataLoaded
					){
						m.scalarDataPending = true;
					}
					if(
						st.sensors.indexOf(sensorLayerData.selected_vector_preview_sensor) >= 0 &&
						!m.vectorDataLoading &&
						!m.vectorDataLoaded
					){
						m.vectorDataPending = true;
					}
					
					addToVisibleStationsList(st);
					
				}else{
					removeFromVisibleStationsList(st);
				}
			}
		}
		
		private var visible_stations:Vector.<Station> = new Vector.<Station>;
		private function addToVisibleStationsList($station:Station):void{
			if(visible_stations.indexOf($station) < 0){
				visible_stations.push($station);
			}
		}
		
		private function removeFromVisibleStationsList($station:Station):void{
			if(visible_stations.indexOf($station) >= 0){
				visible_stations.splice(visible_stations.indexOf($station),1);
			}
		}
		

		
		private var active_markers:Vector.<RealTimeDataMarker> = new Vector.<RealTimeDataMarker>;
		private function addToActiveMarkersList($marker:RealTimeDataMarker):void{
			if(active_markers.indexOf($marker) < 0){
				active_markers.push($marker);	
			}
		}
		private function removeFromActiveMarkersList($marker:RealTimeDataMarker):void{
			if(!$marker.active && active_markers.indexOf($marker) >= 0){
				//trace('TRYING TO REMOVE ' + $marker.data.station.label);
				active_markers.splice(active_markers.indexOf($marker),1);
				$marker.hideData();
			}
		}
		
		private function requestDataOnVisibleStationList():void{
			
			for each(var sta:Station in visible_stations){
				requestDataForMarker(markerFromStation(sta));
			}
		}
		
		
		private var _request_list:Vector.<RealTimeDataMarker>;
		private var _chunk_size:int = 10;
		private var _delay_timer:Timer = new Timer(100);
		private var _last_index:int =0;
		
		private function requestDataForMarkerList():void{
			if(_request_list){
				
			}
		}
		
		private function requestChunk($evt:Event = null):void{
			_delay_timer.stop();
			var ct:int = 0;
			var i:int;
			for(i = _last_index;(i < _request_list.length && ct < _chunk_size);i ++){
				requestDataForMarker(_request_list[i]);
			}
			
			if(ct < (_request_list.length - 1)){
				if(!_delay_timer.hasEventListener(TimerEvent.TIMER)){
					_delay_timer.addEventListener(TimerEvent.TIMER,requestChunk);
				}
				_last_index = i;
				_delay_timer.start();
				
			}else{
				_request_list = new Vector.<RealTimeDataMarker>;
			}
		}
		
		private function requestDataForMarker($marker:RealTimeDataMarker):void{
			var station:Station = $marker.data.station as Station;
			if($marker.scalarDataPending){
				requestScalarData(station);
			}
			
			if($marker.vectorDataPending){
				requestVectorData(station);
			}
		}
		
		private function requestScalarData($station:Station):void{
			var marker:RealTimeDataMarker = markerFromStation($station);
			marker.scalarDataPending = false;
			if(sensorLayerData.scalar_realtime_active){
				marker.scalarDataLoading = true;
				requestMostRecentData($station,sensorLayerData.selected_scalar_preview_sensor,scalarResultCallBack);
			}
		}
		
		private function requestVectorData($station:Station):void{
			var marker:RealTimeDataMarker = markerFromStation($station);
			marker.vectorDataPending = false;
			if(sensorLayerData.vector_realtime_active){
				marker.vectorDataLoading = true;
				requestMostRecentData($station,sensorLayerData.selected_vector_preview_sensor,vectorResultCallBack);
			}
		}
		
		
		private var proxy_counter:int = 0;
		private function requestMostRecentData($station:Station,$sensor:Sensor,$callBack:Function):void{
			addToActiveMarkersList(markerFromStation($station));
			markerFromStation($station).startLoader();
			
			proxy_counter ++;
			if(proxy_counter > 9){
				proxy_counter = 0;
			}
			
			serviceHelper.executeServiceCall(
				dataLayerService.getLayerData(
					$station.createSensorAMFServiceRequest($sensor,false,{mostRecent:true,pastHours:6},proxy_counter)
				),
				$callBack,handleError,
				[$station,$sensor]
			);

		}
		

		

		private function vectorResultCallBack($evt:ResultEvent,$station:Station,$sensor:Sensor):void{
			
			if(!timer.running){
				settupTimer();
			}
			
			var marker:RealTimeDataMarker = stationDataLayer.marker_map[$station.id];
			marker.vectorDataLoading = false;
			
			if(sensorData.vector_realtime_active){
			
				marker.vectorDataLoaded = true;
				marker.vectorDataTimeStamp = new Date();
				
				if($evt.result && $evt.result is Array){
					var rs:ResultSet = $evt.result[0] as ResultSet;
					UnitConverter.convertResultSet(rs,$sensor);
					marker.vectorData = ResultSetHelper.getMostRecentResultSetRow(rs);
					if(marker.vectorData){
						
						var magInd:Array = ResultSetHelper.getVariableDescriptorTypeIndex(rs,[VariableDescriptorType.VALUE],[VariableDataDescriptorIndexType.MAGNITUDE]);
						var dirInd:Array = ResultSetHelper.getVariableDescriptorTypeIndex(rs,[VariableDescriptorType.VALUE],[VariableDataDescriptorIndexType.DIRECTION]);
						
						if(magInd && dirInd){
							
							if(marker.vectorData){
								var dir:Number = marker.vectorData.result[dirInd[0]];
		
								dir = dir - 180;
								/*
								if(dir > 180){
									dir = dir - 360;
								}
								*/
		
								var mag:Number = marker.vectorData.result[magInd[0]];
								
								
								if(mag > 0){
									
									var min:Number = marker.dataStyle.size/2 + 5;
									var max:Number = marker.dataStyle.size/2 + 80;
									var maxWind:Number = 80;
									
									if(mag > maxWind){
										mag = maxWind;
									}
									
									var size:Number = ((mag * (max - min)) / maxWind) + min;
									
									if(marker.vectorDataDisplay && marker.contains(marker.vectorDataDisplay)){
										marker.removeChild(marker.vectorDataDisplay);
									}
									
									var sp:Sprite = marker.makeVectorWedge(size,0,40,20);
									marker.vectorDataDisplay = sp;
									//TweenMax.to(marker.vectorDataDisplay,2,{rotation:String(dir)});
									marker.toTop();
									
								}
							}
						}
		
					}
	
				}
				if(!marker.vectorData && !marker.scalarData){
					marker.toBottom();
				}
				
				if(marker.vectorDataDisplay && !marker.contains(marker.vectorDataDisplay)){
					marker.addChildAt(marker.vectorDataDisplay,0);
				}
				marker.stopLoader();
			
			}
			
		}
		
		private  function scalarResultCallBack($evt:ResultEvent,$station:Station,$sensor:Sensor):void{
			nf.precision = 0;
			
			if(!timer.running){
				settupTimer();
			}
			
			var marker:RealTimeDataMarker = stationDataLayer.marker_map[$station.id];
			marker.scalarDataLoading = false;
			
			if(sensorData.scalar_realtime_active){
			
				marker.scalarDataLoaded = true;
				marker.scalarDataTimeStamp = new Date();

				
				if($evt.result && $evt.result is Array){
					var rs:ResultSet = $evt.result[0] as ResultSet;
					
					UnitConverter.convertResultSet(rs,$sensor);
					marker.scalarData = ResultSetHelper.getMostRecentResultSetRow(rs);
					if(marker.scalarData){
						var inds:Array = ResultSetHelper.getVariableDescriptorTypeIndex(rs,[VariableDescriptorType.VALUE],[VariableDataDescriptorIndexType.SINGLE]);
						if(!inds){
							inds = ResultSetHelper.getVariableDescriptorTypeIndex(rs,[VariableDescriptorType.AVG],[VariableDataDescriptorIndexType.SINGLE]);
						}
						if(inds){
							var row:ResultSetRow = ResultSetHelper.getMostRecentResultSetRow(rs);
							if(row){
								var val:Number = row.result[inds[0]];
								var cm:ColorMapRow = findColorFromMap(val,SensorMarkerColorMaps.temperatureMap);
								marker.scalarData = row;
								marker.setDataDisplayColor(cm.color);
								marker.setDataDisplayText(nf.format(val),cm.text_color);
								marker.toTop();
							}
						}
					}
				}
				if(!marker.scalarData){
					marker.showDataDead();
					if(!marker.vectorData){
						marker.toBottom();
					}
				}
				
				
				marker.stopLoader();
			}
			
			
			
			
			
		}

		
		
		/* HELPERS */
		
		
		private function markerFromStation($station:Station):RealTimeDataMarker{
			var m:RealTimeDataMarker;
			if(stationDataLayer.marker_map.hasOwnProperty($station.id)){
				m = stationDataLayer.marker_map[$station.id] as RealTimeDataMarker;
			}
			return m;
		}
		
		

		
		private function findColorFromMap($value:Number,$colorMap:Array):ColorMapRow{
			
			for each(var row:ColorMapRow in $colorMap){
				if($value < row.value){
					return row;
				}
			}
			
			return row;
			
			
		}
		
		private function handleError($evt:FaultEvent,$station:Station,$sensor:Sensor):void{
			Alert.show('Error loading latest result: "' + $evt.fault.faultString + '"' + "\n" + 'Station: ' + $station.id + ' (' +  $station.label + ') Sensor: ' + $sensor.id + ' (' + $sensor.label + ')');
		}
		


		
		
	}
}