package com.axiomalaska.map.types.google.overlay.WMS
{
	import com.google.maps.Alpha;

	public class AlaskaCoastOutlineTileLayer extends AlaskaCoastTileLayer
	{
		
		
		public function AlaskaCoastOutlineTileLayer(url:String = AppSettings.domain + '/geoserver/gwc/service/gmaps', alpha:Number=Alpha.OPAQUE, minResolution:Number=1, maxResolution:Number=17, copyright:String=null)
		{			
			super(url, alpha, minResolution, maxResolution, copyright);
			super.layer = 'axiom:AKCoastPolygonOutlineOnly';
		}
	}
}