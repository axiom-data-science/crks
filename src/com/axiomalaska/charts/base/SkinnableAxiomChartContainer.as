package com.axiomalaska.charts.base
{
	import com.axiomalaska.charts.axes.HorizontalAxis;
	import com.axiomalaska.charts.axes.VerticalAxis;
	import com.axiomalaska.charts.events.ChartElementEvent;
	import com.axiomalaska.charts.implementations.IAxiomChartImplementation;
	import com.axiomalaska.charts.skins.DefaultAxiomChartContainerSkin;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	
	import spark.components.Group;
	import spark.components.SkinnableContainer;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.primitives.supportClasses.FilledElement;
	import spark.skins.spark.SkinnableContainerSkin;
	

	[Style(name="gutterLeft", type="Number")]
	[Style(name="gutterRight", type="Number")]
	[Style(name="gutterTop", type="Number")]
	[Style(name="gutterBottom", type="Number")]
	
	public class SkinnableAxiomChartContainer extends SkinnableContainer implements IAxiomChartContainer
	{
		
		[SkinPart(required="false")]
		public var horizontalAxisDisplay:Group;
		
		[SkinPart(required="false")]
		public var verticalAxisDisplay:Group;
		
		[SkinPart(required="false")]
		public var chartImplementationDisplay:Group;
		
		[SkinPart(required="false")]
		public var backgroundDisplay:Group;
		
		[SkinPart(required="false")]
		public var foregroundDisplay:Group; 
		
		/* PUBLIC VARS */
		
		/* TEMPLATING VARS */
		[Bindable]
		public var horizontalAxes:Vector.<HorizontalAxis>;
		
		[Bindable]
		public var verticalAxes:Vector.<VerticalAxis>;
		
		[Bindable]
		public var chartImplementations:Vector.<IAxiomChartImplementation>;
		
		[Bindable]
		public var backgroundElements:Array;
		
		[Bindable]
		public var foregroundElements:Array;
		
		
		private var _childChartElements:Vector.<IAxiomChartElement> = new Vector.<IAxiomChartElement>;
		
		public function set childChartElements($childChartElements:Vector.<IAxiomChartElement>):void{
			if(_childChartElements != $childChartElements){
				_childChartElements = $childChartElements;
				updateChildChartElements();
			}
		}
		
		public function get childChartElements():Vector.<IAxiomChartElement>{
			return _childChartElements;
		}
		
		public function addImplementation($chart_implementation:IAxiomChartImplementation):void{
			if(chartImplementations.indexOf($chart_implementation) < 0){
				chartImplementations.push($chart_implementation);
				chartImplementationDisplay.addElement($chart_implementation);
				childChartElements.unshift($chart_implementation);
				attachAxiomChartElementEventListeners($chart_implementation);
				updateChildChartElements();
				
				
				trace('added it!');
				/*
				chartImplementationDisplay.addElement($chart_implementation);
				childChartElements.unshift($chart_implementation);
				attachAxiomChartElementEventListeners($chart_implementation);
				*/
			}
		}
		
		/* OVERRIDES */
		override protected function partAdded(partName:String, instance:Object):void{
			super.partAdded(partName, instance);
			
			if(verticalAxes !== null && instance == verticalAxisDisplay)
				for each(var verticalAxis:VerticalAxis in verticalAxes){
					verticalAxisDisplay.addElement(verticalAxis);
				}
				
			
			if(horizontalAxes !== null && instance == horizontalAxisDisplay)
				for each(var horizontalAxis:HorizontalAxis in horizontalAxes){
					horizontalAxisDisplay.addElement(horizontalAxis);
				}
			
			if(chartImplementations !== null && instance == chartImplementationDisplay)
				for each(var chartImplementation:IAxiomChartImplementation in chartImplementations){
					chartImplementationDisplay.addElement(chartImplementation);
				}
			
			
			if(foregroundElements !== null && instance == foregroundDisplay)
				for each(var foregroundElement:IVisualElement in foregroundElements){
					foregroundDisplay.addElement(foregroundElement);
				}
			
			if(backgroundElements !== null && instance == backgroundDisplay)
				for each(var backgroundElement:IVisualElement in backgroundElements){
					backgroundDisplay.addElement(backgroundElement);
				}
				
			
			if(instance is Group){
				var i:int = 0;
				while(i < (instance as Group).numElements){	
					if(instance.getElementAt(i) is IAxiomChartElement){
						childChartElements.unshift((instance as Group).getElementAt(i));
						attachAxiomChartElementEventListeners(instance.getElementAt(i) as IAxiomChartElement);
					}
					
					i ++;
				}
				updateChildChartElements();
			}
			
		}
		
		
		private function attachAxiomChartElementEventListeners($chartElement:IAxiomChartElement):void{
			$chartElement.addEventListener(ChartElementEvent.CHART_ELEMENT_INVALIDATE,onChartElementInvalidate);
		}
		
		private function onChartElementInvalidate($evt:ChartElementEvent):void{
			updateChildChartElements();
		}
		
		private function removeAxiomChartElementEventListeners($chartElement:IAxiomChartElement):void{
			$chartElement.removeEventListener(ChartElementEvent.CHART_ELEMENT_INVALIDATE,onChartElementInvalidate);
		}
		
		override protected function partRemoved(partName:String, instance:Object):void{
			super.partRemoved(partName, instance);
			
			//CLEAN UP childChartElements before actually removing elements
			if(instance is Group){
				var i:int = 0;
				while(i < (instance as Group).numElements){
					if(instance.getElementAt(i) is IAxiomChartElement)
						childChartElements.splice(childChartElements.indexOf((instance as Group).getElementAt(i)),i);
					i ++;
				}
			}
			
			if(verticalAxes !== null && instance == verticalAxisDisplay)
				for each(var verticalAxis:HorizontalAxis in horizontalAxes){
					verticalAxisDisplay.removeElement(verticalAxis);
				}
			
			
			if(horizontalAxes !== null && instance == horizontalAxisDisplay)
				for each(var horizontalAxis:HorizontalAxis in horizontalAxes){
					horizontalAxisDisplay.removeElement(horizontalAxis);
				}
			
			if(chartImplementations !== null && instance == chartImplementationDisplay)
				for each(var chartImplementation:IAxiomChartImplementation in chartImplementations){
					chartImplementationDisplay.removeElement(chartImplementation);
				}
			
			if(foregroundElements !== null && instance == foregroundDisplay)
				for each(var foregroundElement:IVisualElement in foregroundElements){
					foregroundDisplay.removeElement(foregroundElement);
				}
			
			if(backgroundElements !== null && instance == backgroundDisplay)
				for each(var backgroundElement:IVisualElement in backgroundElements){
					backgroundDisplay.removeElement(backgroundElement);
				}
			
		}

		/* PUBLIC FUNCTIONS */	
		public function updateChildChartElements():void{	
			for each(var childElement:IAxiomChartElement in childChartElements){
				childElement.redraw();
			}
		}
		

		
		
		/* PRIVATE FUNCTIONS */
		
		
	}
}