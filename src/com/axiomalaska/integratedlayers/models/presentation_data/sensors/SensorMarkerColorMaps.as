package com.axiomalaska.integratedlayers.models.presentation_data.sensors
{
	import com.google.maps.Color;

	public class SensorMarkerColorMaps
	{
		
		public static const temperatureMap:Array = [
			new ColorMapRow(-10,0xCC3300,'#FFFFFF'),
			new ColorMapRow(0,0x0033cc,'#FFFFFF'),
			new ColorMapRow(10,0x0066CC,'#FFFFFF'),
			new ColorMapRow(20,0x0099CC,'#FFFFFF'),
			new ColorMapRow(30,0x00cccc),
			new ColorMapRow(40,0x00cc99),
			new ColorMapRow(50,0x99cc33),
			new ColorMapRow(60,0xcccc33),
			new ColorMapRow(70,0xcc9933),
			new ColorMapRow(80,0xcc6633),
			new ColorMapRow(10000,0xCC3300)
		];
		
		
	}
}