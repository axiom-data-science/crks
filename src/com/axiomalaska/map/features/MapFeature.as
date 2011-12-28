package com.axiomalaska.map.features
{
	import com.axiomalaska.map.interfaces.ILatLon;
	import com.axiomalaska.map.interfaces.ILayer;
	import com.axiomalaska.map.interfaces.IMapFeature;
	import com.axiomalaska.map.interfaces.IMapFeatureMetaData;
	import com.axiomalaska.utilities.Style;
	
	import flash.display.LineScaleMode;
	import flash.display.Sprite;
	
	[Bindable]
	public class MapFeature extends Sprite implements IMapFeature
	{
		
		private var _id:String;
		private var _latlon:ILatLon;
		private var _data:Object;
		private var _layer:ILayer;
		private var _meta_data:IMapFeatureMetaData;
		private var _style:Style;

		
		
		public function MapFeature($latlon:ILatLon,$data:Object = null,$style:Style = null, $layer:ILayer = null)
		{
			latlon = $latlon;
			if($data){
				data = $data;
				if($data.hasOwnProperty('id')){
					id = $data.id;
					name = $data.id;
				}
			}
			
			if($style){
				style = $style;
			}
			
			if($layer){
				layer = $layer;
			}
		}
		
		public function get id():String{
			return _id;
		}
		public function set id($id:String):void{
			_id = $id;
		}
		
		public function get latlon():ILatLon
		{
			return _latlon;
		}
		public function set latlon($latlon:ILatLon):void
		{
			_latlon = $latlon
		}
		
		public function get data():Object
		{
			return _data;
		}
		public function set data($data:Object):void
		{
			_data = $data;
		}
		
		public function get meta_data():IMapFeatureMetaData{
			return _meta_data;	
		}
		public function set meta_data($meta_data:IMapFeatureMetaData):void{
			_meta_data = $meta_data;
		}
		
		public function get style():Style
		{
			return _style;
		}
		public function set style($style:Style):void
		{
			_style = $style;
		}
		
		public function get layer():ILayer{
			return _layer;
		}
		public function set layer($layer:ILayer):void{
			$layer = _layer;
		}
		
		public function draw():void{
			if(style){
				var doDraw:Boolean = false;
				if(style && style.size){
					if(style.point_fill_color){
						this.graphics.beginFill(style.point_fill_color,style.point_fill_alpha);
						doDraw = true;
					}
					if(style.point_stroke_color){
						this.graphics.lineStyle(style.point_stroke_size,style.point_stroke_color,style.point_stroke_alpha,false,LineScaleMode.NONE);
						doDraw = true;
					}
				}
				if(doDraw){
					this.graphics.drawCircle(0,0,style.size);
				}
			}
		}
	}
}