package com.axiomalaska.integratedlayers.models
{
	import com.axiomalaska.map.features.MapFeature;
	import com.axiomalaska.map.interfaces.IMapFeature;
	import com.axiomalaska.models.ResultSet;
	import com.axiomalaska.crks.dto.AmfDataService;
	
	import mx.collections.ArrayCollection;

	[Bindable]
	public class DataRequest
	{
		
		public var amf_service:AmfDataService;
		public var loading:Boolean = true;
		public var results:ArrayCollection = new ArrayCollection();
		public var map_feature:IMapFeature;
		public var result_set:ResultSet;
		
	}
}