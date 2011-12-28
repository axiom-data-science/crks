package com.axiomalaska.charts.base
{
	
	import com.axiomalaska.charts.scale.IScale;
	import com.axiomalaska.charts.skins.graphical_elements.AxiomChartGraphicalElement;
	
	import flash.geom.Point;
	
	import mx.core.IVisualElement;

	public interface IAxiomChartElement extends IVisualElement
	{
		
		function set graphicalElement($graphicalElement:AxiomChartGraphicalElement):void;
		function get graphicalElement():AxiomChartGraphicalElement;
		
		function set chartContainer($chartContainer:IAxiomChartContainer):void;
		function get chartContainer():IAxiomChartContainer;
		
		function get plottableItems():Vector.<AxiomChartPlottableItem>;
		
		function invalidate():void;
		function beforeRedraw():void;
		function redraw():void;
		function afterRedraw():void;
		
		
		function buildPlottableItems():void;
		function getPointAtValue($xAxisValue:Number,$yAxisValue:Number):Point;
		function getXAxisValueAtPoint($point:Point):Number;
		function getYAxisValueAtPoint($point:Point):Number;
		function getNearestPlottableItem($point:Point):AxiomChartPlottableItem;
		
		function createPlottableItem($object:Object,$point:Point = null,$label:String = null,$description:String = null):AxiomChartPlottableItem;
		function addPlottableItem($plottableItem:AxiomChartPlottableItem):void;
		function removePlottableItemAt($index:int):void;
		function removePlottableItem($plottableItem:AxiomChartPlottableItem):void;
		function getPlottableItemAt($index:int):AxiomChartPlottableItem;
		function getPlottableItemIndex($plottableItem:AxiomChartPlottableItem):int;
		function getPlottableItems():Vector.<AxiomChartPlottableItem>;
		function setPlottableItems($plottableItems:Vector.<AxiomChartPlottableItem>):void;
	}
}