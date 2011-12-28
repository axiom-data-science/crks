package com.axiomalaska.integratedlayers.models.layers.data.stations_layer
{
	import com.axiomalaska.integratedlayers.events.ApplicationStateEvent;
	import com.axiomalaska.integratedlayers.events.DataFilterEvent;
	import com.axiomalaska.integratedlayers.events.DataLayerEvent;
	import com.axiomalaska.integratedlayers.events.MarkerEvent;
	import com.axiomalaska.integratedlayers.events.SensorEvent;
	import com.axiomalaska.integratedlayers.models.DataRequest;
	import com.axiomalaska.integratedlayers.models.layers.LayerData;
	import com.axiomalaska.integratedlayers.models.presentation_data.MapData;
	import com.axiomalaska.integratedlayers.models.presentation_data.sensors.SensorLegendPM;
	import com.axiomalaska.integratedlayers.models.presentation_data.sensors.StreamingSensorDataMarkerPM;
	import com.axiomalaska.integratedlayers.services.DataLayerService;
	import com.axiomalaska.integratedlayers.utilities.UnitConverter;
	import com.axiomalaska.map.LatLon;
	import com.axiomalaska.map.features.MapFeature;
	import com.axiomalaska.map.types.google.GoogleMap;
	import com.axiomalaska.map.types.google.overlay.SimpleMarker;
	import com.axiomalaska.models.ResultSet;
	import com.axiomalaska.models.VariableData;
	import com.axiomalaska.models.VariableDataDescriptor;
	import com.axiomalaska.crks.dto.DataLayer;
	import com.axiomalaska.crks.utilities.ApplicationState;
	import com.axiomalaska.utilities.Style;
	import com.google.maps.LatLng;
	import com.google.maps.LatLngBounds;
	import com.google.maps.Map;
	import com.google.maps.MapEvent;
	//import com.greensock.TweenLite;
	//import com.greensock.TweenMax;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.BevelFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.controls.Alert;
	import mx.formatters.NumberFormatter;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import org.swizframework.events.BeanEvent;
	import org.swizframework.utils.services.ServiceHelper;
	
	public class StationsDataLayer extends LayerData
	{
		
		
		public var marker_map:Object = {}; 
		
		public var sensor:Sensor;
		public var station:Station;
		public var source:Source;
		
		[Bindable]
		public var stations:ArrayCollection = new ArrayCollection();
		public var stations_map:Object = {};
		
		[Bindable]
		public var station_search:String;
		
		[Bindable]
		public var sensors:ArrayCollection = new ArrayCollection();
		public var sensors_map:Object = {};
		public var sensors_type_map:Object = {};
		
		[Bindable]
		public var sensor_search:String;
		
		[Bindable]
		public var parent_layer:DataLayer;
		
		
		[Bindable]
		public var sources:ArrayCollection = new ArrayCollection();
		public var sources_map:Object = {};
		
		[Bindable]
		public var source_search:String;
		
		[Bindable]
		public var sensor_to_visualize:Sensor;
		
		[Bindable]
		public var vector_sensor_to_visualize:Sensor;
		
		public var loading:Boolean = false;
		
		[Inject]
		public var mapData:MapData;
		
		
		[Inject("sensorLayerData")]
		public var sensorLayerData:SensorLegendPM;
		

		
		public var stationMarkerData:StreamingSensorDataMarkerPM;
		
		[PostConstruct]
		public function onConstruct():void{
			stationMarkerData = new StreamingSensorDataMarkerPM();
			dispatcher.dispatchEvent( new BeanEvent( BeanEvent.ADD_BEAN, stationMarkerData ) );
		}
		
		
		[PreDestroy]
		public function onDestroy():void{
			dispatcher.dispatchEvent(new BeanEvent(BeanEvent.TEAR_DOWN_BEAN,this));
		}
		
		[EventHandler("AxiomMapEvent.AXIOM_MAP_PAN_COMPLETE")]
		[EventHandler("AxiomMapEvent.AXIOM_MAP_ZOOM_COMPLETE")]
		public function onMapUpdate():void{
			dispatcher.dispatchEvent(new DataLayerEvent(DataLayerEvent.UPDATE_DATA_LAYER_VIEW,this));
		}
		
		private var _alpha:Number;
		override public function set alpha($alpha:Number):void{
			_alpha = $alpha;
			if(features){
				for each(var feature:MapFeature in features){
					feature.alpha = _alpha / 100;
				}
			}
		}
		override public function get alpha():Number{
			return _alpha;
		}
		
		public function StationsDataLayer($name:String = null)
		{
			if(!$name){
				$name = this.className;
			}
			super($name);	
			
		}
		
		public function filterSensors($sensor:Sensor):Boolean{
			return _filterProperty($sensor,sensor_search);
		}
		
		public function filterStations($station:Station):Boolean{
			return _crossFilterStation($station,station_search);
		}
		
		public function filterSources($source:Source):Boolean{
			return _filterProperty($source,source_search);
		}
		
		private function _crossFilterStation($station:Station,$search_string:String):Boolean{
			
			var ret:Boolean = _filterProperty($station,$search_string);
			
			if(ret){
				var i:int = 0;
				var sensor_pass:Boolean = false;
				while(i < $station.sensors.length && !sensor_pass){
					if($station.sensors[i].selected && sensors.getItemIndex($station.sensors[i]) >= 0){
						sensor_pass = true;
					}
					i ++;
				}
				
				ret = sensor_pass;
				
			}
			
			
			if(ret){
				if($station.source && (!$station.source.selected || sources.getItemIndex($station.source) < 0)){
					ret = false;
				}else{
					ret = true;
				}
			}
			
			return ret;
		}
		
		private function _filterProperty($item:Filterable,$search_string:String = null):Boolean{
			
			var ret:Boolean = false;
			
			var srch:String = $item.label;
			
			if(srch && srch.length > 0 && $search_string){
				ret = srch.toLowerCase().indexOf($search_string.toLowerCase()) > -1;
			}else{
				ret = true;
			}
			
			return ret;
		}
		
		public function process_data($result_set:ResultSet):void{
			
			
			var srt:Sort = new Sort();
			srt.fields = [new SortField('label',true)]
			
			for each(var sensor:Sensor in $result_set.sensors){
				sensors.addItem(sensor);
				sensors_map[sensor.id] = sensor;
				sensors_type_map[sensor.sensorType] = sensor;
				//trace('public static const ' + sensor.sensorType + ':String = \'' + sensor.sensorType + '\';');
			}
			
			sensors.filterFunction = null;
			sensors.filterFunction = filterSensors;
			sensors.sort = srt;
			sensors.refresh();
			
			for each(var source:Source in $result_set.sources){
				sources.addItem(source);
				sources_map[source.id] = source;
			}
			
			sources.filterFunction = null;
			sources.filterFunction = filterSources;
			sources.sort = srt;
			sources.refresh();
			
			var pairs:int = 0;

			for each(var station:Station in $result_set.stations){
				stations_map[station.id] = station;
				stations.addItem(station);
				station.source = $result_set.sources[station.sourceId];
				station.sensors = [];
				for each(var sid:int in station.sensorIds){
					station.sensors.push($result_set.sensors[sid]);	
					pairs ++;
				}
				
				station.sensors.sort(function($a:Sensor,$b:Sensor):int{
					
					var cmpA:String = $a.label;
					var cmpB:String = $b.label;
					
					//ARTIFICIALLY RASE WEB CAMS TO TOP OF LIST
					if($a.sensorType == SensorTypes.WEB_CAM){
						cmpA = 'AA' + cmpA;
					}
					if($b.sensorType == SensorTypes.WEB_CAM){
						cmpB = 'AA' + cmpB;
					}
					
					return cmpA.localeCompare(cmpB);
				});
			}
			
			trace(sources.length + ' sources');
			trace(sensors.length + ' sensors');
			trace(stations.length + ' stations');
			trace(pairs + ' unique station/sensors');
			
			
			
			//set some defaults
			sensorLayerData.selected_scalar_preview_sensor = sensors_type_map[SensorTypes.AIR_TEMPERATURE];
			sensorLayerData.selected_vector_preview_sensor = sensors_type_map[SensorTypes.WINDS];
			sensorLayerData.stationDataLayer = this;
			
			
			stations.filterFunction = null;
			stations.filterFunction = filterStations;
			stations.sort = srt;
			stations.refresh();
			drawMarkers();
			

		}
		
		public function handleUrlArguments():void{
			trace('StationsDataLayer.handleUrlArguments!');
			if(parent_layer.urlArguments){
				if(parent_layer.urlArguments.hasOwnProperty('st') && parent_layer.urlArguments.hasOwnProperty('sn')){
					if(stations_map.hasOwnProperty(parent_layer.urlArguments['st']) && sensors_map.hasOwnProperty(parent_layer.urlArguments['sn'])){
						var m:SimpleMarker = marker_map[parent_layer.urlArguments['st']] as SimpleMarker;
						m.data.selectedSensor = sensors_map[parent_layer.urlArguments['sn']];
						dispatcher.dispatchEvent(new MarkerEvent(MarkerEvent.MARKER_CLICK, m));
					}
				}
			}
			
		}
		
		public function filterMarkers():void{
			trace('starting filter');
			for(var station_id:String in marker_map){
				var st:Station = stations_map[station_id];
				var m:SimpleMarker = marker_map[station_id];
				var vis:Boolean = true;
				if(stations.getItemIndex(st) < 0 || !st.selected){
					vis = false;
				}
				m.visible = vis;
			}
			
			dispatcher.dispatchEvent(new DataLayerEvent(DataLayerEvent.UPDATE_DATA_LAYER_VIEW,this));
		}
		
		private function drawMarkers():void{
			
			var _alph:Number = .9;
			var _size:Number = 4;
			var _strokeSize:Number = 2;
			var _bgColor:uint = 0xFFFFFF;
			
			var cam_style:Style = new Style();
			cam_style.color = _bgColor;
			cam_style.alpha = _alph;
			cam_style.size = _size;
			cam_style.stroke = 0x990000;
			cam_style.strokeSize = _strokeSize;
			
			var tides_style:Style = new Style();
			tides_style.color = _bgColor;
			tides_style.alpha = _alph;
			tides_style.size = _size;
			tides_style.stroke = 0x006699;
			tides_style.strokeSize = _strokeSize;
			
			
			var style:Style = new Style();
			style.color = _bgColor;
			style.alpha = _alph;
			style.size = _size;
			style.stroke = 0x666666;
			style.strokeSize = _strokeSize;

			
			var hstyle:Style = new Style();
			hstyle.color = 0xFFFFCC;
			hstyle.size = style.size + 5;
			hstyle.stroke = 0x660000;
			hstyle.strokeSize = style.strokeSize + 6;
			
			var web_cam_sensor:Sensor;
			if(sensors_type_map.hasOwnProperty(SensorTypes.WEB_CAM)){
				web_cam_sensor = sensors_type_map[SensorTypes.WEB_CAM]
			}
			
			var tide_sensor:Sensor;
			if(sensors_type_map.hasOwnProperty(SensorTypes.TIDES)){
				tide_sensor = sensors_type_map[SensorTypes.TIDES];
			}
			
			for each(station in stations){
				/*
				var m:SimpleMarker;
				var hm:SimpleMarker;
				
				var _mstyle:Style = style;
				
				if(tide_sensor && station.sensors.indexOf(tide_sensor) >= 0){
					_mstyle = tides_style;
				}else if(web_cam_sensor && station.sensors.indexOf(web_cam_sensor) >= 0){
					_mstyle = cam_style;
				}
				
				m = new RealTimeDataMarker(new LatLon(station.latitude,station.longitude),{station:station},_mstyle);
				hm = new SimpleMarker(new LatLon(),null,hstyle);
				hm.draw();
				hm.visible = false;
				m.addChild(hm);
				m.highlight = hm;
				m.id = 'pp' + station.id;
				m.draw();*/
				var m:RealTimeDataMarker = sensorLayerData.getStationMarker(station);
				addMarkerEvents(m);
				addFeature(m);
				marker_map[station.id] = m;
				
				//markers.addItem(m);
				
				//point_marker_map[item.id] = m;
				
			}
			
			filterMarkers();
		}
		
		
		
		private function addMarkerEvents($marker:SimpleMarker):void{
			$marker.buttonMode = true;
			$marker.addEventListener(MouseEvent.CLICK,function($evt:MouseEvent):void{
				dispatcher.dispatchEvent(new MarkerEvent(MarkerEvent.MARKER_CLICK,$marker));
			});
			
			$marker.addEventListener(MouseEvent.MOUSE_OVER,function($evt:MouseEvent):void{
				dispatcher.dispatchEvent(new MarkerEvent(MarkerEvent.MARKER_OVER,$marker));
			});
			
			$marker.addEventListener(MouseEvent.MOUSE_OUT,function($evt:MouseEvent):void{
				dispatcher.dispatchEvent(new MarkerEvent(MarkerEvent.MARKER_OFF,$marker));
			});
			
		}
		
		
		[EventHandler("DataFilterEvent.RUN_FILTER")]
		public function onRunFilter():void{
			stations.refresh();
			filterMarkers();
		}
		
		[EventHandler("DataFilterEvent.UNCHECKALL_BUT_SELECTED", properties="filterable")]
		public function onCheckAllButSelected($filterable:Filterable):void{
			var coll:ArrayCollection;
			if($filterable is Sensor){
				coll = sensors;
			}else if($filterable is Source){
				coll = sources;
			}else if($filterable is Station){
				coll = stations;
			}
			if(coll){
				var f:Filterable;
				for each(f in coll){
					f.selected = false;
				}
				var filters:Array = [sensors,stations,sources];
				for each(var filter:ArrayCollection in filters){
					if(filter != coll){
						for each(f in filter){
							f.selected = true;
						}
					}
				}
				$filterable.selected = true;
				dispatcher.dispatchEvent(new DataFilterEvent(DataFilterEvent.RUN_FILTER));
			}
		}
		
		
		
		[EventHandler("DataFilterEvent.HIGHLIGHT_FILTERABLE", properties="filterable")]
		public function onFilterableHover($filterable:Filterable):void{
			onFilterableOut();
			markers_to_highlight = new Vector.<RealTimeDataMarker>;
			if($filterable is Source){
				highlightSourceStations($filterable as Source);
			}else if($filterable is Sensor){
				highlightSensorStations($filterable as Sensor);
			}else if($filterable is Station){
				highlightStation($filterable as Station);
			}
			highlightStations();
		}
		
		[EventHandler("DataFilterEvent.UNHIGHLIGHT_FILTERABLE")]
		public function onFilterableOut():void{
			for each(var marker:RealTimeDataMarker in markers_to_highlight){
				marker.highlight.visible = false;
				if(!marker.active){
					marker.toBottom();
				}
			}
		}
		
		
		private var markers_to_highlight:Vector.<RealTimeDataMarker>;
		
		private function highlightSourceStations($source:Source):void{
			for each(var station:Station in stations){
				if($source == station.source){
					markers_to_highlight.push(marker_map[station.id]);
				}
			}
		}
		
		private function highlightSensorStations($sensor:Sensor):void{
			for each(var station:Station in stations){
				if(station.sensors.indexOf($sensor) >= 0){
					markers_to_highlight.push(marker_map[station.id]);
				}
			}
		}
		
		private function highlightStation($station:Station):void{
			markers_to_highlight.push(marker_map[$station.id]);
		}
		
		
		private function highlightStations():void{
			for each(var marker:RealTimeDataMarker in markers_to_highlight){
				marker.highlight.visible = true;
				marker.toTop();
			}
		}

		
		

		
		/* WHEN A SENSOR VIEW AT LOCATION IS SELECTED */
		[EventHandler("SensorEvent.REQUEST_SENSOR_DATA", properties="station,sensor,update_state")]
		public function onStationSensorSelection($station:Station,$sensor:Sensor,$update_state:Boolean):void{

			
			
			if($update_state){
				parent_layer.applicationState.children = new Vector.<ApplicationState>;
				
				var station_state:ApplicationState = new ApplicationState();
				station_state.property = 'st';
				station_state.value = $station.id.toString();
				parent_layer.applicationState.children.push(station_state);
				
				var sensor_state:ApplicationState = new ApplicationState();
				sensor_state.property = 'sn';
				sensor_state.value = $sensor.id.toString();
				parent_layer.applicationState.children.push(sensor_state);
				
				dispatcher.dispatchEvent(new ApplicationStateEvent(ApplicationStateEvent.UPDATE_APPLICATION_STATE_PROPERTY,parent_layer.applicationState));
			}
		}
		
		[EventHandler("SensorEvent.REMOVE_SENSOR_DATA")]
		public function onSelectedStationRemove():void{
			for each(var apS:ApplicationState in parent_layer.applicationState.children){
				if(apS.property == 'st' || apS.property == 'sn'){
					parent_layer.applicationState.children.splice(parent_layer.applicationState.children.indexOf(apS),1);
				}
			}
			
			dispatcher.dispatchEvent(new ApplicationStateEvent(ApplicationStateEvent.UPDATE_APPLICATION_STATE_PROPERTY,parent_layer.applicationState));
		}
		
		/* CURRENT SENSOR VALUE SYMBOLIZED ON STATION MARKER BEHAVIOR */
		
		
		

		
		

		
		
		
		
		
	}
		
	
}