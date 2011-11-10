package com.axiomalaska.models
{
	import com.axiomalaska.interfaces.IKeyableData;
	
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	
	import mx.utils.ObjectUtil;
	
	public class KeyedData implements IKeyableData
	{
		public function KeyedData()
		{
		}
		
		private var _resultSetKey:String;
		public function set resultSetKey($resultSetKey:String):void{_resultSetKey = $resultSetKey}
		public function get resultSetKey():String{return _resultSetKey}
		
		private var _relationshipSets:RelationshipSet;
		public function set relationshipSet($relationshipSets:RelationshipSet):void{_relationshipSets = $relationshipSets;}
		public function get relationshipSet():RelationshipSet{return _relationshipSets;}
		
		private var _spatialFieldKey:String;
		public function set spatialFieldKey($spatialFieldKey:String):void{_spatialFieldKey = $spatialFieldKey}
		public function get spatialFieldKey():String{return _spatialFieldKey}
		
		private var _keys:Object;
		public function set keys($keys:Object):void{_keys = $keys;}
		public function get keys():Object{return _keys;}
		
		public function populateKeyedPropertiesFromValues($values_array:Array,$descriptor:VariableDescriptor):void{
			if(keys){	
				var x:XML = flash.utils.describeType(this);
				
				for(var p:String in keys){
					if(p in this && $descriptor.dataFields[keys[p]]){
						
						var c:int = 0;
						for(var prop:String in $descriptor.dataFields[keys[p]].keys){
							c ++;
						}
						
						trace('c = ' + c);
						
						if(c > 1){
							var classOfSourceObj:Class = flash.utils.getDefinitionByName(flash.utils.getQualifiedClassName($descriptor.dataFields[keys[p]])) as Class;
							this[p] = new classOfSourceObj();
							if('keys' in this[p]){
								for(var kprop:String in $descriptor.dataFields[keys[p]].keys){
									if(kprop in this[p]){
										this[p][kprop] = $values_array[$descriptor.dataFields[keys[p]]['keys'][kprop]];
									}
								}
							}
						}else{
							trace('setting ' + p + ' = ' + $values_array[$descriptor.dataFields[keys[p]]['keys']['text']]);
							//this[p] = $values_array[
						}
					}
				}
			}
			
		}
		
		
		
	}
}