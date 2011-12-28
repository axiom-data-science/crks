package com.axiomalaska.crks.service.result
{
	import com.axiomalaska.crks.dto.Module;
	import com.axiomalaska.crks.dto.Portal;
	
	import mx.collections.ArrayCollection;
	
	[RemoteClass(alias="com.axiomalaska.crks.service.result.PortalDataServiceResult")]
	public class PortalDataServiceResult extends ServiceResult
	{

		public var portal:Portal;
		public var baseLayers:ArrayCollection;
		public var portalModules:ArrayCollection;
		public var portalLayerGroups:ArrayCollection;
		public var modules:ArrayCollection;
		public var moduleStickyLayerGroups:ArrayCollection;
		public var layerGroups:ArrayCollection;
		
		public var dataProviders:ArrayCollection;
		
		public var layerTypes:ArrayCollection;
		public var layerSubtypes:ArrayCollection;
		
		public var parameters:ArrayCollection;
		public var parameterTypes:ArrayCollection;
		
		public var dataLayers:ArrayCollection;
		public var rasterLayers:ArrayCollection;
		public var vectorLayers:ArrayCollection;
		//public var moduleLayers:ArrayCollection;		
		
	}
}