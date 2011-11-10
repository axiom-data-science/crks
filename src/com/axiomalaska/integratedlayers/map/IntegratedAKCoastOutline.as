package com.axiomalaska.integratedlayers.map
{
	import com.axiomalaska.crks.dto.OgcLayer;
	import com.axiomalaska.map.features.MapFeature;
	import com.axiomalaska.map.interfaces.ILayer;
	import com.axiomalaska.map.interfaces.IMap;
	import com.axiomalaska.map.types.google.overlay.WMS.AlaskaCoastOutlineTileLayer;
	import com.axiomalaska.utilities.Style;
	
	import config.AppSettings;
	
	public class IntegratedAKCoastOutline extends IntegratedWMSGoogleLayer
	{
		public function IntegratedAKCoastOutline($map:IMap)
		{
			//super(url, alpha, minResolution, maxResolution, copyright);
			var ogc:OgcLayer = new OgcLayer();
			ogc.ogcName = 'axiom:AKCoastPolygonOutlineOnly';
			ogc.preferredEpsg = 900913;
			ogc.wmsUrl = AppSettings.domain + '/';
			ogc.googleMapsTileUrl = AppSettings.domain + '/geoserver/gwc/service/gmaps';
			super(ogc,$map);
		}
	}
}