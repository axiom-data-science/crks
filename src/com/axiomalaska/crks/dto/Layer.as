package com.axiomalaska.crks.dto {
	import com.axiomalaska.map.interfaces.ILayer;
	import com.axiomalaska.models.SpatialBounds;
	import com.axiomalaska.models.Temporal;
	import com.axiomalaska.crks.interfaces.ILegendItem;
	import com.axiomalaska.crks.interfaces.IMetaDataItem;
	import com.axiomalaska.crks.interfaces.ISpatialExtentItem;
	import com.axiomalaska.crks.utilities.ApplicationState;
	
	import flash.display.DisplayObject;
	
	import mx.collections.ArrayCollection;

	// Generated May 25, 2011 4:36:19 PM by Hibernate Tools 3.2.2.GA
	
	[Bindable]
	[RemoteClass(alias="com.axiomalaska.crks.dto.LayerDTO")]
	public class Layer extends LayerGenerated implements ILegendItem,IMetaDataItem,ISpatialExtentItem{
		
		//SET BY SERVICE
		public var hasMetadata:Boolean;
		
		//SET IN APP
		public var mapLayer:ILayer;
		
		public var urlArguments:Object;
		
		private var _activeOnMap:Boolean = false;
		public function set activeOnMap($activeOnMap:Boolean):void{
			_activeOnMap = $activeOnMap;
		}
		public function get activeOnMap():Boolean{
			return _activeOnMap;
		}
		
		private var _children:ArrayCollection;
		public function set children($children:ArrayCollection):void{
			_children = $children;
		}
		public function get children():ArrayCollection{
			return _children;
		}
		
		private var _temporal:Temporal;
		public function set temporal($temporal:Temporal):void{
			_temporal = $temporal;
		}
		public function get temporal():Temporal{
			if(startTimeUtc && endTimeUtc){
				_temporal = new Temporal();
				_temporal.startdate = startTimeUtc;
				_temporal.enddate = endTimeUtc;
			}
			return _temporal;
		}
		
		
		
		public function getUrlKey():String{
			var urlKey:String;
			if(label){
				urlKey = label.replace(/[^a-zA-Z]/g,'_').toLowerCase();
			}
			return urlKey;
		}
		
		
		private var _alpha:Number = 100;
		public function set alpha($alpha:Number):void{
			_alpha = $alpha;
			if(mapLayer){
				mapLayer.alpha = _alpha;
			}
			
		}
		public function get alpha():Number{
			return _alpha;
		}
		
		private var _spatialBounds:SpatialBounds;
		public function set spatialBounds($spatialBounds:SpatialBounds):void{
			
		}
		public function get spatialBounds():SpatialBounds{
			if(!_spatialBounds){
				if(maxLat && maxLng && minLat && minLng){
					_spatialBounds = new SpatialBounds(minLat,minLng,maxLat,maxLng);
				}
				
			}
			return _spatialBounds;
		}
		
		
		private var _visible:Boolean = true;
		public function set visible($visible:Boolean):void{
			_visible = $visible;
			if(mapLayer){
				if($visible === true){
					mapLayer.show();
				}else{
					mapLayer.hide();
				}
			}
		}
		public function get visible():Boolean{
			return _visible;
		}
		
		
		private var _hasBounds:Boolean;
		public function set hasBounds($hasBounds:Boolean):void{
			_hasBounds = $hasBounds;
		}
		public function get hasBounds():Boolean{
			if(!_hasBounds && minLat && minLng && maxLat && maxLng){
				_hasBounds = true;
			}else{
				_hasBounds = false;
			}
			return _hasBounds;
		}
		
		private var _hasTimeComponent:Boolean;
		public function set hasTimeComponent($hasTimeComponent:Boolean):void{
			_hasTimeComponent = $hasTimeComponent;
		}
		public function get hasTimeComponent():Boolean{
			if(!_hasTimeComponent){
				if(this.startTimeUtc && this.endTimeUtc){
					_hasTimeComponent = true;
				}
			}
			return _hasTimeComponent;
		}
		
		public function getLegendImageUrl():String{
			return legendImageUrl;	
		}
		
		
		private var _applicationState:ApplicationState;
		
		public function set applicationState($applicationState:ApplicationState):void{
			_applicationState = $applicationState;
		}
		
		public function get applicationState():ApplicationState{
			if(!_applicationState){
				_applicationState = new ApplicationState();
				_applicationState.property = this.getUrlKey();
			}
			return _applicationState;
		}
		
		
		
		
		
		

	}
}