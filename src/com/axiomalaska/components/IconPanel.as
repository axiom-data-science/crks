package com.axiomalaska.components
{
	import mx.core.UIComponent;
	
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.HGroup;
	import spark.components.Panel;
	import spark.primitives.BitmapImage;
	
	[Style(name="background1", type="uint", inherit="yes")]
	[Style(name="background2", type="uint", inherit="yes")]
	
	public class IconPanel extends Panel
	{
		public function IconPanel()
		{
			super();
		}
		

		
		[Bindable]
		public var titleBarIcons:UIComponent;
		
		/*
		[Bindable]
		public var background1:uint = 0x5e6e87;
		
		[Bindable]
		public var background2:uint = 0x393941;
		*/

		
		
		//--------------------------------------------------------------------------
		//
		//  Skin Parts
		//
		//--------------------------------------------------------------------------
		
		
		[SkinPart(required="false")]
		public var titleBarIconsDisplay:Group;

		
		
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);

			
			if(titleBarIcons !== null && instance == titleBarIconsDisplay)
				titleBarIconsDisplay.addElement(titleBarIcons);
			
		}
	}
}