package com.axiomalaska.timeline.charts.axes.background
{
	import flash.display.Graphics;
	import flash.display.GraphicsPathCommand;
	
	import spark.primitives.supportClasses.FilledElement;
	
	
	
	public class TimeLineGraphicElement extends AxisBackgroundElement
	{
		
		
		/**
		 * Commands to draw the tick lines 
		 */
		private var _commands:Vector.<int> = new Vector.<int>();
		
		/**
		 * Data to draw the tick lines 
		 */
		private var _data:Vector.<Number> = new Vector.<Number>();
		
		/**
		 * Index for drawing commands 
		 */
		private var _ci:int = 0;
		
		/**
		 * Index for data commands 
		 */
		private var _di:int = 0;
		
		[Bindable]
		public var backgroundColor:uint = 0x000000;
		
		
		
		
		
		public function TimeLineGraphicElement()
		{
			super();
		}
		
		override protected function draw(g:Graphics):void
		{
			
			//get root coordinates for this graphic element relative to the drawnDisplayObject
			//coordinates of this graphical element must be taken into account
			//coordinates to draw to relative to the drawnDisplayObject might not start at 0, 0 but at drawX, drawY
			//since display object might be shared
			var gx:Number = drawX;
			var gy:Number = drawY;
			
			//reset indexes for drawing commands
			
			
			_ci = 0;
			_di = 0;
			
			//current height of tickline to draw
			var th:int = height;
			
			var cntr:int = 0;
			
			//var ticks:int = (divisions) * subdivisions;
			
			//the bottom line
			/*
			_commands[_ci++] = GraphicsPathCommand.MOVE_TO;
			_data[_di++] = gx;
			_data[_di++] = gy + height;
			
			_commands[_ci++] = GraphicsPathCommand.LINE_TO;
			_data[_di++] = gx + width;
			_data[_di++] = gy + height;
			*/
			
			//prepare drawing commands for tick lines
			if(segments){
				while (cntr < segments.length) {
					
					th = 0;
					
					//Tick
					_commands[_ci++] = GraphicsPathCommand.MOVE_TO;
					_data[_di++] = gx + segments[cntr].point.x;
					_data[_di++] = gy + height;
					
					_commands[_ci++] = GraphicsPathCommand.LINE_TO;
					_data[_di++] = gx + segments[cntr].point.x;
					_data[_di++] = gy + th;
					
					
					
					cntr++;
					if(cntr < segments.length){

						_commands[_ci++] = GraphicsPathCommand.LINE_TO;
						_data[_di++] = gx + segments[cntr].point.x;
						_data[_di++] = gy + th;
						
						_commands[_ci++] = GraphicsPathCommand.LINE_TO;
						_data[_di++] = gx + segments[cntr].point.x;
						_data[_di++] = gy + height;
						
						
						cntr++;
					}else if(cntr == segments.length){
						_commands[_ci++] = GraphicsPathCommand.LINE_TO;
						_data[_di++] = gx + width;
						_data[_di++] = gy + th;
						
						_commands[_ci++] = GraphicsPathCommand.LINE_TO;
						_data[_di++] = gx + width;
						_data[_di++] = gy + height;
					}
				}
			}
			
			//since we are reusing command and data vectors over multiple passses clear out unnecessary data from former pass
			//TODO. Actually make caching work so that if no parameters changed, chached drawing is enabled.
			if (_ci != _commands.length)
			{
				_commands.splice(_ci, _commands.length - _ci);
				_data.splice(_di, _data.length - _di);
			}
			
			//g.drawRect(gx, gy, width, height);
			//g.endFill();
			//g.beginFill(0xEDEDED);
			//g.drawRect(gx,gy,width,height);
			//g.beginFill(backgroundColor);
			g.drawPath(_commands, _data);

			
			
			
		}
		
		
	}
}