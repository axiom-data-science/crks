package com.axiomalaska.integratedlayers.controllers
{
	import com.axiomalaska.integratedlayers.controllers.BaseController;
	import com.axiomalaska.integratedlayers.events.ApplicationStateEvent;
	import com.axiomalaska.crks.utilities.ApplicationState;
	import com.axiomalaska.crks.utilities.ApplicationStateArguments;
	
	import mx.controls.Alert;
	import mx.core.Application;
	
	public class ApplicationStateController extends BaseController
	{
		
		private var application_states:Object = {};
		
		/*
		[EventHandler(event="ApplicationStateEvent.ADD_APPLICATON_STATE_PROPERTY", properties="application_state")]
		public function onApplicationStateAppendAddProperty($application_state:ApplicationState):void{
			
		}
		*/
		
		public function onChildApplicationStatePropertyChange($parent_key:String,$application_state:ApplicationState):void{
			if(application_states.hasOwnProperty($parent_key)){
				
			}
		}
		
		
		
		
		[EventHandler(event="ApplicationStateEvent.UPDATE_APPLICATION_STATE_PROPERTY", properties="application_state")]
		public function onApplicationStatePropertyChange($application_state:ApplicationState):void{
			if($application_state.parent && application_states.hasOwnProperty($application_state.parent.property)){
				application_states[$application_state.parent.property] = $application_state.parent;
			}else{
				application_states[$application_state.property] = $application_state;
			}
			var str:String = rebuildUrlString();
			dispatcher.dispatchEvent(new ApplicationStateEvent(ApplicationStateEvent.UPDATE_APPLICATION_STATE,null,str));
		}
		
		private function rebuildUrlString():String{
			var url_pieces:Array = [];
			for(var p:String in application_states){
				url_pieces.push(buildApplicationStateSegment(application_states[p]));
			}
			
			return url_pieces.join(ApplicationStateArguments.VARIABLE_SEPERATOR);
		}
		
		private function buildApplicationStateSegment($application_state:ApplicationState,$equals_operator:String = null,$variable_seperator:String = null):String{
			
			if(!$equals_operator){
				$equals_operator = ApplicationStateArguments.VARIABLE_EQUAL_OPERATOR;
			}
			
			if(!$variable_seperator){
				$variable_seperator = ApplicationStateArguments.VARIABLE_LIST_SEPERATOR;
			}
			
			var str:String = '';
			if($application_state.children){
				str = str + $application_state.property + $equals_operator;
				var child_strings:Array = [];
				for each(var ap_state_child:ApplicationState in $application_state.children){
					var child_string:String = '';
					if(ap_state_child.children){
						var child_child_strings:Array = [];
						for each(var ap_child_child_state:ApplicationState in ap_state_child.children){
							child_child_strings.push(concatPropValString(ap_child_child_state.property,ApplicationStateArguments.CHILD_VARIABLE_EQUAL_OPERATOR,ap_child_child_state.value));
						}
						child_string = concatPropValString(ap_state_child.property,'','[' + child_child_strings.join(ApplicationStateArguments.CHILD_VARIABLE_LIST_SEPERATOR) + ']');
						
					}else{
						child_string = concatPropValString(ap_state_child.property,$equals_operator,ap_state_child.value);
					}
					child_strings.push(child_string);
				}
				str = concatPropValString($application_state.property,$equals_operator,child_strings.join($variable_seperator));
			}else{
				str = concatPropValString($application_state.property,$equals_operator,$application_state.value);
			}
			return str;
		}
		
		private function concatPropValString($property:String,$equals_operator:String,$value:String = null):String{
			var str:String = $property;
			if($value){
				str = str + $equals_operator + $value;
			}
			
			return str;
			
		}
		
		[URLMapping(url="{0}")]
		[EventHandler(event="ApplicationStateEvent.UPDATE_APPLICATION_STATE", properties="application_state_string")]
		public function onApplicationStateUpdate($application_state_string:String):void{
			//Alert.show('updating url to ' + $application_state_string);
		}
		
		

		
	}
}