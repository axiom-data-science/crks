package com.axiomalaska.map.interfaces
{
	public interface ILocationsLayer extends ILayer
	{
		function set locations($locations:Array):void;
		function get locations():Array;
		
		function filter():void;
	}
}