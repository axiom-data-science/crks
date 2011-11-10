package com.axiomalaska.integratedlayers.views.components.navigation.tabs {
	import com.axiomalaska.integratedlayers.views.components.navigation.tabs.events.TerrificTabBarEvent;
	
	import mx.collections.IList;
	import mx.containers.ViewStack;
	
	import spark.components.TabBar;
	
	public class TerrificTabBar extends TabBar {
		public function TerrificTabBar() {
			super();
		}
		
		public function setCloseableTab(index:int, value:Boolean):void {
			if (index >= 0 && index < dataGroup.numElements) {
				var btn:TerrificTabBarButton = dataGroup.getElementAt(index) as TerrificTabBarButton;
				btn.closeable = value;
			}
		}
		public function getCloseableTab(index:int):Boolean {
			if (index >= 0 && index < dataGroup.numElements) {
				var btn:TerrificTabBarButton = dataGroup.getElementAt(index) as TerrificTabBarButton;
				return btn.closeable;
			}
			return false;
		}
		
		private function closeHandler(e:TerrificTabBarEvent):void {
			closeTab(e.index, selectedIndex);
		}
		
		public function closeTab(closedTab:int, selectedTab:int):void {
			if (dataProvider.length == 0) return;
			
			if (dataProvider is IList) {
				dataProvider.removeItemAt(closedTab);
			} else if (dataProvider is ViewStack){
				//remove the entire child from the dataProvider, which also removes it from the ViewStack
				(dataProvider as ViewStack).removeChildAt(closedTab);
			}
			
			//adjust selectedIndex appropriately
			if (dataProvider.length == 0) {
				selectedIndex = -1;
			} else if (closedTab < selectedTab) {
				selectedIndex = selectedTab - 1;
			} else if (closedTab == selectedTab) {
				selectedIndex = (selectedTab == 0 ? 0 : selectedTab - 1);
			} else {
				selectedIndex = selectedTab;
			}
		}
		
		protected override function partAdded(partName:String, instance:Object):void {
			super.partAdded(partName, instance);
			
			if (instance == dataGroup) {
				dataGroup.addEventListener(TerrificTabBarEvent.CLOSE_TAB, closeHandler);
			}
		}
		
		protected override function partRemoved(partName:String, instance:Object):void {
			super.partRemoved(partName, instance);
			
			if (instance == dataGroup) {
				dataGroup.removeEventListener(TerrificTabBarEvent.CLOSE_TAB, closeHandler);
			}
		}
	}
}