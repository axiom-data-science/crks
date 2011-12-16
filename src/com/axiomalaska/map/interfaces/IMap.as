package com.axiomalaska.map.interfaces
{
	import com.axiomalaska.map.events.AxiomMapEvent;

	public interface IMap
	{
		
		function set layers($layers:Array):void;
		function get layers():Array;
		
		function addControls():void;
		function removeControls():void;
		
		function addZoomControl():void;
		function removeZoomControl():void;
		
		function addPanControl():void;
		function removePanControl():void;
		
		function addWheelControl():void;
		function removeWheelControl():void;
		
		function addPopUp($popup:IPopUp):void;
		function removePopUp($popup:IPopUp):void;
		
		function addLayer($layer:ILayer):Boolean;
		function removeLayer($layer:ILayer):Boolean;
		function addLayerToGroup($layer:ILayer,$layer_group:ILayerGroup):Boolean;
		function getLayerByName($name:String):ILayer;
		function resetLayerOrder():void;
		
		function setCenter($latlong:ILatLon,$zoom:Number = NaN,$animate:Boolean = true):void;
		function panTo($latlon:ILatLon):void;
		
		function onMapReady():void;
		
	}
}