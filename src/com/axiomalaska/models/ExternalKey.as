package com.axiomalaska.models
{
	import com.axiomalaska.interfaces.IKeyableDataKey;
	
	[RemoteClass(alias="MapAssets.ExternalKey")]
	public class ExternalKey implements IKeyableDataKey
	{
		public var label:String;
		public var relationshipType:String;
		public var resultSetCrossTableKey:int;
		public var typeKey:int;
	}
}