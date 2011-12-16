package com.axiomalaska.map.types.google
{
	import com.axiomalaska.map.features.MapFeature;
	import com.axiomalaska.map.interfaces.ILayer;
	import com.axiomalaska.map.interfaces.IMap;
	import com.axiomalaska.map.interfaces.IOGCLayer;
	import com.axiomalaska.map.types.google.GoogleMap;
	import com.axiomalaska.map.types.google.overlay.WMS.WMSOverlay;
	import com.axiomalaska.utilities.Style;
	import com.google.maps.overlays.TileLayerOverlay;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	public class GoogleWMSLayer extends GoogleTileLayer implements ILayer
	{

		public var ogc:IOGCLayer;
		public var wmsOverlay:WMSOverlay;
		
		[Bindable]
		public var loading:Boolean;
				
		public function GoogleWMSLayer($ogc:IOGCLayer,$map:IMap,$params:Object = null)
		{
			var copy:int = $ogc.id;
			var i:String = $ogc.id.toString();
			this.id = i;
			//trace('id for ' + $ogc.ogcName + ' is ' + id + '(' + $ogc.id + ')');
			this.name = this.id;
			this.ogc = $ogc;
			var params:Object = {map:($map as GoogleMap).map,styles:$ogc.defaultStyle};
			if($params){
				for(var p:String in $params){
					params[p] = $params[p];
				}
			}
			
			if(ogc.wmsCacheUrl){
				params.wmsCacheUrl = ogc.wmsCacheUrl;
			}
			
			var epsg:int = $ogc.nativeEpsg;
			if($ogc.preferredEpsg){
				epsg = $ogc.preferredEpsg;
			}
			
			wmsOverlay = new WMSOverlay($ogc.ogcName,$ogc.wmsUrl,$ogc.ogcName,false,epsg,params);
			
			wmsOverlay.dispatcher.addEventListener(Event.COMPLETE,function($evt:Event):void{
				//trace('COMPLETED LOADING ' + $ogc.ogcName);
				loading = false;
			});
			wmsOverlay.dispatcher.addEventListener(Event.CHANGE,function($evt:Event):void{
				//trace('STARTED LOADING ' + $ogc.ogcName);
				loading = true;
			});
			
			super(wmsOverlay);
		}
		

		
		
		
		
		
	}
}