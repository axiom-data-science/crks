package com.axiomalaska.integratedlayers.controllers
{
	import com.axiomalaska.crks.dto.Module;
	
	import com.axiomalaska.integratedlayers.events.LayerPanelEvent;
	
	import com.axiomalaska.integratedlayers.models.presentation_data.ApplicationData;

	public class ModulesController extends BaseController
	{
		
		[Inject("applicationData")]
		public var applicationData:ApplicationData;
		
		[EventHandler("ModuleEvent.SHOW_MODULE", properties="module")]
		public function loadModule($module:Module):void{
			dispatcher.dispatchEvent(new LayerPanelEvent(LayerPanelEvent.LAYER_PANEL_DEACTIVATE));
			applicationData.active_module = $module;
		}
		
		[EventHandler("ModuleEvent.HIDE_MODULE", properties="module")]
		public function removeModule($module:Module):void{
			applicationData.active_module = null;
		}
		
		[EventHandler("LayerPanelEvent.LAYER_PANEL_ACTIVATE")]
		public function showAllLayersPanel():void{
			applicationData.layers_panel_active = true;
		}
		
		[EventHandler("LayerPanelEvent.LAYER_PANEL_DEACTIVATE")]
		public function hideAllLayersPanel():void{
			applicationData.layers_panel_active = false;
		}
	}
}