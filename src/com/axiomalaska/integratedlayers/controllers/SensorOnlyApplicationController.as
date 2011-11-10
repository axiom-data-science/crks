package com.axiomalaska.integratedlayers.controllers
{
	import com.axiomalaska.integratedlayers.events.LayerGroupEvent;
	import com.axiomalaska.map.interfaces.IMap;
	import com.axiomalaska.map.types.google.GoogleMap;
	import com.axiomalaska.crks.dto.DataLayer;
	import com.axiomalaska.crks.dto.Layer;
	import com.axiomalaska.crks.dto.LayerGroup;
	import com.axiomalaska.crks.dto.LayerType;
	import com.axiomalaska.crks.dto.Portal;
	import com.axiomalaska.crks.dto.PortalLayerGroup;
	import com.axiomalaska.crks.helpers.LayerTypes;
	import com.axiomalaska.crks.service.result.PortalDataServiceResult;
	import com.axiomalaska.crks.utilities.ApplicationStateArguments;
	import com.google.maps.Map;
	import com.google.maps.services.ClientGeocoder;
	import com.google.maps.services.ClientGeocoderOptions;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;

	public class SensorOnlyApplicationController extends ApplicationController
	{
		
		private var constructed:Boolean = false;
		
		/*
		[PostConstruct]
		override public function onConstruct():void{
			super.onConstruct();
			constructed = true;
			if(map){
				loadSensors();
			}
		}*/
		
		override public function getApplicationData():void{
			//if(constructed && map){
				loadSensors();
			//}
		}
		
		
		public function loadSensors():void{
			var res:PortalDataServiceResult = new PortalDataServiceResult();
			res.portal = new Portal();
			var dlt:LayerType = new LayerType();
			dlt.type = LayerTypes.DATA_LAYER_TYPE;
			res.layerTypes = new ArrayCollection([dlt]);
			applicationData.insertServerData(res);
			
			
			
			var dataLayer:DataLayer;
			
			if(applicationData.layers.getItemAt(0) is DataLayer){
				dataLayer = applicationData.layers.getItemAt(0) as DataLayer;		
				var sensor_portal_layer_group:PortalLayerGroup = new PortalLayerGroup();
				sensor_portal_layer_group.layerGroup = applicationData.layer_groups_collection.getItemAt(0) as LayerGroup;
				applicationData.portal.portalLayerGroups.addItem(sensor_portal_layer_group);
				handleDefaultSettings();
			
			}else{
				trace('how was the data layer added?');
			}
			
			
			
			
			//dispatcher.dispatchEvent(new LayerGroupEvent(LayerGroupEvent.LOAD_LAYER_GROUP,applicationData.layer_groups_collection.getItemAt(0) as LayerGroup));
			
			applicationData.loading = false;

		}
		
		/*
		override public function handleDefaultSettings():void{
			super.handleDefaultSettings();
			if(!url_arguments.hasOwnProperty(ApplicationStateArguments.BOUNDS)){
				var m:Map = (mapData.map as GoogleMap).map;
				var geocoder:ClientGeocoder = new ClientGeocoder(new ClientGeocoderOptions({
					countryCode:'US',
					viewPort:m.getLatLngBounds()
				}));
					
				
				
			}
		}
		*/
		
		
	}
}