package com.axiomalaska.map.types.google
{
	import com.axiomalaska.map.features.MapFeature;
	import com.axiomalaska.map.interfaces.ILayer;
	import com.axiomalaska.utilities.Style;
	import com.google.maps.interfaces.IProjection;
	import com.google.maps.interfaces.ITileLayer;
	import com.google.maps.overlays.TileLayerOverlay;
	
	public class GoogleTileLayer extends TileLayerOverlay implements ILayer
	{
		public function GoogleTileLayer($tileLayer:ITileLayer, $tileSize:int=256, $projection:IProjection=null)
		{
			super($tileLayer, $tileSize, $projection);
		}
		
		public function hide():void{
			this.foreground.visible = false;
		}
		
		public function show():void{
			this.foreground.visible = true;
		}
		
		public function redraw():void{
			if(this.pane){
				this.pane.invalidate();
			}
		}
		
		private var _alpha:Number;
		public function set alpha($alpha:Number):void{
			_alpha = $alpha;
			this.foreground.alpha = _alpha / 100;
		}
		public function get alpha():Number{
			return _alpha;
		}
		
		private var _id:String;
		public function set id($id:String):void{
			_id = $id;
		}
		public function get id():String{
			return _id;
		}
		
		
		private var _name:String;
		public function get name():String
		{
			return _name;
		}
		
		public function set name($name:String):void
		{
			_name = $name;
		}
		
		private var _features:Array;
		public function get features():Array{
			return _features;
		}
		public function set features($features:Array):void{
			_features = $features;
		}
		
		
		private var _style:Style;
		public function get style():Style
		{
			return _style;
		}
		
		public function set style($style:Style):void
		{
			_style = $style;
		}
		
		
		private var _zindex:int = -1;
		public function get zindex():int
		{
			return _zindex;
		}
		
		public function set zindex($zindex:int):void
		{
			_zindex = $zindex;
		}
		
		public function addFeature($feature:MapFeature):void
		{
		}
		
		public function removeAllFeatures():void
		{
		}
		
		public function removeFeature($feature:MapFeature):void
		{
		}
		
		public function draw():void
		{
		}
	}
}