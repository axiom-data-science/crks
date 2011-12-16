package com.axiomalaska.models
{
	import com.axiomalaska.interfaces.IKeyableDataKey;

	[RemoteClass(alias="MapAssets.InternalKey")]
	public class InternalKey implements IKeyableDataKey
	{
		public var dataFieldKey:int;
		public var resultSetKey:int;
	}
}