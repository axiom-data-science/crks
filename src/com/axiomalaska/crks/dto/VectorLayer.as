package com.axiomalaska.crks.dto {
	// Generated May 25, 2011 4:36:19 PM by Hibernate Tools 3.2.2.GA
	
	[Bindable]
	[RemoteClass(alias="com.axiomalaska.crks.dto.VectorLayerDTO")]
	public class VectorLayer extends VectorLayerGenerated{
		
		override public function set hasTimeComponent($htc:Boolean):void{}
		override public function get hasTimeComponent():Boolean{
			if(this.timeProperty && this.startTimeUtc && this.endTimeUtc){
				return true;
			}
			return false;
		}
		
		private var _sldFile:String;
		public function set sldFile($sldFile:String):void{
			_sldFile = $sldFile;
		}
		public function get sldFile():String{
			return _sldFile;
		}
		
		override public function getLegendImageUrl():String{
			var l:String = legendImageUrl;
			if(l && hasSld){
				l += '&SLD=' + sldFile;
			}
			return l;
		}
	}
}