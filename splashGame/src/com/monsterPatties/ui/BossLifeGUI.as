package com.monsterPatties.ui 
{
	import com.monsterPatties.config.CaveSmashConfig;
	import com.monsterPatties.controllers.GameDataController;
	import com.monsterPatties.events.CaveSmashEvent;
	import com.monsterPatties.utils.eventSatellite.EventSatellite;
	import components.items.ItemConfig;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author jc
	 */
	public class BossLifeGUI extends Sprite
	{
		/*----------------------------------------------------------------------Constant--------------------------------------------------------------*/
		
		/*----------------------------------------------------------------------Properties------------------------------------------------------------*/
		private var _bossHudGUI:BossHudMC;
		private var _xpos:Number = 0;
		private var _ypos:Number = 0;
		private var _es:EventSatellite;
		private var _gdc:GameDataController;
		/*----------------------------------------------------------------------Constructor-----------------------------------------------------------*/
		
		
		public function BossLifeGUI( xpos:Number = 0, ypos:Number = 0 ) 
		{
			_xpos = xpos;
			_ypos = ypos;
			addEventListener( Event.ADDED_TO_STAGE, init );
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener( Event.REMOVED_FROM_STAGE, destroy );
			initControllers();
			initEventListeners();
			setDisplay();
		}
		
		private function destroy(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			removeEventListeners();
			removeDisplay();
		}
		
		/*----------------------------------------------------------------------Methods--------------------------------------------------------------*/
		private function setDisplay():void 
		{
			_bossHudGUI = new BossHudMC();
			addChild( _bossHudGUI );
			_bossHudGUI.x = _xpos;
			_bossHudGUI.y = _ypos;	
			hideHP();
		}
		
		private function removeDisplay():void 
		{
			if ( _bossHudGUI != null ) {
				if ( this.contains( _bossHudGUI ) ) {
					this.removeChild( _bossHudGUI )
					_bossHudGUI = null;
				}
			}
		}
		
		private function initEventListeners():void 
		{
			_es =  EventSatellite.getInstance();
			_es.addEventListener( CaveSmashEvent.SHOW_BOSS_HP, onShowGUI );
			_es.addEventListener( CaveSmashEvent.HIDE_BOSS_HP, onHideGUI );			
			_es.addEventListener( CaveSmashEvent.HIDE_BOSS_HP, onHideGUI );
			_es.addEventListener( CaveSmashEvent.HIDE_BOSS_HP, onHideGUI );
			_es.addEventListener( CaveSmashEvent.BOSS_RECIEVED_DAMAGED, onBossRecievedDamage );
			_es.addEventListener( CaveSmashEvent.BOSS_DIED, onBossDied );
		}										
		
		private function removeEventListeners():void 
		{			
			_es.removeEventListener( CaveSmashEvent.SHOW_BOSS_HP, onShowGUI );
			_es.removeEventListener( CaveSmashEvent.HIDE_BOSS_HP, onHideGUI );			
			_es.removeEventListener( CaveSmashEvent.HIDE_BOSS_HP, onHideGUI );
			_es.removeEventListener( CaveSmashEvent.HIDE_BOSS_HP, onHideGUI );
			_es.removeEventListener( CaveSmashEvent.BOSS_RECIEVED_DAMAGED, onBossRecievedDamage );
			_es.removeEventListener( CaveSmashEvent.BOSS_DIED, onBossDied );
		}
		
		private function initControllers():void 
		{
			_gdc = GameDataController.getInstance();			
		}
		
		private function removeControllers():void 
		{
			//reset date here ????
		}
		
		private function updateBossLifeHud( max:Number = 0, hp:Number = 0 ):void 
		{
			if ( _bossHudGUI != null ) {
				var percent:Number = hp / max;
				trace( "[ " + this + " ] " + percent );
				if(percent<=0){
					percent = 0;
				}
				_bossHudGUI.hp.bar.scaleX = percent;
			}
		}
		
		private function hideHP():void 
		{
			_bossHudGUI.visible = false;
		}
		/*----------------------------------------------------------------------Setters--------------------------------------------------------------*/
		
		/*----------------------------------------------------------------------Getters--------------------------------------------------------------*/
		
		/*----------------------------------------------------------------------EventHandlers--------------------------------------------------------*/		
		private function onBossRecievedDamage(e:CaveSmashEvent):void 
		{
			updateBossLifeHud( e.obj.max, e.obj.hp );
		}
		
		private function onHideGUI(e:CaveSmashEvent):void 
		{			
			trace("[BossLifeGUI]: onHideGUI!!!!!!!!!!!!!!!!!!!!!!!!!!!");
			hideHP();
		}
		
		private function onShowGUI(e:CaveSmashEvent):void 
		{
			updateBossLifeHud( CaveSmashConfig.BOSS1_HP, CaveSmashConfig.BOSS1_HP );
			_bossHudGUI.visible = true;
			trace("[BossLifeGUI]: onShowGUI!!!!!!!!!!!!!!!!!!!!!!!!!!!");
		}
		
		private function onBossDied(e:CaveSmashEvent):void 
		{
			hideHP();
		}
	}
}