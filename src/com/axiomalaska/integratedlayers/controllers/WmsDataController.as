package com.axiomalaska.integratedlayers.controllers
{
	import com.axiomalaska.map.LatLon;
	import com.axiomalaska.map.interfaces.IMap;
	import com.axiomalaska.map.overlay.WMS;
	import com.axiomalaska.map.types.google.GoogleMap;
	import com.axiomalaska.models.SpatialBounds;
	import com.axiomalaska.crks.dto.OgcLayer;
	import com.axiomalaska.crks.dto.VectorLayer;
	import com.google.maps.LatLngBounds;
	import com.google.maps.MapMouseEvent;
	import com.google.maps.overlays.Marker;
	import com.google.maps.overlays.MarkerOptions;
	
	import com.axiomalaska.integratedlayers.events.WMSDataEvent;
	
	import flash.events.MouseEvent;
	
	import com.axiomalaska.integratedlayers.models.WMSGetInfoData;
	import com.axiomalaska.integratedlayers.models.WMSInfoLayerResult;
	import com.axiomalaska.integratedlayers.models.WMSRequest;
	import com.axiomalaska.integratedlayers.models.presentation_data.ApplicationData;
	import com.axiomalaska.integratedlayers.models.presentation_data.MapData;
	
	import mx.collections.ArrayCollection;
	import mx.managers.CursorManager;
	import mx.rpc.events.ResultEvent;
	
	import org.swizframework.utils.services.ServiceHelper;
	
	import com.axiomalaska.integratedlayers.services.WMSService;
	
	import com.axiomalaska.integratedlayers.views.panels.data.layer_data.wms_point_data.WMSDataPanel;

	public class WmsDataController extends BaseController
	{
		
		[Inject("wmsService")]
		public var wmsService:WMSService;
		
		[Inject]
		public var serviceHelper:ServiceHelper;
		
		[Inject("applicationData")]
		public var applicationData:ApplicationData;
		
		[Inject("mapData")]
		public var mapData:MapData;
		
		[Embed(source="E:/flex/AxiomMaps/src/assets/images/wms-info-icon.png")]
		[Bindable]
		public var wmsInfoIcon:Class;
		
		[Embed(source="E:/flex/AxiomMaps/src/assets/images/wms-info-cursor.png")]
		[Bindable]
		private var cursor:Class;
		
		public var map:IMap;
		public var marker:Marker;
		
		[EventHandler("AxiomMapEvent.AXIOM_MAP_READY", properties="map")]
		public function mapLoaded($map:IMap):void{
			map = $map;
		}
		
		[EventHandler("WMSDataEvent.WMS_POINT_FEATURE_REMOVE_POINT")]
		public function wmsPointRemove():void{
			mapData.wms_info_data = null;
			if(marker){
				(map as GoogleMap).map.removeOverlay(marker);
				marker = null;
			}
			wmsPointInfoModeEnd();
		}
		

		private var cursor_id:int;
		private function setCursor():void{
			if(!cursor_id || isNaN(cursor_id)){
				cursor_id = CursorManager.setCursor(cursor);
			}
		}
		private function removeCursor():void{
			if(cursor_id && !isNaN(cursor_id)){
				CursorManager.removeCursor(cursor_id);
			}
			cursor_id = NaN;
		}
		
		[EventHandler("WMSDataEvent.WMS_INFO_MODE_START")]
		public function wmsPointInfoModeStart():void{
			setCursor();
			(map as GoogleMap).map.addEventListener(MouseEvent.MOUSE_OUT,onMouseOffMap);
			(map as GoogleMap).map.addEventListener(MouseEvent.MOUSE_OVER,onMouseOnMap);
			(map as GoogleMap).map.addEventListener(MapMouseEvent.CLICK,onWmsInfoClick);
		}
		
		private function onMouseOffMap($evt:MouseEvent):void{
			removeCursor();
			trace('off');
		}
		
		private function onMouseOnMap($evt:MouseEvent):void{
			setCursor();
			trace('back on');
			
		}
		
		private function onWmsInfoClick($evt:MapMouseEvent):void{
			
			wmsPointInfoModeEnd();
			
			var wms_info:WMSGetInfoData = new WMSGetInfoData();
			wms_info.x = (map as GoogleMap).map.fromLatLngToViewport($evt.latLng).x;
			wms_info.y = (map as GoogleMap).map.fromLatLngToViewport($evt.latLng).y;
			wms_info.latlon = new LatLon($evt.latLng.lat(),$evt.latLng.lng());
			
			var bnds:LatLngBounds = (map as GoogleMap).map.getLatLngBounds(); 
			wms_info.map_bounds = new SpatialBounds(bnds.getSouth(),bnds.getWest(),bnds.getNorth(),bnds.getEast());
			wms_info.map_rectangle = (map as GoogleMap).map.getPaneManager().getPaneAt(0).getViewportBounds();
			wms_info.layers = applicationData.active_vector_layers_collection.source;
			mapData.wms_info_data = wms_info;
			
			var view:WMSDataPanel = new WMSDataPanel();
			view.wms_info = wms_info;
			mapData.active_data_views.addItem(view);
			
			
			if(marker){
				marker.setLatLng($evt.latLng);
				
			}else{
				var mo:MarkerOptions = new MarkerOptions();
				mo.icon = new wmsInfoIcon();
				mo.draggable = true;
				marker = new Marker($evt.latLng,mo);
				marker.addEventListener(MapMouseEvent.DRAG_END,onWmsInfoClick);
				(map as GoogleMap).map.addOverlay(marker);
			}
			
			
			(map as GoogleMap).map.panTo($evt.latLng);
			
			for each(var layer:VectorLayer in wms_info.layers){
				serviceHelper.executeServiceCall(wmsService.callService(wms_info.makePointDataUrl(layer)),onWMSPointFeatureResult,handleError,[wms_info,layer]);
			}
			
		}
		
		public function onWMSPointFeatureResult($evt:ResultEvent,$wms_info:WMSGetInfoData,$layer:VectorLayer):void{
			$wms_info.loaded_results ++;
			addLayerResultToWmsInfo($evt,$wms_info,$layer);
			if($wms_info.loaded_results == $wms_info.layers.length){
				$wms_info.loading = false;
				if($wms_info.layer_results.length < 1){
					$wms_info.message = 'No layer data found at this location';
				}
			}
		}
		
		private function addLayerResultToWmsInfo($evt:ResultEvent,$wms_info:WMSGetInfoData,$layer:VectorLayer):void{
			if($evt.result.hasOwnProperty('FeatureCollection') && $evt.result.FeatureCollection.hasOwnProperty('featureMember')){
				var layer_result:ArrayCollection = new ArrayCollection();
				if($evt.result.FeatureCollection.featureMember is ArrayCollection){
					for each(var featureMember:Object in $evt.result.FeatureCollection.featureMember){
						for each(var fobj:Object in featureMember){
							layer_result.addItem(makeWmsResultObj(fobj));
						}
					}
				}else{
					for each(var obj:Object in $evt.result.FeatureCollection.featureMember){
						layer_result.addItem(makeWmsResultObj(obj));
					}
				}
				if(layer_result.length > 0){
					var wms_info_result:WMSInfoLayerResult = new WMSInfoLayerResult();
					wms_info_result.layer = $layer;
					wms_info_result.data_collection = layer_result;
					$wms_info.layer_results.addItem(wms_info_result);
				}
				
			}
		}
		
		
		[EventHandler("WMSDataEvent.WMS_INFO_MODE_END")]
		public function wmsPointInfoModeEnd():void{
			removeCursor();
			(map as GoogleMap).map.removeEventListener(MapMouseEvent.CLICK,onWmsInfoClick);
			(map as GoogleMap).map.removeEventListener(MouseEvent.MOUSE_OUT,onMouseOffMap);
			(map as GoogleMap).map.removeEventListener(MouseEvent.MOUSE_OVER,onMouseOnMap);
			mapData.wms_info_mode = false;
		}
		
		
		
		[EventHandler("WMSDataEvent.WMS_POINT_FEATURE_INFO_REQUEST", properties="wms_request")]
		public function wmsPointFeatureInfoRequest($wms_request:WMSRequest):void{
			trace('recieved..');
			serviceHelper.executeServiceCall(wmsService.callService($wms_request.makePointDataUrl()),onWMSPointFeatureResult,handleError,[$wms_request]);
		}
		public function onWMSPointFeatureResultOLD($evt:ResultEvent,$wms_request:WMSRequest):void{

			
			
			
			if($evt.result.hasOwnProperty('FeatureCollection') && $evt.result.FeatureCollection.hasOwnProperty('featureMember')){
				$wms_request.result_collection = new ArrayCollection();
				if($evt.result.FeatureCollection.featureMember is ArrayCollection){
					for each(var featureMember:Object in $evt.result.FeatureCollection.featureMember){
						for each(var fobj:Object in featureMember){
							$wms_request.result_collection.addItem(makeWmsResultObj(fobj));
						}
					}
				}else{
					for each(var obj:Object in $evt.result.FeatureCollection.featureMember){
						$wms_request.result_collection.addItem(makeWmsResultObj(obj));
					}
				}
				

			}else{
				$wms_request.message = 'No features were found in the selected location.';
			}
			
			$wms_request.loading = false;
			
			
		}
		
		private function makeWmsResultObj($obj:Object):Object{
			var exclude:Array = ['x','y','geom','geometry','area','perimeter'];
			var result_obj:Object = {};
			
			for(var k:String in $obj){
				if(exclude.indexOf(k) < 0){
					result_obj[k] = $obj[k];
				}
			}
			
			return result_obj;
		}
		
		
	}
}