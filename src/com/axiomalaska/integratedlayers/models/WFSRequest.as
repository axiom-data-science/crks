package com.axiomalaska.integratedlayers.models
{
	import com.axiomalaska.crks.dto.Layer;
	import com.axiomalaska.crks.dto.OgcLayer;
	import com.axiomalaska.crks.dto.VectorLayer;
	import com.axiomalaska.map.interfaces.IOGCLayer;
	import com.axiomalaska.models.SpatialBounds;
	import com.axiomalaska.models.Temporal;
	
	import config.AppSettings;

	[Bindable]
	public class WFSRequest
	{
		
		public var geoserver_domain:String;
		public var geoserver_version:String;
		public var spatial_bounds:SpatialBounds;
		public var layers:Array;
		public var output_format:String;
		public var time_bounds:Temporal;
		public var srs:int = 3338;
		
		public var state:String = 'loading';
		public var error:String;
		public var feature_count:Number;
		public var data_response:Object;
		
		public function getFeatureCall():String{			
			//return _makeFeatureURL('GetFeature');
			return _makeCustomDownloadURL();
		}
		

		
		private function _makeCustomDownloadURL():String{
			var _url:String = AppSettings.domain + AppSettings.crks_service_path + '/wfsDownload?';
			_url += 'url=' + geoserver_domain.replace(/wms$/,'wfs');
			_url += '&outputFormat=' + output_format;
			_url += '&layerNames=' + _makeTypeNameString();
			_url += '&dateProperties=' + _makeDatePropertyString();
			_url += '&swLat=' + spatial_bounds.south_west.latitude;
			_url += '&swLng=' + spatial_bounds.south_west.longitude;
			_url += '&neLat=' + spatial_bounds.north_east.latitude;
			_url += '&neLng=' + spatial_bounds.north_east.longitude;
			if(time_bounds.startdate && time_bounds.enddate){
				_url += '&startDate=' + _makeTimeString(time_bounds.startdate);
				_url += '&endDate=' + _makeTimeString(time_bounds.enddate);
			}
			return _url;
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
		
		private function _makeFeatureURL($request:String):String{
			var _url:String = '';
			if(geoserver_domain){
				_url = geoserver_domain + '?service=WFS&version=' + geoserver_version + '&request=' + $request;
				_url += '&TYPENAME=' + _makeTypeNameString();
				_url += '&OUTPUTFORMAT=' + output_format;
				_url += '&SRS=' + srs;
				if(spatial_bounds){
					_url += '&FILTER=' + makeFilter();
				}
				
			}
			return _url;
		}
		

		private function _uniqueLayers():Array{
			var arr:Array = [];
			var out_arr:Array = [];
			for each(var layer:OgcLayer in layers){
				if(arr.indexOf(layer.ogcName) < 0){
					arr.push(layer.ogcName);
					out_arr.push(layer);
				}
			}
			
			return out_arr;
		}
		
		private function _makeTypeNameString():String{
			var arr:Array = [];
			for each(var layer:IOGCLayer in _uniqueLayers()){
				arr.push(layer.ogcName);
			}
			return arr.join(',');
		}
		
		private function _makeDatePropertyString():String{
			var arr:Array = [];
			for each(var layer:VectorLayer in _uniqueLayers()){

				if(layer.timeProperty){
					arr.push(layer.timeProperty);
				}else{
					arr.push('NODATE');
				}
				
			}
			return arr.join(',');
		}
		
		public function makeFilter():String{
			var _filter:String = '';
			
			return _filter;
		}
		
		
		
		private function _makeBoundingBoxFilterString():String{
			var _filter_txt:String = '';
			_filter_txt = '<ogc:Filter xmlns:ogc="http://www.opengis.net/ogc" xmlns:gml="http://www.opengis.net/gml">';
			_filter_txt += '<ogc:BBOX><ogc:PropertyName></ogc:PropertyName><gml:Box srsName="EPSG:4326"><gml:coordinates>';
			
			//WFS 1.1.1
			//_filter_txt += spatial_bounds.south_west.latitude + ',' +  spatial_bounds.south_west.longitude + ' ' +  spatial_bounds.north_east.latitude + ',' +  spatial_bounds.north_east.longitude;
			
			//WFS 1.0.0
			_filter_txt += spatial_bounds.south_west.longitude + ',' +  spatial_bounds.south_west.latitude + ' ' +  spatial_bounds.north_east.longitude + ',' +  spatial_bounds.north_east.latitude;
			
			_filter_txt += '</gml:coordinates></gml:Box></ogc:BBOX>';
			_filter_txt += '</ogc:Filter>';
			return _filter_txt;
		}
		
		private function _makeTimeBoundsFilterString():String{
			
			return null;
		}
		
		
	}
}