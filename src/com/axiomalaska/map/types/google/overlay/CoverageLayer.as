package com.axiomalaska.map.types.google.overlay
{
	import com.axiomalaska.map.types.google.overlay.WMS.WMSOverlay;
	import com.axiomalaska.models.LayerGroup;
	import com.axiomalaska.models.sensors.Sensor;
	import com.google.maps.LatLng;
	import com.google.maps.LatLngBounds;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.events.ResultEvent;

	[Bindable]
	[RemoteClass(alias="MapAssets.CoverageLayer")]
	public class CoverageLayer
	{
		
		public var CatalogControlJSObject:String;	
		public var CF:String;	
		public var ComplexSymbology:Boolean;	
		public var Coverage:Boolean;
		public var DataURL:String;	
		public var DateProperty:String;
		public var DatePropertyUpper:String;
		public var DatePropertyLower:String;
		public var DontUseGwc:Boolean;	
		public var DynamicLegendURL:String;
		public var SupportsGetLegendGraphic:String;

		public var EPSG:Number;
		public var extentNeLat:Number;	
		public var extentNeLng:Number;	
		public var extentSwLat:Number;	
		public var extentSwLng:Number;	
		public var HasPeriods:Boolean;	
		public var HasSLD:Boolean;
		public var LayerDescription:String;	
		public var LayerID:String;
		public var old_id:String;
		public var LayerGroupID:String;
		public var LayerLabel:String;
		public var LayerName:String;
		public var LayerNameSpace:String;
		public var LegendURL:String;	
		public var MetadataURL:String;
		public var NumSensorStations:int;
		public var SensorID:String;
		public var Style:String;
		public var useCFC:Boolean;
		public var units:String;
		public var version:String;
		public var wmsUrl:String;
		public var zIndex:int;
		
		public var SourceLogo:String;
		public var TimeSeries:Boolean;
		
		//public var cfcUrl:String;	
		//public var EndDateTime:Date;
		//public var gwcUrl:String;	
		//public var SourceLogo:String;	
		//public var StartDateTime:Date;
		//public var TimeSeries:Boolean;
		//public var wfsUrl:String;
		
		public var virtualSensorEnabled:Boolean = true;
		public var ParameterID:String;
		public var sensor:Sensor;
		
		public var elevations:Array;
		public var periods:Array;
		public var periods_collection:ArrayCollection;
		public var layer_group:LayerGroup;
		
		public var akbounds:LatLngBounds = new LatLngBounds(new LatLng(45,-179),new LatLng(85,-130));

		
		public function CoverageLayer($obj:Object = null)
		{
			if($obj){
				for(var _p:String in $obj){
					if(_p in this){
						this[_p] = $obj[_p];
					}
				}
			}	
		}
		
		
		public function insertElevationsPeriodsServiceCall($evt:ResultEvent):void{
			if($evt.result.hasOwnProperty('PERIODS')){
				periods = [];
				//$evt.result.PERIODS.sort();
				for each(var t:Number in $evt.result.PERIODS){
					var d:Date = new Date();
					d.setTime(t * 1000);
					periods.push(d);
				}
				periods.sort(function($a:Date,$b:Date):int{
					if($a > $b){
						return 1;
					}else if($b > $a){
						return -1;
					}
					return 0;
				});
				var _src:Array = [];
				for each(var date:Date in periods){
					_src.push({date:date,value:10});
				}
				periods_collection = new ArrayCollection(_src);
				
			}
			if($evt.result.hasOwnProperty('PERIODS')){
				$evt.result.ELEVATIONS.sort();
				elevations = $evt.result.ELEVATIONS;
				elevations.sort(function($a:String,$b:String):int{
					var _a:Number = Number($a);
					var _b:Number = Number($b);
					if(_a > _b){
						return -1;
					}else if(_b > _a){
						return 1;
					}else{
						return 0;
					}
				});
			}

		}
		
		public function findPeriodIndexOfDate($date:Date):int{
			if(periods && periods.length > 0){
				var i:int = 0;
				for each(var d:Date in periods){
					if(d.toString() == $date.toString()){
						return i;
						break;
					}
					i ++;
				}
			}
			return -1;
		}
		
		public function getPreviewImageSource($maxWidth:Number, $maxHeight:Number, $date:Date = null,$elevation:Number = NaN):String{
			
			var layerName:String = '';
			if(this.LayerNameSpace){
				layerName += this.LayerNameSpace + ':';
			}
			layerName += this.LayerName;

			var params:Object = {};
			if($date){
				params.time = $date;
			}
			if($elevation){
				params.elevation= $elevation;
			}
			
			var wms:WMSOverlay = new WMSOverlay(this.LayerName + 'preview',this.wmsUrl,layerName,false,this.EPSG, params);
			var src:String;
			
			
			var bnds:LatLngBounds;
			
			
			if(this.hasExtent()){
				
				bnds = new LatLngBounds(
					new LatLng(extentSwLat,extentSwLng),new LatLng(extentNeLat,extentNeLng)
				);
			}else{
				bnds = akbounds;	
			}
				
			//var _lh:Number = extentNeLng - extentSwLng;
			//var _lw:Number = extentNeLat - extentSwLat;
			
			var _lh:Number = bnds.getNorthEast().distanceFrom(bnds.getNorthWest());
			var _lw:Number = bnds.getNorthEast().distanceFrom(bnds.getSouthEast());
			
			if(_lh < 1){
				bnds = akbounds;
				_lh = bnds.getNorthEast().distanceFrom(bnds.getNorthWest());
				_lw = bnds.getNorthEast().distanceFrom(bnds.getSouthEast());
				
			}
			
			var _ratio:Number = 1;
			if(_lh > _lw){
				_ratio = _lw / _lh;
			}else{
				_ratio = _lh / _lw;
			}
			
			var _w:Number = $maxWidth;
			var _h:Number = Math.floor($maxWidth * _ratio);
			
			if(_h > $maxHeight){
				_h = $maxHeight;
				_w = Math.floor(_ratio * $maxHeight);
			}


			
			src = wms.makeURLForBounds(bnds,NaN,'image/jpeg',_h,_w);
			//= wms.makeURLForBounds;
			
			
			return src;
			
			
		}
		
		public function hasExtent():Boolean{
			if(
				//(extentNeLat && extentNeLng && extentSwLat && extentSwLng) &&
				(!isNaN(this.extentNeLat) && !isNaN(this.extentNeLng) && !isNaN(this.extentSwLat) && !isNaN(this.extentSwLng)) &&
				(extentNeLat > 0 || extentNeLng > 0 || extentSwLat > 0 || extentSwLng > 0)
			){
				return true;
			}
			return false;
		}
		
		public function getClosestPeriodToNow($now:Date = null):int{
			if(!$now){
				$now = new Date;
				trace($now.toString());
			}
			
			var i:int = 0
			
			if(periods && periods.length > 0){
				for(i;i < periods.length; i ++){
					var date:Date = periods[i];
					if(date > $now){
						return i;
						break;
					}
				}
			}
			
			if(i > 0){
				i = i - 1;
			}
			
			return i;
		}
		
		
		public function getLayerLegend():String{
			var _str:String = '';
			
			if(SupportsGetLegendGraphic){
				_str += wmsUrl + '?Request=GetLegendGraphic';
				var ln:String = LayerName;
				if(LayerNameSpace){
					ln = LayerNameSpace + ':' + ln;
				}
				
				if(LayerNameSpace.match(/echam/i)){
					_str += '&LAYER=' + ln;
				}else{
					
					_str += '&LAYER=' + ln + '&SHOWLABEL=false&HORIZONTAL=true';
				}
				
			}else if(LegendURL){
				_str += LegendURL;
			}
			
			/*
			if(DynamicLegendURL){
				_str += DynamicLegendURL;
				if(LayerNameSpace.match(/echam/i)){
					_str += '&LAYER=' + LayerNameSpace + ':' + LayerName;
				}else{
					_str += '&SHOWLABEL=false&HORIZONTAL=true';
				}
			}else{
				_str += LegendURL;
			}
			*/

			return _str;
		}
	}
}