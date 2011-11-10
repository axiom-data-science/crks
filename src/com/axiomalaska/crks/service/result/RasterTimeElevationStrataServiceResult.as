package com.axiomalaska.crks.service.result
{
	import mx.collections.ArrayCollection;
	
	[RemoteClass(alias="com.axiomalaska.crks.service.result.RasterTimeElevationStrataServiceResult")]
	public class RasterTimeElevationStrataServiceResult extends ServiceResult
	{
		public var layerId:int;
		public var timeStrata:ArrayCollection;
		public var elevationStrata:ArrayCollection;
	}
}