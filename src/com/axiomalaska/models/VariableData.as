package com.axiomalaska.models
{
	import mx.collections.ArrayCollection;
	
	//[RemoteClass(alias="com.axiom.services.netcdf.data.VariableData,model.VariableData")]

	[Bindable]
	[RemoteClass(alias="com.axiom.services.netcdf.data.VariableData")]
	public class VariableData
	{
		//public var values:Array;
		public var metadata:MetaDataItem;
		//public var metadata:Object;
		
		//lance
		public var variableValueCollection:VariableValueCollection; 
		
		//public var values:Array;
		
		private var _values:Array;
		public function set values($values:Array):void{
			_values = $values;
		}
		public function get values():Array{
			if(!_values){
				if(variableValueCollection){
					_values = variableValueCollection.getValues();
				}
			}
			return _values;
		}
		
	}
}