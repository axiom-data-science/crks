package com.axiomalaska.interfaces
{
	import com.axiomalaska.models.Spatial;

	public interface IPlottableData
	{
		function set spatial($spatial:Spatial):void;
		function get spatial():Spatial;	
	}
}