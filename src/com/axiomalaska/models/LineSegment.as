package com.axiomalaska.models
{
	import com.axiomalaska.models.Spatial;
	import com.axiomalaska.models.Temporal;
	
	[RemoteClass(alias="MapAssets.LineSegment")]
	public class LineSegment
	{
		public var id:int;
		public var label:String;
		public var linestart:Spatial;
		public var lineend:Spatial;
		public var temporal:Temporal;
	}
}