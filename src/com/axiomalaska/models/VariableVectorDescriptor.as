package com.axiomalaska.models
{
	[Bindable]
	[RemoteClass(alias="com.axiom.services.netcdf.data.VariableVectorDescriptor")]
	public class VariableVectorDescriptor
	{
		public var azimuth:int;
		public var magnitude:int;
		public var descriptorType:String;
	}
}