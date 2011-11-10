package com.axiomalaska.integratedlayers.views.panels
{

	import mx.collections.ArrayCollection;
	import mx.core.UIComponent;
	
	import spark.components.supportClasses.SkinnableComponent;
	
	public class SkinnableDataPanel extends SkinnableComponent
	{
		[SkinPart(required="true")]
		public var chartDisplay:UIComponent;
		
		[SkinPart(required="true")]
		public var dataFormat:IFactory;
		
		

		
	}
}