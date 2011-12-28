package com.axiomalaska.map.types.google.overlay.WMS
{
	import com.axiomalaska.map.LatLon;
	import com.axiomalaska.map.interfaces.ILatLon;
	import com.axiomalaska.map.overlay.WMS;
	import com.axiomalaska.utilities.Style;
	import com.google.maps.CopyrightCollection;
	import com.google.maps.LatLng;
	import com.google.maps.LatLngBounds;
	import com.google.maps.Map;
	import com.google.maps.MapEvent;
	import com.google.maps.MapMoveEvent;
	import com.google.maps.MapType;
	import com.google.maps.TileLayerBase;
	import com.google.maps.interfaces.ICopyrightCollection;
	import com.google.maps.interfaces.IProjection;
	import com.google.maps.overlays.Polygon;
	import com.google.maps.overlays.PolygonOptions;
	import com.google.maps.styles.FillStyle;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.utils.Timer;
	
	import mx.controls.Alert;
	
	
	
	
	public class WMSOverlay extends TileLayerBase
	{
		
		private var loader:Loader;
		
		
		public var url:String;
		public var wmsCacheUrl:String;
		public var useGoogleStyleCache:Boolean = false;
		public var layerNames:String;
		public var epsg:Number;
		public var bounds:LatLngBounds;
		public var isBaseLayer:Boolean;
		public var params:Object = new Object();
		public var boundary_filter:Object;
		public var sld_style:Style;
		public var version:String = '1.1.1';
		public var format:String = 'image/png';
		public var bgcolor:String = '0xFFFFFF';
		public var filters:Array;
		public var transparent:Boolean = true;
		public var size:Number = 256;
		public var reaspect:Boolean = false;
		public var styles:String;
		public var time:Date;
		public var elevation:String;
		public var map:Map;
		public var alpha:Number;
		public var use_buffer:Boolean = false;
		public var dispatcher:Sprite = new Sprite();
		
		
		public var pendingTiles:Array = new Array();
		
		private var _name:String;
		public function set name($name:String):void{_name = $name;}
		public function get name():String{return _name;}
		
		
		public function WMSOverlay($name:String,$url:String,$layerNames:String = null,$isBaseLayer:Boolean = false,$epsg:Number = NaN,$params:Object = null)
		{
			
			var minResolution:Number = 1;
			var maxResolution:Number = 17;
			alpha = 1;
			
			name = $name;
			url = $url;
			epsg = $epsg;
			layerNames = $layerNames;
			
			if($params){
				params = $params;
			}
			for(var p:String in params){
				if(p in this){
					this[p] = params[p];
					delete(params[p]);
				}
			}
			
			if(map){
				map.addEventListener(MapEvent.TILES_LOADED,function($evt:MapEvent):void{
					//trace('TILES LOADED ' + $name);
					//onTilesLoaded();
					//pendingTiles = [];
				});
				map.addEventListener(MapEvent.VIEW_CHANGED,function($evt:MapEvent):void{
					trace('VIEW CHANGED ' + $name);
					//pendingTiles = [];
				});
				map.addEventListener(MapEvent.OVERLAY_ANIMATE_END,function($evt:MapEvent):void{
					trace('OVERLAY ANIMATE END ' + $name);
					//pendingTiles = [];
				});
				map.addEventListener(MapEvent.OVERLAY_MOVED,function($evt:MapEvent):void{
					trace('OVERLAY MOVED ' + $name);
					//pendingTiles = [];
				});
				map.addEventListener(MapEvent.OVERLAY_CHANGED,function($evt:MapEvent):void{
					trace('OVERLAY CHANGED ' + $name);
					//pendingTiles = [];
				});
				map.addEventListener(MapMoveEvent.MOVE_START,function($evt:MapMoveEvent):void{
					//trace('MAP MOVE!');
					//pendingTiles = [];
				});
			}
			
			Security.allowDomain('*');
			var sec_url:String = 'http://' + $url.replace('http://','').replace(/\/.*/,'') + '/crossdomain.xml';
			trace(sec_url);
			Security.loadPolicyFile(sec_url);
			//Security.loadPolicyFile('http://maps.axiomalaska.com/crossdomain.xml');
			
			
			var copyRightCollection:CopyrightCollection = new CopyrightCollection();
			//setupTimer();
			super(copyRightCollection);
			
			
		}
		
		public override function loadTile($tile:Point, $zoom:Number):DisplayObject{
			
			var doload:Boolean = true;
			if(bounds){
				var southWestPixel:Point = new Point(
					$tile.x * size
					,( $tile.y + 1 ) * size
				); 
				var northEastPixel:Point = new Point(
					( $tile.x + 1 ) * size
					, $tile.y * size
				); 		 
				
				
				var southWestCoords:ILatLon = pixelToLatLon(southWestPixel,$zoom);
				var northEastCoords:ILatLon = pixelToLatLon(northEastPixel,$zoom);
				
				var _bnds:LatLngBounds = new LatLngBounds(
					new LatLng(southWestCoords.latitude,southWestCoords.longitude),
					new LatLng(northEastCoords.latitude,northEastCoords.longitude)
				);				
				
				if(!bounds.intersects(_bnds)){
					doload = false;
				}
			}
			
			var l:Loader =  new Loader();
			
			if(doload){
				var url:String = makeURL($tile,$zoom);
				if(url != null){
					
					var high:int = 10;
					var low:int = 1;
					//url = url.replace('proxy.axiomalaska.com','proxy' + Math.floor(Math.random() * (0+9-0)) + '.axiomalaska.com');
					trace(url);
					addToPlaybackCache($tile,l);
					
					//trace('----> ' + url);
					
					var lc:LoaderContext = new LoaderContext();
					lc.checkPolicyFile = true;
					l.load(new URLRequest(url),lc);
				}
				
				//trace(makeURL($tile,$zoom));
				//pendingTiles.push(loader);
			}
			
			return l; 
		}
		

		
		private function addToPlaybackCache($tile:Point,$loader:Loader):void{
			
			
			
			var _tile:Point = new Point($tile.x,$tile.y);
			
			if(pendingTiles.length == 0){
				onTilesStartLoading();
			}
			
			//trace($loader.contentLoaderInfo.url);
			
			
			$loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler,false,0,true);
			$loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoaded);
			$loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS,httpStatusHandler);
			$loader.contentLoaderInfo.addEventListener(Event.OPEN,openHandler);
			
			
			//$loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			//$loader.contentLoaderInfo.addEventListener(Event.UNLOAD, unLoadHandler);

			

		}
		
		
		private function openHandler($evt:Event):void {
			if($evt.currentTarget.loader){
				pendingTiles.push($evt.currentTarget.loader);
			}
		}
		
		//pendingTiles.push($loader);
		
		private function progressHandler($evt:ProgressEvent):void{
			//trace(name + ": progressHandler: bytesLoaded=" + $loader.contentLoaderInfo.bytesLoaded + " bytesTotal=" + $loader.contentLoaderInfo.bytesTotal);
		}
		
		private function unLoadHandler(event:Event):void {
			//trace("unLoadHandler: " + event);
		}
		
		private function httpStatusHandler($evt:HTTPStatusEvent):void {
			//trace("httpStatusHandler: " + event + ' // ' + event.status + ' // ' + $loader.contentLoaderInfo.bytesTotal + ' => ' + $loader.contentLoaderInfo.bytesLoaded);
			
			var loader:Loader;
			if($evt.currentTarget.loader){
				loader = $evt.currentTarget.loader;
			}
			
			if(loader){
				if(loader.contentLoaderInfo.bytesTotal == loader.contentLoaderInfo.bytesLoaded){
					var ind:int = pendingTiles.indexOf(loader);
					pendingTiles.splice(ind,1);
					checkDone();
					//trace('removing .. ' + $loader.contentLoaderInfo.url);
				}
			}
			//trace(event.status);
			
		}
		
		
		private function onLoaded($evt:Event):void{
			var loader:Loader;
			if($evt.currentTarget.loader){
				loader = $evt.currentTarget.loader;	
			}
			if(loader){
				
				for each(var al:Loader in pendingTiles){
					if(al.contentLoaderInfo.bytesTotal < 1){
						var alInd:int = pendingTiles.indexOf(al);
						pendingTiles.splice(alInd,al);
						checkDone();
					}
				}
				
				
				if(pendingTiles.indexOf(loader) >= 0){
					var ind:int = pendingTiles.indexOf(loader);
					pendingTiles.splice(ind,1);
					checkDone();
					
				}else{
					trace(loader + ' NOT IN PENDING LAYERS ARRAY!');
				}
			}
		}
		
		private function checkDone():void{
			if(pendingTiles.length < 1){
				onTilesLoaded();
			}
		}
		
		/*
		private var timer:Timer = new Timer(100);
		private function setupTimer():void{
			timer.addEventListener(TimerEvent.TIMER,checkTiles);
		}
		private function startTileWatcher():void{
			timer.start();
		}
		
		private function checkTiles($evt:TimerEvent = null):void{
			for each(var loader:Loader in pendingTiles){
				if(loader.contentLoaderInfo.bytesLoaded == loader.contentLoaderInfo.bytesTotal){
					var ind:int = pendingTiles.indexOf(loader);
					pendingTiles.splice(ind,1);
				}
			}
			
			if(pendingTiles.length < 1){
				onTilesLoaded();
			}
		}
		
		private function endTileWatcher():void{
			timer.stop();
			pendingTiles = [];
		}
		*/
		
		private function onTilesStartLoading():void{
			dispatcher.dispatchEvent(new Event(Event.CHANGE));
			//startTileWatcher();
		}
		
		private function onTilesLoaded():void{
			//endTileWatcher();
			pendingTiles = [];
			dispatcher.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/*
		private function _makeWmsUrl($tile:Point, $zoom:Number):String{
			var _url:String = '';
			return _url;
		}
		
		private function _makeWmsCacheUrl($tile:Point, $zoom:Number):String{
			var _url:String = '';
			return _url;
			
		}
		*/
		
		public function makeURLForBounds($bounds:LatLngBounds,$size:Number = NaN,$format:String=null,$height:Number = NaN,$width:Number = NaN):String{
			
			
			var _useCache:Boolean = false;
			
			if(useGoogleStyleCache){
				_useCache = true;
			}
			
			if(isNaN($size)){
				$size = size;
			}
			
			var _width:Number = $size;
			var _height:Number = $size;
			
			if(!isNaN($width)){
				_width = $width;
			}
			
			if(!isNaN($height)){
				_height = $height;
			}
			
			var _trans:Boolean = transparent;
			if(!$format){
				$format = format;
			}
			
			var wmsURL:String;
			
			if(wmsCacheUrl){
				wmsURL = wmsCacheUrl;
			}else{
				wmsURL = url;
			}
			
			if(!wmsURL.match(/\?/)){
				wmsURL += '?';
			}else{
				wmsURL += '&';
			}
			
			//wmsURL += 'method=wms&';
			if(!_useCache){
				wmsURL += 'REQUEST=GetMap&';
				wmsURL += 'SERVICE=WMS&';
				wmsURL += 'VERSION=' + version + '&';
			}
			wmsURL += 'LAYERS=' + layerNames + '&';
			wmsURL += 'FORMAT=' + $format + '&';
			wmsURL += 'BGCOLOR=' + bgcolor + '&';
			if(!$format.match(/jpeg/)){
				wmsURL += 'TRANSPARENT=' + String(transparent).toUpperCase() + '&';
			}
			//wmsURL += 'SRS=EPSG:' + epsg + '&';
			wmsURL += 'SRS=EPSG:4326&';
			wmsURL += 'BBOX=' + getBoundingBoxStringFromBounds($bounds) + '&';
			wmsURL += 'WIDTH=' + _width + '&';
			wmsURL += 'HEIGHT=' + _height + '&';
			wmsURL += 'REASPECT=' + reaspect + '&';
			
			if(!_useCache){
				if(styles){
					wmsURL += 'STYLES=' + styles + '&';
				}else{
					wmsURL += 'STYLES=&';
				}
			}
			
			if(time){
				wmsURL += 'TIME=' + _makeTimeString(time) + '&';
			}
			
			if(elevation){
				wmsURL += 'ELEVATION=' + elevation;
			}
			//wmsURL += 'depth=' + depth + '&';
			
			for(var p:String in params){
				wmsURL += '&' + p.toUpperCase() + '=' + params[p] + '&';
			}
			if(wmsCacheUrl){
				wmsURL += '&tiled=true'
			}
			//trace(wmsURL);
			return wmsURL;
			
		}
		
		private function padStr($str:String):String{
			if($str.length < 2){
				return '0' + $str;
			}
			return $str;
		}
		
		private function _makeTimeString($date:Date):String{
			//wmsURL += 'time=' + time.fullYear + '-' + time.getMonth() + '-' + time.dateUTC + 'T' + time.hoursUTC + ':' + time.minutesUTC + ':' + time.secondsUTC + 'Z';
			var y:String = String($date.fullYearUTC);
			var m:String = padStr(String($date.monthUTC + 1));
			var d:String = padStr(String($date.dateUTC));
			var h:String = padStr(String($date.hoursUTC));
			var min:String = padStr(String($date.minutesUTC));
			var s:String = padStr(String($date.secondsUTC))
			var str:String = y +'-' + m + '-' + d + 'T' + h + ':' + min + ':' + s + 'Z';
			return str;
		}
		
		public function makeURL($tile:Point,$zoom:Number):String{
			//trace($tile + ' ' + $zoom);
			
			var _useCache:Boolean = false;
			
			if(useGoogleStyleCache){
				_useCache = true;
			}

			
			var wmsURL:String;
			
			if(wmsCacheUrl){
				wmsURL = wmsCacheUrl;
			}else{
				wmsURL = url;
			}
			
			
			if(!wmsURL.match(/\?/)){
				wmsURL += '?';
			}else{
				wmsURL += '&';
			}
			
			//wmsURL += 'method=wms&';
			
			if(_useCache){
				wmsURL += 'x=' + $tile.x + '&y=' + $tile.y + '&zoom=' + $zoom + '&';
			}
			
			if(!_useCache){
				wmsURL += 'REQUEST=GetMap&';
				wmsURL += 'SERVICE=WMS&';
				wmsURL += 'VERSION=1.1.1&';
			}
			wmsURL += 'LAYERS=' + layerNames + '&';
			wmsURL += 'FORMAT=' + format + '&';
			wmsURL += 'BGCOLOR=' + bgcolor + '&';
			wmsURL += 'TRANSPARENT=' + String(transparent).toUpperCase() + '&';
			wmsURL += 'SRS=EPSG:' + epsg + '&';
			
			if(!_useCache){
				wmsURL += 'BBOX=' + getBoundingBoxString($tile,$zoom) + '&';
				wmsURL += 'WIDTH=' + size + '&';
				wmsURL += 'HEIGHT=' + size + '&';
				wmsURL += 'REASPECT=' + reaspect + '&';
				
				
				if(styles){
					wmsURL += 'STYLES=' + styles + '&';
				}else{
					wmsURL += 'STYLES=&';
				}
			}

			if(time){
				wmsURL += 'TIME=' + _makeTimeString(time) + '&';
			}
			
			if(elevation){
				wmsURL += 'ELEVATION=' + elevation;
			}
			

			
			//wmsURL += 'depth=' + depth + '&';
			
			for(var p:String in params){
				wmsURL += '&' + p.toUpperCase() + '=' + params[p];
			}
			
			
			if(boundary_filter){
				wmsURL += '&FILTER=' + _makeOGCFilter([boundary_filter])
			}
			
			if(filters){
				wmsURL += '&FILTER=' + _makeOGCFilter(filters);
			}
			
			
			if(wmsCacheUrl){
				wmsURL += '&tiled=true'
			}
			
			if(sld_style){
				
				
				
				var _style_str:String = '<StyledLayerDescriptor version="1.0.0" xsi:schemaLocation="http://www.opengis.net/sld StyledLayerDescriptor.xsd" ' +
					'xmlns="http://www.opengis.net/sld" xmlns:ogc="http://www.opengis.net/ogc" xmlns:xlink="http://www.w3.org/1999/xlink" ' + 
					'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">' + 
					'<NamedLayer>' +
					'<Name>' + layerNames + '</Name>' + 
					'<UserStyle>';
				
				_style_str += '<FeatureTypeStyle><Rule>' ; 
				
				if(sld_style.hasPolygonStyle()){
					
					_style_str += '<PolygonSymbolizer>';
					
					if(sld_style.polygon_fill_color || sld_style.polygon_fill_alpha){
						_style_str += '<Fill>';
						if(sld_style.polygon_fill_color){
							_style_str += '<CssParameter name="fill">' + sld_style.polygon_fill_color + '</CssParameter>';
						}
						if(sld_style.polygon_fill_alpha){
							_style_str += '<CssParameter name="fill-opacity">' + sld_style.polygon_fill_alpha + '</CssParameter>';
						}
						_style_str += '</Fill>';
					}
					
					if(sld_style.polygon_stroke_color || sld_style.polygon_stroke_size){
						_style_str += '<Stroke>';
						if(sld_style.polygon_stroke_color){
							_style_str += '<CssParameter name="stroke">' + sld_style.polygon_stroke_color + '</CssParameter>';
						}
						if(sld_style.polygon_stroke_size){
							_style_str += '<CssParameter name="stroke-width">' + sld_style.polygon_stroke_size + '</CssParameter>';	
						}
						_style_str += '</Stroke>';
					}
					
					
					
					_style_str += '</PolygonSymbolizer>';
				}
				
				
				if(sld_style.hasPointStyle()){
					
					
					_style_str += '<PointSymbolizer>' +
						'<Graphic>' + 
						'<Mark>' +
						'<WellKnownName>' + sld_style.point_shape + '</WellKnownName>';
					
					if(sld_style.point_fill_color){
						_style_str +=  '<Fill>';
						_style_str += '<CssParameter name="fill">' + sld_style.point_fill_color + '</CssParameter>';
						if(sld_style.point_fill_alpha){
							_style_str += '<CssParameter name="fill-opacity">' + sld_style.point_fill_alpha + '</CssParameter>';
						}
						_style_str += '</Fill>';
					}
					
	
				
					if(sld_style.point_stroke_color || sld_style.point_stroke_color){
						_style_str += '<Stroke>';
						if(sld_style.point_stroke_color){
							_style_str += '<CssParameter name="stroke">' + sld_style.point_stroke_color + '</CssParameter>';
						}
						if(sld_style.point_stroke_size){
							_style_str += '<CssParameter name="stroke-width">' + sld_style.point_stroke_size + '</CssParameter>';
						}
						_style_str += '</Stroke>';
					}
					
					_style_str +='</Mark>';
					
					if(sld_style.point_size){
						_style_str += '<Size>' + sld_style.point_size + '</Size>';
					}
						
					_style_str += '</Graphic>' +
						'</PointSymbolizer>';
				}
				
				
				
				_style_str += '</Rule></FeatureTypeStyle>';
				
				_style_str += '</UserStyle>' +
					'</NamedLayer>' + 
					'</StyledLayerDescriptor>';
			
				
				wmsURL += '&SLD_BODY=' + _style_str;
				
				//wmsURL += '&SLD=http://localhost:8090/data.aoos.org/test.xml';
				
			}
			
			wmsURL = wmsURL.replace(/&&/,'&');
			
			
			//trace('---->' + wmsURL);
			return wmsURL;
		}
		
		
		private function _makeOGCFilter($filters:Array):String{
			
			var _str:String = '<Filter xmlns="http%3A//www.opengis.net/ogc">';
			
			if($filters.length > 1){
				_str += '<And>';
			}
			
			for each(var filter:Object in $filters){
				
				//backward compatibility
				if(filter.hasOwnProperty('name') && !filter.hasOwnProperty('property')){
					filter.property = filter.name;
				}
				
				if(filter.hasOwnProperty('property')){
					if(filter.property.toLowerCase() == 'bbox'){
						
						_str += '<BBox>';
						_str += '<PropertyName>the_geom</PropertyName>';
						_str += '<Box>';
						_str += '<coordinates>' +  filter.swLat + ',' + filter.swLng + ' ' + filter.neLat + ',' + filter.neLng + '</coordinates>';
						_str += '</Box>';
						_str += '</BBox>';
						
					}else if(filter.property.match(/date/i) || (filter.hasOwnProperty('type') && (filter.type == 'timeFilter')) ){
					//if(filter.hasOwnProperty('upper') && filter.hasOwnProperty('lower')){
						
						var lower:String = _makeTimeString(filter.lower);
						var upper:String = _makeTimeString(filter.upper);
						
						//hack for cases where the date bounds there's a max date property and a min date property
						if(filter.hasOwnProperty('upper_property') && filter.hasOwnProperty('lower_property')){
							
							
							if($filters.length <= 1){
								_str += '<And>';
							}
							
							_str += '<PropertyIsGreaterThan>';
							_str += '<PropertyName>' + filter.lower_property + '</PropertyName>';
							_str += '<Literal>' + lower + '</Literal>';
							_str += '</PropertyIsGreaterThan>';
							
							_str += '<PropertyIsLessThan>';
							_str += '<PropertyName>' + filter.upper_property + '</PropertyName>';
							_str += '<Literal>' + upper + '</Literal>';
							_str += '</PropertyIsLessThan>';
							
							if($filters.length <= 1){
								_str += '</And>';
							}
							
						}else{


							_str += '<PropertyIsBetween>';
							_str += '<PropertyName>' + filter.property + '</PropertyName>';
							_str += '<LowerBoundary><Literal>' + lower + '</Literal></LowerBoundary>';
							_str += '<UpperBoundary><Literal>' + upper + '</Literal></UpperBoundary>';
							_str += '</PropertyIsBetween>';
							
						}
						
						
					}else if(filter.hasOwnProperty('value')){
						_str += '<PropertyIsEqualTo>';
						_str += '<PropertyName>' + filter.property + '</PropertyName>';
						_str += '<Literal>' + filter.value + '</Literal>';
						_str += '</PropertyIsEqualTo>';
					}
				}
			}
			
			if($filters.length > 1){
				_str += '</And>';
			}
			
			_str += '</Filter>';
			
			return _str;
			
			
		}
	
		
		public function getBoundingBoxString($tilePosition:Point, $zoom:Number):String
		{
			
			var fauxZoom:Number = $zoom - ( size / 256 ) + 1;
			
			var bbox:String;
			
			//trace('I GOT CALLED');
			
			switch(epsg ){
				case 3857:
				case 900913:
					//trace('TP = ' + $tilePosition);
					var initialResolution:Number = 2 * Math.PI * 6378137 / size;  // == 156543.0339 for 256
					var res:Number = initialResolution / ( 1 << fauxZoom );
					var originShift:Number = Math.PI * 6378137; // == 20037508.34
					
					
					//trace('layer res = ' + res);
					//trace('the math: ' + initialResolution + '/ ( 1 <<' +  fauxZoom + ' )');
					
					$tilePosition.y = (( 1 << fauxZoom ) - $tilePosition.y - 1); // TMS
					
					//trace('Y = ' + $tilePosition.y);
					
					bbox = [
						($tilePosition.x * size * res - originShift)
						,($tilePosition.y * size * res - originShift)
						,(($tilePosition.x + 1) * size * res - originShift)
						,(($tilePosition.y + 1) * size * res - originShift)
					].join(',');
					
					//trace('-->' + bbox);
					
					
					break;
				
				case 4326:
					var southWestPixel:Point = new Point(
						$tilePosition.x * size
						,( $tilePosition.y + 1 ) * size
					); 
					var northEastPixel:Point = new Point(
						( $tilePosition.x + 1 ) * size
						, $tilePosition.y * size
					); 		 
					
					var southWestCoords:ILatLon = pixelToLatLon(southWestPixel,$zoom);
					var northEastCoords:ILatLon = pixelToLatLon(northEastPixel,$zoom);	 
					
					bbox = [
						southWestCoords.longitude
						,southWestCoords.latitude
						,northEastCoords.longitude
						,northEastCoords.latitude
					].join(',');
					break;
				default:
					bbox = [
						0
						,0
						,0
						,0
					].join(',');  						
					break;
			}
			
			if(use_buffer){
				bbox += '&BUFFER=' + size * Math.pow(2,$zoom);
				//trace(bbox);
			}
			
			
			return bbox;
				
		}
		
		
		public function getBoundingBoxStringFromBounds($bounds:LatLngBounds,$size:Number = NaN):String{
			
			if(isNaN($size)){
				$size = size;
			}
			
			//var fauxZoom:Number = $zoom - ( size / 256 ) + 1;
			
			var bbox:String;
			
			var _epsg:Number = 4326;
			
			switch(_epsg ){
				case 3857:
				case 900913:			
					
					
					
					/*var initialResolution:Number = 2 * Math.PI * 6378137 / size;  // == 156543.0339 for 256
					var res:Number = initialResolution / ( 1 << fauxZoom );
					var originShift:Number = Math.PI * 6378137; // == 20037508.34
					
					$tilePosition.y = (( 1 << fauxZoom ) - $tilePosition.y - 1); // TMS
					
					bbox = [
						($tilePosition.x * size * res - originShift)
						,($tilePosition.y * size * res - originShift)
						,(($tilePosition.x + 1) * $size * res - originShift)
						,(($tilePosition.y + 1) * $size * res - originShift)
					].join(',');  			
					break;*/
					break;
				
				case 4326:
					var swlng:Number = $bounds.getSouthWest().lng();
					var swlat:Number = $bounds.getSouthWest().lat();
					var nelng:Number = $bounds.getNorthEast().lng();
					var nelat:Number = $bounds.getNorthEast().lat();
					
					//for cases where the tile crosses the dateline
					if(swlng > 0 && nelng < 0){
						swlng = -180 - (180 - swlng);
					}
	 
					bbox = [
						swlng,//southWestCoords.longitude
						swlat,//,southWestCoords.latitude
						nelng,//,northEastCoords.longitude
						nelat
					].join(',');
					break;
				
				default:
					bbox = [
						0
						,0
						,0
						,0
					].join(',');  						
					break;
			}
			return bbox;
			
			
		}
		
		private function pixelToLatLon($point:Point,$zoom:Number):ILatLon{
			//var projection:IProjection = MapType.NORMAL_MAP_TYPE.getProjection();
			var coords:LatLng = map.fromPointToLatLng($point,$zoom);
			//var coords:LatLng = getMapType().getProjection().fromPixelToLatLng($point,$zoom);
			//var coords:LatLng = projection.fromPixelToLatLng($point,$zoom,true);
			var ll:LatLon = new LatLon(coords.lat(),coords.lng());
			return ll;
		}
		
		public function ioErrorHandler($evt:IOErrorEvent):void {
			trace("WMSOverlay: IO Error !", $evt.text)
		}
		
		
	}
}
