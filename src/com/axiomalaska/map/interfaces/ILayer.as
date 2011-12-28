package com.axiomalaska.map.interfaces
{
	import com.axiomalaska.map.features.MapFeature;
	import com.axiomalaska.utilities.Style;
	
	import flash.display.DisplayObject;

	public interface ILayer
	{


		function get id():String;
		function set id($id:String):void;
		
		function get name():String;
		function set name($name:String):void;
		
		//function get label():String;
		//function set label($label:String):void;

		function get features():Array;
		function set features($features:Array):void;
		
		//function get icon():DisplayObject;
		//function set icon($icon:DisplayObject):void;
		
		function get style():Style;
		function set style($style:Style):void;
		
		function get zindex():int;
		function set zindex($zindex:int):void;
		
		function get alpha():Number;
		function set alpha($alpha:Number):void;

		function addFeature($feature:MapFeature):void;
		function removeAllFeatures():void;
		function removeFeature($feature:MapFeature):void;
		
		function draw():void;
		function redraw():void;
		function hide():void;
		function show():void;
		

	}
}