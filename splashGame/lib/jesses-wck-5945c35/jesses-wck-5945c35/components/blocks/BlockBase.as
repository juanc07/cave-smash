package components.blocks {
	
	import Box2DAS.Dynamics.ContactEvent;
	import Box2DAS.Dynamics.StepEvent;
	import com.monsterPatties.events.CaveSmashEvent;
	import com.monsterPatties.utils.eventSatellite.EventSatellite;
	import components.players.Player2;
	import flash.events.Event;
	import wck.*;
	
	public class BlockBase extends BodyShape{
	
		/*------------------------------------------------------------------Constant----------------------------------------------------------------------*/
		/*------------------------------------------------------------------Properties--------------------------------------------------------------------*/
		public var contacts:ContactList;
		public var blockType:String = BlockConfig.DEFAULT;
		public var _isDestroyed:Boolean = false;
		public var _es:EventSatellite;
		public var hasRemoved:Boolean;
		
		public var _target:Player2;
		public var _levelIsDone:Boolean = false;
		/*------------------------------------------------------------------Constructor----------------------------------------------------------------------*/
		public override function shapes():void{
		}
		
		override public function create():void{
			super.create();
			type = "Static";
			applyGravity = false;
			fixedRotation = true;
			
			listenWhileVisible(this, ContactEvent.BEGIN_CONTACT, handleContact);
			listenWhileVisible(this, ContactEvent.END_CONTACT, endContact);
			listenWhileVisible(world, StepEvent.STEP, parseInput, false, 10);
			
			contacts = new ContactList();
			contacts.listenTo(this);
			addGameEvent();
		}
		/*------------------------------------------------------------------Methods----------------------------------------------------------------------*/
		public function animate():void{
			
		}
		
		public function checkIfHitPlayer():void{
			if ( _levelIsDone ) {
				return;
			}
			
			if ( this != null ){
				if ( _target != null ){
					attackPlayer( _target );
				}
			}
		}
		
		public function attackPlayer( target:Player2 ):void
		{
			var player:Player2 = target as Player2;
			if( !player.isDead){
				player.die();
				//player.hit(0,0,0);
			}
		}
		
		
		
		public function clearAll():void
		{
			removeAllListeners();
			removeControllers();
			removeGameEvent();
		}
		
		private function initControllers():void{
		}
		
		private function removeControllers():void{
		}
		
		private function addGameEvent():void{
			_es = EventSatellite.getInstance();
			_es.addEventListener( CaveSmashEvent.LEVEL_STARTED, onLevelStarted );
			_es.addEventListener( CaveSmashEvent.LEVEL_QUIT, OnLevelQuit );
			_es.addEventListener( CaveSmashEvent.LEVEL_COMPLETE, onLevelComplete );
			_es.addEventListener( CaveSmashEvent.LEVEL_FAILED, onLevelFailed );
			_es.addEventListener( CaveSmashEvent.RELOAD_LEVEL, onReloadLevel );
		}
		
		private function removeGameEvent():void{
			_es = EventSatellite.getInstance();
			_es.removeEventListener( CaveSmashEvent.LEVEL_STARTED, onLevelStarted );
			_es.removeEventListener( CaveSmashEvent.LEVEL_QUIT, OnLevelQuit );
			_es.removeEventListener( CaveSmashEvent.LEVEL_COMPLETE, onLevelComplete );
			_es.removeEventListener( CaveSmashEvent.LEVEL_FAILED, onLevelFailed );
			_es.removeEventListener( CaveSmashEvent.RELOAD_LEVEL, onReloadLevel );
		}
		
		public function removeME():void{
			if( !hasRemoved  ){
				hasRemoved = true;
				this.remove();
			}
		}
		/*------------------------------------------------------------------Setters----------------------------------------------------------------------*/
		
		/*------------------------------------------------------------------Getters----------------------------------------------------------------------*/
		
		/*------------------------------------------------------------------EventHandlers----------------------------------------------------------------*/
		public function endContact(e:ContactEvent):void {
			if (!world  || this == null ) return;
			trace( "[ Block Base ]: end contact with: === >" + e.other.GetBody().GetUserData() );
		}
		public function handleContact(e:ContactEvent):void {
			if (!world  || this == null ) return;
			trace( "[ Block Base ]: begin contact with: === >" + e.other.GetBody().GetUserData() );
		}
		
		public function parseInput(e:Event):void{
			if (!world  || this == null ) return;
		}
		
		public function onLevelFailed(e:CaveSmashEvent):void{
			_levelIsDone = true;
			clearAll();
		}
		
		public function onLevelComplete(e:CaveSmashEvent):void {
			_levelIsDone = true;
			clearAll();
		}
		
		public function onLevelStarted(e:CaveSmashEvent):void{
			_levelIsDone = false;
			initControllers();
		}
		
		public function OnLevelQuit(e:CaveSmashEvent):void{
			clearAll();
			removeME();
		}
		
		public function onReloadLevel(e:CaveSmashEvent):void{
			clearAll();
			removeME();
		}
	}
}