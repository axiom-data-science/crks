package com.axiomalaska.integratedlayers.utilities
{
	import com.axiomalaska.integratedlayers.models.layers.data.stations_layer.Sensor;
	import com.axiomalaska.integratedlayers.models.layers.data.stations_layer.SensorTypes;
	import com.axiomalaska.models.ResultSet;
	import com.axiomalaska.models.VariableData;
	import com.axiomalaska.models.VariableType;
	
	import mx.formatters.NumberFormatter;

	public class UnitConverter
	{
		
		
		
		public static function convertResultSet($result_set:ResultSet,$sensor:Sensor):void{
			UnitConverter.resultSetFromCelsiusToFarenheit($result_set);
			UnitConverter.resultsSetFromMPSToMPH($result_set);
			if($sensor.sensorType == SensorTypes.PRECIPITATION || $sensor.sensorType == SensorTypes.SNOW_DEPTH){
				UnitConverter.resultSetFromMMToInches($result_set);
			}
		}
		
		public static function fromCelsiusToFarenheit($val:Number):Number{
			var nf:NumberFormatter = new NumberFormatter();
			nf.precision = 2;
			return Number(nf.format($val * (9/5) + 32));
		}
		
		public static function fromMPSToMPH($val:Number):Number{
			var nf:NumberFormatter = new NumberFormatter();
			nf.precision = 2;
			return Number(nf.format($val * 2.23693629));
		}
		
		public static function fromInchesToMM($val:Number):Number{
			if($val == 0){
				return 0;
			}else{
				var nf:NumberFormatter = new NumberFormatter();
				nf.precision = 2;
				return Number(nf.format($val * 25.4));
			}
		}
		
		public static function fromMMToInches($val:Number):Number{
			var nf:NumberFormatter = new NumberFormatter();
			nf.precision = 2;
			var num:Number = Number(nf.format($val / 25.4));
			if(isNaN(num)){
				trace($val);
			}
			return num;
		}
		
		public static function resultSetFromInchesToMM($result_set:ResultSet):void{
			if(ResultSetHelper.resultSetHasData($result_set)){
				for each(var vd:VariableData in $result_set.data){
					if((vd.metadata.unit.toLowerCase() == 'inches' || vd.metadata.unit.toLowerCase() == 'in') && vd.variableValueCollection.valueType == VariableType.DOUBLE){
						var newArr:Array = [];
						for each(var val:Number in vd.variableValueCollection.doubleValues){
							newArr.push(fromInchesToMM(val));
						}
						vd.metadata.unit = vd.metadata.unit.replace(/inches/i,'mm');
						vd.metadata.unit = vd.metadata.unit.replace(/in/i,'mm');
						vd.variableValueCollection.doubleValues = newArr;
						vd.values = newArr;
						$result_set.collection = null;
						$result_set.keyed_collection = null;
					}
				}
			}
		}
		
		public static function resultSetFromMMToInches($result_set:ResultSet):void{
			if(ResultSetHelper.resultSetHasData($result_set)){
				for each(var vd:VariableData in $result_set.data){
					if(vd.metadata.unit.toLowerCase() == 'mm' && vd.variableValueCollection.valueType == VariableType.DOUBLE){
						var newArr:Array = [];
						for each(var val:Number in vd.variableValueCollection.doubleValues){
							newArr.push(fromMMToInches(val));
						}
						vd.metadata.unit = vd.metadata.unit.replace(/mm/i,'In');
						vd.variableValueCollection.doubleValues = newArr;
						vd.values = newArr;
						$result_set.collection = null;
						$result_set.keyed_collection = null;
					}
				}
			}
		}
		
		public static function resultsSetFromMPSToMPH($result_set:ResultSet):void{
			if(ResultSetHelper.resultSetHasData($result_set)){
				for each(var vd:VariableData in $result_set.data){
					if(vd.metadata.unit.toLowerCase() == 'm/s' && vd.variableValueCollection.valueType == VariableType.DOUBLE){
						var newArr:Array = [];
						for each(var val:Number in vd.variableValueCollection.doubleValues){
							newArr.push(fromMPSToMPH(val));
						}
						vd.metadata.unit = vd.metadata.unit.replace(/m\/s/i,'mph');
						vd.variableValueCollection.doubleValues = newArr;
						vd.values = newArr;
						$result_set.collection = null;
						$result_set.keyed_collection = null;
					}
				}
			}
		}
		
		public static function resultSetFromCelsiusToFarenheit($result_set:ResultSet):void{
			if(ResultSetHelper.resultSetHasData($result_set)){
				for each(var vd:VariableData in $result_set.data){
					if(vd.metadata.unit.toLowerCase() == 'c' && vd.variableValueCollection.valueType == VariableType.DOUBLE){
						var newArr:Array = [];
						for each(var val:Number in vd.variableValueCollection.doubleValues){
							newArr.push(fromCelsiusToFarenheit(val));
						}
						vd.metadata.unit = 'F';
						vd.variableValueCollection.doubleValues = newArr;
						vd.values = newArr;
						$result_set.collection = null;
						$result_set.keyed_collection = null;
					}
				}
			}
		}
	}
}