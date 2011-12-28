package com.axiomalaska.models.sensors
{
	import com.axiomalaska.models.KeyedData;

	[Bindable]
	[RemoteClass(alias="MapAssets.Source")]
	public class Source extends KeyedData
	{
		public var id:String;
		public var label:String;
		public var city:String;
		public var country:String;
		public var address:String;
		public var postal_code:String;
		public var selected:Boolean;
	}
}