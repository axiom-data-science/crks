package com.axiomalaska.map.interfaces
{
	import mx.collections.ArrayCollection;

	public interface ILayerGroup
	{
		function set id($id:int):void;
		function get id():int;
		
		function set label($label:String):void;
		function get label():String;
		
		function set zindex($zindex:int):void;
		function get zindex():int;
		
		function set layers($layers:ArrayCollection):void;
		function get layers():ArrayCollection;
		
	}
}