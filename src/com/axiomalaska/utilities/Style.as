package com.axiomalaska.utilities
{
	public class Style
	{
		public var id:String;
		public var label:String;
		public var strokes:Object;
		
		public var point_fill_color:uint;
		public var point_fill_alpha:Number = 1;
		public var point_fill_highlight_color:uint;
		public var point_stroke_size:Number = 1;
		public var point_stroke_alpha:Number = 1;
		public var point_stroke_color:uint;
		public var point_size:Number;
		public var point_shape:String = 'circle';
		
		public var polygon_fill_color:uint;
		public var polygon_fill_alpha:Number = 1;
		public var polygon_highlight_color:uint;
		public var polygon_stroke_color:uint;
		public var polygon_stroke_size:int;
		public var polygon_stroke_alpha:Number = 1;
		public var polygon_size:Number;
		
		public function set alpha($alpha:Number):void{
			point_fill_alpha = $alpha;
		}
		public function get alpha():Number{
			return point_fill_alpha;
		}
		
		public function set color($color:uint):void{
			point_fill_color = $color;
		}
		public function get color():uint{
			return point_fill_color;
		}
		
		public function set highlight_color($highlight_color:uint):void{
			point_fill_highlight_color = $highlight_color;
		}
		public function get highlight_color():uint{
			return point_fill_highlight_color;
		}
		
		public function set stroke($stroke:uint):void{
			point_stroke_color = $stroke;
		}
		public function get stroke():uint{
			return point_stroke_color;
		}
		
		
		public function set strokeSize($strokeSize:Number):void{
			point_stroke_size = $strokeSize;
		}
		public function get strokeSize():Number{
			return point_stroke_size;
		}
		
		public function set strokeAlpha($strokeAlpha:Number):void{
			point_stroke_alpha = $strokeAlpha;
		}
		public function get strokeAlpha():Number{
			return point_stroke_alpha;
		}
		
		public function set size($size:Number):void{
			point_size = $size;
		}
		public function get size():Number{
			return point_size;
		}
		
		public function Style($obj:Object = null):void{
			if($obj){
				for(var p:String in $obj){
					
					if(p in this){
					//if(this[p]){
						this[p] = $obj[p];
					//}
					}
				}
			}
		}
		
		public function hasPointStyle():Boolean{
			if(point_fill_color || point_stroke_color || point_size || point_stroke_size){
				return true;
			}
			return false;
		}
		
		public function hasPolygonStyle():Boolean{
			if(polygon_fill_color || polygon_stroke_color || polygon_size || polygon_stroke_size){
				return true;
			}
			return false;
		}
	}
}