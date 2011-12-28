package com.axiomalaska.charts.skins.graphical_elements
{
	import com.axiomalaska.charts.base.AxiomChartPlottableItem;
	
	import spark.primitives.supportClasses.FilledElement;
	
	public class AxiomChartGraphicalElement extends FilledElement
	{

		private var _segments:Vector.<AxiomChartPlottableItem> = new Vector.<AxiomChartPlottableItem>();
		
		public function get segments():Vector.<AxiomChartPlottableItem>{
			return _segments;
		}
		public function set segments($segments:Vector.<AxiomChartPlottableItem>):void{
			//if(_segments != $segments){
				_segments = $segments;
				invalidateDisplayList();
			//}
		}
		
		public function redraw():void{
			invalidateDisplayList();
		}
		
		
		/**
		 * Commands to draw the tick lines 
		 */
		protected var _commands:Vector.<int> = new Vector.<int>();
		
		/**
		 * Data to draw the tick lines 
		 */
		protected var _data:Vector.<Number> = new Vector.<Number>();
		
		/**
		 * Index for drawing commands 
		 */
		protected var _ci:int = 0;
		
		/**
		 * Index for data commands 
		 */
		protected var _di:int = 0;
		
		
	}
}