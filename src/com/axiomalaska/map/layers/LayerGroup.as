package com.axiomalaska.map.layers
{
	import com.axiomalaska.map.interfaces.ILayerGroup;
	
	import mx.collections.ArrayCollection;
	
	[Bindable]
	public class LayerGroup implements ILayerGroup
	{
		public function LayerGroup($params:Object =null)
		{
			for(var p:String in $params){
				if(p in this){
					this[p] = $params[p];
				}
			}
		}
		
		private var _id:int;
		public function set id($id:int):void
		{
			_id = $id;
		}
		
		public function get id():int
		{
			return _id;
		}
		
		private var _label:String;
		public function set label($label:String):void
		{
			_label = $label;
		}
		
		public function get label():String
		{
			return _label;
		}
		
		private var _zindex:int;
		public function set zindex($zindex:int):void
		{
			_zindex = $zindex;
		}
		
		public function get zindex():int
		{
			return _zindex;
		}
		
		private var _layers:ArrayCollection;
		public function set layers($layers:ArrayCollection):void{
			_layers = $layers;
		}
		public function get layers():ArrayCollection{
			return _layers;
		}
	}
}