package com.axiomalaska.integratedlayers.controllers
{
	import com.axiomalaska.map.LatLon;
	import com.axiomalaska.map.interfaces.IMap;
	import com.axiomalaska.map.types.google.GoogleMap;
	import com.axiomalaska.models.MetaDataItem;
	import com.axiomalaska.models.ResultSet;
	import com.axiomalaska.models.Spatial;
	import com.axiomalaska.models.VariableType;
	import com.axiomalaska.crks.dto.RasterLayer;
	import com.google.maps.MapMouseEvent;
	import com.google.maps.overlays.Marker;
	import com.google.maps.overlays.MarkerOptions;
	
	import flash.display.DisplayObject;
	
	import com.axiomalaska.integratedlayers.models.VirtualSensorLocation;
	import com.axiomalaska.integratedlayers.models.VirtualSensorRequest;
	import com.axiomalaska.integratedlayers.models.presentation_data.ApplicationData;
	import com.axiomalaska.integratedlayers.models.presentation_data.MapData;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.managers.CursorManager;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectUtil;
	
	import org.swizframework.utils.services.ServiceHelper;
	
	import com.axiomalaska.integratedlayers.services.VirtualSensorService;
	
	import com.axiomalaska.integratedlayers.views.panels.data.layer_data.virtual_sensor.VirtualSensorDataPanel;

	public class VirtualSensorController extends BaseController
	{
		
		[Inject("applicationData")]
		public var applicationData:ApplicationData;
		
		[Inject("mapData")]
		public var mapData:MapData;
		
		[Inject("virtualSensorService")]
		public var virtualSensorService:VirtualSensorService;
		
		[Inject]
		public var serviceHelper:ServiceHelper;
		
		public var map:IMap;
		public var marker:Marker;
		
		[Embed(source="E:/flex/AxiomMaps/src/assets/images/virtual-sensor-marker-icon.png")]
		[Bindable]
		public var virtualSensorIcon:Class;
		
		[Embed(source="E:/flex/AxiomMaps/src/assets/images/virtual-sensor-cursor.png")]
		[Bindable]
		private var cursor:Class;
		
		[EventHandler("AxiomMapEvent.AXIOM_MAP_READY", properties="map")]
		public function mapLoaded($map:IMap):void{
			map = $map;
			
		}
		
		private var cursor_id:int;
		private function setCursor():void{
			cursor_id = CursorManager.setCursor(cursor);
		}
		private function removeCursor():void{
			CursorManager.removeCursor(cursor_id);
		}
		
		[EventHandler("VirtualSensorEvent.VIRTUAL_SENSOR_MODE_START")]
		public function virtualSensorModeStart():void{

			setCursor();
			mapData.virtual_sensor_mode = true;
			
			(map as GoogleMap).map.addEventListener(MapMouseEvent.CLICK,onVirtualSensorClick);
		}
		
		[EventHandler("VirtualSensorEvent.VIRTUAL_SENSOR_MODE_END")]
		public function virtualSensorModeEnd():void{
			removeCursor();
			(map as GoogleMap).map.removeEventListener(MapMouseEvent.CLICK,onVirtualSensorClick);
			mapData.virtual_sensor_mode = false;
		}
		
		[EventHandler("VirtualSensorEvent.VIRTUAL_SENSOR_REMOVE_SENSOR")]
		public function virtualSensorRemoveSensor():void{
			if(marker){
				(map as GoogleMap).map.removeOverlay(marker);
				marker = null;
			}
			applicationData.active_virtual_sensor = null;
			virtualSensorModeEnd();
			
		}
		
		
		[EventHandler("VirtualSensorEvent.VIRTUAL_SENSOR_REQUEST_DATA", properties="virtual_sensor_request")]
		public function virtualSensorRequestData($virtual_sensor_request:VirtualSensorRequest):void{
			var sp:Spatial = new Spatial();
			sp.latlon = $virtual_sensor_request.virtual_sensor_location.latlon;
			serviceHelper.executeServiceCall(virtualSensorService.getVirtualSensorData($virtual_sensor_request.layer.id,sp,null),onVirtualSensorDataReturn,handleError,[$virtual_sensor_request]);
		}
		public function onVirtualSensorDataReturn($evt:ResultEvent,$virtual_sensor_request:VirtualSensorRequest):void{
			var rs:ResultSet = $evt.result[0] as ResultSet;
			var coll:ArrayCollection = rs.collection;
			var namedKeysColl:ArrayCollection = new ArrayCollection();
			var timeCol:String;
			for each(var obj:Object in coll){
				var kobj:Object = {};
				for(var k:String in obj){
					var md:MetaDataItem = rs.data[k].metadata;
					var key:String = md.label + ' (' + md.unit + ')';
					
					kobj[key] = obj[k];

					if(md.dataType == VariableType.DATE){
						timeCol = key;
					}
				}
				namedKeysColl.addItem(kobj);
				
				
			}
			
			if(timeCol){
				var sort_field:SortField = new SortField(timeCol);
				var coll_sort:Sort = new Sort();
				coll_sort.fields = [sort_field];
				coll_sort.compareFunction = dateSort;
				namedKeysColl.sort = coll_sort;
				namedKeysColl.refresh();
			}else{
				trace('NO TIMECOL!');
			}
			
			$virtual_sensor_request.results = namedKeysColl;
			$virtual_sensor_request.result_set = rs;
			$virtual_sensor_request.loading = false;
		}
		
		private function dateSort($a:Object,$b:Object,fields:Array = null):int
		{
			//fnDtfParceFunct is a Date parse function avail in DownloadCode.
			var dateA:Date=$a[fields[0].name];
			var dateB:Date=$b[fields[0].name];
			return ObjectUtil.dateCompare(dateA, dateB);
			
		}
		
		
		private function onVirtualSensorClick($evt:MapMouseEvent):void{
			
			virtualSensorModeEnd();
			
			if(marker){
				marker.setLatLng($evt.latLng);
				
			}else{
				var mo:MarkerOptions = new MarkerOptions();
				mo.icon = new virtualSensorIcon();
				mo.draggable = true;
				marker = new Marker($evt.latLng,mo);
				marker.addEventListener(MapMouseEvent.DRAG_END,onVirtualSensorClick);
				(map as GoogleMap).map.addOverlay(marker);
			}
			
			
			(map as GoogleMap).map.panTo($evt.latLng);
			
			var v:VirtualSensorLocation = new VirtualSensorLocation();
			v.layers = [];
			for each(var rl:RasterLayer in applicationData.active_raster_layers_collection.source){
				if(rl.wmsUrl.match(/axiom/i)){
					v.layers.push(rl);
				}
			}
			v.latlon = new LatLon($evt.latLng.lat(),$evt.latLng.lng());
			applicationData.active_virtual_sensor = v;
			
			var view:VirtualSensorDataPanel = new VirtualSensorDataPanel();
			view.virtual_sensor_location = v;
			mapData.active_data_views.addItem(view);

			
		}
		
	}
}