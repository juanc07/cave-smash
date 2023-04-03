package components.base {	
	
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.ContactEvent;
	import com.monsterPatties.config.CaveSmashConfig;
	import com.monsterPatties.events.CaveSmashEvent;
	import com.monsterPatties.utils.eventSatellite.EventSatellite;
	import components.blocks.BlockConfig;
	import wck.*;
	
	public class MoveableBase extends BodyShape{
	
		/*------------------------------------------------------------------Constant----------------------------------------------------------------------*/		
		/*------------------------------------------------------------------Properties--------------------------------------------------------------------*/
		public var contacts:ContactList;
		public var blockType:String = BlockConfig.MOVEABLE;		
		public var _caveSmashEvent:CaveSmashEvent;
		public var _es:EventSatellite;
		private var hasRemoved:Boolean;
		private static const MOVE_POWER:Number = CaveSmashConfig.BLUE_BOX_MOVE_SPEED;
		private var isMovingRight:Boolean = false;
		private var isMovingLeft:Boolean = false;
		private var _levelIsDone:Boolean = false;
		/*------------------------------------------------------------------Constructor----------------------------------------------------------------------*/		
		override public function shapes():void 
		{
			super.shapes();			
		}
		
		override public function create():void 
		{
			super.create();
			
			type = "Dynamic";
			fixedRotation = false;			
			
			listenWhileVisible(this, ContactEvent.BEGIN_CONTACT, handleContact);
			listenWhileVisible(this, ContactEvent.END_CONTACT, endContact);
			contacts = new ContactList();
			contacts.listenTo(this);		
			addGameEvent();
		}
		/*------------------------------------------------------------------Methods----------------------------------------------------------------------*/
		private function clearAll():void
		{			
			removeAllListeners();
			removeControllers();
			removeGameEvent();			
		}
		
		private function initControllers():void 
		{
			
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
			trace( "[MoveableBase]:add GameEvent........................ " );
		}		
		
		private function removeGameEvent():void 
		{
			_es = EventSatellite.getInstance();
			_es.removeEventListener( CaveSmashEvent.LEVEL_STARTED, onLevelStarted );
			_es.removeEventListener( CaveSmashEvent.LEVEL_QUIT, OnLevelQuit );
			_es.removeEventListener( CaveSmashEvent.LEVEL_COMPLETE, onLevelComplete );			
			_es.removeEventListener( CaveSmashEvent.LEVEL_FAILED, onLevelFailed );
			_es.removeEventListener( CaveSmashEvent.RELOAD_LEVEL, onReloadLevel );
			trace( "[MoveableBase]:remove GameEvent........................ " );
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
		
		
		public function moveRight( ):void 
		{
			trace( "[ MoveableBase]: moveRight!!!" );
			if ( _levelIsDone ) {
				return;
			}			
			
			if( this != null ){				
				var speedX:Number = this.b2body.m_linearVelocity.x;
				var speedY:Number = this.b2body.m_linearVelocity.y;
				
				if ( speedX < 0 ) {
					b2body.SetLinearVelocity( new V2( 0,speedY ) );
				}
				
				b2body.ApplyImpulse(new V2( MOVE_POWER, 0), b2body.GetWorldCenter());				
				isMovingRight = true;
				isMovingLeft = false;
				trace( "[ MoveableBase]: moveRight!!!" );
			}
		}
		
		
		public function moveLeft():void 
		{
			trace( "[ MoveableBase]: moveLeft!!!" );
			if ( _levelIsDone ) {
				return;
			}
			
			if( this != null ){			
				var speedX:Number = this.b2body.m_linearVelocity.x;
				var speedY:Number = this.b2body.m_linearVelocity.y;
				
				if ( speedX > 0 ) {
					b2body.SetLinearVelocity( new V2( 0,speedY ) );
				}
				
				b2body.ApplyImpulse(new V2( -MOVE_POWER, 0), b2body.GetWorldCenter());				
				isMovingLeft = true;
				isMovingRight = false;
				
			}
		}
		
		
		/*------------------------------------------------------------------Setters----------------------------------------------------------------------*/
		
		/*------------------------------------------------------------------Getters----------------------------------------------------------------------*/
		
		/*------------------------------------------------------------------EventHandlers----------------------------------------------------------------*/
		public function endContact(e:ContactEvent):void {
			trace( "[ MoveableBase ]: end contact with: === >" + e.other.GetBody().GetUserData() );
		}
		public function handleContact(e:ContactEvent):void {
			trace( "[ MoveableBase ]: begin contact with: === >" + e.other.GetBody().GetUserData() );			
			if(this != null ){
				if ( e.other.GetBody().GetUserData() is CatcherMC  ) {
					clearAll();
					removeME();
				}
			}
		}
		
		private function onLevelFailed(e:CaveSmashEvent):void 
		{			
			_levelIsDone = true;
			clearAll();			
		}
		
		private function onLevelComplete(e:CaveSmashEvent):void 
		{			
			_levelIsDone = true;
			clearAll();
		}
		
		private function onLevelStarted(e:CaveSmashEvent):void 
		{			
			_levelIsDone = false;
			initControllers();			
		}
		
		public function OnLevelQuit(e:CaveSmashEvent):void 
		{
			clearAll();
			removeME();
		}
		
		public function onReloadLevel(e:CaveSmashEvent):void 
		{
			clearAll();
			removeME();
		}
	}
}