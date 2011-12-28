package com.axiomalaska.crks.dto {
	import com.axiomalaska.map.interfaces.IOGCLayer;

	// Generated May 25, 2011 4:36:19 PM by Hibernate Tools 3.2.2.GA
	
	[Bindable]
	[RemoteClass(alias="com.axiomalaska.crks.dto.OgcLayerDTO")]
	public class OgcLayer extends OgcLayerGenerated implements IOGCLayer{
		
		private var _legendImageUrl:String;
		override public function set legendImageUrl($legendImageUrl:String):void{
			_legendImageUrl = $legendImageUrl;
		}
		override public function get legendImageUrl():String{
			if(!_legendImageUrl){
				_legendImageUrl = this.wmsUrl + '?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&STRICT=false&LAYER=' + this.ogcName + '&HORIZONTAL=true&SHOWLABEL=false';
			}
			return _legendImageUrl;
		}
		
		override public function getUrlKey():String{
			return ogcName;
		}
		
		
		
		private var _wmsUrl:String;
		
		override public function set wmsUrl($wmsUrl:String):void{
			//if($wmsUrl.match('proxy.axiomalaska.com')){
				//var rand:int = Math.floor(Math.random() * (1+9-0)) + 0;
				//var rand:int = 3;
			$wmsUrl = $wmsUrl.replace('proxy.axiomalaska.com','proxy' + Math.floor(Math.random() * (1+9-0)) + '.axiomalaska.com');
			_wmsUrl = $wmsUrl;
				//trace('LOOK!! ==> ' + _wmsUrl);
			//}
			_wmsUrl = $wmsUrl;
		}
		
		override public function get wmsUrl():String{
			return _wmsUrl;
		}
		
		
		
		/*
		private var _url_key:String;
		override public function set url_key($url_key:String):void{
			_url_key = $url_key;
		}	
		override public function get url_key():String{
			if(ogcName){
				url_key = ogcName;
			}
			return _url_key;
		}
		*/

	}
}