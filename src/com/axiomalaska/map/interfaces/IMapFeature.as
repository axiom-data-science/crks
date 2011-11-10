package com.axiomalaska.map.interfaces
{
	import com.axiomalaska.utilities.Style;

	[Bindable]
	public interface IMapFeature{
		
		function get id():String;
		function set id($id:String):void;		
		
		function get latlon():ILatLon;
		function set latlon($latlon:ILatLon):void;
		
		function get data():Object;
		function set data($data:Object):void;
		
		function get meta_data():IMapFeatureMetaData;
		function set meta_data($meta_data:IMapFeatureMetaData):void;
		
		function get style():Style;
		function set style($style:Style):void;
		
		function draw():void;
		
	}
}