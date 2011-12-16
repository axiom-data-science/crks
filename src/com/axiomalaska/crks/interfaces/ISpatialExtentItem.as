package com.axiomalaska.crks.interfaces
{
	import com.axiomalaska.models.SpatialBounds;

	[Bindable]
	public interface ISpatialExtentItem
	{
		function set spatialBounds($spatialBounds:SpatialBounds):void;
		function get spatialBounds():SpatialBounds;
		
		function set hasBounds($hasBounds:Boolean):void;
		function get hasBounds():Boolean;
		
	}
}