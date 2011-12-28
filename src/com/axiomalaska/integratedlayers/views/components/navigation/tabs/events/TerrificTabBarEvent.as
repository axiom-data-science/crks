package com.axiomalaska.integratedlayers.views.components.navigation.tabs.events {
	import flash.events.Event;
	
	public class TerrificTabBarEvent extends Event {
		public static const CLOSE_TAB:String = 'closeTab';
		
		private var _index:int = -1;
		
		public function TerrificTabBarEvent(type:String, index:int, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			_index = index;
		}
		
		public function get index():int {
			return _index;
		}
		
		override public function clone():Event {
			return new TerrificTabBarEvent(type,index,bubbles,cancelable);
		}
	}
}