package com.axiomalaska.integratedlayers.controllers
{
	import com.axiomalaska.map.interfaces.ILayer;
	import com.axiomalaska.map.interfaces.ILayerGroup;
	import com.axiomalaska.map.layers.LayerGroup;
	import com.axiomalaska.map.types.google.GoogleWMSLayer;
	import com.axiomalaska.models.Temporal;
	import com.axiomalaska.crks.dto.Layer;
	import com.axiomalaska.crks.dto.LayerType;
	import com.axiomalaska.crks.dto.VectorLayer;
	import com.axiomalaska.crks.helpers.LayerTypes;
	import com.google.maps.interfaces.IOverlay;
	
	import com.axiomalaska.integratedlayers.map.IntegratedGoogleMap;
	import com.axiomalaska.integratedlayers.map.IntegratedWMSGoogleLayer;
	
	public class VectorLayersController extends OgcLayersController
	{
		
		[Inject("timeController")]
		public var timeController:TimeController;
		
		private var layer_group:LayerGroup;
		
		public function VectorLayersController()
		{
			super();
		}
		

		
		[EventHandler("LayerEvent.LOAD_VECTOR_LAYER", properties="layer")]
		public function onLoadVectorLayer($vector_layer:VectorLayer):void{
			//var ol:GoogleWMSLayer = new GoogleWMSLayer($vector_layer,map);
			//loadOverlay(ol,$vector_layer);
			
			if(!layer_group){
				layer_group = new LayerGroup();
				layer_group.id = (applicationData.layer_types_lookup[LayerTypes.VECTOR_LAYER_TYPE] as LayerType).id;
				layer_group.label = 'Vector layers';
				layer_group.zindex = 200;
			}
			
			_loadLayer($vector_layer);
		}
		
		[EventHandler("CompoundTimeSliderEvent.BOUNDED_TIME_SLIDER_SLIDING_COMPLETE")]
		public function onTimeSliderUpdate():void{
			for each(var layer:Layer in applicationData.active_layers_collection){
				if(layer.hasTimeComponent && layer is VectorLayer){
					_loadLayer(layer as VectorLayer);

				}
			}
		}
		
		private function _loadLayer($vector_layer:VectorLayer):void{
			
			
			
			
			var map_layer:ILayer;
			

			var arr:Array = [];
			for each(var layer:Layer in applicationData.active_layers_collection){
				arr.push(layer);
			}
			arr.push($vector_layer);
			
			timeController.resetTimeBar(arr);
			
			 
			var params:Object = {};
			
			if($vector_layer.hasTimeComponent && timeData.time_bounds && timeData.time_bounds.startdate && timeData.time_bounds.enddate){
				var _filter:Object = {
					type:'timeFilter',
					name:$vector_layer.timeProperty,
					lower:timeData.time_bounds.startdate,
					upper:timeData.time_bounds.enddate
				};
				params.boundary_filter = _filter;
			}
			if($vector_layer.hasSld){
				params.sld = $vector_layer.sldFile;
			}

			map_layer = new IntegratedWMSGoogleLayer($vector_layer,map,params);

			
			$vector_layer.mapLayer = map_layer;
			
			
			loadOverlay(map_layer,$vector_layer,layer_group);
		}
		

		
		
		
	}
}