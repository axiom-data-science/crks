package com.axiomalaska.charts.skins.graphical_elements
{
	import com.axiomalaska.charts.base.AxiomChartPlottableItem;
	
	import flash.display.Graphics;
	import flash.display.GraphicsPathCommand;

	public class PointChartGraphicalElement extends AxiomChartGraphicalElement
	{
		
		[Bindable]
		public var strokeColor:uint;
		
		[Bindable]
		public var strokeWeight:int;
		

		override protected function draw(g:Graphics):void{
			
			//trace('DRAWING LINE');
			
			g.lineStyle(strokeWeight,strokeColor,.5,false);
			g.beginFill(strokeColor);
			
			
			var cntr:int = 0;
			
			var gx:Number = drawX;
			var gy:Number = drawY;
			
			_commands = new Vector.<int>;
			_data = new Vector.<Number>;
			_di = 0;
			_ci = 0;

			
			if(segments && segments.length > 0){
				
				var len:int = segments.length;
				
				
				for(var i:int = 0;i < len; i++){
					var segment:AxiomChartPlottableItem = segments[i];
					
					if(segment.point){

						//g.drawCircle(gx + segment.point.x,gy + segment.point.y,2);
						g.drawEllipse(gx + segment.point.x,gy + segment.point.y,4,4);
						
						
					}
					
					
				}
			}
			
			
			if (_ci != _commands.length)
			{
				_commands.splice(_ci, _commands.length - _ci);
				_data.splice(_di, _data.length - _di);
			}
			

			g.endFill();
			
		}
		
	}
}