package com.axiomalaska.charts.axes
{
	import com.axiomalaska.charts.axes.labels.AxiomChartAxisLabel;
	import com.axiomalaska.charts.base.AxiomChartPlottableItem;
	import com.axiomalaska.charts.base.SkinnableAxiomChartElement;
	import com.axiomalaska.charts.scale.AbstractScale;
	import com.axiomalaska.charts.scale.IScale;
	import com.axiomalaska.charts.scale.ScaleUtils;
	import com.axiomalaska.charts.skins.graphical_elements.AxiomChartGraphicalElement;
	
	import flash.events.Event;
	import flash.geom.Point;
	
	import mx.core.IFactory;
	import mx.events.FlexEvent;
	
	import spark.components.Group; 
	import spark.components.supportClasses.SkinnableComponent;
	
	
	
	[Style(name="bgColor", format="Color", type="uint")]
	
	public class SkinnableAxis extends SkinnableAxiomChartElement implements IAxiomAxis
	{
		
		/* SKIN PARTS */
		[SkinPart("false")]
		public var labelDisplay:Group;
		
		[SkinPart(required="true")]
		public var segmentLabel:IFactory;

		
		/* PUBLIC VARIABLES */	
		
		private var _dataChanged:Boolean = false;
		
		private var _scale:IScale;
		
		[Bindable]
		public function set scale($scale:IScale):void{
			if(_scale != $scale){
				_scale = $scale;
				addScaleListeners();				
				_dataChanged = true;
				invalidate();
			}
		}
		public function get scale():IScale{
			return _scale;
		}
		
		private function addScaleListeners():void {
			AbstractScale(_scale).addEventListener("invalidate",onScaleChange);
			AbstractScale(_scale).addEventListener("dataFieldChange",onScaleChange);
			AbstractScale(_scale).addEventListener("minValueChange",onScaleChange);
			AbstractScale(_scale).addEventListener("maxValueChange",onScaleChange);
			AbstractScale(_scale).addEventListener("maxLayoutChange",onScaleChange);
		}
		
		private function removeScaleListeners():void {
			if (!_scale) return;
			AbstractScale(_scale).removeEventListener("invalidate",onScaleChange);
		}
		
		private function onScaleChange(e:Event):void {
			//_minMaxAdjusted = false;
			//adjustScaleMinMax();
			_dataChanged = true;
			invalidate();
		}
		
		/*
		[Bindable]
		public var scaleMinMaxFormatFunction:Function;
		
		private var _minMaxAdjusted:Boolean = false;
		private function adjustScaleMinMax():void{
			if(scale && scale.dataProvider && ! _minMaxAdjusted){
				if(Boolean(scaleMinMaxFormatFunction)){
					scaleMinMaxFormatFunction.call(this);
				}
				_minMaxAdjusted = true;
			}
		}
		*/
		
		
		
		[Bindable]
		public var labelInstances:Array;
		
		
		private var _axisItemInterval:Number;
		
		[Bindable]
		public function set axisItemInterval($axisItemInterval:Number):void{
			if(_axisItemInterval != $axisItemInterval){
				_axisItemInterval = $axisItemInterval;
				_dataChanged = true;
				invalidate();
			}
		}
		public function get axisItemInterval():Number{
			return _axisItemInterval;
		}
		
		private var _axisStartValue:Number;
		
		[Bindable]
		public function set axisStartValue($axisStartValue:Number):void{
			if(_axisStartValue != $axisStartValue){
				_axisStartValue = $axisStartValue;
				_dataChanged = true;
				invalidate();
			}
		}
		public function get axisStartValue():Number{
			if(!_axisStartValue){
				return Number(scale.minValue);
			}
			return _axisStartValue;
		}
		
		
		
		[Bindable]
		public var axisItemIntervalCalculator:Function;
		
		
		private var _minSegmentSize:Number = 150;
		
		[Bindable]
		public function set minSegmentSize($minSegmentSize:Number):void{
			if(_minSegmentSize != $minSegmentSize){
				_minSegmentSize = $minSegmentSize;
				_dataChanged = true;
				invalidate();
			}
		}
		public function get minSegmentSize():Number{
			return _minSegmentSize;
		}

		
		
		
		override protected function commitProperties():void 
		{
			super.commitProperties();
			
			if(readyForRedraw()){
				if(labelDisplay){
					if(labelInstances){
						var segmentLabelInstance:AxiomChartAxisLabel;
						for (var i:int = 0; i< labelInstances.length; i++)
						{
							segmentLabelInstance = labelInstances[i];
							//will call partRemoved, make sure to remove any event listeners there if any have been added 
							this.removeDynamicPartInstance("segmentLabel", segmentLabelInstance);
							//remove from skin manually (dynamic skin part are not added, removed by flex
							labelDisplay.removeElement(segmentLabelInstance);	
							//explicit for readability, gc would get it anyway
							segmentLabelInstance = null;
						}
					}
					
					
					
					labelInstances = new Array();
					
					var _plottableItems:Vector.<AxiomChartPlottableItem> = getPlottableItems();
					
					for (var k:int = 0; k < _plottableItems.length; k++)
					{
						var label:AxiomChartAxisLabel = createDynamicPartInstance("segmentLabel") as AxiomChartAxisLabel;
						label.axisItem = _plottableItems[k];
						labelDisplay.addElement(label);
						if(label.axisItem.point){
							label.move(label.axisItem.point.x,label.axisItem.point.y);
							label.visible = true;
						}else{
							label.visible = false;
						}
						labelInstances[k] = label;
					}
				}
				
			}
		}
				
		
		/*  */
		override public function buildPlottableItems():void{						
			if(readyForRedraw()){
				var segmentCt:int = Math.floor(scale.maxLayout / minSegmentSize);
				var diff:Number = scale.maxValue - scale.minValue;
				if(!axisItemInterval || isNaN(axisItemInterval)){

					//if it's not set, bypass public var so we don't trigger invalidate()					
					if(Boolean(axisItemIntervalCalculator)){
						_axisItemInterval = axisItemIntervalCalculator.call();
						if(_axisItemInterval < diff / segmentCt){
							_axisItemInterval = diff / segmentCt;
						}
					}else{
						_axisItemInterval =  diff / segmentCt;
						
					}
				}
	
				var startAt:Number = axisStartValue;			
				var all:Vector.<AxiomChartPlottableItem> = new Vector.<AxiomChartPlottableItem>;
				var _m:Number = Number(scale.maxValue);
				while(startAt < _m){
					all.push(createPlottableItem(startAt));
					startAt += axisItemInterval;
				}			
				setPlottableItems(all);
				//trace('SETTING ' + all.length + ' FOR ' + this.className);
				
			}
		}
		
		override public function readyForRedraw():Boolean{
			if(_dataChanged && scale && scale.minValue && scale.maxValue && scale.maxLayout){
				return true;
			}
			return false;
		}
		
		override public function afterRedraw():void{
			_dataChanged = false;
		}
		
		override public function invalidate():void{
			if(axisItemInterval){
				_axisItemInterval = NaN;
			}
			super.invalidate();
		}
		
		
	}
}