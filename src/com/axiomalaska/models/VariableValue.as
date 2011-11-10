package com.axiomalaska.models
{
	[Bindable]
	[RemoteClass(alias="com.axiom.services.netcdf.data.VariableValue")]
	public class VariableValue
	{
		
		public var intValue:int;
		public var stringValue:String;
		public var doubleValue:Number;
		public var dateValue:Date;
		public var valueType:String;
		public var isNull:Boolean;
		//public var name:String;
		
		public function VariableValue($obj:Object = null)
		{
			for(var p:String in $obj){
				if(p in this){
					this[p] = $obj[p];
				}
			}
		}
		

	}
}