package components.items 
{
	import Box2DAS.Dynamics.ContactEvent;
	import Box2DAS.Dynamics.StepEvent;
	import com.monsterPatties.config.CaveSmashConfig;
	import com.monsterPatties.config.GameConfig;
	import com.monsterPatties.controllers.GameDataController;
	import com.monsterPatties.events.CaveSmashEvent;
	import com.monsterPatties.utils.eventSatellite.EventSatellite;
	import components.players.Player2;
	import flash.events.Event;
	import misc.Util;
	import wck.BodyShape;
	import wck.ContactList;
	/**
	 * ...
	 * @author jc
	 */
	public class ItemCrystal extends BodyShape {	
		
		public static const LABEL_COLLECT:String = "collect";
		private var _isCollected:Boolean = false;
		public var itemType:String = ItemConfig.CRYSTAL;		
		public var contacts:ContactList;
		
			//cavesmash events
		private var _es:EventSatellite;
		private var _caveSmashEvent:CaveSmashEvent;
		private var hasRemoved:Boolean;	
		private var _gdc:GameDataController;
		
		public override function shapes():void {						
		}
		
		override public function create():void 
		{
			super.create();
			
			type = "Static";
			applyGravity = false;
			//type = "Dynamic";
			listenWhileVisible(this, ContactEvent.BEGIN_CONTACT, handleContact);
			listenWhileVisible(this, ContactEvent.END_CONTACT, endContact);
			listenWhileVisible(world, StepEvent.STEP, parseInput, false, 10);
			contacts = new ContactList();
			contacts.listenTo(this);
			
			if ( GameConfig.showCollider ){
				this.collider.alpha = 1;
			}
			addGameEvent();
		}
		
		public function collect():void 
		{			
			if ( !_isCollected && this.mc.currentFrameLabel != LABEL_COLLECT && this.mc != null && this.collider != null ) {
				type = "Static";
				this.collider.isSensor = true;
				Util.addChildAtPosOf(world, new FX1(), this );
				this.mc.addFrameScript( this.mc.totalFrames - 2, onEndAnimation );
				this.mc.gotoAndPlay( LABEL_COLLECT );
				_isCollected = true;				
			}
		}
		
		private function onEndAnimation():void 
		{
			if ( this != null ) {
				this.mc.addFrameScript( this.mc.totalFrames - 2, null );
				_caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.PICK_UP_ITEM );
				_caveSmashEvent.obj.itemType = itemType;
				_caveSmashEvent.obj.score = CaveSmashConfig.CRYSTAL_SCORE;
				_es.dispatchESEvent( _caveSmashEvent );
				removeGameEvent();
				
				if ( !_gdc.getCrystalTutorial() ){					
					_caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.ON_SHOW_CRYSTAL_INFO );
					_es.dispatchESEvent( _caveSmashEvent );
				}
				
				removeME();
			}
		}	
		
		private function initControllers():void 
		{
			_es = EventSatellite.getInstance();
			_gdc = GameDataController.getInstance();
		}
		
		private function removeControllers():void 
		{
			
		}
		
		private function addGameEvent():void 
		{
			_es = EventSatellite.getInstance();
			_es.addEventListener( CaveSmashEvent.LEVEL_STARTED, onLevelStarted );
			_es.addEventListener( CaveSmashEvent.LEVEL_QUIT, OnLevelQuit );
			_es.addEventListener( CaveSmashEvent.LEVEL_COMPLETE, onLevelComplete );			
			_es.addEventListener( CaveSmashEvent.LEVEL_FAILED, onLevelFailed );
			_es.addEventListener( CaveSmashEvent.RELOAD_LEVEL, onReloadLevel );
			//trace( "[ItemCrstal]:add GameEvent........................ " );
		}				
		
		private function removeGameEvent():void 
		{
			_es = EventSatellite.getInstance();
			_es.removeEventListener( CaveSmashEvent.LEVEL_STARTED, onLevelStarted );
			_es.removeEventListener( CaveSmashEvent.LEVEL_QUIT, OnLevelQuit );
			_es.removeEventListener( CaveSmashEvent.LEVEL_COMPLETE, onLevelComplete );			
			_es.removeEventListener( CaveSmashEvent.LEVEL_FAILED, onLevelFailed );
			_es.removeEventListener( CaveSmashEvent.RELOAD_LEVEL, onReloadLevel );
			//trace( "[ItemCrstal]:remove GameEvent........................ " );
		}		
		
		private function clearAll():void
		{			
			removeAllListeners();
			removeControllers();
			removeGameEvent();
			//this.remove();
			//destroy();
			//trace( "[Divider]:ClearALl........................ " );
		}
		
		private function removeME():void 
		{
			if( !hasRemoved  ){
				hasRemoved = true;
				this.remove();
				while (this.numChildren > 0){
					this.removeChildAt(0);
				}
				//trace( "ItemCrystal clear via reloader level!!!!!!!!!!!!!!!!!!!!" );
			}
		}
		
		
		/*----------------------------------------------------------------------Events-------------------------------------------------------------*/
		
		public function endContact(e:ContactEvent):void {
			if( this != null ){
				//trace( "[ Item ]: end contact with: === >" + e.other.GetBody().GetUserData() );			
				if ( e.other.GetBody().GetUserData() is Player2 ) {
					collect();
				}
			}
		}
		public function handleContact(e:ContactEvent):void {
			//trace( "[ Item ]: begin contact with: === >" + e.other.GetBody().GetUserData() );
			if ( this != null ){
				if ( e.other.GetBody().GetUserData() is Player2 ) {
					collect();
				}
			}
		}
		
		private function onLevelFailed(e:CaveSmashEvent):void 
		{
			clearAll();
		}
		
		private function onLevelComplete(e:CaveSmashEvent):void 
		{
			clearAll();			
		}
		
		private function onLevelStarted(e:CaveSmashEvent):void 
		{
			initControllers();
		}		
		
		private function OnLevelQuit(e:CaveSmashEvent):void 
		{
			clearAll();
			removeME();
		}
		
		private function onReloadLevel(e:CaveSmashEvent):void 
		{
			clearAll();
			removeME();
		}
		
		public function parseInput(e:Event):void{
			if (!world  || this == null ) return;			
		}
	}
}