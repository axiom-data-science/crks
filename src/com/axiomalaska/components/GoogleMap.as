package com.axiomalaska.components
{
	import org.openscales.fx.layer.FxLayer;
	
	public class GoogleMap extends FxLayer
	{
		public function GoogleMap()
		{
			this._layer=new GoogleMapRoot("");
			super();
		}
	}
}