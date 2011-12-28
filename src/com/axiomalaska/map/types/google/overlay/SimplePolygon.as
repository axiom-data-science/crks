package com.axiomalaska.map.types.google.overlay
{
	import com.axiomalaska.map.features.MapFeature;
	import com.axiomalaska.map.interfaces.ILatLon;
	import com.axiomalaska.models.LineSegment;
	import com.axiomalaska.utilities.Style;
	
	import flash.display.Sprite;
	
	public class SimplePolygon extends MapFeature
	{
		
		public var highlight:Sprite = new Sprite();
		public var line_segments:Array = new Array();
		
		public function SimplePolygon($line_segments:Array,$data:Object = null,$style:Style = null)
		{
			line_segments = $line_segments;
			super(null,$data,$style);
			this.setStyle();
			addChild(highlight);
		}
		
		public function setStyle():void{
			if(!style){
				style = new Style();
			}
				
			if(!style.polygon_fill_color){
				style.polygon_fill_color = 0xFF0000;
			}

			if(!style.polygon_fill_alpha){
				style.polygon_fill_alpha = .7;
			}
			
			if(!style.polygon_stroke_size){
				style.polygon_stroke_size = 5;
			}
			
			if(!style.polygon_stroke_color){
				style.polygon_stroke_color = 0x006633;
			}
			
			if(!style.polygon_stroke_alpha){
				style.polygon_stroke_alpha = 1;
			}			
			
			
			this.graphics.beginFill(style.polygon_fill_color,style.polygon_fill_alpha);
			this.graphics.lineStyle(style.polygon_stroke_size,style.polygon_stroke_size,style.polygon_stroke_size);

		}
		
	}
	
}