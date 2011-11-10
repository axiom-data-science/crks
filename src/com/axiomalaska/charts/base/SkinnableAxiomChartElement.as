package com.axiomalaska.charts.base
{
	import com.axiomalaska.charts.events.ChartElementEvent;
	import com.axiomalaska.charts.scale.AbstractScale;
	import com.axiomalaska.charts.scale.IScale;
	import com.axiomalaska.charts.skins.graphical_elements.AxiomChartGraphicalElement;
	
	import flash.events.Event;
	import flash.geom.Point;
	
	import spark.components.SkinnableContainer;
	import spark.components.supportClasses.SkinnableComponent;
	
	[Event(name="chart_element_invalidate")]
	
	public class SkinnableAxiomChartElement extends SkinnableComponent implements IAxiomChartElement
	{
		
		/* TEMPLATE VARS */
		
		private var _graphicalElement:AxiomChartGraphicalElement;
		
		[SkinPart(required="false")]
		public function set graphicalElement($graphicalElement:AxiomChartGraphicalElement):void{
			if(_graphicalElement != $graphicalElement){
				_graphicalElement = $graphicalElement;
			}
			
		}
		public function get graphicalElement():AxiomChartGraphicalElement{
			return _graphicalElement;
		}
		

		
		/* PUBLIC VARS */

		private var _chartContainer:IAxiomChartContainer;
		
		public function set chartContainer($chartContainer:IAxiomChartContainer):void{
			if(_chartContainer != $chartContainer){
				_chartContainer = $chartContainer;
			}
		}
		public function get chartContainer():IAxiomChartContainer{
			return _chartContainer;
		}
		
		/* PUBLIC FUNCTIONS */
		
		[Bindable]
		public var plottableItemLabelFormatFunction:Function = defaultPlottableLabelFormatFunction;
		
		private function defaultPlottableLabelFormatFunction($value:Number):String{
			return $value.toString();
		}
		
		
		[Bindable]
		public var plottableItemValueFormatFunction:Function;
		
		[Bindable]
		public var plottablePointFormatFunction:Function;
		
		public function get plottableItems():Vector.<AxiomChartPlottableItem>{
			return _plottableItems;
		}
		
		private var _plottableItems:Vector.<AxiomChartPlottableItem> = new Vector.<AxiomChartPlottableItem>();
		
		public function createPlottableItem($object:Object,$point:Point = null,$label:String = null,$description:String = null):AxiomChartPlottableItem{
			
			var ai:AxiomChartPlottableItem = new AxiomChartPlottableItem();
			
			ai.value = $object;
			
			if(Boolean(plottableItemValueFormatFunction)){
				ai.value = plottableItemValueFormatFunction.call(this,ai.value);
			}
			
			if(Boolean(plottableItemLabelFormatFunction)){
				ai.label = plottableItemLabelFormatFunction.call(this,ai.value);
			}else if($label){
				ai.label = $label;
			}
			
			ai.description = $description;
			if($point){
				ai.point = $point;
			}else if(Boolean(plottablePointFormatFunction)){
				ai.point = plottablePointFormatFunction.call(this,$object);
			}

			return ai;
		}
		
		public function addPlottableItem($plottableItem:AxiomChartPlottableItem):void{
			if(_plottableItems.indexOf($plottableItem) < 0){
				_plottableItems.unshift($plottableItem);
				invalidate();
			}
		}
		
		public function removePlottableItemAt($index:int):void{
			if(_plottableItems.splice($index,1)){
				invalidate();
			}
		}
		
		public function removePlottableItem($plottableItem:AxiomChartPlottableItem):void{
			//invalidation handled by removePlottableItemAt
			removePlottableItemAt(getPlottableItemIndex($plottableItem));			
		}
		
		public function getPlottableItemAt($index:int):AxiomChartPlottableItem{
			return _plottableItems[$index];
		}
		
		public function getPlottableItemIndex($plottableItem:AxiomChartPlottableItem):int{
			return _plottableItems.indexOf($plottableItem);
		}
		
		public function getPlottableItems():Vector.<AxiomChartPlottableItem>{
			return _plottableItems;
		}
		
		public function setPlottableItems($plottableItems:Vector.<AxiomChartPlottableItem>):void{
			//if(!_plottableItems || ($plottableItems && _plottableItems.length != $plottableItems.length)){
			if(_plottableItems != $plottableItems){
				_plottableItems = $plottableItems;
				//invalidate();
			}
		}
		
		
		
		//THIS SHOULD TRIGGER THE PARENT CHART TO REBUILD EVERYTHING
		public function invalidate():void{
			if(readyForRedraw()){
				dispatchEvent(new ChartElementEvent(ChartElementEvent.CHART_ELEMENT_INVALIDATE,this));
			}
		}
		
	
		
		public function getPointAtValue($xAxisValue:Number,$yAxisValue:Number):Point{
			var pt:Point;
			
			return pt;
		}
		
		public function getXAxisValueAtPoint($point:Point):Number{
			var xVal:Number;
			
			return xVal;
			
		}
		public function getYAxisValueAtPoint($point:Point):Number{
			var yVal:Number;
			
			return yVal;
			
		}
		public function getNearestPlottableItem($point:Point):AxiomChartPlottableItem{			
			var ai:AxiomChartPlottableItem;
			
			return ai;
			
		}
		
		public function readyForRedraw():Boolean{
			return false;
		}
		
		public function buildPlottableItems():void{
			
		}
		
		public function beforeRedraw():void{
			
		}
		
		public function afterRedraw():void{
			
		}
		
		
		public function redraw():void{
			if(readyForRedraw()){
				beforeRedraw();
				buildPlottableItems();
				if(graphicalElement && plottableItems && plottableItems.length > 0){
					graphicalElement.segments = plottableItems;
				}
				commitProperties();
				invalidateProperties();
				invalidateDisplayList();
				afterRedraw();
			}
		}
		
		
	}
}