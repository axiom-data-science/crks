package com.axiomalaska.crks.dto {
// Generated May 28, 2011 5:53:51 PM
import mx.collections.ArrayCollection;

	[Bindable]
	public class PortalGenerated extends AbstractDTO {
		public var id:int;
		public var idBaseLayer:int;
		public var label:String;
		public var description:String;
		public var backgroundColor:String;
		public var backgroundColor2:String;
		public var minLng:Number;
		public var minLat:Number;
		public var maxLng:Number;
		public var maxLat:Number;
		public var splashScreenHtml:String;
		public var v1StartOverlays:String;
		public var v1Javascript:String;
		public var v1LogoImage:String;
		public var v1BannerImage:String;
		public var portalModules:ArrayCollection = new ArrayCollection();
		public var portalLayerGroups:ArrayCollection = new ArrayCollection();
	}
}
