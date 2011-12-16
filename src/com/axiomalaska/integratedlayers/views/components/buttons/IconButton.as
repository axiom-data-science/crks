package com.axiomalaska.integratedlayers.views.components.buttons
{
	import spark.components.Button;
	import spark.components.Group;
	import spark.primitives.Graphic;
	
	public class IconButton extends Button
	{
		[Bindable]
		public var icon:Graphic;
		
		[SkinPart(required="true")]
		public var iconDisplay:Group;
		
		override protected function partAdded(partName:String, instance:Object):void{
			
			if(icon !== null && instance == iconDisplay){
				iconDisplay.addElement(icon);
			}
		}
	}
}