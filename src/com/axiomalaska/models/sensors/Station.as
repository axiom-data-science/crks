package com.axiomalaska.models.sensors
{
	import com.axiomalaska.models.Contact;
	import com.axiomalaska.models.KeyedData;
	import com.axiomalaska.models.Spatial;
	import com.axiomalaska.models.Temporal;

	[Bindable]
	[RemoteClass(alias="MapAssets.Station")]
	public class Station extends KeyedData
	{
		
		public var id:String;
		public var label:String;
		public var sensors:Object;
		public var source:Source;
		public var contractor:Source;
		public var funding_source:Source;
		public var sensor_type:SensorType;
		public var status:Status;
		public var contact:Contact;
		public var website:String;
		public var datecomment:String;
		public var spatial:Spatial;
		public var temporal:Temporal;
		public var _dataavail:String;
		public var hasdata:Boolean;
		
		public function set dataavail($dataavail:String):void{
			_dataavail = $dataavail;
			if(dataavail.match(/t/i)){
				hasdata = true;
			}else{
				hasdata = false;
			}
		}
		public function get dataavail():String{return _dataavail};
	}
}