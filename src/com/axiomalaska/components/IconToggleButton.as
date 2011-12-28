package com.axiomalaska.components
{
	import spark.components.ToggleButton;
	import spark.primitives.BitmapImage;
	
	[Style(name="backgroundColor", type="uint", format="Color", default="0xFFFFFF")]
	[Style(name="backgroundHighlight", type="uint", format="Color")]
	[Style(name="backgroundSelected", type="uint", format="Color")]
	[Style(name="iconUp", type="class", format="Bitmap")]
	[Style(name="iconOver", type="class", format="Bitmap")]
	[Style(name="iconSelected", type="class", format="Bitmap")]
	public class IconToggleButton extends ToggleButton
	{
		public function IconToggleButton()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//	Properties
		//
		//--------------------------------------------------------------------------
		
		//--
		// backgroundColor
		//--
		
		//[Bindable]
		//public var backgroundColor:uint;
		
		
		//[Bindable]
		//public var backgroundHighlight:uint;
		
		

		
		
		//----------------------------------
		//  icon
		//----------------------------------
		
		/**
		 *  @private
		 *  Internal storage for the icon property.
		 */
		private var _icon:Class;
		
		[Bindable]
		
		/**
		 *  
		 */
		public function get icon():Class
		{
			return _icon;
		}
		
		/**
		 *  @private
		 */
		public function set icon(val:Class):void
		{
			_icon = val;
			
			if (iconDisplay != null)
				iconDisplay.source = _icon;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Skin Parts
		//
		//--------------------------------------------------------------------------
		
		[SkinPart(required="false")]
		public var iconDisplay:BitmapImage;
		
		
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
			
			if (icon !== null && instance == iconDisplay)
				iconDisplay.source = icon;
		}		
		
	}
}