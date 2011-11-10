package com.axiomalaska.models
{
	[Bindable]
	[RemoteClass(alias="MapAssets.LayerGroup")]
	public class LayerGroup
	{
		public var LayerGroupId:String;
		public var LayerGroupName:String;
		public var Description:String;
		public var LastModelUpdate:Date;
		public var Source:String;
		public var SpatialResolution:String;
		public var TemporalResolutionHours:Number;
		public var ModelRunFrequencyHours:Number;
		public var ForecastThresholdHours:Number;
		public var Region:String;
		public var MetadataURL:String;
		public var Layers:Array;
	}
}