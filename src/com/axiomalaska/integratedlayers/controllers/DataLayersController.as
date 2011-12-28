package com.axiomalaska.integratedlayers.controllers
{
	import com.axiomalaska.integratedlayers.events.ApplicationStateEvent;
	import com.axiomalaska.integratedlayers.events.DataLayerEvent;
	import com.axiomalaska.integratedlayers.map.IntegratedGoogleLayer;
	import com.axiomalaska.integratedlayers.models.DataRequest;
	import com.axiomalaska.integratedlayers.models.RequestValue;
	import com.axiomalaska.integratedlayers.models.layers.data.stations_layer.RealTimeDataMarker;
	import com.axiomalaska.integratedlayers.models.layers.data.stations_layer.Sensor;
	import com.axiomalaska.integratedlayers.models.layers.data.stations_layer.SensorTypes;
	import com.axiomalaska.integratedlayers.models.layers.data.stations_layer.Station;
	import com.axiomalaska.integratedlayers.models.layers.data.stations_layer.StationsDataLayer;
	import com.axiomalaska.integratedlayers.models.presentation_data.ApplicationData;
	import com.axiomalaska.integratedlayers.models.presentation_data.MapData;
	import com.axiomalaska.integratedlayers.services.ApplicationService;
	import com.axiomalaska.integratedlayers.services.DataLayerService;
	import com.axiomalaska.integratedlayers.utilities.ResultSetHelper;
	import com.axiomalaska.integratedlayers.utilities.UnitConverter;
	import com.axiomalaska.integratedlayers.views.panels.data.layer_data.sensors_data.SensorSparkLine;
	import com.axiomalaska.integratedlayers.views.panels.data.layer_data.sensors_data.StationDataPanel;
	import com.axiomalaska.integratedlayers.views.panels.data.layer_data.sensors_data.hover_popup.HoverMarkerContent;
	import com.axiomalaska.integratedlayers.views.panels.data.layer_data.sensors_data.web_cam_display.WebCam;
	import com.axiomalaska.map.interfaces.ILayer;
	import com.axiomalaska.map.interfaces.IMapFeature;
	import com.axiomalaska.map.layers.LayerGroup;
	import com.axiomalaska.map.types.google.GoogleMap;
	import com.axiomalaska.models.MetaDataItem;
	import com.axiomalaska.models.ResultSet;
	import com.axiomalaska.models.VariableData;
	import com.axiomalaska.models.VariableType;
	import com.axiomalaska.crks.dto.AmfDataService;
	import com.axiomalaska.crks.dto.DataLayer;
	import com.axiomalaska.crks.dto.LayerType;
	import com.axiomalaska.crks.helpers.LayerTypes;
	import com.axiomalaska.crks.utilities.ApplicationState;
	import com.axiomalaska.crks.utilities.ApplicationStateArguments;
	import com.axiomalaska.utilities.logos.SourceLogos;
	import com.google.maps.LatLng;
	import com.google.maps.LatLngBounds;
	import com.google.maps.Map;
	//import com.greensock.TweenMax;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.containers.TitleWindow;
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	import mx.events.ModuleEvent;
	import mx.events.ResizeEvent;
	import mx.formatters.NumberFormatter;
	import mx.managers.PopUpManager;
	import mx.modules.IModuleInfo;
	import mx.modules.ModuleManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectUtil;
	
	import org.swizframework.core.Bean;
	import org.swizframework.events.BeanEvent;
	import org.swizframework.utils.services.ServiceHelper;
	
	import spark.components.BorderContainer;
	import spark.components.Group;
	import spark.components.HGroup;
	import spark.components.Label;
	import spark.components.VGroup;

	public class DataLayersController extends LayersController
	{
		
		[Inject]
		public var serviceHelper:ServiceHelper;
		
		[Inject("dataLayerService")]
		public var dataLayerService:DataLayerService;
		
		[Inject("mapData")]
		public var mapData:MapData;
		
		public var layer_group:LayerGroup = new LayerGroup();
		
		private var info:IModuleInfo;
		
		[EventHandler("LayerEvent.LOAD_DATA_LAYER", properties="layer")]
		public function loadLayer($layer:DataLayer):void{
			serviceHelper.executeServiceCall(dataLayerService.getLayerData($layer.amfDataService,true),onDataResult,handleError,[$layer]);
		}
		


		
		
		public function onDataResult($evt:ResultEvent,$layer:DataLayer):void{
			
			var resultSets:Array = $evt.result.resultSets;
			
			layer_group.id = (applicationData.layer_types_lookup[LayerTypes.DATA_LAYER_TYPE] as LayerType).id;
			layer_group.zindex = 3000;
			
			if($evt.result is Array && ($evt.result[0] as ResultSet).stations){
				
				var rs:ResultSet = $evt.result[0] as ResultSet;
				var sl:StationsDataLayer = new StationsDataLayer($layer.label);
				sl.id = $layer.id.toString();
				dispatcher.dispatchEvent( new BeanEvent( BeanEvent.ADD_BEAN, sl ) );
				sl.process_data(rs);
				
				$layer.mapLayer = sl;
				sl.parent_layer = $layer;
				sl.handleUrlArguments();
				
				loadOverlay(sl,$layer,layer_group);
			}

		}
		
		

		
		
		private var marker_popup:HoverMarkerContent;
		private var hover_marker:IMapFeature;
		
		
		[EventHandler("MarkerEvent.MARKER_OVER", properties="marker")]
		public function onMarkerOver($marker:IMapFeature):void{
			
			($marker as RealTimeDataMarker).highlight.visible = true;
			//TweenMax.to(($marker as RealTimeDataMarker).highlight,.2,{dropShadowFilter:{color:0xff0000, alpha:1, blurX:12, blurY:12, distance:0}});
			
			if($marker != hover_marker){
				
				hover_marker = $marker;
				
				if(marker_popup && marker_popup.isPopUp){
					
					PopUpManager.removePopUp(marker_popup);
				}
				
				marker_popup =  new HoverMarkerContent();
				marker_popup.station = $marker.data.station;
				
				//MOVE THE MARKER TO THE TOP OF THE STACK
				var ml:DisplayObjectContainer = ($marker as Sprite).parent;
				ml.setChildIndex($marker as Sprite,ml.numChildren - 1);
				
			}
			
			
			PopUpManager.addPopUp(marker_popup,FlexGlobals.topLevelApplication as DisplayObject,false);
			
			var _x:Number = ($marker as Sprite).x + 40;
			var _y:Number = ($marker as Sprite).y + 30;
			
			onResize();
			marker_popup.addEventListener(ResizeEvent.RESIZE,onResize);
			
			function onResize($evt:ResizeEvent = null):void{
				if((_y + marker_popup.height) > FlexGlobals.topLevelApplication.height - 30){
					_y = FlexGlobals.topLevelApplication.height - marker_popup.height - 30;
				}
				
				marker_popup.x = _x;
				marker_popup.y = _y;
				
			}
			

			
			
		}
		

		
		
		
		[EventHandler("MarkerEvent.MARKER_OFF", properties="marker")]
		public function onMarkerOff($marker:IMapFeature):void{
			if($marker != selected_marker){
				($marker as RealTimeDataMarker).highlight.visible = false;
			}
			PopUpManager.removePopUp(marker_popup);
		}
		
		private var station_data_panel:StationDataPanel;
		private var selected_marker:IMapFeature;
		
		[EventHandler("MarkerEvent.MARKER_CLICK", properties="marker")]
		public function onMarkerClick($marker:IMapFeature):void{
			
			if(selected_marker){
				(selected_marker as RealTimeDataMarker).highlight.visible = false;
				(selected_marker as RealTimeDataMarker).toTop();
				//TweenMax.to((selected_marker as RealTimeDataMarker).highlight,.2,{dropShadowFilter:{color:0xff0000, alpha:1, blurX:12, blurY:12, distance:0}});
			}
			
			selected_marker = $marker;
			(selected_marker as RealTimeDataMarker).highlight.visible = true;
			
			applicationData.active_station = $marker.data.station;
			
			if(!station_data_panel){
				station_data_panel = new StationDataPanel();
				mapData.active_data_views.addItem(station_data_panel);
			}
			if($marker.data.hasOwnProperty('selectedSensor')){
				station_data_panel.selected_sensor = $marker.data.selectedSensor as Sensor;
			}
			station_data_panel.station = $marker.data.station;
			
			(mapData.map as GoogleMap).map.panTo(new LatLng($marker.latlon.latitude,$marker.latlon.longitude));

			
		}
		
		[EventHandler("SensorEvent.REMOVE_SENSOR_DATA")]
		public function onSensorDataRemove():void{
			if(station_data_panel){
				mapData.active_data_views.removeItemAt(mapData.active_data_views.getItemIndex(station_data_panel));
				if(station_data_panel && station_data_panel.parent){
					station_data_panel.parent.removeChild(station_data_panel);
				}
				station_data_panel = null;
			}
			if(selected_marker){
				(selected_marker as RealTimeDataMarker).highlight.visible = false;
				selected_marker = null;
			}
			if(applicationData.active_station){
				applicationData.active_station = null;
			}
		}
		
		[EventHandler("SensorEvent.REQUEST_SENSOR_DATA", properties="station,sensor,data_request,extra_params")]
		public function onSensorDataRequest($station:Station,$sensor:Sensor,$data_request:DataRequest,$extra_params:Object = null):void{
			
			$data_request.amf_service = $station.createSensorAMFServiceRequest($sensor,true,$extra_params);
			serviceHelper.executeServiceCall(dataLayerService.getLayerData($data_request.amf_service),onSensorResult,handleError,[$data_request,$sensor,$station]);

		}

		
		public function onSensorResult($evt:ResultEvent,$data_request:DataRequest = null,$sensor:Sensor = null,$station:Station = null):void{
			var rs:ResultSet = $evt.result[0] as ResultSet;
			if($sensor){
				UnitConverter.convertResultSet(rs,$sensor);
			}
			

			//trace('FIRST / LAST');
			var outstr:String = '';
			if($sensor && $station){
				outstr += $sensor.label + '(' + $sensor.id + ')' + ' AT ' + $station.label + ' (' + $station.id + ')' + "\n";
			}
			
			
			
			

			if(ResultSetHelper.resultSetHasData(rs)){
				$data_request.result_set = rs;
				$data_request.results = rs.keyed_collection;
				var obj:Object = rs.collection.getItemAt(0);
				var lobj:Object = rs.collection.getItemAt(rs.collection.length - 1);
				for(var p:String in obj){
					outstr += 'FIRST: ' + obj[p] + ' LAST: ' + lobj[p] + "\n";
				}
				
				//trace(outstr);
			}else{
				$data_request.result_set = new ResultSet();
			}
			$data_request.loading = false;
		}
		
		private function dateSort($a:Object,$b:Object,fields:Array = null):int
		{
			//fnDtfParceFunct is a Date parse function avail in DownloadCode.
			var dateA:Date=$a[fields[0].name];
			var dateB:Date=$b[fields[0].name];
			return ObjectUtil.dateCompare(dateA, dateB);

		}
		

		
		
	}
}