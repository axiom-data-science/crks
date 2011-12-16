package com.axiomalaska.integratedlayers.views.panels.time_slider
{
	import com.axiomalaska.crks.dto.Layer;
	
	import mx.core.UIComponent;
	
	import spark.components.Group;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.primitives.Graphic;
	
	public class SkinnableCompoundTimeLayer extends SkinnableComponent
	{
		
		[Bindable]
		public var layer:Layer;
		
		[Bindable]
		public var maxTime:Date;
		
		[Bindable]
		public var minTime:Date;
		
		[Bindable]
		public var timeLineContent:UIComponent;
		
		[Bindable]
		public var labelContent:Group;
		
		[SkinPart(required="true")]
		public var timeLineContentDisplay:Graphic;
		
		[SkinPart(required="true")]
		public var labelContentDisplay:Group;
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			
			if(timeLineContent !== null && instance == timeLineContentDisplay){
				timeLineContentDisplay.addElement(timeLineContent);
			}else if(labelContent !== null && instance == labelContentDisplay){
				labelContentDisplay.addElement(labelContent);
			}
			
			
			
			
		}
	}
}