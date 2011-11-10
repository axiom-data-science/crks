package com.axiomalaska.interfaces
{
	import com.axiomalaska.models.RelationshipSet;
	import com.axiomalaska.models.VariableDescriptor;

	public interface IKeyableData
	{
		
		function set keys($keys:Object):void;
		function get keys():Object;
		
		function set resultSetKey($key:String):void;
		function get resultSetKey():String;
		
		function set spatialFieldKey($key:String):void;
		function get spatialFieldKey():String;
		
		function set relationshipSet($relationshipSets:RelationshipSet):void;
		function get relationshipSet():RelationshipSet;
		
		function populateKeyedPropertiesFromValues($values_array:Array,$descriptor:VariableDescriptor):void;
		
	}
}