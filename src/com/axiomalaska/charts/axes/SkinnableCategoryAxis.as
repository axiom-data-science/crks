package com.axiomalaska.charts.axes
{
	import mx.collections.ArrayCollection;

	public class SkinnableCategoryAxis extends SkinnableAxis
	{
		
		[Bindable]
		public var categories:ArrayCollection;
		
		override public function buildPlottableItems():void{
			//build out axis items based on size and number of categories
		}

	}
}