package com.axiomalaska.models
{
	[Bindable]
	[RemoteClass(alias="MapAssets.EncodedPolygon")]
	public class EncodedPolygon extends KeyedData
	{
		public var encoded_levels:String;
		public var encoded_points:String;
	}
}