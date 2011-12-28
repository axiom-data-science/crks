package com.axiomalaska.models
{

	[Bindable]
	[RemoteClass(alias="MapAssets.MetaLabel")]
	public class MetaLabel extends KeyedData
	{
		public var label:String;
		public var text:String;
		public var url:String;
		public var showLabel:Boolean;
		
	}
}