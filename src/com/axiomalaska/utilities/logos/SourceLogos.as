package com.axiomalaska.utilities.logos
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public class SourceLogos
	{
		
		[Embed(source="/assets/logos/logo0.png")]
		static public var LOGO0:Class;
		
		[Embed(source="/assets/logos/conoco.png")]
		static public var CONOCO:Class;

		[Embed(source="/assets/logos/sio-mpl.png")]
		static public var SIOMPL:Class;

		[Embed(source="/assets/logos/uaf.png")]
		static public var UAF:Class;
		
		[Embed(source="/assets/logos/usace.png")]
		static public var USACE:Class;
		
		[Embed(source="/assets/logos/canada_ocean.png")]
		static public var CANADA_OCEAN:Class;
		
		[Embed(source="/assets/logos/jamstec.png")]
		static public var JAMSTEC:Class;
		
		[Embed(source="/assets/logos/jasco.png")]
		static public var JASCO:Class;
		
		[Embed(source="/assets/logos/noaa.png")]
		static public var NOAA:Class;
		
		[Embed(source="/assets/logos/shell.png")]
		static public var SHELL:Class;

		[Embed(source="/assets/logos/usgs.png")]
		static public var USGS:Class;		
		
		[Embed(source="/assets/logos/snotel.png")]
		static public var SNOTEL:Class;
		
		[Embed(source="/assets/logos/stanford.png")]
		static public var STANFORD:Class;
		
		[Embed(source="/assets/logos/whoi.png")]
		static public var WHOI:Class;

		[Embed(source="/assets/logos/webcam.png")]
		static public var WEBCAM:Class;
		
		[Embed(source="/assets/logos/low_temperature_science.png")]
		static public var INSTITUTE_OF_LOW_TEMPURATURE_SCIENCE:Class;
		
		[Embed(source="/assets/logos/apl_uw.png")]
		static public var APL_UW:Class;

		[Embed(source="/assets/logos/rusalca.png")]
		static public var RUSALCA:Class;
		
		[Embed(source="/assets/logos/dot.png")]
		static public var DOT:Class;
		
		[Embed(source="/assets/logos/faa.png")]
		static public var FAA:Class;

		[Embed(source="/assets/logos/raws.png")]
		static public var RAWS:Class;	
		
		[Embed(source="/assets/logos/hads.png")]
		static public var HADS:Class;	

		[Embed(source="/assets/logos/cnfaic.png")]
		static public var CNFAIC:Class;	
		
		[Embed(source="/assets/logos/jpl.png")]
		static public var JPL:Class;		

		[Embed(source="/assets/logos/nasa.png")]
		static public var NASA:Class;		

		[Embed(source="/assets/logos/aeff.png")]
		static public var AEFF:Class;
		
		[Embed(source="/assets/logos/uaa.png")]
		static public var UAA:Class;
		
		[Embed(source="/assets/logos/snapp.png")]
		static public var SNAPP:Class;		

		[Embed(source="/assets/logos/nam-wrf.png")]
		static public var NAMWRF:Class;
		
		[Embed(source="/assets/logos/kbay-research-reserve.png")]
		static public var KBRR:Class;
		
		[Embed(source="/assets/logos/nsidc.png")]
		static public var NSIDC:Class;
		
		[Embed(source="/assets/logos/arsc.png")]
		static public var ARSC:Class;
		
		[Embed(source="/assets/logos/aoos.png")]
		static public var AOOS:Class;
		
		[Embed(source="/assets/logos/statoil.png")]
		static public var STATOIL:Class;	
		
		[Embed(source="/assets/logos/hokkaido.png")]
		static public var HOKKAIDO:Class;
		
		[Embed(source="/assets/logos/pag.png")]
		static public var PAG:Class;
		
		
		[Embed(source="/assets/logos/fairweather.png")]
		static public var FAIRWEATHER:Class;
		
		[Embed(source="/assets/logos/empty.png")]
		static public var EMPTY:Class;
		
		
		
		
		
		static public function findLogo($str:String):DisplayObject{
			
			var cl:Class = findLogoClass($str);
			var logo:DisplayObject = new cl;
			return logo;
			
		}
		
		static public function findLogoClass($str:String):Class{
			var logo:Class = EMPTY;
			
			if($str.match(/conoco/i)){
				logo =  CONOCO;
			}else if($str.match(/sio-mpl/i)){
				logo =  SIOMPL;
			}else if($str.match(/uaf/i) || $str.match(/university of alaska fairbanks/i)){
				logo =  UAF;
			}else if($str.match(/usace/i) || $str.match(/crrel/i) || $str.match(/us army corps/i)){
				logo =  USACE;
			}else if($str.match(/ocean canada/i)){
				logo =  CANADA_OCEAN;
			}else if($str.match(/jamstec/i)){
				logo =  JAMSTEC;
			}else if($str.match(/jasco/i)){
				logo =  JASCO;
			}else if(
				$str.match(/pacific marine environmental lab/i) || 
				$str.match(/noaa/i) || 
				$str.match(/ndbc/i) || 
				$str.match(/coops/i) ||
				$str.match(/nws/i) ||
				$str.match(/wave watch iii/i) ||
				$str.match(/ndfd/i)
			){
				logo =  NOAA;
			}else if($str.match(/shell/i)){
				logo =  SHELL;
			}else if($str.match(/usgs/i)){
				logo =  USGS;
			}else if($str.match(/snotel/i)){
				logo =  SNOTEL;
			}else if($str.match(/stanford/i)){
				logo =  STANFORD;
			}else if($str.match(/institute of low temperature science/i)){
				logo =  INSTITUTE_OF_LOW_TEMPURATURE_SCIENCE;
			}else if($str.match(/whoi/i)){
				logo =  WHOI;
			}else if($str.match(/webcam/i)){
				logo =  WEBCAM;
			}else if($str.match(/washington applied physics/i)){
				logo =  APL_UW;
			}else if($str.match(/rusalca/i)){
				logo =  RUSALCA;
			}else if($str.match(/dot/i)){
				logo = DOT;
			}else if($str.match(/faa/i)){
				logo = FAA;
			}else if($str.match(/hads/i)){
				logo = HADS;
			}else if($str.match(/raws/i)){
				logo = RAWS;
			}else if(
				$str.match(/cnfaic/i) ||
				$str.match(/friends of the chugach/i)
			){
				logo = CNFAIC;
			}else if($str.match(/nasa/i)){
				logo = NASA;
			}else if($str.match(/region ocean modeling system/i)){
				logo = JPL;
			}else if($str.match(/alaska climate model|snap/i)){
				logo = SNAPP;
			}else if($str.match(/wrf/i)){
				logo = UAA;
			//right now, uaa gets all wrf..
			}else if($str.match(/nam-wrf/i)){
				logo = NAMWRF;
			}else if($str.match(/kachemak bay national estuarine/i)){
				logo = KBRR;
			}else if($str.match(/masie/i)){
				logo = NSIDC;
			}else if($str.match(/arsc/i)){
				logo = ARSC;
			}else if($str.match(/aoos/i)){
				logo = AOOS;
			}else if($str.match(/statoil/i)){
				logo = STATOIL;
			}else if($str.match(/hokkaido/i)){
				logo = HOKKAIDO;
			}else if($str.match(/pacific arctic group/i)){
				logo = PAG;
			}else if($str.match(/fairweather/i)){
				logo = FAIRWEATHER;
			}
			
			return logo;
		}
		
	}
}