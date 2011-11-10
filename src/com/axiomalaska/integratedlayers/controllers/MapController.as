package com.axiomalaska.integratedlayers.controllers
{
	import com.axiomalaska.crks.dto.DataLayer;
	import com.axiomalaska.crks.dto.Layer;
	import com.axiomalaska.crks.dto.OgcLayer;
	import com.axiomalaska.crks.dto.RasterLayer;
	import com.axiomalaska.crks.dto.VectorLayer;
	import com.axiomalaska.crks.utilities.ApplicationState;
	import com.axiomalaska.crks.utilities.ApplicationStateArguments;
	import com.axiomalaska.integratedlayers.events.ApplicationEvent;
	import com.axiomalaska.integratedlayers.events.ApplicationStateEvent;
	import com.axiomalaska.integratedlayers.events.LayerEvent;
	import com.axiomalaska.integratedlayers.map.IntegratedGoogleLayer;
	import com.axiomalaska.integratedlayers.map.IntegratedGoogleMap;
	import com.axiomalaska.integratedlayers.map.IntegratedWMSGoogleLayer;
	import com.axiomalaska.integratedlayers.models.WMSGetInfoData;
	import com.axiomalaska.integratedlayers.models.presentation_data.ApplicationData;
	import com.axiomalaska.integratedlayers.models.presentation_data.LegendData;
	import com.axiomalaska.integratedlayers.models.presentation_data.MapData;
	import com.axiomalaska.integratedlayers.models.presentation_data.TimeData;
	import com.axiomalaska.integratedlayers.views.panels.data.download.WFSAreaDownloadPopup;
	import com.axiomalaska.map.LatLon;
	import com.axiomalaska.map.events.BoundingBoxEvent;
	import com.axiomalaska.map.interfaces.ILayer;
	import com.axiomalaska.map.interfaces.IMap;
	import com.axiomalaska.map.layers.LayerGroup;
	import com.axiomalaska.map.types.google.BoundingBoxLayer;
	import com.axiomalaska.map.types.google.GoogleLayer;
	import com.axiomalaska.map.types.google.GoogleMap;
	import com.axiomalaska.map.types.google.overlay.WMS.WMSOverlay;
	import com.axiomalaska.models.SpatialBounds;
	import com.google.maps.LatLng;
	import com.google.maps.LatLngBounds;
	import com.google.maps.MapMouseEvent;
	import com.google.maps.MapMoveEvent;
	import com.google.maps.interfaces.IOverlay;
	import com.google.maps.interfaces.IPane;
	import com.google.maps.overlays.OverlayBase;
	import com.google.maps.overlays.Polygon;
	import com.google.maps.overlays.TileLayerOverlay;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	
	
	public class MapController extends BaseController
	{
		
		public var map:IMap;
		public var pane:IPane;
		public var layer_dict:Object = {};

		
		[Inject("applicationData")]
		public var applicationData:ApplicationData;
		
		[Inject("timeController")]
		public var timeController:TimeController;
		
		[Inject("layersController")]
		public var layersController:LayersController;
		
		[Inject("legendData")]
		public var legendData:LegendData;
		
		[Inject("mapData")]
		public var mapData:MapData;
		
		[Inject("timeData")]
		public var timeData:TimeData;
		
		
		public function MapController()
		{
			super();
		}
		
		[EventHandler("AxiomMapEvent.AXIOM_MAP_ZOOM_COMPLETE")]
		public function onZoomComplete():void{
			
		}
		
		[EventHandler("AxiomMapEvent.AXIOM_MAP_READY", properties="map")]
		public function mapLoaded($map:IMap):void{
			map = $map;

			(map as GoogleMap).map.addEventListener(MapMoveEvent.MOVE_END,function($evt:MapMoveEvent):void{
				//trace('view changed..');
				var ap:ApplicationState = new ApplicationState();
				//ap.property = 'llz';
				//ap.value = (map as GoogleMap).map.getCenter().toString().replace(/\s+|\(|\)/g,'') + ',' + (map as GoogleMap).map.getZoom();
				ap.property = ApplicationStateArguments.BOUNDS;
				var ul:LatLng = (map as GoogleMap).map.fromViewportToLatLng(new Point(0,0));
				var lr:LatLng = (map as GoogleMap).map.fromViewportToLatLng(new Point((map as GoogleMap).width,(map as GoogleMap).height));
				var ext:LatLngBounds = new LatLngBounds(ul,lr);
				ap.value = ext.getSouth() + ApplicationStateArguments.VARIABLE_LIST_SEPERATOR + 
						ext.getWest() + ApplicationStateArguments.VARIABLE_LIST_SEPERATOR + 
						ext.getNorth() + ApplicationStateArguments.VARIABLE_LIST_SEPERATOR + 
						ext.getEast(); 
				//ap.value = ;
				dispatcher.dispatchEvent(new ApplicationStateEvent(ApplicationStateEvent.UPDATE_APPLICATION_STATE_PROPERTY,ap));
			});
			
			dispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.APPLICATION_READY));
			
		}
		
		//[EventHandler("MapZoomEvent.HIGHLIGHT_AND_ZOOM_TO_EXTENT", properties="bounds")]
		public function onZoomAndHighlight($bounds:SpatialBounds):void{
			//(map as GoogleMap).map.addOverlay(new Polygon([new LatLng(
			
		}
		
		/*
		private var tileLayersPending:Array = [];
		
		[EventHandler("AxiomLayerEvent.AXIOM_LAYER_START_TILE_LOAD", properties="layer")]
		public function onLayerStartTileLoad($layer:ILayer):void{
			mapData.tiles_loading = true;
			trace('MAP LOADING ON');
			if(tileLayersPending.indexOf($layer) < 0){
				tileLayersPending.push($layer);
			}
		}
		
		
		
		[EventHandler("AxiomLayerEvent.AXIOM_LAYER_END_TILE_LOAD", properties="layer")]
		public function onLayerEndTileLoad($layer:ILayer):void{
			if(tileLayersPending.indexOf($layer) >= 0){
				var ind:int = tileLayersPending.indexOf($layer);
				tileLayersPending.splice(ind,1);
			}
			
			if(tileLayersPending.length < 1){
				mapData.tiles_loading = false;
				trace('MAP LOADING STOPPED');
			}
		}
		*/

		
		[EventHandler("LayerEvent.LOAD_LAYER", properties="layer")]
		public function loadLayer($layer:Layer):void{
			var copy:int = $layer.id;
			var id:String = copy.toString();
			
			if(!map.getLayerByName(id)){
				if($layer is VectorLayer){
					dispatcher.dispatchEvent(new LayerEvent(LayerEvent.LOAD_VECTOR_LAYER,$layer));
				}else if($layer is DataLayer){
					dispatcher.dispatchEvent(new LayerEvent(LayerEvent.LOAD_DATA_LAYER,$layer));	
				}else if($layer is RasterLayer){
					dispatcher.dispatchEvent(new LayerEvent(LayerEvent.LOAD_RASTER_LAYER,$layer));
				}
			}
			
		}
		
		[EventHandler("LayerEvent.LOAD_STICKY_LAYER", properties="layer")]
		public function loadStickyLayer($layer:Layer):void{
			
		}
		
		
		
		[EventHandler("LayerEvent.UNLOAD_LAYER", properties="layer")]
		public function unloadLayer($layer:Layer):void{
			var copy:int = $layer.id;
			var id:String = copy.toString();
			var layer:ILayer = map.getLayerByName(id);
			//trace('UNLOAD LAYER ID = ' + id);
			map.removeLayer(layer);
			//timeController.resetTimeBar(a);
			if(applicationData.unregister_active_layer($layer)){
				timeController.resetTimeBar(applicationData.active_layers_collection.source);
				layersController.resetLayerStackingOrder();
				dispatcher.dispatchEvent(new LayerEvent(LayerEvent.LAYER_UNLOADED,$layer));
			}
			
		}
		


		
		
		
		
		
	}
}