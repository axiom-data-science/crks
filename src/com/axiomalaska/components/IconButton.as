package com.axiomalaska.components
{
	import spark.components.Button;
	import spark.primitives.BitmapImage;
	//import spark.primitives.supportClasses.TextGraphicElement;
	
	public class IconButton extends Button
	{
		//--------------------------------------------------------------------------
		//
		//	Constructor
		//
		//--------------------------------------------------------------------------
		
		public function IconButton()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//	Properties
		//
		//--------------------------------------------------------------------------
		
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