package com.axiomalaska.timeline.charts.axes.labels
{
	
	import com.axiomalaska.timeline.charts.axes.AxisItem;
	import com.axiomalaska.timeline.skins.AxisLabelSkin;
	
	import spark.components.Label;
	import spark.components.SkinnableContainer;
	import spark.components.supportClasses.SkinnableComponent;
	
	
	
	[Style(name="fontSize",type="int",inherit="yes")]
	[Style(name="color",type="uint", type="Color", inherit="yes")]
	
	public class SkinnableAxisLabel extends SkinnableComponent
	{
		
		[Bindable]
		public var axisItem:AxisItem;
		
		/*
		[Bindable]
		public var text:String;
		
		[Bindable]
		public var value:Number;
		*/
		
		public function SkinnableAxisLabel()
		{
			super();
		}
		
		override public function stylesInitialized():void {
			super.stylesInitialized();
			if(!skin){
				//this.setStyle("skinClass",Class(com.axiomalaska.timeline.skins.AxisLabelSkin));
			}
		}
		
		
		
	}
}