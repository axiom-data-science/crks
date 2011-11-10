package config
{
	
	public class AppSettings
	{
		public static function get domain():String{
			return CONFIG::SERVICES_DOMAIN;	
			//return '';
		}
		public static function get crks_service_path():String{
			return CONFIG::SERVICES_PATH;
		}
	}
}