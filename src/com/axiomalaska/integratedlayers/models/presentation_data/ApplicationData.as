package com.axiomalaska.integratedlayers.models.presentation_data
{
	import com.axiomalaska.crks.dto.AmfDataService;
	import com.axiomalaska.crks.dto.DataLayer;
	import com.axiomalaska.crks.dto.DataProvider;
	import com.axiomalaska.crks.dto.Layer;
	import com.axiomalaska.crks.dto.LayerGroup;
	import com.axiomalaska.crks.dto.LayerSubtype;
	import com.axiomalaska.crks.dto.LayerType;
	import com.axiomalaska.crks.dto.Module;
	import com.axiomalaska.crks.dto.ModuleStickyLayerGroup;
	import com.axiomalaska.crks.dto.OgcLayer;
	import com.axiomalaska.crks.dto.Parameter;
	import com.axiomalaska.crks.dto.ParameterType;
	import com.axiomalaska.crks.dto.Portal;
	import com.axiomalaska.crks.dto.PortalLayerGroup;
	import com.axiomalaska.crks.dto.PortalModule;
	import com.axiomalaska.crks.dto.RasterLayer;
	import com.axiomalaska.crks.dto.VectorLayer;
	import com.axiomalaska.crks.helpers.LayerTypes;
	import com.axiomalaska.crks.interfaces.ILegendItem;
	import com.axiomalaska.crks.interfaces.IMetaDataItem;
	import com.axiomalaska.crks.service.result.PortalDataServiceResult;
	import com.axiomalaska.crks.service.result.ServiceResult;
	import com.axiomalaska.integratedlayers.models.DataRequest;
	import com.axiomalaska.integratedlayers.models.VirtualSensorLocation;
	import com.axiomalaska.integratedlayers.models.layers.data.stations_layer.Station;
	import com.axiomalaska.map.LatLon;
	import com.axiomalaska.models.SpatialBounds;
	import com.google.maps.LatLng;
	import com.google.maps.LatLngBounds;
	import com.google.maps.interfaces.IOverlay;
	
	import config.AppSettings;
	
	import flash.utils.describeType;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	
	[Bindable]
	public class ApplicationData
	{
		
		public var portal:Portal;
		public var portal_meta:Portal;
		
		public var loading:Boolean = true;
		
		public var active_module:Module;
		public var layers_panel_active:Boolean = false;
		
		public var map_overlays_map:Object = {};		
		public var layers_map:Object = {};
		public var layer_urls_map:Object = {};
		public var layers:ArrayCollection = new ArrayCollection();
		
		public var modules_map:Object = {};
		public var modules:ArrayCollection = new ArrayCollection();
		
		public var base_layers_map:Object = {};
		public var base_layers:ArrayCollection = new ArrayCollection();
		
		public var layer_groups_map:Object = {};
		public var layer_groups_collection:ArrayCollection = new ArrayCollection();
		
		public var parameters_map:Object = {};
		public var parameters:ArrayCollection = new ArrayCollection();
		
		public var parameter_types_map:Object = {};
		public var parameter_types:ArrayCollection = new ArrayCollection();
		
		public var data_providers_map:Object = {};
		public var data_providers_collection:ArrayCollection = new ArrayCollection();
		
		public var layer_types_collection:ArrayCollection = new ArrayCollection();
		public var layer_types_map:Object = {};
		public var layer_types_lookup:Object = {};
		
		public var layer_subtypes_map:Object = {};
		
		public var active_portal_modules:ArrayCollection = new ArrayCollection();
		public var active_portal_layers_map:Object = {};
		public var active_portal_layers:ArrayCollection = new ArrayCollection();
		public var active_layers_collection:ArrayCollection = new ArrayCollection();
		
		public var active_vector_layers_collection:ArrayCollection = new ArrayCollection();
		public var active_raster_layers_collection:ArrayCollection = new ArrayCollection();
		
		public var active_vector_time_layers_collection:ArrayCollection = new ArrayCollection();
		public var active_raster_time_layers_collection:ArrayCollection = new ArrayCollection();
		
		public var active_modules:ArrayCollection = new ArrayCollection();
		
		public var active_help_item:IMetaDataItem;
		
		public var active_station:Station;
		
		public var active_virtual_sensor:VirtualSensorLocation;
		
		public var legend_panel_active:Boolean = true;
		
		public var hide_intro:Boolean = false;
		
		public function findLayerByName($layer_key:String):Layer{
			var l:Layer;
			if(layer_urls_map.hasOwnProperty($layer_key)){
				l = layer_urls_map[$layer_key];
			}
			return l;
		}
		
		
		public function register_active_layer($layer:Layer):Boolean{
			$layer.activeOnMap = true;
			$layer.layerGroup.activeOnMap = true;
			$layer.layerGroup.module.activeOnMap = true;
			if(active_layers_collection.getItemIndex($layer) < 0){
				active_layers_collection.addItem($layer);
				if($layer is VectorLayer && active_vector_layers_collection.getItemIndex($layer) < 0){
					active_vector_layers_collection.addItem($layer);
				}else if($layer is RasterLayer && active_raster_layers_collection.getItemIndex($layer) < 0){
					active_raster_layers_collection.addItem($layer);
				}
				return true;
			}
			return false;
		}
		
		public function unregister_active_layer($layer:Layer):Boolean{
			$layer.activeOnMap = false;
			var layer_group_active:Boolean = false;
			for each(var layer:Layer in $layer.layerGroup.layers){
				if(layer.activeOnMap){
					layer_group_active = true;
				}
			}
			$layer.layerGroup.activeOnMap = layer_group_active;
			var module_active:Boolean = false;
			for each(var layer_group:LayerGroup in $layer.layerGroup.module.layerGroups){
				if(layer_group.activeOnMap){
					module_active = true;
				}
			}
			$layer.layerGroup.module.activeOnMap = module_active;
			
			if(active_layers_collection.getItemIndex($layer) >= 0){
				active_layers_collection.removeItemAt(active_layers_collection.getItemIndex($layer));
				
				if($layer is VectorLayer && active_vector_layers_collection.getItemIndex($layer) >= 0){
					active_vector_layers_collection.removeItemAt(active_vector_layers_collection.getItemIndex($layer));
				}else if($layer is RasterLayer && active_raster_layers_collection.getItemIndex($layer) >= 0){
					active_raster_layers_collection.removeItemAt(active_raster_layers_collection.getItemIndex($layer));
				}
				
				return true;
			}
			return false;
		}
		
		public var layer_search_term:String;
		public function searchLayers():void{
			layers.filterFunction = null;
			layers.filterFunction = runLayerFilter;
			layers.refresh();
		}
		
		public function runLayerFilter($layer:Layer):Boolean{
			
			var ret:Boolean = false;
			
			var srch:String = $layer.label;
			
			if(srch.length > 0 && layer_search_term){
				ret = srch.toLowerCase().indexOf(layer_search_term.toLowerCase()) > -1;
			}else{
				ret = true;
			}
			
			return ret;
		}
		
		public function searchLayerGroups():void{
			layer_groups_collection.filterFunction = null;
			layer_groups_collection.filterFunction = runLayerGroupFilter;
			layer_groups_collection.refresh();
		}
		
		public function runLayerGroupFilter($layer_group:LayerGroup):Boolean{
			
			var ret:Boolean = false;
			
			var layer_str:String = '';
			for each(var layer:Layer in $layer_group.layers){
				layer_str += ' ' + layer.label;
			}
			
			var srch:String = $layer_group.label + ' ' + $layer_group.module.label + ' ' + layer_str;
			
			if(srch.length > 0 && layer_search_term){
				ret = srch.toLowerCase().indexOf(layer_search_term.toLowerCase()) > -1;
			}else{
				ret = true;
			}
			
			
			return ret;
		}
		
		
		public function mapOverlayActive($layer_id:int):Boolean{
			if(map_overlays_map[$layer_id]){
				return true;
			}
			return false;
		}
		
		public function getMapOverlay($layer_id:int):IOverlay{
			if(mapOverlayActive($layer_id)){
				return map_overlays_map[$layer_id];
			}
			return null;
		}
		
		public function registerMapOverlay($overlay:IOverlay,$layer_id:int):void{
			if(!map_overlays_map.hasOwnProperty($layer_id)){
				map_overlays_map[$layer_id] = $overlay;
			}
		}
		
		public function unregisterMapOverlay($layer_id:int):void{			
			if(map_overlays_map.hasOwnProperty($layer_id)){
				delete(map_overlays_map[$layer_id]);
			}
		}
		
		
		
		public function registerLayer($layer:Layer):void{
			
			if(layers.getItemIndex($layer) < 0){
				layers.addItem($layer);
			}
			if(!layers_map.hasOwnProperty($layer.id)){
				layers_map[$layer.id] = $layer;
			}
			
			if(!layer_urls_map.hasOwnProperty($layer.getUrlKey())){
				layer_urls_map[$layer.getUrlKey()] = $layer;
			}
			
			if($layer.idParameter && !$layer.parameter){
				if(parameters_map.hasOwnProperty($layer.idParameter)){
					var parameter:Parameter = parameters_map[$layer.idParameter];
					$layer.parameter = parameter;
					if(parameter.layers.getItemIndex(parameter) < 0){
						parameter.layers.addItem($layer);
					}
				}
			}
			
			if($layer.idParameterType && !$layer.parameterType){
				if(parameter_types_map[$layer.idParameterType]){
					var parameter_type:ParameterType = parameter_types_map[$layer.idParameterType];
					$layer.parameterType = parameter_type;
					if(parameter_type.layers.getItemIndex(parameter_type) < 0){
						parameter_type.layers.addItem($layer);
					}
				}
			}
			
			if(!$layer.layerSubtype && layer_subtypes_map.hasOwnProperty($layer.idLayerSubtype)){
				var layer_subtype:LayerSubtype = layer_subtypes_map[$layer.idLayerSubtype];
				$layer.layerSubtype = layer_subtype;
				if(layer_subtype.layers.getItemIndex($layer) < 0){
					layer_subtype.layers.addItem($layer);
				}
			}
			
			
			if($layer.idLayerGroup && layer_groups_map.hasOwnProperty($layer.idLayerGroup)){
				var lg:LayerGroup = layer_groups_map[$layer.idLayerGroup];
				$layer.layerGroup = lg;
				if(lg.layers.getItemIndex($layer) < 0){
					lg.layers.addItem($layer);
				}
			}
			
		}
		
		public function registerModule($module:Module):void{

			if(!$module.dataProvider && data_providers_map.hasOwnProperty($module.idDataProvider)){
				var data_provider:DataProvider = data_providers_map[$module.idDataProvider];
				$module.dataProvider = data_provider;
				if(data_provider.modules.getItemIndex($module) < 0){
					data_provider.modules.addItem($module);
				}
			}
			if(modules.getItemIndex($module) < 0){
				modules.addItem($module);
			}
			if(!modules_map.hasOwnProperty($module.id)){
				modules_map[$module.id] = $module;
			}
		}
		
		
		
		public function registerDataProvider($data_provider:DataProvider):void{
			
			if(!data_providers_map.hasOwnProperty($data_provider.id)){
				data_providers_map[$data_provider.id] = $data_provider;
			}
			
			if(data_providers_collection.getItemIndex($data_provider) < 0){
				data_providers_collection.addItem($data_provider);
			}
		}
		

		
		public function registerLayerGroup($layer_group:LayerGroup):void{
			
			if(!$layer_group.module && modules_map.hasOwnProperty($layer_group.idModule)){
				var module:Module = modules_map[$layer_group.idModule] as Module;
				$layer_group.module = module;
				if(module.layerGroups.getItemIndex($layer_group) < 0){
					module.layerGroups.addItem($layer_group);
				}
				
			}
			
			if(!$layer_group.layerType && layer_types_map.hasOwnProperty($layer_group.idLayerType)){
				var layer_type:LayerType = layer_types_map[$layer_group.idLayerType];
				$layer_group.layerType = layer_type;
				if(layer_type.layerGroups.getItemIndex($layer_group) < 0){
					layer_type.layerGroups.addItem($layer_group);
				}
			}
			
			if(layer_groups_collection.getItemIndex($layer_group) < 0){
				layer_groups_collection.addItem($layer_group);
			}
			if(!layer_groups_map.hasOwnProperty($layer_group.id)){
				layer_groups_map[$layer_group.id] = $layer_group;
			}

			
		}
		
		public function registerModuleStickyLayerGroup($moduleStickyLayerGroup:ModuleStickyLayerGroup):void{

			if(!$moduleStickyLayerGroup.module && modules_map.hasOwnProperty($moduleStickyLayerGroup.idModule)){
				var module:Module = modules_map[$moduleStickyLayerGroup.idModule] as Module;
				$moduleStickyLayerGroup.module = module;
				if(module.moduleStickyLayerGroups.getItemIndex($moduleStickyLayerGroup) < 0){
					module.moduleStickyLayerGroups.addItem($moduleStickyLayerGroup);
				}
			}
			
			if(!$moduleStickyLayerGroup.layerGroup && layer_groups_map.hasOwnProperty($moduleStickyLayerGroup.idLayerGroup)){
				var layer_group:LayerGroup = layer_groups_map[$moduleStickyLayerGroup.idLayerGroup] as LayerGroup;
				$moduleStickyLayerGroup.layerGroup = layer_group;
				if(layer_group.moduleStickyLayerGroups.getItemIndex($moduleStickyLayerGroup) < 0){
					layer_group.moduleStickyLayerGroups.addItem($moduleStickyLayerGroup);
				}
				
			}
			

			
		}
		
		
		public function registerLayerType($layerType:LayerType):void{
			
			if(!layer_types_map.hasOwnProperty($layerType.id)){
				layer_types_map[$layerType.id] = $layerType;
			}
			if(!layer_types_lookup.hasOwnProperty($layerType.type)){
				layer_types_lookup[$layerType.type] = $layerType;
			}
			if(layer_types_collection.getItemIndex($layerType) < 0){
				layer_types_collection.addItem($layerType);
			}
		}
		
		public function registerLayerSubtype($layerSubtype:LayerSubtype):void{
			if(!$layerSubtype.layerType && layer_types_map.hasOwnProperty($layerSubtype.idLayerType)){
				var layer_type:LayerType = layer_types_map[$layerSubtype.idLayerType];
				$layerSubtype.layerType = layer_type;
				if(layer_type.layerSubtypes.getItemIndex($layerSubtype) < 0){
					layer_type.layerSubtypes.addItem($layerSubtype);
				}
			}
			if(!layer_subtypes_map.hasOwnProperty($layerSubtype.id)){
				layer_subtypes_map[$layerSubtype.id] = $layerSubtype;
			}
		}
		
		public function registerPortalLayerGroup($portalLayerGroup:PortalLayerGroup):void{
			if(!$portalLayerGroup.portal){
				$portalLayerGroup.portal = portal;
				if(portal.backgroundColor && !portal.backgroundColor2){
					portal.backgroundColor2 = String(uint('0x' + portal.backgroundColor) * .9);
				}
			}
			if(!$portalLayerGroup.layerGroup && layer_groups_map.hasOwnProperty($portalLayerGroup.idLayerGroup)){
				$portalLayerGroup.layerGroup = layer_groups_map[$portalLayerGroup.idLayerGroup];
			}
			
			if(portal.portalLayerGroups.getItemIndex($portalLayerGroup) < 0){
				portal.portalLayerGroups.addItem($portalLayerGroup);
			}			
			
			
		}
		
		public function registerParameter($parameter:Parameter):void{
			parameters_map[$parameter.id] = $parameter;	
			if($parameter.idParameterType){
				if(parameter_types.hasOwnProperty($parameter.idParameterType)){
					var parameter_type:ParameterType = parameter_types[$parameter.idParameterType];
					$parameter.parameterType = parameter_type;
					if(parameter_type.parameters.getItemIndex($parameter) < 0){
						parameter_type.parameters.addItem($parameter);
					}
				}
			}
		}
		
		
		public function registerPortalModule($portalModule:PortalModule):void{
			if(!$portalModule.portal){
				$portalModule.portal = portal;
			}
			if(!$portalModule.module && modules_map.hasOwnProperty($portalModule.idModule)){
				$portalModule.module = modules_map[$portalModule.idModule];
			}
			if($portalModule.module.portalModules.getItemIndex($portalModule) < 0){
				$portalModule.module.portalModules.addItem($portalModule);
			}
			if(portal.portalModules.getItemIndex($portalModule) < 0){
				portal.portalModules.addItem($portalModule);
			}
			
			
			if(active_portal_modules.getItemIndex($portalModule) < 0){
				active_portal_modules.addItem($portalModule.module);
			}
			
			
		}
		
		public function registerParameterType($parameter_type:ParameterType):void{
			parameter_types_map[$parameter_type.id] = $parameter_type;
		}
		
		
		
		
		public function insertServerData($sr:PortalDataServiceResult):void{
			
			var module:Module;
			
			portal = $sr.portal;
			
			
			
			for each(var data_provider:DataProvider in $sr.dataProviders){
				registerDataProvider(data_provider);
			}
			
			parameter_types = $sr.parameterTypes;	
			for each(var parameter_type:ParameterType in parameter_types){
				registerParameterType(parameter_type);
			}
			
			parameters = $sr.parameters;
			for each(var parameter:Parameter in parameters){
				registerParameter(parameter);
			}
			
			for each(var layerType:LayerType in $sr.layerTypes){
				registerLayerType(layerType);
			}
			
			for each(var layerSubtype:LayerSubtype in $sr.layerSubtypes){
				registerLayerSubtype(layerSubtype);
			}
			
			for each(module in $sr.modules){
				registerModule(module);
			}
			
			for each(var portalModule:PortalModule in $sr.portalModules){
				registerPortalModule(portalModule);
			}
			
			for each(var layerGroup:LayerGroup in $sr.layerGroups){	
				registerLayerGroup(layerGroup);
			}
			
			for each(var raster_layer:RasterLayer in $sr.rasterLayers){
				registerLayer(raster_layer);
			}
			
			for each(var vector_layer:VectorLayer in $sr.vectorLayers){
				registerLayer(vector_layer);
			}
			
			
			for each(var data_layer:DataLayer in $sr.dataLayers){
				registerLayer(data_layer);
			}
			
			for each(var portalLayerGroup:PortalLayerGroup in $sr.portalLayerGroups){
				registerPortalLayerGroup(portalLayerGroup);
			}
			var plg_sort_field:SortField = new SortField('sortOrder',true,false,true);
			var plg_sort:Sort = new Sort();
			plg_sort.fields = [plg_sort_field];
			portal.portalLayerGroups.sort = plg_sort;
			portal.portalLayerGroups.refresh();
			
			
			for each(var moduleStickyLayerGroup:ModuleStickyLayerGroup in $sr.moduleStickyLayerGroups){
				registerModuleStickyLayerGroup(moduleStickyLayerGroup);
			}
			
			//makeFakeDataLayer();
			
			var layer_groups_sort_field:SortField = new SortField('label',true);
			//layer_groups_sort_field.compareFunction = sortLayerGroups;
			var layer_groups_sort:Sort = new Sort();
			layer_groups_sort.fields = [layer_groups_sort_field];
			layer_groups_collection.sort = layer_groups_sort;
			layer_groups_collection.refresh();
			
			
			for each(var mod:Module in modules){
				mod.layerGroups.sort = layer_groups_sort;
				mod.layerGroups.refresh();
			}
			
			var mod_sort_field:SortField = new SortField('label',true);
			var mod_sort:Sort = new Sort();
			mod_sort.fields = [mod_sort_field];
			modules.sort = mod_sort;
			modules.refresh();
			
			active_portal_modules.sort = mod_sort;
			active_portal_modules.refresh();
			

			
			
			
			
		}
		
		
		
		public function makeFakeDataLayer():void{
			var m:Module = new Module();
			m.label = 'Sensors';
			m.iconCode = ModuleIcons.weather_sensors;
			m.layerGroups = new ArrayCollection();
			_makeStationsLayer(m,'Data feed: All Sensor Stations');
			//_makeSensorsLayer(m,'Data feed: Web cams',[2]);
			//_makeSensorsLayer(m,'Data feed: Winds',[5]);
			
			registerModule(m);
			
			var pm:PortalModule = new PortalModule();
			pm.module = m;
			pm.portal = portal;
			registerPortalModule(pm);
			
			
			//_makeADIWGLayer();
		}
		
		private function _makeStationsLayer($module:Module,$label:String = 'Sensors'):void{
			var a:AmfDataService = new AmfDataService();
			a.destination = 'StationSensorService';
			
			a.url = AppSettings.domain + '/stationsensorservice/messagebroker/amf2';
			a.method = 'getStations';
			
			var l:DataLayer = new DataLayer();
			l.amfDataService = a;
			l.label = $label;
			l.id = layers.length;
			registerLayer(l);
			
			var lg:LayerGroup = new LayerGroup();
			lg.layers.addItem(l);
			lg.label = l.label;
			registerLayerGroup(lg);
			l.layerGroup = lg;
			
			$module.layerGroups.addItem(lg);
			lg.module = $module;
			
			
		}
		

	}
}