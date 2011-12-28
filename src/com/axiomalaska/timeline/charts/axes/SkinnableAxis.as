package com.axiomalaska.timeline.charts.axes
{
	
	import com.axiomalaska.timeline.charts.axes.background.AxisBackgroundElement;
	import com.axiomalaska.timeline.charts.axes.labels.SkinnableAxisLabel;
	
	import mx.core.IFactory;
	
	import spark.components.Group;
	import spark.components.supportClasses.SkinnableComponent;
	
	public class SkinnableAxis extends SkinnableComponent
	{
		
		[SkinPart(required="false")]
		public var segmentLabel:IFactory;
		
		[SkinPart("false")]
		public var labelDisplay:Group;
		
		[SkinPart(required="false")]
		public var backgroundElement:AxisBackgroundElement;
		
		public var labelInstances:Array;
		public var backgroundInstances:Array;
		
		private var _min:Number;
		
		[Bindable]
		public function set min($min:Number):void{
			if(_min != $min){
				minMaxChanged = true;
				_min = $min;
				rebuildInterface();
			}
		}
		public function get min():Number{
			return _min;
			
		}
		
		
		private var _max:Number;
		
		[Bindable]
		public function set max($max:Number):void{
			if(_max != $max){
				minMaxChanged = true;
				_max = $max;
				rebuildInterface();
			}
		}
		public function get max():Number{
			return _max;
			
		}
		
		public var minMaxChanged:Boolean;
		public var segments:Vector.<AxisItem>;
		

		
		public function SkinnableAxis()
		{
			super();
		}
		
		protected var interfaceBuilt:Boolean = false;
		
		public function rebuildInterface():void{
			trace('Override rebuildInterface method please');
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void 
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if(!interfaceBuilt){
				rebuildInterface();
			}
			calculateSegmentPositions();
			positionSegments();
		}
		
		
		override protected function commitProperties():void 
		{
			super.commitProperties();
			
			if(minMaxChanged && segments){
				if(labelDisplay){
					if(labelInstances){
						var segmentLabelInstance:SkinnableAxisLabel;
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
					
					for (var k:int = 0; k < segments.length; k++)
					{
						var label:SkinnableAxisLabel = createDynamicPartInstance("segmentLabel") as SkinnableAxisLabel;
						label.axisItem = segments[k];
						labelDisplay.addElement(label);
						labelInstances[k] = label;
					}
				}
				
			}
		}
		
		public function positionSegments():void{
			if(segments){
				for(var i:int = 0;i < segments.length;i++){
					if(labelInstances && labelInstances[i]){
						labelInstances[i].move(segments[i].point.x,segments[i].point.y);
						
					}
				}			
				
				if(backgroundElement){
					backgroundElement.segments = segments;
				}
			}
		}
		
		
		public function calculateSegmentPositions():void{}

	}
}