package com.axiomalaska.models
{
	[Bindable]
	[RemoteClass(alias="com.axiom.services.netcdf.data.VariableDataDescriptor")]
	public class VariableDataDescriptor
	{
		public var value:int;
		public var descriptorType:String;
		public var indexes:Object;
	}
}