package com.axiomalaska.crks.service.result
{
	import com.axiomalaska.crks.dto.DataLayer;
	import com.axiomalaska.crks.dto.Module;
	import com.axiomalaska.crks.dto.LayerGroup;
	import com.axiomalaska.crks.dto.RasterLayer;
	import com.axiomalaska.crks.dto.VectorLayer;
	
	import mx.collections.ArrayCollection;
	
	[RemoteClass(alias="com.axiomalaska.crks.service.result.ModuleServiceResult")]
	public class ModuleServiceResult extends ServiceResult {
		public var module:Module;
		public var stickyLayerGroups:ArrayCollection = new ArrayCollection();
		public var layerGroups:ArrayCollection = new ArrayCollection();
		public var vectorLayers:ArrayCollection = new ArrayCollection();
		public var rasterLayers:ArrayCollection = new ArrayCollection();
		public var dataLayers:ArrayCollection = new ArrayCollection();
	}

}