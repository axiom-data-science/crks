package com.axiomalaska.integratedlayers.controllers
{
	import com.axiomalaska.crks.dto.Layer;
	import com.axiomalaska.crks.dto.LayerGroup;
	import com.axiomalaska.crks.dto.RasterLayer;
	import com.axiomalaska.crks.dto.VectorLayer;
	import com.axiomalaska.crks.utilities.ApplicationState;
	import com.axiomalaska.crks.utilities.ApplicationStateArguments;
	import com.axiomalaska.integratedlayers.events.ApplicationStateEvent;
	import com.axiomalaska.integratedlayers.events.LayerEvent;
	import com.axiomalaska.integratedlayers.map.IntegratedGoogleMap;
	import com.axiomalaska.integratedlayers.models.presentation_data.ApplicationData;
	import com.axiomalaska.integratedlayers.models.presentation_data.LegendData;
	import com.axiomalaska.integratedlayers.models.presentation_data.TimeData;
	import com.axiomalaska.map.interfaces.ILayer;
	import com.axiomalaska.map.interfaces.ILayerGroup;
	import com.axiomalaska.map.interfaces.IMap;
	import com.axiomalaska.map.layers.LayerGroup;
	import com.axiomalaska.map.types.google.GoogleMapV2;
	import com.google.maps.interfaces.IOverlay;
	import com.google.maps.interfaces.IPane;
	
	import mx.collections.ArrayCollection;
	
	public class LayersController extends BaseController
	{
		
		public var map:IMap;
		public var pane:IPane;
		
		[Inject("applicationData")]
		public var applicationData:ApplicationData;
		
		[Inject("timeData", bind="true")]
		public var timeData:TimeData;
		
		[Inject("legendData")]
		public var legendData:LegendData;
		
		public function LayersController()
		{
			super();
		}

		[EventHandler("AxiomMapEvent.AXIOM_MAP_READY", properties="map")]
		public function mapLoaded($map:IMap):void{
			map = $map;
			pane = (map as IntegratedGoogleMap).map.getPaneManager().createPane();
		}
		
		

		
		public function loadMapLayer($layer:Layer):void{
			(map as IntegratedGoogleMap).addLayer($layer.mapLayer);
		}
		
		
		public function loadOverlay($layer:ILayer,$otc_layer:Layer,$layer_group:ILayerGroup = null):void{
			
			if(!$layer_group){
				$layer_group = new com.axiomalaska.map.layers.LayerGroup();
				$layer_group.id = 0;
				$layer_group.zindex = 0;
			}
			
			
			
			if(map.addLayerToGroup($layer,$layer_group) && applicationData.register_active_layer($otc_layer)){
				dispatcher.dispatchEvent(new LayerEvent(LayerEvent.LAYER_LOADED,$otc_layer));
			}
			
			//hack to get setter to run!
			$otc_layer.alpha = $otc_layer.alpha + 1;
			$otc_layer.alpha = $otc_layer.alpha - 1;
			
			resetLayerStackingOrder()
			
			
		}
		
		[EventHandler("LegendEvent.LEGEND_REORDER_COMPLETE")]
		public function resetLayerStackingOrder():void{
			var layer_z:int = 0;
			layer_z = _setZindexesForType(legendData.vector_legend_items_collection,layer_z);
			layer_z = _setZindexesForType(legendData.raster_legend_items_collection,layer_z);
			layer_z = _setZindexesForType(legendData.sensor_legend_items_collection,layer_z);
			
			map.resetLayerOrder();
			
			var ap:ApplicationState = new ApplicationState();
			ap.property = ApplicationStateArguments.LAYERS;
			
			var layer_states:Vector.<ApplicationState> = new Vector.<ApplicationState>;
			for each(var l:Layer in applicationData.active_layers_collection){
				l.applicationState.parent = ap;
				layer_states.unshift(l.applicationState);
			}
			

			ap.children = layer_states;
			//ap.value = layer_keys.join(ApplicationStateArguments.VARIABLE_LIST_SEPERATOR);
			dispatcher.dispatchEvent(new ApplicationStateEvent(ApplicationStateEvent.UPDATE_APPLICATION_STATE_PROPERTY,ap));
			
			if(legendData.vector_legend_items_collection.length > 0 && timeData.time_bounds.startdate && timeData.time_bounds.enddate){
				var bounds_ap:ApplicationState = new ApplicationState();
				bounds_ap.property = ApplicationStateArguments.TIME_BOUNDS;
				bounds_ap.value = timeData.time_bounds.startdate.getTime().toString() + ',' + timeData.time_bounds.enddate.getTime().toString();
				dispatcher.dispatchEvent(new ApplicationStateEvent(ApplicationStateEvent.UPDATE_APPLICATION_STATE_PROPERTY,bounds_ap));
			}
			
			if(legendData.raster_legend_items_collection.length > 0 && timeData.time_slice){
				var slice_ap:ApplicationState = new ApplicationState();
				slice_ap.property = ApplicationStateArguments.TIME_SLICE;
				slice_ap.value = timeData.time_slice.getTime().toString();
				dispatcher.dispatchEvent(new ApplicationStateEvent(ApplicationStateEvent.UPDATE_APPLICATION_STATE_PROPERTY,slice_ap));
			}
			
			
		}
		
		private function _setZindexesForType($arrayCollection:ArrayCollection,$startZ:int):int{
			for each(var lg:com.axiomalaska.crks.dto.LayerGroup in $arrayCollection){
				for each(var l:Layer in lg.layers){
					if(l.mapLayer){
						var layer:ILayer = l.mapLayer;//(map as GoogleMapV2).layers_map[vl.id];
						layer.zindex = $startZ;
						$startZ ++;	
					}
				}
			}
			return $startZ;
		}

	}
}