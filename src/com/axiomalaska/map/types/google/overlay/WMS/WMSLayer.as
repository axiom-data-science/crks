package com.axiomalaska.map.types.google.overlay.WMS
{
	import com.axiomalaska.map.overlay.WMS;
	import com.google.maps.interfaces.ICopyrightCollection;
	import com.google.maps.interfaces.IMapType;
	import com.google.maps.interfaces.ITileLayer;
	
	public class WMSLayer extends WMS implements ITileLayer
	{
		public function WMSLayer($name:String='', $url:String='', $layerNames:String='', $isBaseLayer:Boolean=false, $epsg:String='', $params:Object=null)
		{
			super($name, $url, $layerNames, $isBaseLayer, $epsg, $params);
		}
		
		public function getAlpha():Number
		{
			return 0;
		}
		
		public function setMapType(arg0:IMapType):void
		{
		}
		
		public function getCopyrightCollection():ICopyrightCollection
		{
			return null;
		}
		
		public function getMaxResolution():Number
		{
			return 0;
		}
		
		public function getMinResolution():Number
		{
			return 0;
		}
		
		public function get interfaceChain():Array
		{
			return null;
		}
		
		public function get wrapper():Object
		{
			return null;
		}
		
		public function set wrapper(arg0:Object):void
		{
		}
	}
}