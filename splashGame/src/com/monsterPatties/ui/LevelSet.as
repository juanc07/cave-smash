package com.monsterPatties.ui 
{
	import com.monsterPatties.config.CaveSmashConfig;
	import com.monsterPatties.controllers.GameDataController;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author jc
	 */
	public class LevelSet extends Sprite
	{
		private var _mapHolder:Sprite;
		private var _levelBtnHolder:Sprite;
		private var _levelBtnCollection:Vector.<LevelBtn>;
		//private var bg:Sprite;
		private var bg:MapBGMC;
		public var id:int;
		private var _mapName:String;
		private var _totalCrystal:String;
		
		public static var maps:Vector.<String> = Vector.<String>( [ "Grass Land", "Dessert Land", "Snow Land" ] );		
		private var crystals:Vector.<String> = Vector.<String>( [ "Crystal 0/60", "Crystal 0/60", "Crystal 0/60" ] );
		private var _levelUpperMC:UpperMapMC;
		private var _gdc:GameDataController;
		
		public function LevelSet() 
		{
			addEventListener( Event.ADDED_TO_STAGE, init );
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener( Event.REMOVED_FROM_STAGE, destroy );
			
			_gdc = GameDataController.getInstance();
			setDisplay();
		}
		
		private function destroy(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			removeDisplay();
		}
		
		private function setDisplay():void 
		{
			createLevelBtns();
		}
		
		
		private function createLevelBtns():void 
		{		
			_mapHolder = new Sprite();
			addChild( _mapHolder );
			
			bg = new MapBGMC();
			_mapHolder.addChild( bg );
			bg.x = 10;
			bg.y += 5;
			
			var row:int = 4;
			var col:int = 5;
			var xpos:Number = 110;
			var ypos:Number = 100;
			var xOffset:Number = 95;
			var yOffset:Number = 80;
			var ctr:int = 1;
			
			var levelBtn:LevelBtn;
			
			_levelBtnHolder = new Sprite();
			_mapHolder.addChild( _levelBtnHolder );			
			
			_levelBtnCollection = new Vector.<LevelBtn>();
			
			for (var i:int = 0; i < row; i++) 
			{
				for (var j:int = 0; j < col; j++)
				{					
					levelBtn = new LevelBtn();
					levelBtn.id = ctr;
					levelBtn.map = id;
					levelBtn.btnLabel = ctr + "";
					levelBtn.crystalStatus = "/30";
					levelBtn.x = xpos + ( ( levelBtn.width + xOffset ) *  j  );
					levelBtn.y = ypos + ( ( levelBtn.height + yOffset ) *  i );
					_levelBtnHolder.addChild( levelBtn );
					_levelBtnCollection.push( levelBtn );
					ctr++;
				}				
			}
			
			updateInfo();			
		}
		
		
		private function updateInfo():void 
		{
			_levelUpperMC = new UpperMapMC();
			addChild( _levelUpperMC );
			_levelUpperMC.x = 35;
			_levelUpperMC.y = 15;
			
			_levelUpperMC.txtMapName.text = maps[ id ];
			//_levelUpperMC.txtTotalCrystal.text = crystals[ id ];			
			_levelUpperMC.txtTotalCrystal.text = "Crystals "+  _gdc.getTotalCollectedCrystalByMap( id ) + "/" + CaveSmashConfig.TOTAL_CRYSTALS_PER_MAP;
		}
		
		private function removeLevelBtns():void 
		{
			if ( _levelUpperMC != null ) {
				if ( this.contains( _levelUpperMC ) ) {
					this.removeChild( _levelUpperMC );
					_levelUpperMC = null;
				}
			}
			
			if ( bg != null ) {
				if ( _mapHolder.contains( bg ) ) {
					_mapHolder.removeChild( bg );
					bg = null;
				}
			}
			
			var len:int = _levelBtnCollection.length;
			for (var i:int = len - 1; i >= 0; i--) 
			{
				if ( _levelBtnCollection[ i ] != null ) {
					if ( _levelBtnHolder.contains( _levelBtnCollection[ i ]  ) ) {
						_levelBtnHolder.removeChild( _levelBtnCollection[ i ] );
						_levelBtnCollection[ i ] = null;
						_levelBtnCollection.splice( i , 1 );
						//trace( "Level set remove splice " + i );
					}
				}
			}
			
			if ( _mapHolder != null ) {
				if ( this.contains( _mapHolder ) ) {
					this.removeChild( _mapHolder );
					_mapHolder = null;
				}
			}
			
			_levelBtnCollection = new Vector.<LevelBtn>();
		}
		
		
		private function removeDisplay():void 
		{
			removeLevelBtns();
		}
		
	}

}