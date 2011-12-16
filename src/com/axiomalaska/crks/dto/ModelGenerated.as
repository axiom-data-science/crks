package com.axiomalaska.crks.dto {
// Generated May 28, 2011 5:53:51 PM
import mx.collections.ArrayCollection;

	[Bindable]
	public class ModelGenerated extends AbstractDTO {
		public var id:int;
		public var idDataProvider:int;
		public var dataProvider:DataProvider;
		public var label:String;
		public var description:String;
		public var ncwmsName:String;
		public var lefteyePath:String;
		public var lastUpdateTimeUtc:Date;
		public var spatialResolution:String;
		public var temporalResolutionHours:Number;
		public var modelRunFrequencyHours:Number;
		public var forecastThresholdHours:Number;
		public var region:String;
		public var metadataUrl:String;
		public var enabled:Boolean;
		public var minLng:Number;
		public var minLat:Number;
		public var maxLng:Number;
		public var maxLat:Number;
		public var modelVariables:ArrayCollection = new ArrayCollection();
	}
}
