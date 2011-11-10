package com.axiomalaska.crks.dto {
// Generated May 28, 2011 5:53:51 PM
import mx.collections.ArrayCollection;

	[Bindable]
	public class ModuleGenerated extends AbstractDTO {
		public var id:int;
		public var idDataProvider:int;
		public var dataProvider:DataProvider;
		public var label:String;
		public var description:String;
		public var metadataUrl:String;
		public var v1ParentOfSelectables:Boolean;
		public var mutuallyExclusive:Boolean;
		public var startTimeUtc:Date;
		public var endTimeUtc:Date;
		public var minLng:Number;
		public var minLat:Number;
		public var maxLng:Number;
		public var maxLat:Number;
		public var moduleStickyLayerGroups:ArrayCollection = new ArrayCollection();
		public var portalModules:ArrayCollection = new ArrayCollection();
		public var layerGroups:ArrayCollection = new ArrayCollection();
	}
}
