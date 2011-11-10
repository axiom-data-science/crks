package com.axiomalaska.integratedlayers.controllers
{
	import com.axiomalaska.map.interfaces.ILayer;
	import com.axiomalaska.map.layers.LayerGroup;
	import com.axiomalaska.crks.dto.Layer;
	import com.axiomalaska.crks.dto.LayerType;
	import com.axiomalaska.crks.dto.RasterElevationStrata;
	import com.axiomalaska.crks.dto.RasterLayer;
	import com.axiomalaska.crks.dto.RasterTimeStrata;
	import com.axiomalaska.crks.helpers.LayerTypes;
	import com.axiomalaska.crks.service.result.RasterTimeElevationStrataServiceResult;
	import com.google.maps.LatLng;
	import com.google.maps.LatLngBounds;
	
	import mx.controls.Alert;
	import mx.rpc.events.ResultEvent;
	
	import org.swizframework.utils.services.ServiceHelper;
	
	import com.axiomalaska.integratedlayers.services.ApplicationService;
	
	import com.axiomalaska.integratedlayers.map.IntegratedAKCoastOutline;
	import com.axiomalaska.integratedlayers.map.IntegratedWMSGoogleLayer;
	
	public class RasterLayersController extends OgcLayersController
	{
		
		
		[Inject("applicationService")]
		public var applicationService:ApplicationService;
		
		[Inject]
		public var serviceHelper:ServiceHelper;
		
		[Inject("timeController")]
		public var timeController:TimeController;
		
		private var dummy_time_strata:RasterTimeStrata;
		private var dummy_elevation_strata:RasterElevationStrata;
		private var dummy_res:RasterTimeElevationStrataServiceResult;
		
		private var layer_group:LayerGroup;
		
		private var ak_outline_layer_group:LayerGroup;
		private var ak_outline_layer:IntegratedAKCoastOutline;
		
		
		

		
		
		public function RasterLayersController(){
			super();
			ak_outline_layer_group = new LayerGroup();
			ak_outline_layer_group.id = 999;
			ak_outline_layer_group.label  = 'Alaska outline';
			ak_outline_layer_group.zindex = 101;
			
		}
		
		
		[EventHandler("LayerEvent.LOAD_RASTER_LAYER", properties="layer")]
		public function loadLayer($raster_layer:RasterLayer):void{
			serviceHelper.executeServiceCall(applicationService.getRasterTimeAndElevationStrata($raster_layer.id),onTimeAndElevationResult,handleError,[$raster_layer]);
		}
		
		public function onTimeAndElevationResult($evt:ResultEvent,$raster_layer:RasterLayer):void{
			//hack for now..
			var sr:RasterTimeElevationStrataServiceResult = $evt.result as RasterTimeElevationStrataServiceResult;
			if($raster_layer.id == sr.layerId){
				$raster_layer.insertServerData(sr);
				_loadLayer($raster_layer);
			}else{
				trace('ids do not match');
			}
			
		}
		
		[EventHandler("CompoundTimeSliderEvent.SLICE_TIME_SLIDER_SLIDING_COMPLETE")]
		public function onTimeSliderUpdate():void{
			trace('CALLING!');
			for each(var layer:Layer in applicationData.active_layers_collection){
				if(layer.hasTimeComponent && layer is RasterLayer){
					_loadLayer(layer as RasterLayer);
				}
			}
		}
		
		private function _loadLayer($raster_layer:RasterLayer):void{
			
			if(!layer_group){
				layer_group = new LayerGroup();
				layer_group.id = (applicationData.layer_types_lookup[LayerTypes.RASTER_LAYER_TYPE] as LayerType).id;
				layer_group.label = 'Raster layers';
				layer_group.zindex = 100;
			}
			
			var map_layer:ILayer; 
			
			var arr:Array = [];
			for each(var layer:Layer in applicationData.active_layers_collection){
				arr.push(layer);
			}
			arr.push($raster_layer);
			timeController.resetTimeBar(arr);
			
			
			var params:Object = {};
			
			if($raster_layer.hasTimeComponent && timeData.time_slice){

				
				var selectedStrata:RasterTimeStrata = $raster_layer.findStrataNearestToTime(timeData.time_slice);
				if(selectedStrata){
					params.time = selectedStrata.startTimeUtc;
				}else{
					if(applicationData.active_raster_layers_collection.length == 0){
						timeData.time_slice = $raster_layer.endTimeUtc;
						selectedStrata = $raster_layer.findStrataNearestToTime(timeData.time_slice);
						params.time = selectedStrata.startTimeUtc;
					}
				}
			}else{
				if(!timeData.time_slice){
					trace('no time slice');
					Alert.show('No time slice data');
				}
				if(!$raster_layer.hasTimeComponent && $raster_layer.rasterTimeStratas.length > 0){
					Alert.show('No time data for layer ' + $raster_layer.label + '(' + $raster_layer.id+ ')');
				}
			}
			
			map_layer = new IntegratedWMSGoogleLayer($raster_layer,map,params);
			if(!params.hasOwnProperty('time') && $raster_layer.rasterTimeStratas.length > 0){
				map_layer.hide();
			}else{
				map_layer.show();
			}
			
			
			/*
			for each(var strata:RasterTimeStrata in $raster_layer.rasterTimeStratas){
				var p:Object = {};
				p.time = strata.startTimeUtc;
				var l:IntegratedWMSGoogleLayer = new IntegratedWMSGoogleLayer($raster_layer,map,p);
				trace(l.wmsOverlay.makeURLForBounds(new LatLngBounds(new LatLng($raster_layer.minLat,$raster_layer.minLng),new LatLng($raster_layer.maxLat,$raster_layer.maxLng))));
				
			}
			*/
			
			$raster_layer.mapLayer = map_layer;
			
			loadOverlay(map_layer,$raster_layer,layer_group);
			
			
			

			
			if(!ak_outline_layer){
				ak_outline_layer  = new IntegratedAKCoastOutline(map);
			}
			map.addLayerToGroup(ak_outline_layer,ak_outline_layer_group);
		}
		
		
	}
}