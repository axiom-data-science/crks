package com.axiomalaska.integratedlayers.models.presentation_data
{
	import com.axiomalaska.map.LatLon;
	import com.axiomalaska.map.interfaces.IMap;
	import com.axiomalaska.models.SpatialBounds;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import com.axiomalaska.integratedlayers.models.WMSGetInfoData;
	
	import mx.collections.ArrayCollection;

	[Bindable]
	public class MapData
	{
		
		public var map:IMap;
		
		public var bounding_box_mode:Boolean = false;
		public var wfs_download_bounds:SpatialBounds;
		
		public var wms_info_mode:Boolean = false;
		public var wms_info_data:WMSGetInfoData;
		
		public var virtual_sensor_mode:Boolean = false;
		
		public var tiles_loading:Boolean = false;
		
		public var active_layers:ArrayCollection = new ArrayCollection();
		public var active_vector_layers:ArrayCollection = new ArrayCollection();
		public var active_raster_layers:ArrayCollection = new ArrayCollection();
		
		public var active_data_views:ArrayCollection = new ArrayCollection();
		
	}
}