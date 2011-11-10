package com.axiomalaska.crks.dto {
// Generated May 28, 2011 5:53:51 PM
import flash.utils.ByteArray;
import mx.collections.ArrayCollection;

	[Bindable]
	public class DataProviderGenerated extends AbstractDTO {
		public var id:int;
		public var label:String;
		public var description:String;
		public var logo:ByteArray;
		public var url:String;
		public var modules:ArrayCollection = new ArrayCollection();
		public var models:ArrayCollection = new ArrayCollection();
		public var layers:ArrayCollection = new ArrayCollection();
	}
}
