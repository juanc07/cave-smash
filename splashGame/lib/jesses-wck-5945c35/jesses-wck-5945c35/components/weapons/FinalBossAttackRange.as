package components.weapons 
{
	import Box2DAS.Dynamics.ContactEvent;
	import com.greensock.TweenLite;
	import com.monsterPatties.config.CaveSmashConfig;
	import com.monsterPatties.events.CaveSmashEvent;
	import com.monsterPatties.utils.eventSatellite.EventSatellite;
	import components.base.MoveableBase;
	import components.config.CSObjects;
	import components.players.Player2;
	import flash.events.Event;
	import flash.geom.Point;
	import misc.Util;
	import wck.BodyShape;
	import wck.ContactList;
	/**
	 * ...
	 * @author jc
	 */
	public class FinalBossAttackRange extends BodyShape {	
		
		/*----------------------------------------------------------------------Constants-------------------------------------------------------------*/		
		private static const DIRECTION_RIGHT:int = 0;
		private static const DIRECTION_LEFT:int = 1;
		/*----------------------------------------------------------------------Properties-------------------------------------------------------------*/
		private var currentDirection:int = DIRECTION_RIGHT;
		public var contacts:ContactList;
		public var KNOCK_BACK_POWER:Number = CaveSmashConfig.BOSS_DARK_ATTACK_KNOCK_BACK_POWER;
		public var KNOCK_BACK_RANGE:Number = CaveSmashConfig.BOSS_DARK_ATTACK_KNOCK_BACK_RANGE;
		
		//cavesmash events
		private var _es:EventSatellite;
		private var _caveSmashEvent:CaveSmashEvent;
		private var _isRemove:Boolean = false;
		private var isAddEffect:Boolean;	
		private var _hasEffect:Boolean = false;		
		private var _player:Player2;
		/*----------------------------------------------------------------------Constructor-------------------------------------------------------------*/
		public override function shapes():void {			
			
		}
		
		override public function create():void 
		{
			super.create();
			type = "Dynamic";
			applyGravity = false;
			
			if( world != null &&  this != null ){
				listenWhileVisible(this, ContactEvent.BEGIN_CONTACT, handleContact);
				listenWhileVisible(this, ContactEvent.END_CONTACT, endContact);
				contacts = new ContactList();
				contacts.listenTo(this);				
			}
			initControllers();
			TweenLite.delayedCall( 0.3 , removeME );
			trace("final boss attack range created!!!!!!!!!!!");
		}
		
		/*----------------------------------------------------------------------Methods-------------------------------------------------------------*/
		
		public function setDirection( dir:int ):void 
		{
			currentDirection = dir;
		}		
		
		private function initControllers():void 
		{
			_es = EventSatellite.getInstance();
		}
		
		private function removeControllers():void 
		{
			
		}		
		
		private function removeME():void 
		{
			if ( this != null && !_isRemove ) {
				TweenLite.killDelayedCallsTo(removeME);
				_isRemove = true;				
				this.remove();	
				_caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.ON_REMOVE_ATTACK_RANGE );
				_es.dispatchESEvent( _caveSmashEvent );
			}
		}
		
		private function addHitEffect( val:Boolean ):void 
		{
			if ( val && this != null && !_hasEffect ) {
				var hitEffect:HitEffectMC = new HitEffectMC();
				hitEffect.addEventListener( Event.COMPLETE, onComplete );
				if( currentDirection == DIRECTION_RIGHT ){
					Util.addChildAtPosOf( world,hitEffect, this, -1, new Point( 5 , -15 ) );
				}else {
					Util.addChildAtPosOf( world, hitEffect, this, -1, new Point(  -25 , -15 ) );
				}
				_hasEffect = true;
			}
		}
		
		private function onComplete(e:Event):void 
		{
			_hasEffect = false;
			trace( "[ AttackRange ]: hit Effect remove!!! " );
		}
		
		/*----------------------------------------------------------------------Setters-------------------------------------------------------------*/
		
		/*----------------------------------------------------------------------Getters-------------------------------------------------------------*/
		
		/*----------------------------------------------------------------------Events-------------------------------------------------------------*/
		
		public function endContact(e:ContactEvent):void {
			if( this != null ){				
			}
			
			if ( e.other.GetBody().GetUserData() is Player2 ){
				_player = null;
			}			
		}
		public function handleContact(e:ContactEvent):void{			
			if ( this != null && !_isRemove ) {				
				trace( "[ AttackRange ]: begin contact with: === >" + e.other.GetBody().GetUserData() );				
				
				if ( e.other.GetBody().GetUserData() is Player2 ){
					_player = e.other.GetBody().m_userData;
					if( _player != null ){
						_player.hit(KNOCK_BACK_POWER ,KNOCK_BACK_RANGE,currentDirection);
					}
				}
				
				if (   e.other.GetBody().GetUserData() is NormalBlockMC ) {
					var normalBlockMC:NormalBlockMC = e.other.GetBody().m_userData;
					if ( normalBlockMC != null ){
						normalBlockMC.animate();
						//removeME();
					}
				}
				
				var monsterLen:int = CSObjects.MONSTERS.length;
				for (var i:int = 0; i < monsterLen; i++) 
				{
					if ( e.other.GetBody().GetUserData() is CSObjects.MONSTERS[i]) {
						var monster:* = e.other.GetBody().m_userData;					
						if( monster != null ){
							isAddEffect = monster.kill(  );
							addHitEffect( isAddEffect );
							//removeME();
						}
					}
				}	
				
				
				if ( e.other.GetBody().GetUserData() is MoveableBase	){
					var moveableBlockMC:MoveableBase = e.other.GetBody().m_userData;
					if ( moveableBlockMC != null && !isAddEffect ) {
						if ( currentDirection == DIRECTION_RIGHT ) {
							moveableBlockMC.moveRight();							
						}else {
							moveableBlockMC.moveLeft();
						}
						
						isAddEffect = true;
						addHitEffect( isAddEffect );
						//removeME();
					}
				}else if ( e.other.GetBody().GetUserData() is BigRockMC	){
					var bigRockMC:BigRockMC = e.other.GetBody().m_userData;
					if ( bigRockMC != null && !isAddEffect ) {
						if ( currentDirection == DIRECTION_RIGHT ) {
							bigRockMC.moveRight();							
						}else {
							bigRockMC.moveLeft();
						}
						
						isAddEffect = true;
						addHitEffect( isAddEffect );
						//removeME();
					}
				}		
			}
		}		
	}
}