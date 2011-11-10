package com.axiomalaska.charts.base
{
	import mx.core.IVisualElement;

	public interface IAxiomChartContainer extends IVisualElement
	{
		function set childChartElements($childChartElements:Vector.<IAxiomChartElement>):void;
		function get childChartElements():Vector.<IAxiomChartElement>;
		
		function updateChildChartElements():void;
	}
}