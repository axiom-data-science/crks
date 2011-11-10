package com.axiomalaska.map.interfaces
{
	[Bindable]
	public interface ILatLon
	{
		function get latitude():Number;
		function set latitude($latitude:Number):void;
		
		function get longitude():Number;
		function set longitude($longitude:Number):void;
		
	}
}