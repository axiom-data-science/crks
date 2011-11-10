package com.axiomalaska.models
{
	[Bindable]
	[RemoteClass(alias="MapAssets.Temporal")]
	public class Temporal extends KeyedData
	{
		private var _startdate:Date;
		public function set startdate($startdate:*):void{
			_startdate = _setDate($startdate);
		}
		public function get startdate():Date{
			return _startdate;
		}

		
		public var start_date_print:String;
		public var end_date_print:String;
		public var date_print:String;
		
		private var _enddate:Date;
		public function set enddate($enddate:*):void{
			_enddate = _setDate($enddate);
		}
		public function get enddate():Date{
			return _enddate;
		}
		
		private var _distinctdate:Date;
		public function set distinctdate($distinctdate:*):void{
			_distinctdate = _setDate($distinctdate);
		}
		public function get distinctdate():Date{
			return _distinctdate;
		}
		
		private function _setDate($date:*):Date{
			
			var _type:String = typeof($date);
			if(_type == 'string'){
				$date = $date.replace(/-/g,'/');
				//trace($date);
				return new Date($date);
			}else{
				return $date;
			}
			return null;
			
		}
		
		public var label:String;
	}
}