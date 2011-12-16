package com.axiomalaska.models
{
	[RemoteClass(alias="com.axiom.services.netcdf.data.RelationshipSet")]
	public class RelationshipSet
	{
	
			
			public var behavior:String;
			public var belongs_to:Array;
			public var dataFields:Object;
			public var has_many:Array;
			public var has_and_belongs_to_many:Array;
			public var has_one:Array;		
			public var presentation:String;
			public var table_name:String;
			
			private var _rsr:ResultSetRelationship;
		
	}
}