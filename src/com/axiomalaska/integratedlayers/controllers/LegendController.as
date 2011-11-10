package com.axiomalaska.integratedlayers.controllers
{
	import com.axiomalaska.crks.dto.Layer;
	import com.axiomalaska.crks.dto.Module;
	import com.axiomalaska.crks.dto.PortalModule;
	import com.axiomalaska.crks.interfaces.ILegendItem;
	
	import com.axiomalaska.integratedlayers.events.LayerEvent;
	
	import com.axiomalaska.integratedlayers.models.presentation_data.ApplicationData;
	import com.axiomalaska.integratedlayers.models.presentation_data.LegendData;

	public class LegendController extends BaseController
	{
		[Inject("applicationData")]
		public var applicationData:ApplicationData;
		
		[Inject("legendData")]
		public var legendData:LegendData;
		
		[EventHandler("LegendEvent.LOAD_LEGEND_ITEM", properties="legend_item")]
		public function loadLegendItem($legend_item:ILegendItem):void{
			legendData.registerLegendItem($legend_item);
			
			/*
			if($legend_item is Layer){
				dispatcher.dispatchEvent(new LayerEvent(LayerEvent.LOAD_LAYER,$legend_item as Layer));
			}else if($legend_item is Module){
				
			}
			*/
		}
		
		[EventHandler("LegendEvent.UNLOAD_LEGEND_ITEM", properties="legend_item")]
		public function unloadLegendItem($legend_item:ILegendItem):void{
			legendData.unregisterLegendItem($legend_item);
			if($legend_item is Layer){
				dispatcher.dispatchEvent(new LayerEvent(LayerEvent.UNLOAD_LAYER,$legend_item as Layer));
			}
		}

	}
}