package com.axiomalaska.crks.dto {
// Generated May 28, 2011 5:53:51 PM
import com.axiomalaska.crks.dto.Layer;
import mx.collections.ArrayCollection;

	[Bindable]
	public class OgcLayerGenerated extends Layer {
		public var ogcName:String;
		public var wmsUrl:String;
		public var wmsCacheUrl:String;
		public var cacheExpirationSeconds:int;
		public var nativeEpsg:int;
		public var defaultStyle:String;
		public var supportsGetLegendGraphic:Boolean;
		public var googleMapsTileUrl:String;
		public var supportedEpsgs:ArrayCollection = new ArrayCollection();
	}
}
