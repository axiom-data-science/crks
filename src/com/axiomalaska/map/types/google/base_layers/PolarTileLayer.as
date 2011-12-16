package com.axiomalaska.map.types.google.base_layers
{
	import com.google.maps.CopyrightCollection;
	import com.google.maps.TileLayerBase;
	import com.google.maps.interfaces.ICopyrightCollection;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	
	public class PolarTileLayer extends TileLayerBase
	{
		public function PolarTileLayer()
		{
			var copyrightCollection:CopyrightCollection = new CopyrightCollection();
			super(copyrightCollection, 1, 17);
		}
		
		public override function loadTile($tile:Point,$zoom:Number):DisplayObject{
			
			var s:Sprite = new Sprite();
			s.graphics.beginFill(0xFF0000,.3);
			s.graphics.lineStyle(1,0xFF0000);
			s.graphics.drawRect(0,0,256,256);
			
			var t:TextField = new TextField();
			t.border = true;
			t.htmlText = '<font color="#FFFFFF" face="arial">pt = ' + $tile.x + ',' + $tile.y + ' z=' + $zoom +'</font>';
			t.x = 0;
			t.y = 0;
			s.addChild(t);
			
			return s;
			
		}
	}
}