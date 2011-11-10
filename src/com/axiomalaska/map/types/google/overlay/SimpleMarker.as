package com.axiomalaska.map.types.google.overlay
{
	import com.axiomalaska.map.features.MapFeature;
	import com.axiomalaska.map.interfaces.ILatLon;
	import com.axiomalaska.models.Temporal;
	import com.axiomalaska.utilities.Style;
	
	import flash.display.Sprite;
	
	[Bindable]
	public class SimpleMarker extends MapFeature
	{
		
		public var highlight:Sprite = new Sprite();
		public var temporal:Temporal;
		
		public function SimpleMarker($latlon:ILatLon,$data:Object = null,$style:Style = null)
		{
			super($latlon,$data,$style);
			addChild(highlight);
		}
		
	}

}