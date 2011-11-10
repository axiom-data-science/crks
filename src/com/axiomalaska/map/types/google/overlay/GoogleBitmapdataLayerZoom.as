package com.axiomalaska.map.types.google.overlay
{
	/** 
	 By Jonathan Wagner : www.jonathanwagner.ca
	 
	 This class works by copying bitmapdata pixels to custom bitmapdata tiles using the fast copyPixels method,
	 bypassing the vector renderer. Keep in mind when using this and adding markers -do not- clone bitmapdata
	 if you can avoid it, instead pass in the same BitmapData reference each time.
	 
	 When markers are added, they are indexed into sectors, this allows the markers that need to be rendered
	 to be looked up rapidly. Rendering is done through a queue to avoid possible timeouts when dealing with
	 large amounts of markers. Depending on how much data you plan on handling you can modify the properties to make
	 it render faster.
	 
	 No Copyrights, but you can still send me money.
	 **/
	
	import com.axiomalaska.map.types.google.event.BitmapMarkerEvent;
	import com.google.maps.Copyright;
	import com.google.maps.CopyrightCollection;
	import com.google.maps.LatLng;
	import com.google.maps.LatLngBounds;
	import com.google.maps.Map;
	import com.google.maps.TileLayerBase;
	import com.google.maps.overlays.Polygon;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	public class GoogleBitmapdataLayerZoom extends TileLayerBase
	{
		private var _map:Map;
		private var _markersBitmapData:Array = [];
		
		private var _tiles:Array = [];
		private var _markerRegistry:Array;
		private var _dataMap:Object = {};
		private var _over:Sprite = new Sprite();
		private var _overlap:int = 5;
		
		public var markerRenderDelay:Number = 250;
		public var markerRenderCount:Number = 5000;
		
		private var dispatcher:EventDispatcher = new EventDispatcher();
		
		public function addMarker(marker:BitmapData, ll:LatLng, id:String, markerOffset:Point, data:Object,buffer:int = 5):void {
			//If the BitmapData is missing, it adds it to the list
			var bitmapIndex:int = _markersBitmapData.indexOf(marker);
			//trace('BMI ' + bitmapIndex);
			if(bitmapIndex == -1) {
				_markersBitmapData.push(marker);
				bitmapIndex = _markersBitmapData.length - 1;
			}
			registerMarker(bitmapIndex, ll, id, markerOffset, buffer, data);
		}
		
		//Registers and indexs the marker for later rendering
		public function registerMarker(index:int, ll:LatLng, id:String, markerOffset:Point, buffer:int, data:Object = null):void {
			var indexSectorLng:int = Math.round(ll.lng()+180);
			var indexSectorLat:int = Math.round(ll.lat()+90);
			
			//trace('ID = ' + id + ' // ISL ' + indexSectorLng + ' // ' + indexSectorLat);
			
			if(!_markerRegistry[indexSectorLat][indexSectorLng]) {
				_markerRegistry[indexSectorLat][indexSectorLng] = [];
			}
			
			_markerRegistry[indexSectorLat][indexSectorLng].push([index, ll, id, markerOffset, buffer, data]);
			//trace(indexSectorLat + ' x ' + indexSectorLng);
			//trace(index + ' == ' +  indexSectorLat + ' x ' + indexSectorLng + ' // ' + ll);
		}
		
		private function createIndex():void {
			_markerRegistry = new Array(181);
			
			for(var i:int = 0; i < _markerRegistry.length; i++) {
				_markerRegistry[i] = new Array(361);
			}
		}
		
		public function GoogleBitmapdataLayerZoom(map:Map):void {
			_map = map;
			
			createIndex();
			
			var bounds:LatLngBounds = new LatLngBounds(new LatLng(-90,-180),new LatLng(90,180))
			var copyright:Copyright = new Copyright("", bounds, 1, "");
			var cc:CopyrightCollection = new CopyrightCollection('');
			cc.addCopyright(copyright);
			
			_renderTimer.addEventListener(TimerEvent.TIMER, renderNext, false, 0, true);
			
			super(cc, 1, 14, 1);
		}
		
		/** Modify these values to increase or decrease rendering times. **/
		private var _renderTimer:Timer = new Timer(markerRenderDelay, 0); // Modify the delay to specify how long to wait between each render cycle
		private var _renderCount:int = markerRenderCount; // How many markers to render per tile, per cycle
		
		private function renderTile(rqi:RenderQueueItem):Boolean {
			var j:int;
			var k:int;
			
			var count:int = 0;
			
			var p:Point;
			var mbdata:BitmapData;
			
			//sort markerregistry here?
			
			for(var i:int = rqi.currentLatSector; i < rqi.endLatSector; i++) {
				for(j = rqi.currentLngSector; j < rqi.endLngSector; j++) {
					if(_markerRegistry[i] && _markerRegistry[i][j]) {
						
						/*
						_markerRegistry[i][j] = _markerRegistry[i][j].sort(function($a:Array,$b:Array):int{
							if($a[5].weight > $b[5].weight){
								return 1;
							}else if($b[5].weight > $a[5].weight){
								return -1;
							}else{
								return 0;
							}
						});
						*/
						
						//trace('---');
						
						for(k = rqi.lastPoint; k < _markerRegistry[i][j].length; k++) {
							//trace('W = ' + _markerRegistry[i][j][k][5].weight);
							if(count <= _renderCount) {
								
								p = _map.fromLatLngToPoint(_markerRegistry[i][j][k][1], rqi.tileZoom);
								mbdata = _markersBitmapData[ _markerRegistry[i][j][k][0]];//_markersBitmapData[0];
								rqi.tile.copyPixels(mbdata,new Rectangle(0,0,mbdata.width,mbdata.height), new Point(p.x-rqi.tilePoint.x*256+_markerRegistry[i][j][k][3].x, p.y-rqi.tilePoint.y*256+_markerRegistry[i][j][k][3].y),null,null,true);
								
								count += 1;
							} else if(count >= _renderCount) {
								rqi.currentLatSector = i;
								rqi.currentLngSector = j;
								rqi.lastPoint = k;
								return false;
							}
						}
						
						rqi.lastPoint = 0;
					}
					
					rqi.currentLngSector = rqi.startLngSector;
				}
			}
			
			_removeFromQueue.push(rqi);
			return true;
		}
		
		private function clearRenderQueue():void {
			
			for(var i:int = 0; i < _tiles.length; i++) {
				_tiles[i][1] = new Point(-1,-1);
			}
			
			_renderTimer.stop();
			_renderQueue = [];
			_removeFromQueue = [];
		}
		
		private function cleanTile(t:Bitmap):void {
			//When zoom is changed, wipe all data on current tiles
			t.bitmapData.fillRect(new Rectangle(0, 0, 256, 256), 0x00000000);
		}
		
		private var _renderQueue:Array = [];
		private var _removeFromQueue:Array = [];
		private function addToRenderQueue(t:Bitmap, arg0:Point, arg1:Number):void {
			var maxTiles:Number = Math.pow(2, arg1);
			
			var p1:LatLng = _map.fromPointToLatLng(new Point(arg0.x*256,arg0.y*256), _zoom, true);
			var p2:LatLng = _map.fromPointToLatLng(new Point((arg0.x+1)*256,(arg0.y+1)*256), _zoom, true);
			
			
			//The sectors need to over and under run to make sre the markers are not cut off at the tile edges
			var startLngSector:int = Math.max(0, Math.floor(p1.lng()+181) - _overlap);
			var endLngSector:int =  Math.min(362, Math.ceil(p2.lng()+181) + _overlap);
			
			var endLatSector:int = Math.min(180, Math.ceil(p1.lat()+90) + _overlap);
			var startLatSector:int =  Math.max(0, Math.floor(p2.lat()+90) - _overlap);
			
			var rqi:RenderQueueItem = new RenderQueueItem();
			rqi.tile = t.bitmapData;
			rqi.tilePoint = arg0;
			rqi.tileZoom = arg1;
			rqi.startLatSector = startLatSector;
			rqi.startLngSector = startLngSector;
			rqi.endLatSector = endLatSector;
			rqi.endLngSector = endLngSector;
			rqi.currentLatSector = startLatSector;
			rqi.currentLngSector = startLngSector;
			
			_renderQueue.push(rqi);
			
			if(!_renderTimer.running) {
				_renderTimer.start();
			}
		}
		
		private function renderNext(e:TimerEvent):void {
			for(var i:int = 0; i < _renderQueue.length; i++) {
				renderTile(_renderQueue[i]);
			}
			
			var j:int = 0;
			for(i = 0; i < _removeFromQueue.length; i++) {
				for(j = 0; j < _renderQueue.length; j++) {
					if(_renderQueue[j] == _removeFromQueue[i]) {
						_renderQueue.splice(j, 1);
						break;
					}
				}
			}
			
			_removeFromQueue = [];
			
			if(_renderQueue.length == 0) {
				_renderTimer.stop();
			}
		}
		
		private var _zoom:int = -1;
		public override function loadTile(arg0:Point, arg1:Number):DisplayObject {
			
			//trace(arg0 + ' --> ' + arg1);
			
			if(_zoom != arg1) {
				clearRenderQueue();
				_zoom = arg1;
			}
			
			for(var i:int = 0; i < _tiles.length; i++) {
				if(_tiles[i][1].x == arg0.x && _tiles[i][1].y == arg0.y && _tiles[i][2] == arg1 && !_tiles[i][0].parent) {
					return _tiles[i][0];
				}
			}
			
			var t:Bitmap;
			
			
			for(i = 0; i < _tiles.length; i++) {
				if(!_tiles[i][0].parent) {
					t = _tiles[i][0];    
					cleanTile(t);
					_tiles.splice(i, 1);
					_tiles.push([t, arg0, arg1]);
					break;
				}
			}
			
			if(!t) {
				t = new Bitmap(new BitmapData(256,256,true,0xFFFFFF));
				t.bitmapData.unlock();
				_tiles.push([t, arg0, arg1]);
			}
			
			addToRenderQueue(t, arg0, arg1);
			var s:Sprite = new Sprite;
			s.addChild(t);
			addSpriteCallback(s,arg0);
			s.mouseChildren = true;
			return s;
		}
		
		private function addSpriteCallback($s:Sprite,$pt:Point):void{
			

			var npt:Point = new Point($pt.x * $s.width - $s.width,$pt.y * $s.width - $s.width);

			var ll1:LatLng = _map.fromPointToLatLng(new Point($pt.x * $s.width,$pt.y * $s.height),_map.getZoom());
			var ll2:LatLng = _map.fromPointToLatLng(new Point($pt.x * $s.width + $s.width,$pt.y * $s.height + $s.height),_map.getZoom());
			
			_assignListeners($s,ll1,ll2);
			
		}
		
		private function _assignListeners($s:Sprite,$ll1:LatLng,$ll2:LatLng):void{
			
			var indexSectorLng1:int = Math.round($ll1.lng()+180);
			var indexSectorLat1:int = Math.round($ll1.lat()+90);
			
			var indexSectorLng2:int = Math.round($ll2.lng()+180);
			var indexSectorLat2:int = Math.round($ll2.lat()+90);
			
			/*
			var _p:Polygon = new Polygon([$ll1,new LatLng($ll1.lat(),$ll2.lng()),$ll2,new LatLng($ll2.lat(),$ll1.lng())]);
			_map.addOverlay(_p);
			_map.getPaneManager().placePaneAt(_p.pane,0);
			_p.visible = false;
			_p.addEventListener(MouseEvent.MOUSE_OUT,function($evt:MouseEvent):void{
				_p.visible = false;
			});	*/		
			
			//$s.graphics.clear();
			//$s.graphics.lineStyle(2,0x000000,0);
			//$s.graphics.beginFill(0xCCFF00,.5);
			//$s.graphics.drawRect(0,0,$s.width,$s.height);
			
			$s.addEventListener(MouseEvent.CLICK,function($evt:MouseEvent):void{

				var bm:Bitmap = $s.getChildAt(0) as Bitmap;
				var bmd:BitmapData = new BitmapData(256, 256);
				bmd.draw(bm.bitmapData);
				var color:int = bmd.getPixel($evt.localX,$evt.localY);
				
				if (color != 0xFFFFFF){
					
					var _mpt:Point = new Point($s.x + $evt.localX,$s.y + $evt.localY);
					var ll:LatLng = _map.fromViewportToLatLng(_mpt);
					
					var _sl:int = indexSectorLat1;
					var _rll:LatLng;
					var _candidates:Array = new Array();
					
					while(_sl >= indexSectorLat2){
						
						var _slng:int = indexSectorLng1;
						while(_slng <= indexSectorLng2){
							if(_markerRegistry[_sl][_slng]){
								_candidates.push(_markerRegistry[_sl][_slng]);
							}
							_slng ++;
						}
						_sl --;
					}
					
					var _nearest:Array;
					var _dist:Number;
					var _tc:int = 0;
					
					if(_candidates.length > 0){
						for each(var _pts:Array in _candidates){
							for each(var _ar:Array in _pts){
								_tc ++;
								if(!_nearest){
									_nearest = _ar;
									_dist =  getDist(_mpt,_map.fromLatLngToViewport(_ar[1]));
								}else if(getDist(_mpt,_map.fromLatLngToViewport(_ar[1])) < _dist){
									_dist =  getDist(_mpt,_map.fromLatLngToViewport(_ar[1]));
									_nearest = _ar;
								}
							}
						}
					}
					
					if(_nearest){
						var evt:Event = new BitmapMarkerEvent(BitmapMarkerEvent.MARKER_SELECT,_nearest[2]);
						_map.dispatchEvent(evt);
					}
					
				} 
				
			});
			
			$s.addEventListener(MouseEvent.MOUSE_MOVE,function($evt:MouseEvent):void{
				//trace('$PT = ' + $pt);
				
				var bm:Bitmap = $s.getChildAt(0) as Bitmap;
				var bmd:BitmapData = new BitmapData(256, 256);
				bmd.draw(bm.bitmapData);
				var color:int = bmd.getPixel($evt.localX,$evt.localY);
				
				if (color != 0xFFFFFF){
					
					$s.buttonMode=true;
					
					var _mpt:Point = new Point($s.x + $evt.localX,$s.y + $evt.localY);
					var ll:LatLng = _map.fromViewportToLatLng(_mpt);
					
					var _sl:int = indexSectorLat1;
					var _rll:LatLng;
					var _candidates:Array = new Array();
					
					while(_sl >= indexSectorLat2){
						
						var _slng:int = indexSectorLng1;
						while(_slng <= indexSectorLng2){
							if(_markerRegistry[_sl][_slng]){
								_candidates.push(_markerRegistry[_sl][_slng]);
							}
							_slng ++;
						}
						_sl --;
					}
					
					var _nearest:Array;
					var _dist:Number;
					var _tc:int = 0;
					
					if(_candidates.length > 0){
						for each(var _pts:Array in _candidates){
							for each(var _ar:Array in _pts){
								_tc ++;
								var _tempDist:Number = getDist(_mpt,_map.fromLatLngToViewport(_ar[1]));
								if(_tempDist < _ar[4]){
									if(!_nearest){
										_nearest = _ar;
										_dist =  _tempDist;
									}else if(getDist(_mpt,_map.fromLatLngToViewport(_ar[1])) < _dist){
										_dist =  _tempDist;
										_nearest = _ar;
									}
								}
							}
						}
					}
					
					
					if(_nearest){
						var _all:Array = _markerRegistry;
						//trace(indexSectorLat1 + ' // ' + indexSectorLat2);
						var evt:Event = new BitmapMarkerEvent(BitmapMarkerEvent.MARKER_OVER,_nearest[2],_markersBitmapData[_nearest[0]]);
						_map.dispatchEvent(evt);
					}else{
						var evt_oo:Event = new BitmapMarkerEvent(BitmapMarkerEvent.MARKER_OFF);
					}
					
				} else {
					var evt_o:Event = new BitmapMarkerEvent(BitmapMarkerEvent.MARKER_OFF);
					_map.dispatchEvent(evt_o);
					$s.buttonMode=false;
				}				
			});		
		}
		
		private function getDist($pt1:Point,$pt2:Point):Number{
			return Math.sqrt(Math.pow(Math.abs($pt1.x - $pt2.x),2) + Math.pow(Math.abs($pt1.y - $pt2.y),2));
		}
		
		
		
	}
	
}