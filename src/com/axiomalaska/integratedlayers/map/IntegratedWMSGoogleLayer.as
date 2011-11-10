package com.axiomalaska.integratedlayers.map
{
	import com.axiomalaska.map.features.MapFeature;
	import com.axiomalaska.map.interfaces.ILayer;
	import com.axiomalaska.map.interfaces.IMap;
	import com.axiomalaska.map.types.google.GoogleMap;
	import com.axiomalaska.map.types.google.GoogleWMSLayer;
	import com.axiomalaska.map.types.google.overlay.WMS.WMSOverlay;
	import com.axiomalaska.crks.dto.OgcLayer;
	import com.axiomalaska.utilities.Style;
	import com.google.maps.LatLng;
	import com.google.maps.LatLngBounds;
	import com.google.maps.overlays.TileLayerOverlay;
	
	import flash.display.DisplayObject;
	import flash.events.Event;

	public class IntegratedWMSGoogleLayer extends GoogleWMSLayer
	{
		


		
		
		public function IntegratedWMSGoogleLayer($ogc:OgcLayer,$map:IMap,$params:Object = null)
		{
			
			var p:Object = {};
			if($params){
				p = $params;
			}
			
			if($ogc.maxLat && $ogc.minLat && $ogc.maxLng && $ogc.minLng){
				p.bounds = new LatLngBounds(new LatLng($ogc.minLat,$ogc.minLng),new LatLng($ogc.maxLat,$ogc.maxLng));
			}
			
			if($ogc.googleMapsTileUrl && !$ogc.wmsCacheUrl && !$ogc.hasTimeComponent){
				$ogc.wmsCacheUrl = $ogc.googleMapsTileUrl;
			}
			
			if($ogc.wmsCacheUrl){
				p.useGoogleStyleCache = true;
			}
			
			/*
			this.wmsOverlay.dispatcher.addEventListener(Event.COMPLETE,function($evt:Event):void{
				trace('COMPLETED LOADING ' + $ogc.label);
			});
			*/

			
			super($ogc,$map,p);
			//var to:TileLayerOverlay = new TileLayerOverlay();
			
		}
		
		

		

		
		
		
	}
}