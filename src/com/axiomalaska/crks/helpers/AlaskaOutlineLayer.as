package com.axiomalaska.crks.helpers
{

	import com.axiomalaska.crks.dto.OgcLayer;
	
	import config.AppSettings;
	
	public class AlaskaOutlineLayer extends OgcLayer
	{
		public function AlaskaOutlineLayer()
		{
			this.id = new Date().getTime();
			this.wmsUrl = AppSettings.domain + '/geoserver/wms';
			//this.googleMapsTileUrl = 'http://maps.axiomalaska.com/geoserver/gwc/service/gmaps';
			this.ogcName = 'axiom:AKCoastPolygonOutlineOnly';
			this.preferredEpsg = 900913;
		}
	}
}