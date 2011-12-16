package com.axiomalaska.charts.skins.graphical_elements
{
	import flash.display.Graphics;
	import flash.display.GraphicsPathCommand;

	public class HorizontalGridLines extends AxiomChartGraphicalElement
	{
		
		override protected function draw(g:Graphics):void{
			var gx:Number = drawX;
			var gy:Number = drawY;
			
			//reset indexes for drawing commands
			
			
			_ci = 0;
			_di = 0;
			
			
			
			var cntr:int = 0;
			
			
			//prepare drawing commands for tick lines
			if(segments){
				while (cntr < segments.length) {
					
					
					//Tick
					if(segments[cntr].point){
						_commands[_ci++] = GraphicsPathCommand.MOVE_TO;
						_data[_di++] = gx + segments[cntr].point.x;
						_data[_di++] = 0;
						
						_commands[_ci++] = GraphicsPathCommand.LINE_TO;
						_data[_di++] = gx + segments[cntr].point.x;
						_data[_di++] = height;
					}
					
					cntr++;
					
				}
			}
			
			//since we are reusing command and data vectors over multiple passses clear out unnecessary data from former pass
			//TODO. Actually make caching work so that if no parameters changed, chached drawing is enabled.
			if (_ci != _commands.length)
			{
				_commands.splice(_ci, _commands.length - _ci);
				_data.splice(_di, _data.length - _di);
			}
			
			g.drawPath(_commands, _data);
		}
		
		
	}
}