package com.axiomalaska.integratedlayers.models.layers
{
	import com.axiomalaska.map.interfaces.ILayer;
	import com.axiomalaska.map.types.google.GoogleLayer;
	
	import flash.events.IEventDispatcher;
	
	//import com.axiomalaska.integratedlayers.models.layers.data.DataFilter;
	
	import mx.collections.ArrayCollection;

	public class LayerData extends GoogleLayer implements ILayer
	{
		
		[Dispatcher]
		public var dispatcher:IEventDispatcher;
		
		[Bindable]
		public var filterSet:ArrayCollection;
		
		//[Bindable]
		//public var primaryData:DataFilter;
		
		public function LayerData($name:String){
			super($name);
		}
	}
}