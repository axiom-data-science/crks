package com.axiomalaska.map.interfaces
{
	public interface IOGCLayer
	{
		
		function set defaultStyle($defaultStyle:String):void;
		function get defaultStyle():String;
		
		function set id($id:int):void;
		function get id():int;
		
		function set ogcName($ogcName:String):void;
		function get ogcName():String;
		
		function set nativeEpsg($nativeEpsg:int):void;
		function get nativeEpsg():int;
		
		function set preferredEpsg($prefferedEpsg:int):void;
		function get preferredEpsg():int;
		
		function set wmsUrl($wmsUrl:String):void;
		function get wmsUrl():String;
		
		function set wmsCacheUrl($wmsCacheUrl:String):void;
		function get wmsCacheUrl():String;
		
	}
}