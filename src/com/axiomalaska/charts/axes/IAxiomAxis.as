package com.axiomalaska.charts.axes
{
	import com.axiomalaska.charts.base.AxiomChartPlottableItem;
	import com.axiomalaska.charts.scale.IScale;
	
	import flash.geom.Point;
	
	import mx.core.IVisualElement;
	
	public interface IAxiomAxis extends IVisualElement
	{
		
		function set scale($scale:IScale):void;
		function get scale():IScale;
		
		function set axisItemInterval($axisItemInterval:Number):void;
		function get axisItemInterval():Number;
		
		function set axisStartValue($axisStartValue:Number):void;
		function get axisStartValue():Number;
		
		function set minSegmentSize($minSegmentSize:Number):void;
		function get minSegmentSize():Number;
		
		function set axisItemIntervalCalculator($axisItemIntervalCalculator:Function):void;
		function get axisItemIntervalCalculator():Function;
		
		

		
	}
}