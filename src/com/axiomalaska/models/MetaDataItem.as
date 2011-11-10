package com.axiomalaska.models
{
	[RemoteClass(alias="com.axiom.services.netcdf.data.MetaDataItem")]
	public class MetaDataItem
	{
		public var label:String
		public var unit:String
		public var dataType:String;
		//to add?
		public var max:VariableValue;
		public var min:VariableValue;
		public var avg:VariableValue;
	}
}