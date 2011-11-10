package com.axiomalaska.integratedlayers.models.layers.data.stations_layer
{
	import mx.collections.ArrayCollection;

	public class SensorTypes
	{
		public static const WEB_CAM:String = 'WEBCAM';
		public static const CURRENT_WEATHER:String = 'CURRENT_WEATHER';
		public static const STREAM_GAGE_HEIGHT:String = 'STREAM_GAGE_HEIGHT';
		public static const PRECIPITATION:String = 'PRECIPITATION';
		public static const STREAM_FLOW:String = 'STREAM_FLOW';
		public static const AIR_TEMPERATURE:String = 'AIR_TEMPERATURE';
		public static const WATER_TEMPERATURE:String = 'WATER_TEMPERATURE';
		public static const WINDS:String = 'WINDS';
		public static const BAROMETRIC_PRESSURE:String = 'BAROMETRIC_PRESSURE';
		public static const DEPTH_TO_WATER_LEVEL:String = 'DEPTH_TO_WATER_LEVEL';
		public static const TIDES:String = 'TIDE_PREDICTIONS';
		public static const SEA_FLOOR_DEPTH_BELOW_SEA_SURFACE:String = 'SEA_FLOOR_DEPTH_BELOW_SEA_SURFACE';
		public static const WAVES:String = 'WAVES';
		public static const SALINITY:String = 'SALINITY';
		public static const CURRENTS:String = 'CURRENTS';
		public static const SNOW_WATER_EQUIVALENT:String = 'SNOW_WATER_EQUIVALENT'; 
		public static const SNOW_DEPTH:String = 'SNOW_DEPTH';
		public static const SOIL_MOISTURE_PERCENT:String = 'SOIL_MOISTURE_PERCENT';
		public static const SOIL_TEMPERATURE:String = 'SOIL_TEMPERATURE';
		public static const BATTERY:String = 'BATTERY';
		public static const SOLAR_RADIATION:String = 'SOLAR_RADIATION';
		public static const RELATIVE_HUMIDITY:String = 'RELATIVE_HUMIDITY';
		public static const CONDUCTIVITY:String = 'CONDUCTIVITY';
		public static const REAL_DIELECTRIC_CONSTANT:String = 'REAL_DIELECTRIC_CONSTANT';
		public static const WATER_LEVEL:String = 'WATER_LEVEL';
		public static const WATER_LEVEL_PREDICTIONS:String = 'WATER_LEVEL_PREDICTIONS';
		public static const GROUND_TEMPERATURE:String = 'GROUND_TEMPERATURE';
		public static const PANEL_TEMPERATURE:String = 'PANEL_TEMPERATURE';
		public static const DEW_POINT:String = 'DEW_POINT';
		public static const FUEL_TEMPERATURE:String = 'FUEL_TEMPERATURE';
		public static const FUEL_MOISTURE:String = 'FUEL_MOISTURE';
		public static const RESERVOIR_WATER_SURFACE_ABOVE_DATUM:String = 'RESERVOIR_WATER_SURFACE_ABOVE_DATUM';
		public static const WATER_CONDUCTANCE:String = 'WATER_CONDUCTANCE';
		public static const DISSOLVED_OXYGEN:String = 'DISSOLVED_OXYGEN';
		public static const PH_WATER:String = 'PH_WATER';
		public static const WATER_TURBIDITY:String = 'WATER_TURBIDITY';
		public static const SPECIFIC_CONDUCTANCE_OF_WATER:String = 'SPECIFIC_CONDUCTANCE_OF_WATER';
		public static const POOL_ELEVATION:String = 'POOL_ELEVATION';
		
		public static function getPreviewChartTypes():Array{
			return [
				SensorTypes.SOLAR_RADIATION,
				SensorTypes.WATER_LEVEL,
				SensorTypes.DEPTH_TO_WATER_LEVEL,
				SensorTypes.DISSOLVED_OXYGEN,
				SensorTypes.PH_WATER,
				SensorTypes.RELATIVE_HUMIDITY,
				SensorTypes.STREAM_FLOW,
				SensorTypes.STREAM_GAGE_HEIGHT,
				SensorTypes.PRECIPITATION,
				SensorTypes.BAROMETRIC_PRESSURE, 
				SensorTypes.WINDS,
				SensorTypes.DEW_POINT,
				SensorTypes.DEPTH_TO_WATER_LEVEL,
				SensorTypes.GROUND_TEMPERATURE,
				SensorTypes.AIR_TEMPERATURE,
				SensorTypes.WATER_TEMPERATURE,
				SensorTypes.SNOW_DEPTH,
				SensorTypes.SNOW_WATER_EQUIVALENT
			]
		}
		
		public static function getScalarSensorTypes():Array{
			return [
				SensorTypes.SOLAR_RADIATION,
				SensorTypes.WATER_LEVEL,
				SensorTypes.DEPTH_TO_WATER_LEVEL,
				SensorTypes.DISSOLVED_OXYGEN,
				SensorTypes.PH_WATER,
				SensorTypes.RELATIVE_HUMIDITY,
				SensorTypes.STREAM_FLOW,
				SensorTypes.STREAM_GAGE_HEIGHT,
				SensorTypes.PRECIPITATION,
				SensorTypes.BAROMETRIC_PRESSURE, 
				SensorTypes.DEW_POINT,
				SensorTypes.DEPTH_TO_WATER_LEVEL,
				SensorTypes.GROUND_TEMPERATURE,
				SensorTypes.AIR_TEMPERATURE,
				SensorTypes.WATER_TEMPERATURE,
				SensorTypes.SNOW_DEPTH,
				SensorTypes.SNOW_WATER_EQUIVALENT
			];
		}
		
		public static function getVectorSensorTypes():Array{
			return [
				SensorTypes.WINDS
			];
		}
		
		public static function getWebCamTypes():Array{
			return [
				SensorTypes.WEB_CAM
			]
		}
		
	}
}