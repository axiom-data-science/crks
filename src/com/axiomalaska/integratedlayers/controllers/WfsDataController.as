package com.axiomalaska.integratedlayers.controllers
{
	import com.axiomalaska.integratedlayers.models.WFSRequest;
	import com.axiomalaska.integratedlayers.models.presentation_data.LegendData;
	import com.axiomalaska.integratedlayers.models.presentation_data.MapData;
	import com.axiomalaska.integratedlayers.models.presentation_data.TimeData;
	import com.axiomalaska.integratedlayers.services.ApplicationService;
	import com.axiomalaska.integratedlayers.services.WFSService;
	import com.axiomalaska.integratedlayers.views.panels.data.download.WFSAreaDownloadPopup;
	import com.axiomalaska.map.LatLon;
	import com.axiomalaska.map.events.BoundingBoxEvent;
	import com.axiomalaska.map.interfaces.IMap;
	import com.axiomalaska.map.layers.LayerGroup;
	import com.axiomalaska.map.types.google.BoundingBoxLayer;
	import com.axiomalaska.map.types.google.GoogleMap;
	import com.axiomalaska.models.SpatialBounds;
	import com.google.maps.LatLng;
	import com.google.maps.LatLngBounds;
	import com.google.maps.MapMouseEvent;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import mx.managers.CursorManager;
	import mx.rpc.events.ResultEvent;
	
	import org.swizframework.utils.services.ServiceHelper;

	public class WfsDataController extends BaseController
	{
		
		[Inject]
		public var serviceHelper:ServiceHelper;
		
		[Inject("wfsService")]
		public var wfsService:WFSService;
		
		[Inject("applicationService")]
		public var applicationService:ApplicationService;
		
		
		
		[Embed(source='E:/flex/AxiomMaps/src/assets/images/button_download_small.png')]
		private var downloadButton:Class;
		
		[Embed(source='E:/flex/AxiomMaps/src/assets/images/button_download_cursor.png')]
		private var cursor:Class;
		
		[Inject("mapData")]
		public var mapData:MapData;
		
		[Inject("timeData")]
		public var timeData:TimeData;
		
		[Inject("legendData")]
		public var legendData:LegendData;
		
		public var data_bounding_box:BoundingBoxLayer;
		
		private var map:IMap;
		
		
		private var bounding_box_layer_group:LayerGroup = new LayerGroup();
		
		public function WfsDataController()
		{
			super();
		}
		
		
		[EventHandler("AxiomMapEvent.AXIOM_MAP_READY", properties="map")]
		public function mapLoaded($map:IMap):void{
			map = $map;
			
			bounding_box_layer_group.zindex = 10000;
			bounding_box_layer_group.id= -10;
			
		}
		
		[EventHandler("WFSDataEvent.WFS_REQUEST_FEATURE_COUNT", properties="wfs_request")]
		public function getWFSFeatureCount($wfs_request:WFSRequest):void{
			trace('GOT IT');
			
			serviceHelper.executeServiceCall(applicationService.getWfsFeatureCount($wfs_request),onWfsFeatureCount,handleError,[$wfs_request]);
		}
		public function onWfsFeatureCount($evt:ResultEvent,$wfs_request:WFSRequest):void{
			var count:Number;
			if($evt.result is Number){
				count = $evt.result as Number;
			}
			
			if(count){
				$wfs_request.feature_count = count;
				if($wfs_request.feature_count > 20000 || $wfs_request.feature_count < 0){
					$wfs_request.state = 'error';
				}else{
					$wfs_request.state = 'valid';
				}
			}

			
			/*if($evt.result.hasOwnProperty('wddxPacket')){
				if($evt.result.wddxPacket.data.hasOwnProperty('string')){
					count = Number($evt.result.wddxPacket.data.string);
				}else if($evt.result.wddxPacket.data.hasOwnProperty('number')){
					count = $evt.result.wddxPacket.data.number;
				}
			}else if($evt.result.hasOwnProperty('FeatureCollection')){
				count = $evt.result.FeatureCollection.numberOfFeatures;
			}
			if(count){
				$wfs_request.feature_count = count;
				if($wfs_request.feature_count > 20000 || $wfs_request.feature_count < 0){
					$wfs_request.state = 'error';
				}else{
					$wfs_request.state = 'valid';
				}
			}*/
		}
		
		private var cursor_id:int;
		private function setCursor():void{
			cursor_id = CursorManager.setCursor(cursor,2,2,2);
		}
		private function removeCursor():void{
			CursorManager.removeCursor(cursor_id);
		}
		
		[EventHandler(event="BoundingBoxEvent.BOUNDING_BOX_MODE_START")]
		public function startBoundingBoxMode():void{
			//map.addLayerToGroup(data_bounding_box,bounding_box_layer_group);
			setCursor();
			if(!data_bounding_box){
				_makeBoundingBoxLayer();
			}
			(map as GoogleMap).map.addEventListener(MapMouseEvent.MOUSE_DOWN,onBoundsInit);
			
		}
		private function onBoundsInit($evt:MapMouseEvent):void{
			onBoundingBoxModeUnselect();
			dispatcher.dispatchEvent(new BoundingBoxEvent(BoundingBoxEvent.BOUNDING_BOX_DRAW_START,new LatLon($evt.latLng.lat(),$evt.latLng.lng())));
		}
		private function onBoundingBoxModeUnselect():void{
			if(data_bounding_box){
				data_bounding_box.clearBoundingBox();
				(map as GoogleMap).map.removeEventListener(MapMouseEvent.MOUSE_DOWN,onBoundsInit);
				map.removeLayer(data_bounding_box);
			}
		}
		
		
		[EventHandler(event="BoundingBoxEvent.BOUNDING_BOX_DRAW_START", properties="corner1")]
		public function startBoundingBox($corner1:LatLon):void{
			data_bounding_box.startBoundingBox($corner1);
		}
		
		private function _makeBoundingBoxLayer():void{
			data_bounding_box = new BoundingBoxLayer('bbox');
			
			
			var close:Sprite = new Sprite();
			close.graphics.beginFill(0x000000);
			close.graphics.drawRect(0,0,20,20);
			close.buttonMode = true;
			
			[Embed(source='E:/flex/AKNHP_Shared/src/aknhp/assets/images/close.png')]
			var closeButton:Class;
			var cl:Sprite = new Sprite();
			cl.addChild(new closeButton());
			cl.x = close.width/2 - cl.width/2;
			cl.y = close.height/2 - cl.height/2;
			
			close.addChild(cl);
			
			close.addEventListener(MouseEvent.CLICK,function($evt:MouseEvent):void{
				onBoundingBoxModeUnselect();
				mapData.bounding_box_mode = false;
				//map_data.boundsMode = false;
			});
			
			
			var download:Sprite = new Sprite();
			download.graphics.beginFill(0xFFFFFF,0);
			download.graphics.drawRect(0,0,110,20);
			download.graphics.beginFill(0x333333);
			download.graphics.drawRect(10,0,95,20);

			var dl:Sprite = new Sprite();
			
			var tf:TextField = new TextField();
			tf.autoSize = 'left';
			tf.multiline = false;
			tf.mouseEnabled = false;
			tf.selectable = false;
			tf.htmlText = '<font color="#FFFFFF" face="Arial" size="10">Download data</font>';
			tf.x = 22;
			dl.addChild(tf);
			dl.addChild(new downloadButton());
			
			//dl.x = cl.x - download.width - 5;
			//dl.y = cl.y;
			
			download.addChild(dl);
			
			download.addEventListener(MouseEvent.CLICK,function($evt:MouseEvent):void{
				var dl:WFSAreaDownloadPopup = new WFSAreaDownloadPopup();
				//var dl:DownloadBoundsPopup = new DownloadBoundsPopup();
				//dl.layername = MapData.geoserver_layer_namespace + ':' + LayerTypes.DOWNLOAD_LAYER;
				dl.spatial_bounds = mapData.wfs_download_bounds;
				if(timeData.time_bounds.startdate != timeData.time_bounds.enddate){
					dl.time_bounds = timeData.time_bounds;
				}
				//dl.layer_groups = legendData.vector_legend_items_collection;
				dl.setLayerGroups(legendData.vector_legend_items_collection);
				//dl.spatial_bounds.south_west = new LatLon(
				
				//dl.bounds = map_data.boundingBoxBounds;
				dl.open();
				
			});
			
			
			
			data_bounding_box.addTool(download);				
			data_bounding_box.addTool(close);
			//data_bounding_box.zindex = map_data.sticky_top_layers.length;
			
			map.addLayerToGroup(data_bounding_box,bounding_box_layer_group);
		}
		
		[EventHandler(event="BoundingBoxEvent.BOUNDING_BOX_DRAW_END", properties="corner1,corner2")]
		public function boundingBoxDone($corner1:LatLon,$corner2:LatLon):void{
			//trace('END DRAW!');
			removeCursor();
			var b:LatLngBounds = new LatLngBounds(new LatLng($corner1.latitude,$corner1.longitude),new LatLng($corner2.latitude,$corner2.longitude));
			var sb:SpatialBounds = new SpatialBounds();
			sb.south_west = new LatLon(b.getSouth(),b.getWest());
			sb.north_east = new LatLon(b.getNorth(),b.getEast());
			mapData.wfs_download_bounds = sb;
			/*var l:LatLng
			data_bounding_box.boundingBoxBounds = new LatLngBounds(new LatLng($corner1.latitude,$corner1.longitude),new LatLng($corner2.latitude,$corner2.longitude));
			dispatcher.dispatchEvent(new TrackingEvent(TrackingEvent.TRACK_ACTION,'AKEPIC','Map',
			'bounds - ((' + $corner1.latitude + ',' + $corner1.longitude + '),(' + $corner2.latitude + ',' + $corner2.longitude + '))')
			);
			_setLayersOrder();
			*/
		}
		
		[EventHandler(event="BoundingBoxEvent.BOUNDING_BOX_MODE_END")]
		public function endBoundingBoxMode():void{
			onBoundingBoxModeUnselect();
		}
		
	}
}