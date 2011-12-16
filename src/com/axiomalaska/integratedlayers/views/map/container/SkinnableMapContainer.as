package com.axiomalaska.integratedlayers.views.map.container
{
	import com.axiomalaska.map.interfaces.IMap;
	
	import mx.collections.ArrayCollection;
	
	import spark.components.Group;
	import spark.components.supportClasses.SkinnableComponent;
	
	public class SkinnableMapContainer extends SkinnableComponent
	{
		
		/* 
			SKIN PARTS 
		*/
		
		[SkinPart(required="false")]
		public var mapDisplay:Group;
		
		[SkinPart(required="false")]
		public var legendDisplay:Group;
		
		[SkinPart(required="false")]
		public var timeControlDisplay:Group;
		
		[SkinPart(required="false")]
		public var navigationDisplay:Group;
		
		[SkinPart(required="false")]
		public var searchWindowDisplay:Group;
		
		[SkinPart(required="false")]
		public var dataTabDisplay:UIComponent;
		
		[SkinPart(required="false")]
		public var dataTab:IFactory;
		
		
		
		[Bindable]
		public var map:IMap;
		
		[Bindable]
		public var dataLayers:ArrayCollection;
		
		[Bindable]
		public var vectorLayers:ArrayCollection;
		
		[Bindable]
		public var rasterLayers:ArrayCollection;
		
		
		
		
	}
}