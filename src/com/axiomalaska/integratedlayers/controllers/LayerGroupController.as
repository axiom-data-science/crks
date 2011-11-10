package com.axiomalaska.integratedlayers.controllers
{
	import com.axiomalaska.crks.dto.Layer;
	import com.axiomalaska.crks.dto.LayerGroup;
	import com.axiomalaska.crks.dto.ModuleStickyLayerGroup;
	import com.axiomalaska.integratedlayers.events.LayerEvent;
	import com.axiomalaska.integratedlayers.events.LegendEvent;
	import com.axiomalaska.integratedlayers.map.IntegratedGoogleMap;
	import com.axiomalaska.integratedlayers.models.presentation_data.ApplicationData;
	import com.axiomalaska.map.events.AxiomLayerEvent;
	

	public class LayerGroupController extends BaseController
	{
		
		
		[Inject("applicationData")]
		public var applicationData:ApplicationData;
		
		
		
		public function LayerGroupController()
		{
			super();
		}
		
		
		[EventHandler("LayerGroupEvent.LOAD_LAYER_GROUP", properties="layer_group")]
		public function onLoadLayerGroup($layer_group:LayerGroup):void{
			
			
			if($layer_group.module.moduleStickyLayerGroups && $layer_group.module.moduleStickyLayerGroups.length > 0){
				
				
				for each(var stickyLayerGroup:ModuleStickyLayerGroup in $layer_group.module.moduleStickyLayerGroups){
					//adds layer group to legend
					dispatcher.dispatchEvent(new LegendEvent(LegendEvent.LOAD_LEGEND_ITEM,stickyLayerGroup.layerGroup));
					
					for each(var stickyLayer:Layer in stickyLayerGroup.layerGroup.layers){
						dispatcher.dispatchEvent(new LayerEvent(LayerEvent.LOAD_LAYER,stickyLayer));
					}
				}
				//trace($layer_group);
			}
			
			//adds layer group to legend
			dispatcher.dispatchEvent(new LegendEvent(LegendEvent.LOAD_LEGEND_ITEM,$layer_group));
			
			//loads each layer
			for each(var layer:Layer in $layer_group.layers){
				dispatcher.dispatchEvent(new LayerEvent(LayerEvent.LOAD_LAYER,layer));
			}
			

			
			
		}
		
		[EventHandler("LayerGroupEvent.UNLOAD_LAYER_GROUP", properties="layer_group")]
		public function onUnloadLayerGroup($layer_group:LayerGroup):void{
			dispatcher.dispatchEvent(new LegendEvent(LegendEvent.UNLOAD_LEGEND_ITEM,$layer_group));
			for each(var layer:Layer in $layer_group.layers){
				dispatcher.dispatchEvent(new LayerEvent(LayerEvent.UNLOAD_LAYER,layer));
				//dispatcher.dispatchEvent(new AxiomLayerEvent(AxiomLayerEvent.AXIOM_LAYER_END_TILE_LOAD,layer.mapLayer));
			}
		}
		
		[EventHandler("LayerGroupEvent.REMOVE_ALL_LAYER_GROUPS")]
		public function onRemoveAllLayerGroups():void{
			//for each(var layer_group in applicationData.active
			var layer_groups:Array = [];
			for each(var layer:Layer in applicationData.active_layers_collection){
				if(layer_groups.indexOf(layer.layerGroup) < 0){
					layer_groups.push(layer.layerGroup);
				}
			}
			
			for each(var layerGroup:LayerGroup in layer_groups){
				onUnloadLayerGroup(layerGroup);
			}
			
		}
		
		[EventHandler("LayerGroupEvent.HIDE_ALL_LAYER_GROUPS")]
		public function onHideAllLayerGroups():void{
			//for each(var layer_group in applicationData.active

			for each(var layer:Layer in applicationData.active_layers_collection){
				layer.visible = false;
				layer.layerGroup.visible = false;
				
			}
			

			
		}
		
		[EventHandler("LayerGroupEvent.SHOW_ALL_LAYER_GROUPS")]
		public function onShowAllLayerGroups():void{
			for each(var layer:Layer in applicationData.active_layers_collection){
				layer.visible = true;
				layer.layerGroup.visible = true;
			}

		}
		
		
		
	}
}