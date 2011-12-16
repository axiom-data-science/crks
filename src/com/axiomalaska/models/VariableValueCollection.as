package com.axiomalaska.models
{

	[Bindable]
	[RemoteClass(alias="com.axiom.services.netcdf.data.VariableValueCollection")]
	public class VariableValueCollection
	{
		public var stringValues:Array;
		public var dateValues:Array;
		public var intValues:Array;
		public var doubleValues:Array;
		public var valueType:String;
		
		public function getValues():Array{
			
			if(valueType == VariableType.DATE){
				return dateValues;
			}else if(valueType == VariableType.DOUBLE){
				return doubleValues;
			}else if(valueType == VariableType.INT){
				return intValues;
			}else if(valueType == VariableType.STRING){
				return stringValues;
			}
			
			return null;
			
		}
	}
}