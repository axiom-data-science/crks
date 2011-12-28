package com.axiomalaska.map.features
{
	import com.axiomalaska.map.interfaces.IMapFeatureMetaData;
	import com.axiomalaska.models.MetaLabel;
	
	[Bindable]
	public class MapFeatureMetaData implements IMapFeatureMetaData
	{
		
		public var data:Object = new Object();
		
		private var _fields:Array = [];
		public function get fields():Array{
			return _fields;
		}
		public function set fields($fields:Array):void{
			_fields = $fields;
		}
		
		private var _label:MetaLabel;
		public function get label():MetaLabel{
			return _label;
		}
		public function set label($label:MetaLabel):void{
			_label = $label;
		}

		private var _summary:String;
		public function get summary():String{
			return summary;
		}
		public function set summary($summary:String):void{
			_summary = $summary;
		}	
		
		private var _logo:String;
		public function get logo():String{
			return logo;
		}
		public function set logo($logo:String):void{
			_logo = $logo;
		}
		
		
		public function MapFeatureMetaData()
		{
		}
	}
}