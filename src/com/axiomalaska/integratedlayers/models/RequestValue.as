package com.axiomalaska.integratedlayers.models
{
	import com.axiomalaska.models.VariableType;
	
	[Bindable]
	[RemoteClass(alias="com.axiom.services.netcdf.data.RequestValue")]
	public class RequestValue
	{
		
		public var dateValue:Date;
		public var intValue:int;
		public var doubleValue:Number;
		public var stringValue:String;
		public var name:String;
		public var valueType:String;
		
		private var _value:*;
		public function set value($value:*):void{
			_value = $value;

			
		}
		public function get value():*{
			return _value;
			setTypedValue();
		}
		
		public function setTypedValue():void{
			if(valueType){
				if(valueType == VariableType.DOUBLE){
					doubleValue = Number(value);
				}else if(valueType == VariableType.INT){
					intValue = int(value);
				}else if(valueType == VariableType.STRING){
					stringValue = String(value);
				}
			}
		}
		
		public function RequestValue($obj:Object = null)
		{
			for(var p:String in $obj){
				if(p in this){
					this[p] = $obj[p];
				}
			}
		}
		
	}
	
}