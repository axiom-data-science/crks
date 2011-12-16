package config
{
	import mx.core.FlexGlobals;
	
	public class AppSettings
	{
		public static function get domain():String{
			var services_domain:String = CONFIG::SERVICES_DOMAIN;
			
			if(FlexGlobals.topLevelApplication.parameters.hasOwnProperty('services_domain')){
				// if services_domain in index.html is not null and has been set, use it
				var index_services_domain:String = String( FlexGlobals.topLevelApplication.parameters.services_domain );
				if( index_services_domain != null && index_services_domain.charAt(0) != '$' ){
					services_domain = index_services_domain;
				};
			}

			//add http protocol if it's not there
			if( services_domain.substr(0,4) != 'http' ){
				services_domain = 'http://' + services_domain;
			}
			
			//add trailing slash if it's not there
			if( services_domain.charAt( services_domain.length - 1 ) != '/' ){
				services_domain += '/';
			}
			
			return services_domain;	
		}
		
		public static function get crks_service_path():String{
			if(FlexGlobals.topLevelApplication.parameters.hasOwnProperty('services_path')){
				// if services_path is not null and has been set, return it
				var path_str:String = String( FlexGlobals.topLevelApplication.parameters.services_path );
				if( path_str != null && path_str.charAt(0) != '$' ){
					return path_str;
				};
			}

			//if(FlexGlobals.topLevelApplication.parameters.hasOwnProperty('services_path')){
			//	return String( FlexGlobals.topLevelApplication.parameters.services_path );
		//	}

			return CONFIG::SERVICES_PATH;
		}
	}
}