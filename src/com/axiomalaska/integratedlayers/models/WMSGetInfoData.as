package com.axiomalaska.integratedlayers.models
{
	import com.axiomalaska.map.LatLon;
	import com.axiomalaska.models.SpatialBounds;
	import com.axiomalaska.crks.dto.VectorLayer;
	import com.google.maps.Map;
	
	import flash.geom.Rectangle;
	
	import mx.collections.ArrayCollection;
	
	import com.axiomalaska.integratedlayers.views.panels.data.layer_data.wms_point_data.WMSDataPanel;

	[Bindable]
	public class WMSGetInfoData
	{
		public var x:Number;
		public var y:Number;
		public var map_bounds:SpatialBounds;
		public var map_rectangle:Rectangle;
		public var latlon:LatLon;
		public var output_format:String = GeoserverFileFormats.GML2;
		public var epsg:int = 4326;
		public var geoserver_version:String = '1.0.0';
		
		public var loading:Boolean = true;
		public var loaded_results:int = 0;
		public var message:String;
		public var layers:Array;
		public var layer_results:ArrayCollection = new ArrayCollection();
		
		public function makePointDataUrl($layer:VectorLayer):String{
			return $layer.wmsUrl + '/wms?REQUEST=GetFeatureInfo&BBOX=' + map_bounds.toBBOXString() + 
				'&SERVICE=WMS&VERSION=' + geoserver_version + 
				'&x=' + Math.floor(x) + '&y=' + Math.floor(y) + '&INFO_FORMAT=' + output_format +
				'&LAYERS=' + $layer.ogcName +
				'&QUERY_LAYERS=' + $layer.ogcName +
				'&STYLES=&WIDTH=' + Math.floor(map_rectangle.width) + '&HEIGHT=' + Math.floor(map_rectangle.height) + '&SRS=EPSG:' + epsg + '&FEATURE_COUNT=50';
;
		}
		
		
	}
}