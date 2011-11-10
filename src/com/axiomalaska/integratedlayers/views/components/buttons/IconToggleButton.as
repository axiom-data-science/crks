package com.axiomalaska.integratedlayers.views.components.buttons
{
	import spark.components.Group;
	import spark.components.ToggleButton;
	import spark.primitives.Graphic;
	
	public class IconToggleButton extends ToggleButton
	{
		[Bindable]
		public var icon:Graphic;
		
		[SkinPart(required="true")]
		public var iconDisplay:Group;
		
		[Bindable]
		override public var buttonMode:Boolean = true;
		
		override protected function partAdded(partName:String, instance:Object):void{
			
			if(icon !== null && instance == iconDisplay){
				iconDisplay.addElement(icon);
			}
		}
	}
}