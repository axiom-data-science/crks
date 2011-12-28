package com.axiomalaska.models
{
	
	[Bindable]
	[RemoteClass(alias="com.axiom.services.netcdf.data.DimensionRequestValue")]
	public class DimensionRequestValue
	{
		
		public var startDateValue:Date;
		public var endDateValue:Date;
		public var startIntValue:int;
		public var endIntValue:int;
		public var startDoubleValue:Number;
		public var endDoubleValue:Number;
		public var stringValue:String;
		public var name:String;
		public var valueType:String;
		
		public function DimensionRequestValue($obj:Object = null)
		{
			for(var p:String in $obj){
				if(p in this){
					this[p] = $obj[p];
				}
			}
		}
		
	}
	
}