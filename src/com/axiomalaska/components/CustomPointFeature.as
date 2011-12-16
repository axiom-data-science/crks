package com.axiomalaska.components
{
	import flash.text.TextField;
	
	import org.openscales.core.feature.PointFeature;
	import org.openscales.core.geometry.Collection;
	import org.openscales.core.geometry.Point;
	import org.openscales.core.style.Style;
	import org.openscales.core.style.symbolizer.PointSymbolizer;
	import org.openscales.core.style.symbolizer.Symbolizer;
	
	public class CustomPointFeature extends PointFeature
	{
		public function CustomPointFeature(geom:Point=null, data:Object=null, style:Style=null, isEditionFeature:Boolean=false, editionFeatureParentGeometry:Collection=null)
		{
			super(geom, data, style, isEditionFeature, editionFeatureParentGeometry);
		}
		
		override public function draw():void {
			var i:int = this.numChildren;
			for (i; i > 0; i--) {
				this.removeChildAt(0);
			}
			super.draw();
			var txt:TextField = new TextField;
			txt.htmlText = 'TEST LABEL';
			txt.x = x;
			txt.y = y;
			this.addChild(txt);
			
		}		
		
		
		/*override protected function executeDrawing(symbolizer:Symbolizer):void {
			var x:Number;
			var y:Number;
			var resolution:Number = this.layer.map.resolution
			var dX:int = -int(this.layer.map.layerContainer.x) + this.left;
			var dY:int = -int(this.layer.map.layerContainer.y) + this.top;
			x = dX + point.x / resolution;
			y = dY - point.y / resolution;
			this.graphics.drawRect(x, y, 5, 5);
			

			if (symbolizer is PointSymbolizer) {
				var pointSymbolizer:PointSymbolizer = (symbolizer as PointSymbolizer);
				if (pointSymbolizer.graphic) {
					var render:DisplayObject = pointSymbolizer.graphic.getDisplayObject(this);
					var txt:TextField = new TextField;
					txt.htmlText = 'Test point label';
					render.addChild(txt);
					render.x += x;
					render.y += y;
					this.addChild(render);
				}
			}
		}*/		
		
	}
}


