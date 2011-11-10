package com.axiomalaska.models.sensors
{
	import com.axiomalaska.models.KeyedData;

	[RemoteClass(alias="MapAssets.Status")]
	public class Status extends KeyedData
	{
		public var id:String;
		public var label:String;
		public var selected:Boolean;
		private var _status:String;
		
		public function set status($status:String):void{
			_status = $status;
			label = status;
		}
		public function get status():String{
			return _status;
		}
	}
}
