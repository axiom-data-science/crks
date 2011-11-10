package com.axiomalaska.map.types.google
{
	import com.axiomalaska.map.BaseLayerType;
	import com.axiomalaska.map.events.AxiomMapEvent;
	import com.axiomalaska.map.interfaces.IControl;
	import com.axiomalaska.map.interfaces.ILatLon;
	import com.axiomalaska.map.interfaces.ILayer;
	import com.axiomalaska.map.interfaces.ILayerGroup;
	import com.axiomalaska.map.interfaces.IMap;
	import com.axiomalaska.map.interfaces.IMapFeature;
	import com.axiomalaska.map.interfaces.IPopUp;
	import com.axiomalaska.map.types.google.base_layers.*;
	import com.axiomalaska.map.types.google.controls.LatLonView;
	import com.axiomalaska.map.types.google.controls.MarqueeZoomControl;
	import com.axiomalaska.map.types.google.overlay.WMS.AlaskaCoastTileLayer;
	import com.axiomalaska.map.types.google.overlay.WMS.GinaTileLayer;
	import com.axiomalaska.map.types.google.overlay.WMS.Relief;
	import com.google.maps.LatLng;
	import com.google.maps.Map;
	import com.google.maps.MapEvent;
	import com.google.maps.MapMouseEvent;
	import com.google.maps.MapMoveEvent;
	import com.google.maps.MapType;
	import com.google.maps.MapZoomEvent;
	import com.google.maps.controls.NavigationControl;
	import com.google.maps.controls.NavigationControlOptions;
	import com.google.maps.controls.OverviewMapControl;
	import com.google.maps.controls.OverviewMapControlOptions;
	import com.google.maps.controls.PositionControl;
	import com.google.maps.controls.PositionControlOptions;
	import com.google.maps.controls.ScaleControl;
	import com.google.maps.controls.ZoomControl;
	import com.google.maps.interfaces.IControl;
	import com.google.maps.interfaces.IMapType;
	import com.google.maps.interfaces.IOverlay;
	import com.google.maps.interfaces.IPane;
	import com.google.maps.interfaces.IPaneManager;
	import com.google.maps.interfaces.ITileLayer;
	import com.google.maps.overlays.Marker;
	import com.google.maps.overlays.MarkerOptions;
	import com.google.maps.overlays.TileLayerOverlay;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayList;
	import mx.containers.Canvas;
	import mx.core.Container;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.events.ResizeEvent;
	import mx.formatters.NumberFormatter;
	
	import spark.components.BorderContainer;
	import spark.components.ComboBox;
	import spark.components.HGroup;
	import spark.components.Label;
	
	[Event(name="mapready", type="com.axiomalaska.map.events.AxiomMapEvent")]
	
	public class GoogleMap extends Canvas implements IMap
	{
		
		public var key:String;
		public var zoom:Number = 5;
		public var map:Map = new Map();
		public var controlsLayer:Canvas = new Canvas();
		public var mapLayer:UIComponent = new UIComponent();
		
		private var _center:String = '65,-150';//alaska
		public function set center($center:String):void{
			_center = $center;
			var ctr:Array = _center.split(',');
			if(is_ready){
				map.panTo(new LatLng(Number(ctr[0]),Number(ctr[1])));
			}
		}
		public function get center():String{
			return _center;
		}
		
		private var zc:ZoomControl;
		private var pc:PositionControl;
		private var nc:NavigationControl;
		private var omc:OverviewMapControl;
		
		public var include_overview_map:Boolean = true;
		public var include_lat_lon_viewer:Boolean = false;
		
		public var lat_lon_viewer:LatLonView = new LatLonView();
		public var base_layer_switcher:ComboBox = new ComboBox();
		
		private var is_ready:Boolean = false;
		
		public var toolbar:HGroup = new HGroup();
		
		private var _layers:Array = new Array();
		
		private var layerIdLookup:Object = new Object;
		private var googlePaneLookupByName:Object = new Object;
		
		private var BWBaseLayer:IMapType;
		private var AKCoastBaseLayer:IMapType;
		private var GINABaseLayer:IMapType;
		private var ReliefBaseLayer:IMapType;
		
		public var manager:IPaneManager;
		
		//use this to track which controls are active on map, that should be hidden for print view
		private var active_web_controls:Array = [];
		
		//default is black and white layer
		//public var maptype_index:int = 4;
		
		private var _base_layer:String = BaseLayerType.TERRAIN_BW;
		
		[Bindable]
		public function set base_layer($base_layer:String):void{
			_base_layer = $base_layer;
			setBaseLayer(_base_layer);
			
		}
		public function get base_layer():String{
			return _base_layer;
		}
		
		
		private var base_layer_map:Object = {};
		
		public function GoogleMap()
		{
			super();
			//map.version = '1.9';
			addElement(mapLayer);
			
			controlsLayer.percentHeight = 100;
			controlsLayer.percentWidth = 100;
			addElement(controlsLayer);
			
			toolbar.percentWidth = 100;
			toolbar.percentHeight = 100;
			toolbar.horizontalAlign = 'right';
			toolbar.paddingTop = 10;
			toolbar.paddingRight = 10;
			controlsLayer.addChild(toolbar);
			
			map.sensor = "false";
			this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);	
		}
		
		public function set layers($layers:Array):void{
			_layers = $layers;
		}
		public function get layers():Array{
			return _layers;
		}
		
		
		//prepare google map
		//possibly add this to interface or inherited map class
		private function onCreationComplete($evt:FlexEvent):void{
			
			
			
			map.key = key;
			map.width = this.width;
			map.height = this.height;
			mapLayer.addChild(map);
			map.addEventListener(MapEvent.MAP_READY,function($evt:MapEvent):void{onMapReady();});
			this.addEventListener(ResizeEvent.RESIZE, onResize);
			is_ready = true;
			//manager = map.getPaneManager();
		}
		
		
		
		
		//resize events.. probably should added to inheritable map class
		private function onResize($evt:ResizeEvent):void{
			map.width = this.width;
			map.height = this.height;
		}
		
		//google specific prep
		//manager allows us too create layers on map
		//center can't be set until after map is ready
		//dispatch custom event so all types of code can respond to map ready event
		public function onMapReady():void{
			manager = map.getPaneManager();			
			addControls();
			setBaseLayer(base_layer);
			if(center){
				var ctr:Array = center.split(",");
				if (ctr.length == 2) {
					map.setCenter(new LatLng(Number(ctr[0]), Number(ctr[1])),zoom);
					
				}
				
			}
			dispatchEvent(new AxiomMapEvent(AxiomMapEvent.AXIOM_MAP_READY,this));
			map.addEventListener(MapMoveEvent.MOVE_END,onMapMoveEnd);		
			map.addEventListener(MapZoomEvent.ZOOM_CHANGED,onMapZoomEnd);
			
		}
		
		private function onMapMoveEnd($evt:MapMoveEvent):void{
			dispatchEvent(new AxiomMapEvent(AxiomMapEvent.AXIOM_MAP_PAN_COMPLETE,this));
		}
		
		private function onMapZoomEnd($evt:MapZoomEvent):void{
			dispatchEvent(new AxiomMapEvent(AxiomMapEvent.AXIOM_MAP_ZOOM_COMPLETE,this));
		}
		
		public function addControls():void{
			map.enableScrollWheelZoom();
			map.enableContinuousZoom();
			map.addControl(new ScaleControl());
			
			if(!nc){
				nc = new NavigationControl(new NavigationControlOptions({hasScrollTrack:false}));	
			}
			map.addControl(nc);
			if(active_web_controls.indexOf(nc) < 0){
				active_web_controls.push(nc);
			}
			var mzc:MarqueeZoomControl = addMarqueeZoomControl();
			active_web_controls.push(mzc);
			
			//addOverviewMap();
			addBaseLayers();
			
		}
		
		public function hideControls():void{
			for each(var control:DisplayObject in active_web_controls){
				control.visible = false;
			}
		}
		
		public function showControls():void{
			for each(var control:DisplayObject in active_web_controls){
				control.visible = true;
			}
		}
		
		public function removeControls():void{
			map.removeControl(nc);
			removeOverviewMap();
		}
		
		public function addZoomControl():void{
			if(!zc){
				zc = new ZoomControl();
			}
			map.addControl(zc);
			
		}
		
		
		public function addMarqueeZoomControl():MarqueeZoomControl{
			var mzc:MarqueeZoomControl = new MarqueeZoomControl();
			map.addControl(mzc);
			return mzc;
		}
		
		public function removeZoomControl():void{
			map.removeControl(zc);
		}
		
		/*OVERVIEW MAP*/
		public function addOverviewMap():void{
			if(include_overview_map){
				if(!omc){
					var ops:OverviewMapControlOptions = new OverviewMapControlOptions();
					omc = new OverviewMapControl(ops);
				}
				map.addControl(omc);
			}

		}
		
		public function removeOverviewMap():void{
			map.removeControl(omc);
		}
		
		private function getKeyFromBaseLayer($base_layer:IMapType):String{
			var key:String;
			
			if($base_layer is AKCoastMapType){
				key = BaseLayerType.ALASKA_COAST;
			}else if($base_layer is BWMapType){
				key = BaseLayerType.TERRAIN_BW;
			}else if($base_layer is GINAMapType){
				key = BaseLayerType.GINA;
			}else if($base_layer is ReliefMapType){
				key = BaseLayerType.RELIEF;
			}else{
				var google_key:String = $base_layer.getName(true).toUpperCase();
				//trace(google_key);
				switch (google_key){
					case 'MAP':
						key = BaseLayerType.MAP;
						break;
					
					case 'SAT':
						key = BaseLayerType.SATELLITE;
						break;
						
					case 'HYB':
						key = BaseLayerType.HYBRID;
						break;
						
					case 'TER':
						key = BaseLayerType.TERRAIN;
						break;
						
					default:
						break;
					
				}
				
			}
			
			//trace('BASE LAYER KEY IS ' + key);
			
			return key;
		}
		
		public function setBaseLayer($base_layer:String = null):void{
			if($base_layer && base_layer_map.hasOwnProperty($base_layer) && map && map.isLoaded()){
				map.setMapType(base_layer_map[$base_layer]);
				_base_layer = $base_layer;
				base_layer_switcher.selectedItem = base_layer_map[base_layer];
			}
		}
		
		public function registerBaseLayer($base_layer:IMapType):void{
			base_layer_map[getKeyFromBaseLayer($base_layer)] = $base_layer;
		}
		
		public function findBaseLayer($base_layer:String):IMapType{
			var bl:IMapType;
			if(base_layer_map.hasOwnProperty($base_layer)){
				bl = base_layer_map[$base_layer] as IMapType;
			}
			return bl;
		}
		
		/*ADD BASE LAYERS*/
		public function addBaseLayers():void{

			//var BWTerrainType:IMapType = new MapType(MapType.PHYSICAL_MAP_TYPE.getTileLayers(),MapType.NORMAL_MAP_TYPE.getProjection(),'B&W Terrain');
			BWBaseLayer = new BWMapType(map);
			map.addMapType(BWBaseLayer);
			
			ReliefBaseLayer = new ReliefMapType();
			map.addMapType(ReliefBaseLayer);
			
			GINABaseLayer = new GINAMapType();
			map.addMapType(GINABaseLayer);
			
			AKCoastBaseLayer = new AKCoastMapType();
			map.addMapType(AKCoastBaseLayer);
			
			
			for each(var base_layer:IMapType in map.getMapTypes()){
				registerBaseLayer(base_layer);
			}
			
			
			addLatLonDisplay();
			addBaseLayerSwitcher();
		}
		/*
		public function removeBaseLayers():void{
			
		}
		*/
		
		/*LATLON DISPLAY*/
		public function addLatLonDisplay():void{
			
			map.addEventListener(MouseEvent.ROLL_OVER,activateLatLonDisplay);
			map.addEventListener(MouseEvent.MOUSE_OVER,activateLatLonDisplay);
			map.addEventListener(MouseEvent.ROLL_OUT,deActivateLatLonDisplay);
			
			function activateLatLonDisplay($evt:Event = null):void{
				if(!lat_lon_viewer.visible){
					map.addEventListener(MapMouseEvent.MOUSE_MOVE,showLatLonDisplay);
					lat_lon_viewer.visible = true;
				}
			}
			
			function deActivateLatLonDisplay($evt:Event = null):void{
				map.removeEventListener(MapMouseEvent.MOUSE_MOVE,showLatLonDisplay);
				clearLatLonDisplay();
			}
			
			function showLatLonDisplay($evt:MapMouseEvent):void{
				lat_lon_viewer.updateLatLng($evt.latLng);
			}
			
			function clearLatLonDisplay():void{
				lat_lon_viewer.visible = false;
			}
			
			lat_lon_viewer.visible = false;
			toolbar.addElement(lat_lon_viewer);
			
		}
		
		/*BASE LAYER CONTROL*/
		public function addBaseLayerSwitcher():void{
			//if(!toolbar){
				
				
				var _arr:Array = map.getMapTypes();
				base_layer_switcher.labelFunction = function($item:IMapType):String{
					return $item.getName();
				}

				base_layer_switcher.dataProvider = new ArrayList(_arr);//new ArrayList(['Demis','Gina']);
				if(_arr.indexOf(base_layer_map[base_layer]) >= 0){
					base_layer_switcher.selectedItem = base_layer_map[base_layer];
				}


				
				
				base_layer_switcher.addEventListener(Event.CHANGE,function($evt:Event):void{	
					//map.invalidateDisplayList();
					//map.setMapType(base_layer_switcher.selectedItem);
					setBaseLayer(getKeyFromBaseLayer(base_layer_switcher.selectedItem as IMapType));
					
					//maptype_index = base_layer_switcher.selectedIndex;
				});
				
				
				
				toolbar.addElement(base_layer_switcher);
				
				
				
			//}
		}
		
		
		public function switchBaseLayer($new_base_layer:String):void{
			if($new_base_layer == BaseLayerType.ALASKA_COAST){
				
			}
		}
		
		
		public function removeBaseLayerControl():void{
			
		}
		
		public function addPanControl():void{
			if(!pc){
				pc = new PositionControl(new PositionControlOptions({hasScrollTrack:true}));
			}
			//map.addControl(pc);
		}
		
		public function removePanControl():void{
			map.removeControl(pc);
		}
		
		public function addWheelControl():void{
			
		}
		
		public function removeWheelControl():void{
			
		}
		
		public function addPopUp($popup:IPopUp):void
		{
			//var marker:Marker = new Marker(
		}
		
		public function removePopUp($popup:IPopUp):void
		{
		}
		
		public function addLayerToGroup($layer:ILayer,$layer_group:ILayerGroup):Boolean{
			trace('NOT YET IMPLEMENTED IN BASE CLASS -- OVERRIDE ME');
			return false;
		}
		
		public function addLayer($layer:ILayer):Boolean
		{
			
			//GoogleLayer extends google's overlaybase class
			// - to access overlaybase-specific props/functions, we need to cast the object as our custom googlelayer class 
			// - (or overlaybase, but that would leave out any custom functionality added to googlelayer)
			
			var overlayBase:GoogleLayer;
			
			if(googlePaneLookupByName[$layer.name]){
				overlayBase = googlePaneLookupByName[$layer.name];
			}else{
				overlayBase = GoogleLayer($layer);
				layerIdLookup[overlayBase.id] = $layer.name;
			}
			
			if(layers.indexOf($layer) < 0){
				layers.push($layer);
			}
			
			if(!googlePaneLookupByName.hasOwnProperty($layer.name)){
				googlePaneLookupByName[$layer.name] = overlayBase;
			}
			
			//add it to the top by default
			var _layer_z:int = manager.paneCount;
			
			if(!isNaN($layer.zindex)){
				_layer_z = $layer.zindex;
				trace('HAS Z INDEX? ' + $layer.zindex);
			}else{
				trace('NO Z INDEX!! --> ' + _layer_z);
			}
			
			var pn:IPane = manager.createPane(_layer_z);
			pn.addOverlay(overlayBase);
			manager.placePaneAt(pn,_layer_z);
			
			return true;
		}
		
		public function removeLayer($layer:ILayer):Boolean
		{
			var _layer:GoogleLayer = googlePaneLookupByName[$layer.name];
			trace('trying to remove layer ' + _layer.name);
			if(layers.indexOf(_layer) >= 0){

				trace('removed layer ' + _layer.name);
				_layer.pane.visible = false;
				
				
				
				
				map.removeOverlay(_layer);
				layers.splice(layers.indexOf(_layer),1);

				_layer = null;
				
				return true;
			}
			return false;
			
		}
		
		public function getLayerByName($name:String):ILayer
		{
			return null;
		}
		
		public function resetLayerOrder():void{
			var _layersToReorder:Array = new Array();
			
			for each(var _l:GoogleLayer in layers){
				if(_l.pane){
					_layersToReorder.push(_l);
				}
			}
			
			_layersToReorder.sort(function($a:GoogleLayer,$b:GoogleLayer):int{
				if($a.zindex > $b.zindex){
					return 1;
				}else if($a.zindex < $b.zindex){
					return -1;
				}else{
					return 0;
				}
			});
			
			for each(var _layer:GoogleLayer in _layersToReorder){
				trace('PLACING ' + _layer.name + ' AT ' + _layer.zindex);
				manager.placePaneAt(_layer.pane,_layers.length - _layer.zindex);
			}
			
			
		}
		
		public function setCenter($latlong:ILatLon, $zoom:Number = NaN, $animate:Boolean=true):void
		{
			if(isNaN($zoom)){
				$zoom = map.getZoom();
			}
			
			var _ll:LatLng = new LatLng($latlong.latitude,$latlong.longitude);
			
			if($animate){
				map.panTo(_ll);
				if($zoom != map.getZoom()){
					map.setZoom($zoom,true);
				}
			}else{
				map.setCenter(_ll,$zoom);
			}
		}
		
		public function panTo($latlon:ILatLon):void
		{
			map.panTo(new LatLng($latlon.latitude,$latlon.longitude));
		}
	}
}