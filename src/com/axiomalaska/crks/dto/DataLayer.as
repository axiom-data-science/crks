package com.axiomalaska.crks.dto {
	// Generated May 25, 2011 4:36:19 PM by Hibernate Tools 3.2.2.GA
	
	[Bindable]
	[RemoteClass(alias="com.axiomalaska.crks.dto.DataLayerDTO")]
	public class DataLayer extends DataLayerGenerated{
		public var amfDataService:AmfDataService;
		
		private var _alpha:Number = 100;
		override public function set alpha($alpha:Number):void{
			_alpha = $alpha;
			if(mapLayer){
				mapLayer.alpha = _alpha;
			}
			
		}
		override public function get alpha():Number{
			return _alpha;
		}
		
		
	}
}