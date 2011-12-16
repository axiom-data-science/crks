package com.axiomalaska.models
{
	[RemoteClass(alias="MapAssets.CurrentWeather")]
	public class CurrentWeather
	{
		public var wind_mph:Number;
		public var wind_kt:Number
		public var wind_string:String;
		public var wind_degrees:Number;
		public var wind_dir:String;
		public var wind_gust:Number;
		public var windchill_f:Number;
		public var weather:String;
		public var visibility_mi:Number;
		public var temp_f:Number;
		public var temperature_string:String;
		public var relative_humidity:Number;
		public var pressure_in:Number;
		public var observation_time:String;
		public var location:String;
		public var dewpoint_f:Number;
		public var dewpoint_string:String;
		public var icon:String;
	}
}