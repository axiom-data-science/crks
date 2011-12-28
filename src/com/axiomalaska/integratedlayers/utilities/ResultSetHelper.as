package com.axiomalaska.integratedlayers.utilities
{
	import com.axiomalaska.integratedlayers.models.layers.data.stations_layer.ResultSetRow;
	import com.axiomalaska.models.ResultSet;
	import com.axiomalaska.models.VariableData;
	import com.axiomalaska.models.VariableDataDescriptor;
	import com.axiomalaska.models.VariableDescriptor;
	import com.axiomalaska.models.VariableType;

	public class ResultSetHelper
	{
		
		
		//public static function getValueIndexes(
		//public static function getVectorIndexes
		//public static function getAverageIndexes
		//public static function getMaxIndexes
		//public static function getMinIndexes
		
		public static function resultSetHasData($result_set:ResultSet):Boolean{
			var ret:Boolean = false;
			if($result_set && $result_set.descriptors && $result_set.descriptors.length > 0 && $result_set.data && $result_set.data.length > 0 && $result_set.data[0].values && $result_set.data[0].values.length > 0){
				ret = true;
			}
			return ret;
		}
		
		public static function getVariableDescriptorTypeIndex($result_set:ResultSet,$variable_descriptor_types:Array,$variable_descriptor_index_types:Array,$variable_descriptor_index:int = 0):Array{
			var indexes:Array;
			if(
				$result_set &&
				$result_set.descriptors && 
				$result_set.descriptors[$variable_descriptor_index] && 
				$result_set.descriptors[$variable_descriptor_index].dataFields
			)
			{
				for each(var vdd:VariableDataDescriptor in $result_set.descriptors[$variable_descriptor_index].dataFields){
					if($variable_descriptor_types.indexOf(vdd.descriptorType) >= 0){
						for(var _index:String in vdd.indexes){
							if($variable_descriptor_index_types.indexOf(vdd.indexes[_index]) >= 0){
								if(!indexes){
									indexes = [];
								}
								indexes.push(_index)
							}
						}
					}
				}
			}
			return indexes;
		}
		
		public static function getTimeSinceResult($result_set:ResultSet,$data_index:int,$result_index:int,$variable_descriptor_index:int = 0):String{
			var str:String;
			
			if($result_set.currentTime && 
				$result_set.descriptors && 
				$result_set.descriptors[$variable_descriptor_index] && 
				$result_set.data && $result_set.data[$data_index] && 
				$result_set.collection && $result_set.collection.getItemAt($result_index)){
				
				var vd:VariableDescriptor = $result_set.descriptors[$variable_descriptor_index] as VariableDescriptor;
				var obj:Object = $result_set.collection.getItemAt($result_index);
				
				if($result_set.data[vd.primaryKey].metadata.dataType == VariableType.DATE && obj[vd.primaryKey] is Date){
				
					var elapsed_minutes:Number = Math.floor(($result_set.currentTime.time - (obj[vd.primaryKey] as Date).time) / (1000 * 60));
					if(elapsed_minutes > 0){
						if(elapsed_minutes > 60){
							
							var hours_ago:int = Math.floor(elapsed_minutes / 60);
							var minutes_remain:int = elapsed_minutes % 60;
							
							str = hours_ago + ' hrs ' + minutes_remain + ' min ago';
							
						}else{
							str = elapsed_minutes + ' min ago';
						}
					}
				
				}
			}

			return str;
		}
		
		
		public static function getMostRecentResultSetRow($result_set:ResultSet):ResultSetRow{
			var row:ResultSetRow;
			if(ResultSetHelper.resultSetHasData($result_set)){
				row = new ResultSetRow();
				row.result = $result_set.collection.getItemAt($result_set.collection.length - 1);
				row.metadata = [];
				row.descriptor = $result_set.descriptors[0];
				for each(var data:VariableData in $result_set.data){
					row.metadata.push(data.metadata);
				}
			}
			return row;
		}
		
		
	}
}