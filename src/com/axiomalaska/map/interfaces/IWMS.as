package com.axiomalaska.map.interfaces
{
	import com.axiomalaska.map.LatLon;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;

	public interface IWMS
	{
		
		function get name():String;
		function set name($name:String):void;

		function get layerNames():String;
		function set layerNames($layerNames:String):void;		
		
		function get url():String;
		function set url($url:String):void;
		
		function get epsg():String;
		function set epsg($epsg:String):void;
		
		function get format():String;
		function set format($format:String):void;
		
		function get bgcolor():String;
		function set bgcolor($bgcolor:String):void;

		function get styles():String;
		function set styles($styles:String):void;
		
		function get size():Number;
		function set size($size:Number):void;
		
		function get tiled():Boolean;
		function set tiled($tiled:Boolean):void;
		
		function get transparent():Boolean;
		function set transparent($transparent:Boolean):void;
		
		function get isBaseLayer():Boolean;
		function set isBaseLayer($isBaseLayer:Boolean):void;
		
		function get useCache():Boolean;
		function set useCache($useCache:Boolean):void;
		
		function get params():Object;
		function set params($params:Object):void;
		
		function loadTile($tilePosition:Point, $zoom:Number):DisplayObject;
		//function pixelToLatLon($pixel:Point):ILatLon;
		//function getBoundingBoxString($tilePosition:Point,$zoom:int):String;
		
		
	}
}