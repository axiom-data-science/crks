package com.axiomalaska.map.interfaces
{
	import com.axiomalaska.models.MetaLabel;

	[Bindable]
	public interface IMapFeatureMetaData
	{
		function get fields():Array;
		function set fields($fields:Array):void;
		
		function get label():MetaLabel;
		function set label($label:MetaLabel):void;
		
		function get summary():String;
		function set summary($summary:String):void;
		
		function get logo():String;
		function set logo($logo:String):void;
		
	}
}