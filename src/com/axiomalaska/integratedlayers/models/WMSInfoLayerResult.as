package com.axiomalaska.integratedlayers.models
{
	import com.axiomalaska.crks.dto.VectorLayer;
	
	import mx.collections.ArrayCollection;

	[Bindable]
	public class WMSInfoLayerResult
	{
		public var layer:VectorLayer;
		public var data_collection:ArrayCollection;
	}
}