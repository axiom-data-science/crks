package com.axiomalaska.timeline.charts.line
{
	import com.axiomalaska.timeline.charts.axes.TimeLineItem;
	
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.GraphicsPathCommand;
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.collections.ArrayCollection;
	
	import spark.primitives.supportClasses.FilledElement;
	
	public class LineChartGraphicalElement extends FilledElement
	{
		
		
		public var dates:Vector.<Date> = new Vector.<Date>();
		public var data:Vector.<Vector> = new Vector.<Vector>();
		public var dateProperty:String = 'date';
		
		private var _dataMap:Object = {};
		
		/*private var _minDate:Date;
		private var _maxDate:Date;
		private var maxX:Number;
		private var maxY:Number;*/
		
		private var _segments:Vector.<TimeLineItem> = new Vector.<TimeLineItem>();
		
		public function get segments():Vector.<TimeLineItem>{
			return _segments;
		}
		public function set segments($segments:Vector.<TimeLineItem>):void{
			_segments = $segments;
			/*
			if(segments && segments.length > 0){
				_minDate = segments[0].date;
				_maxDate = segments[segments.length - 1].date;
				
			}
			*/
			invalidateDisplayList();
			
			
		}
		
		
		
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
		
		
		public function LineChartGraphicalElement()
		{
			super();
		}
		
		override protected function draw(g:Graphics):void{
			//g.clear();
			var th:int = height;
			
			var cntr:int = 0;
			
			var gx:Number = drawX;
			var gy:Number = drawY;
			
			//var ticks:int = (divisions) * subdivisions;
			
			//the bottom line
			_commands = new Vector.<int>;
			_data = new Vector.<Number>;
			_di = 0;
			_ci = 0;
			/*_commands[_ci++] = GraphicsPathCommand.MOVE_TO;
			_data[_di++] = gx;
			_data[_di++] = gy + height;
			
			_commands[_ci++] = GraphicsPathCommand.LINE_TO;
			_data[_di++] = gx + width;
			_data[_di++] = gy + height;
			*/
			
			//trace(segments.length + ' SEGMENTS!');
			
			if(segments && segments.length > 0){
				
				
				if(segments[0].point){
					_commands[_ci++] = GraphicsPathCommand.MOVE_TO;
					_data[_di++] = gx + segments[0].point.x;
					_data[_di++] = gy + segments[0].point.y;
				}

				var len:int = segments.length;
				var lastWasEmpty:Boolean = false;
				var nextIsEmpty:Boolean = false;
				
				
				for(var i:int = 0;i < len; i++){
					var segment:TimeLineItem = segments[i];
					
					if(segment.point){
						if((i + 1 < len && !segments[i + 1].point) ||
							i == 0 ||
							i == len
						){
							nextIsEmpty = true;
						}
						
						if(lastWasEmpty || nextIsEmpty){
							g.beginFill(0x000000);
							g.drawCircle(gx + segment.point.x,gy + segment.point.y,2);
							g.endFill();
							lastWasEmpty = false;
							nextIsEmpty = false;
						}
						_data[_di++] = gx + segment.point.x;
						_data[_di++] = gy + segment.point.y;
						_commands[_ci++] = GraphicsPathCommand.LINE_TO;
						


					}else{
						
						
						var next:TimeLineItem;
						var m:int = i + 1;
						if(m >= segments.length){
							m = 0;
						}
						next = segments[m];
						while(!next.point){
							if(m >= segments.length){
								m = 0;
							}
							next = segments[m];
							m ++;
						}

						
						_data[_di++] = gx + next.point.x;
						_data[_di++] = gy + next.point.y;
						_commands[_ci++] = GraphicsPathCommand.MOVE_TO;
						lastWasEmpty = true;
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
			
			
			g.drawPath(_commands, _data);
			//fill.begin(g,new Rectangle(0,0,width,height),new Point(0,0));
			
			//g.beginFill(0xCC0000,.5);
			//g.lineStyle(0,0,0);
			//g.lineTo(width,height);
			//g.lineTo(0,height);
			

		}
	}
}