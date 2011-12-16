package com.axiomalaska.crks.dto {
// Generated May 28, 2011 5:53:51 PM
import mx.collections.ArrayCollection;

	[Bindable]
	public class LayerGroupGenerated extends AbstractDTO {
		
		public var dataProvider:DataProvider;
		
		public var id:int;
		public var idModule:int;
		public var module:Module;
		public var idLayerType:int;
		public var layerType:LayerType;
		public var label:String;
		public var description:String;
		public var metadataUrl:String;
		public var startTimeUtc:Date;
		public var endTimeUtc:Date;
		public var minLng:Number;
		public var minLat:Number;
		public var maxLng:Number;
		public var maxLat:Number;
		public var portalLayerGroups:ArrayCollection = new ArrayCollection();
		public var moduleStickyLayerGroups:ArrayCollection = new ArrayCollection();
		public var layers:ArrayCollection = new ArrayCollection();
	}
}
