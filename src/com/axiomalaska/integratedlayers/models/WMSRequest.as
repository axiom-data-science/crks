package com.axiomalaska.integratedlayers.models
{
	import com.axiomalaska.models.SpatialBounds;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.collections.ArrayCollection;
	
	[Bindable]
	public class WMSRequest
	{
		
		public var geoserver_domain:String;
		public var geoserver_version:String;		
		//public var geoserver_url:String;
		public var spatial_bounds:SpatialBounds;
		public var request_type:String;
		public var output_format:String;
		public var epsg:int = 3338;
		public var layers:Array;
		
		public var point:Point;
		public var rectangle:Rectangle;
		
		public var loading:Boolean = true;
		public var result_collection:ArrayCollection;
		public var message:String;
		
		public function makePointDataUrl():String{
			return geoserver_domain + '/wms?REQUEST=GetFeatureInfo&BBOX=' + spatial_bounds.toBBOXString() + 
				'&SERVICE=WMS&VERSION=' + geoserver_version + 
				'&x=' + Math.floor(point.x) + '&y=' + Math.floor(point.y) + '&INFO_FORMAT=' + output_format +
				'&LAYERS=' + layers.join(',') +
				'&QUERY_LAYERS=' + layers.join(',') +
				'&STYLES=&WIDTH=' + Math.floor(rectangle.width) + '&HEIGHT=' + Math.floor(rectangle.height) + '&SRS=EPSG:' + epsg + '&FEATURE_COUNT=50';
		}
		
	}
}