package com.axiomalaska.models
{
	import com.axiomalaska.interfaces.IKeyableData;
	
	import mx.collections.ArrayCollection;
	
	[Bindable]
	[RemoteClass(alias="com.axiom.services.netcdf.data.VariableDescriptor")]
	public class VariableDescriptor
	{
		public var primaryKey:int;
		public var secondaryKey:int;
		public var vectors:Array;
		public var dataFields:Array;
		public var metadataFields:Array;
		public var children:Array;
		public var sourceUrl:String;
		
		public function getVectorFields():Array{
			if(vectors){
				return vectors;
			}
			return [];
		}
		
	}
}