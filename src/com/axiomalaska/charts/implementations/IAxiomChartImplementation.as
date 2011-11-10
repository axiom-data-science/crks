package com.axiomalaska.charts.implementations
{
	import com.axiomalaska.charts.base.IAxiomChartElement;
	import com.axiomalaska.charts.scale.IScale;
	
	import mx.collections.ArrayCollection;
	import mx.core.IVisualElement;

	public interface IAxiomChartImplementation extends IAxiomChartElement
	{
		
		function set dataProvider($dataProvider:ArrayCollection):void;
		function get dataProvider():ArrayCollection;
		
		function set xField($xField:String):void;
		function get xField():String;
		
		function set yField($yField:String):void;
		function get yField():String;
		
		function set labelField($labelField:String):void;
		function get labelField():String;
		
		function set horizontalScale($horizontalScale:IScale):void;
		function get horizontalScale():IScale;
		
		function set verticalScale($verticalScale:IScale):void;
		function get verticalScale():IScale;
		
		
		
	}
}