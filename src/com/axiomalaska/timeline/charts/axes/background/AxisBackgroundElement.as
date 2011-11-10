package com.axiomalaska.timeline.charts.axes.background
{
	import spark.primitives.supportClasses.FilledElement;
	import com.axiomalaska.timeline.charts.axes.AxisItem;

	public class AxisBackgroundElement extends FilledElement
	{
		private var _segments:Vector.<AxisItem> = new Vector.<AxisItem>();
		
		public function get segments():Vector.<AxisItem>{
			return _segments;
		}
		public function set segments($segments:Vector.<AxisItem>):void{
			if(_segments != $segments){
				_segments = $segments;
				invalidateDisplayList();	
			}
		}
	}
}