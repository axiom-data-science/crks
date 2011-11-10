package com.axiomalaska.crks.dto {
// Generated May 28, 2011 5:53:51 PM
import mx.collections.ArrayCollection;

	[Bindable]
	public class ParameterGenerated extends AbstractDTO {
		public var id:int;
		public var idParameterType:int;
		public var parameterType:ParameterType;
		public var label:String;
		public var unit:String;
		public var layers:ArrayCollection = new ArrayCollection();
		public var modelVariables:ArrayCollection = new ArrayCollection();
	}
}
