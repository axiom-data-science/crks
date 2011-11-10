package com.axiomalaska.crks.service.result
{
	import com.axiomalaska.crks.dto.DataLayer;
	import com.axiomalaska.crks.dto.Layer;
	import com.axiomalaska.crks.dto.RasterLayer;
	import com.axiomalaska.crks.dto.VectorLayer;
	
	[RemoteClass(alias="com.axiomalaska.crks.service.result.LayerServiceResult")]
	public class LayerServiceResult extends ServiceResult
	{
		
		public var dataLayer:DataLayer;
		public var vectorLayer:VectorLayer;
		public var rasterLayer:RasterLayer;
	}
}