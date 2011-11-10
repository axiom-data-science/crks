package com.axiomalaska.integratedlayers.controllers
{
	import com.axiomalaska.map.interfaces.ILayer;
	import com.axiomalaska.map.interfaces.IMap;
	import com.axiomalaska.map.layers.LayerGroup;
	import com.axiomalaska.map.types.google.GoogleWMSLayer;
	import com.axiomalaska.models.Temporal;
	import com.axiomalaska.crks.dto.Layer;
	import com.axiomalaska.crks.dto.RasterLayer;
	import com.axiomalaska.crks.dto.RasterTimeStrata;
	import com.axiomalaska.crks.dto.VectorLayer;
	
	import com.axiomalaska.integratedlayers.models.presentation_data.ApplicationData;
	import com.axiomalaska.integratedlayers.models.presentation_data.TimeData;
	
	import com.axiomalaska.integratedlayers.map.IntegratedGoogleMap;

	public class TimeController extends BaseController
	{
		[Inject("timeData", bind="true")]
		public var timeData:TimeData;
		
		[Inject("applicationData")]
		public var applicationData:ApplicationData;
		
		[Inject("layersController")]
		public var layersController:LayersController;
		
		public var map:IMap;
		
		[EventHandler("AxiomMapEvent.AXIOM_MAP_READY", properties="map")]
		public function mapLoaded($map:IMap):void{
			map = $map;
		}
		
		/*
		[EventHandler("LayerEvent.LAYER_LOADED")]
		public function onLayerLoaded():void{
			//trace('update the layers! ' + applicationData.active_layers_collection.length);
			_resetTimeBar();
		}
		
		[EventHandler("LayerEvent.LAYER_UNLOADED")]
		public function onLayerUnLoaded():void{
			trace('update the layers! ' + applicationData.active_layers_collection.length);
			_resetTimeBar();
		}
		*/
		
		public function resetTimeBar($layers:Array):void{
			
			var has_time_slice:Boolean = false;
			var has_time_span:Boolean = false;
			
			var min_date:Date;
			var max_date:Date;
			
			for each(var layer:Layer in $layers){
				
				if(layer.startTimeUtc && layer.endTimeUtc){
					
					
					if(layer is VectorLayer){
						has_time_span = true;
					}else if(layer is RasterLayer){
						has_time_slice = true;
					}
					
										
					if(!min_date || (layer.startTimeUtc.time < min_date.time)){
						min_date = layer.startTimeUtc;
					}
					
					
					if(!max_date || (layer.endTimeUtc.time > max_date.time)){
						max_date = layer.endTimeUtc;
					}					
					
				}
			}
			
			if(!timeData.time_span_active && has_time_span){
				timeData.time_bounds.startdate = min_date;
				timeData.time_bounds.enddate = max_date;
			}
			
			if(!timeData.time_slice_active && has_time_slice){
				//timeData.time_slice = new Date();
			}
			
			timeData.minimum_date = min_date;
			timeData.maximum_date = max_date;
			timeData.time_slice_active = has_time_slice;
			timeData.time_span_active = has_time_span;
		}
		
	}
}