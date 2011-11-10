package com.axiomalaska.integratedlayers.controllers
{
	import com.axiomalaska.crks.dto.Layer;
	import com.axiomalaska.crks.dto.LayerGroup;
	import com.axiomalaska.crks.dto.Module;
	import com.axiomalaska.crks.dto.Portal;
	import com.axiomalaska.crks.helpers.HelpMetaData;
	import com.axiomalaska.crks.interfaces.IMetaDataItem;
	
	import flash.external.ExternalInterface;
	
	import com.axiomalaska.integratedlayers.models.presentation_data.ApplicationData;
	
	import mx.controls.Alert;
	import mx.rpc.events.ResultEvent;
	
	import org.swizframework.utils.services.ServiceHelper;
	
	import com.axiomalaska.integratedlayers.services.ApplicationService;
	
	import com.axiomalaska.integratedlayers.views.panels.help.CRKSPortalIntro;
	import com.axiomalaska.integratedlayers.views.panels.help.HelpPopup;
	import com.axiomalaska.integratedlayers.views.panels.help.PortalIntro;
	import com.axiomalaska.integratedlayers.views.panels.help.SkinnableMetaDataDisplay;

	public class HelpController extends BaseController
	{
		
		[Inject("applicationService")]
		public var applicationService:ApplicationService;
		
		[Inject("applicationData")]
		public var applicationData:ApplicationData;
		
		[Inject]
		public var serviceHelper:ServiceHelper;
		
		private var helpPopup:HelpPopup = new HelpPopup();
		
		[EventHandler("HelpEvent.LOAD_METADATA_AT_STARTUP")]
		public function onStartUp():void{
			var r:Boolean = ExternalInterface.call('crks_check_hide_intro',applicationData.portal_meta.id);
			//Alert.show(r.toString());
			if(!r){
				onAppHelp();
			}
			applicationData.hide_intro = r;
		}
		
		[EventHandler("HelpEvent.HIDE_APPLICATION_HELP_ON_LOAD")]
		public function onHideHelpOnLoad():void{
			ExternalInterface.call('crks_hide_intro_by_default',applicationData.portal.id);
			//applicationData.hide_intro = true;
		}
		
		[EventHandler("HelpEvent.SHOW_APPLICATION_HELP_ON_LOAD")]
		public function onShowHelpOnLoad():void{
			ExternalInterface.call('crks_show_intro_by_default',applicationData.portal.id);
			//applicationData.hide_intro = false;
		}
		
		
		[EventHandler("HelpEvent.SHOW_APPLICATION_HELP")]
		public function onAppHelp():void{
			if(applicationData.portal_meta && applicationData.portal_meta.id == 10){
				var crks:CRKSPortalIntro = new CRKSPortalIntro();
				crks.portal = applicationData.portal_meta;
				crks.open();
			}else{
				var pi:PortalIntro = new PortalIntro();
				pi.portal = applicationData.portal_meta;
				pi.open();
			}
			
		}
		
		[EventHandler("HelpEvent.SHOW_HELP_CONTENT", properties="meta_data_item")]
		public function onShowHelp($meta_data_item:IMetaDataItem):void{
			//applicationData.active_help_item = $meta_data_item;
			helpPopup.open();
			helpPopup.meta_data_item = $meta_data_item;
			
		}
		
		[EventHandler("HelpEvent.CLOSE_HELP_WINDOW")]
		public function onCloseHelpWindow():void{
			//applicationData.active_help_item = null;
			helpPopup.close();
			helpPopup.meta_data_item = null;
		}
		
		[EventHandler("HelpDataEvent.GET_META_DATA", properties="help_meta_data")]
		public function onRequestHelpData($help_meta_data:HelpMetaData):void{
			if($help_meta_data.source_item is Module){
				serviceHelper.executeServiceCall(applicationService.getLonelyModule(($help_meta_data.source_item as Module).id),onHelpDataReturn,handleError,[$help_meta_data]);
			}else if($help_meta_data.source_item is LayerGroup){
				serviceHelper.executeServiceCall(applicationService.getLonelyLayerGroup(($help_meta_data.source_item as LayerGroup).id),onHelpDataReturn,handleError,[$help_meta_data]);
			}else if($help_meta_data.source_item is Layer){
				serviceHelper.executeServiceCall(applicationService.getLayer(($help_meta_data.source_item as Layer).id),onHelpDataReturn,handleError,[$help_meta_data]);
			}
			
		}
		public function onHelpDataReturn($evt:ResultEvent,$help_meta_data:HelpMetaData):void{
			$help_meta_data.loading = false;
			if($evt.result.hasOwnProperty('module')){
				populateHelpMetaData($evt.result.module as Module,$help_meta_data);
			}else if($evt.result.hasOwnProperty('layerGroup')){
				populateHelpMetaData($evt.result.layerGroup as LayerGroup,$help_meta_data);
			}else if($evt.result.hasOwnProperty('vectorLayer') || $evt.result.hasOwnProperty('dataLayer')){
				populateHelpMetaData($evt.result.vectorLayer as Layer,$help_meta_data);
			}else if($evt.result.hasOwnProperty('rasterLayer')){
				populateHelpMetaData($evt.result.rasterLayer as Layer,$help_meta_data);
			}else if($evt.result.hasOwnProperty('dataLayer')){
				populateHelpMetaData($evt.result.dataLayer as Layer,$help_meta_data);
			}
		}
		
		private function populateHelpMetaData($meta_data_item:IMetaDataItem,$help_meta_data:HelpMetaData):void{
			if($meta_data_item){
				$help_meta_data.description = $meta_data_item.description;
				$help_meta_data.label = $meta_data_item.label;
				$help_meta_data.temporal = $meta_data_item.temporal;
				$help_meta_data.spatialBounds = $meta_data_item.spatialBounds;
				$help_meta_data.metaDataUrl = $meta_data_item.metadataUrl;
			}
		}
		
		
		
	}
}