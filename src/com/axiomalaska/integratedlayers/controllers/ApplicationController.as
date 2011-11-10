package com.axiomalaska.integratedlayers.controllers
{
	import com.axiomalaska.crks.dto.DataProvider;
	import com.axiomalaska.crks.dto.Layer;
	import com.axiomalaska.crks.dto.LayerGroup;
	import com.axiomalaska.crks.dto.Module;
	import com.axiomalaska.crks.dto.Portal;
	import com.axiomalaska.crks.dto.PortalLayerGroup;
	import com.axiomalaska.crks.dto.PortalModule;
	import com.axiomalaska.crks.dto.RasterLayer;
	import com.axiomalaska.crks.dto.VectorLayer;
	import com.axiomalaska.crks.service.result.PortalDataServiceResult;
	import com.axiomalaska.crks.service.result.ServiceResult;
	import com.axiomalaska.crks.utilities.ApplicationState;
	import com.axiomalaska.crks.utilities.ApplicationStateArguments;
	import com.axiomalaska.integratedlayers.events.HelpEvent;
	import com.axiomalaska.integratedlayers.events.LayerGroupEvent;
	import com.axiomalaska.integratedlayers.models.presentation_data.ApplicationData;
	import com.axiomalaska.integratedlayers.models.presentation_data.MapData;
	import com.axiomalaska.integratedlayers.models.presentation_data.TimeData;
	import com.axiomalaska.integratedlayers.services.ApplicationService;
	import com.axiomalaska.integratedlayers.views.panels.help.PortalIntro;
	import com.axiomalaska.map.interfaces.IMap;
	import com.axiomalaska.map.types.google.GoogleMap;
	import com.google.maps.LatLng;
	import com.google.maps.LatLngBounds;
	import com.google.maps.overlays.Polygon;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.managers.BrowserManager;
	import mx.managers.PopUpManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.URLUtil;
	
	import org.swizframework.utils.services.ServiceHelper;

	public class ApplicationController extends BaseController
	{
		
		[Inject("applicationData")]
		public var applicationData:ApplicationData;
		
		[Inject("timeData")]
		public var timeData:TimeData;
		
		[Inject]
		public var serviceHelper:ServiceHelper;
		
		[Inject("applicationService")]
		public var applicationService:ApplicationService;
		
		[Inject("mapData")]
		public var mapData:MapData;
		
		
		
		public var pdsr:PortalDataServiceResult;
		
		public var map:IMap;
		
		protected var url_arguments:Object = {};
		
		[PostConstruct]
		public function onConstruct():void{
			var str:String = BrowserManager.getInstance().fragment;
			
			if(str){
				url_arguments = URLUtil.stringToObject(str,ApplicationStateArguments.VARIABLE_SEPERATOR);
				
			}	
		}
		
		[EventHandler( event="AxiomMapEvent.AXIOM_MAP_READY", properties="map")]
		public function onMapLoad($map:IMap):void{
			map = $map;
			mapData.map = map;
			//getApplicationData();
		}
		
		[EventHandler(event="ApplicationEvent.APPLICATION_READY")]
		public function onAppReady():void{
			//Alert.show('APP READY!');
			getApplicationData();
		}
		
		public function getApplicationData():void{
			var portal_id:int = 10;//10
			//var portal_id:int = 6;
			if(FlexGlobals.topLevelApplication.parameters.hasOwnProperty('portal_id')){
				portal_id = int(FlexGlobals.topLevelApplication.parameters.portal_id);
			}
			serviceHelper.executeServiceCall(applicationService.getPortalMeta(portal_id),handlePortalMetaResult,handleError);
			
		}
		
		public function handlePortalMetaResult($evt:ResultEvent):void{
			applicationData.portal_meta = $evt.result.portal as Portal;
			dispatcher.dispatchEvent(new HelpEvent(HelpEvent.LOAD_METADATA_AT_STARTUP));
			//Alert.show('HANDLE META!');
			serviceHelper.executeServiceCall(applicationService.getApplicationData(applicationData.portal_meta.id),handleApplicationResult,handleError);
		}
		

		public function handleApplicationResult($evt:ResultEvent,$obj:Object = null):void{
			
			
			//Alert.show('GOT RESULT');
			applicationData.insertServerData($evt.result as PortalDataServiceResult);
			//Alert.show('INSERTED DATA');
			handleDefaultSettings();
			//Alert.show('HANDLED DEFAULT');
			applicationData.loading = false;
		}
		
		public function handleDefaultSettings():void{
			var ext_bnds:LatLngBounds;
			//SEE IF EXTENT WAS PASSED IN THROUGH URL
			//FlexGlobals.topLevelApplication.parameters
			
			if(url_arguments.hasOwnProperty(ApplicationStateArguments.BOUNDS)){
				var parts:Array = url_arguments[ApplicationStateArguments.BOUNDS].toString().split(ApplicationStateArguments.VARIABLE_LIST_SEPERATOR);
				//Alert.show(parts.toString());
				if(parts.length == 4){
					ext_bnds = new LatLngBounds(new LatLng(parts[0],parts[1]),new LatLng(parts[2],parts[3]));
				}
			}
			//OTHERWISE TRY USING THE PORTAL'S EXTENT PROPERTIES
			if(!ext_bnds && applicationData.portal.minLat && applicationData.portal.maxLat && applicationData.portal.minLng && applicationData.portal.maxLng){
				ext_bnds = new LatLngBounds(
					new LatLng(applicationData.portal.minLat,applicationData.portal.minLng),
					new LatLng(applicationData.portal.maxLat,applicationData.portal.maxLng)
				);
			}
			
			if(ext_bnds){
				var z:int = (map as GoogleMap).map.getBoundsZoomLevel(ext_bnds);
				(map as GoogleMap).map.setCenter(ext_bnds.getCenter(),z);
			}
			
			var portal_layer_groups:ArrayCollection = new ArrayCollection();
			
			//o[ApplicationStateArguments.LAYERS] = 'SNAP_PRC_CRU/precipitation';
			
			//SEE IF LAYER GROUPS WERE PASSED IN THROUGH URL (CURRENTLY LAYER NAMES, SOON LAYER GROUP IDS)
			if(url_arguments.hasOwnProperty(ApplicationStateArguments.LAYERS)){
				var passed_layer_keys:Array = url_arguments[ApplicationStateArguments.LAYERS].toString().split(ApplicationStateArguments.VARIABLE_LIST_SEPERATOR);
				var order:int = 0;
				for each(var layer_key:String in passed_layer_keys){
					//Alert.show('LAYER KEY IS ' + layer_key);
					
					var layer_args:Object = {};					
					if(layer_key.match(/\[.*\]/)){
						var res:Array = layer_key.match(/\[(.*)\]/);
						var s:String = res[1].replace(/:/g,'=');
						layer_args = URLUtil.stringToObject(s,';');
						layer_key = layer_key.replace(/\[.*\]/,'');
					}

					
					var l:Layer = applicationData.findLayerByName(layer_key);
					if(l){
						
						//layer args need to be saved in the layer as arguments, and the state needs to be preserved in the layer
						
						if(layer_args){
							l.urlArguments = layer_args;
							//var alertSt:String = 'URL ARGS BEING SET ON ' + l.label + ' ' + l.urlArguments.toString();
							//Alert.show(alertSt);
							l.applicationState.children = new Vector.<ApplicationState>;
							for(var p:String in l.urlArguments){
								var ap:ApplicationState = new ApplicationState();
								ap.property = p;
								ap.value = l.urlArguments[p];
								l.applicationState.children.push(ap);
							}
						}
						
						var plg:PortalLayerGroup = new PortalLayerGroup();
						plg.layerGroup = l.layerGroup;
						plg.portal = applicationData.portal;
						plg.idPortal = plg.portal.id;
						plg.sortOrder = order;
						portal_layer_groups.addItem(plg);
						order ++;
					}
				}
			}
			
			//o[ApplicationStateArguments.TIME_SLICE] = '962179200000';
			if(url_arguments.hasOwnProperty(ApplicationStateArguments.TIME_SLICE)){
				timeData.time_slice = new Date(Number(url_arguments[ApplicationStateArguments.TIME_SLICE]));
				//Alert.show('Time slice = (' + o[ApplicationStateArguments.TIME_SLICE] + ')' + timeData.time_slice.toDateString());
			}
			
			
			url_arguments[ApplicationStateArguments.TIME_BOUNDS] = '962179200000,1314136218969';
			if(url_arguments.hasOwnProperty(ApplicationStateArguments.TIME_BOUNDS)){
				//Alert.show(o[ApplicationStateArguments.TIME_BOUNDS]);
				var times:Array = url_arguments[ApplicationStateArguments.TIME_BOUNDS].toString().split(ApplicationStateArguments.VARIABLE_LIST_SEPERATOR);
				if(times.length == 2){
					timeData.time_bounds.startdate = new Date(Number(times[0]));
					timeData.time_bounds.enddate = new Date(Number(times[1]));
					//Alert.show('Time bounds start = (' + times[0] + ')' + timeData.time_bounds.startdate.toDateString());
					//Alert.show('Time bounds end = (' + times[1] + ')' + timeData.time_bounds.enddate.toDateString());
				}
			}
			
			if(portal_layer_groups.length < 1){
				portal_layer_groups = applicationData.portal.portalLayerGroups;
			}
			
			loadPortalLayerGroups(portal_layer_groups);

		}
		
		
		
		public function loadPortalLayerGroups($portal_layer_groups:ArrayCollection):void{
			for each(var portalLayerGroup:PortalLayerGroup in $portal_layer_groups){
				dispatcher.dispatchEvent(new LayerGroupEvent(LayerGroupEvent.LOAD_LAYER_GROUP,portalLayerGroup.layerGroup));
			}
		}

	}
}