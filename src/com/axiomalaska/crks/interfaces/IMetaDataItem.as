package com.axiomalaska.crks.interfaces
{
	import com.axiomalaska.models.Temporal;
	import com.axiomalaska.crks.dto.DataProvider;
	
	import mx.collections.ArrayCollection;

	[Bindable]
	public interface IMetaDataItem extends ISpatialExtentItem
	{
		
		function set label($label:String):void;
		function get label():String;
		
		function set description($description:String):void;
		function get description():String;
		
		function set temporal($temporal:Temporal):void;
		function get temporal():Temporal;
		
		function set children($children:ArrayCollection):void;
		function get children():ArrayCollection;
		
		function set dataProvider($dataProvider:DataProvider):void;
		function get dataProvider():DataProvider;
		
		function set metadataUrl($metadataUrl:String):void;
		function get metadataUrl():String;
	}
}