package components.weapons 
{
	import Box2DAS.Dynamics.ContactEvent;
	import com.greensock.TweenLite;
	import com.monsterPatties.events.CaveSmashEvent;
	import com.monsterPatties.utils.eventSatellite.EventSatellite;
	import components.base.MoveableBase;
	import components.config.CSObjects;
	import flash.events.Event;
	import flash.geom.Point;
	import misc.Util;
	import wck.BodyShape;
	import wck.ContactList;
	/**
	 * ...
	 * @author jc
	 */
	public class AttackRange extends BodyShape {	
		
		/*----------------------------------------------------------------------Constants-------------------------------------------------------------*/		
		private static const DIRECTION_RIGHT:int = 0;
		private static const DIRECTION_LEFT:int = 1;
		/*----------------------------------------------------------------------Properties-------------------------------------------------------------*/
		private var currentDirection:int = DIRECTION_RIGHT;
		public var contacts:ContactList;
		
		//cavesmash events
		private var _es:EventSatellite;
		private var _caveSmashEvent:CaveSmashEvent;
		private var _isRemove:Boolean = false;
		private var isAddEffect:Boolean;	
		private var _hasEffect:Boolean = false;
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
			TweenLite.delayedCall( 0.1 , removeME );
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
				//trace( "[ pOO ]: end contact with: === >" + e.other.GetBody().GetUserData() );			
				//if ( e.other.GetBody().GetUserData() is Player2 ) {
					//
				//}
			}
		}
		public function handleContact(e:ContactEvent):void{			
			if ( this != null && !_isRemove ) {				
				trace( "[ AttackRange ]: begin contact with: === >" + e.other.GetBody().GetUserData() );				
				
				if (   e.other.GetBody().GetUserData() is NormalBlockMC ) {
					var normalBlockMC:NormalBlockMC = e.other.GetBody().m_userData;
					if ( normalBlockMC != null ){
						normalBlockMC.animate();
						removeME();
					}
				}
				
				var monsterLen:int = CSObjects.MONSTERS.length;
				for (var i:int = 0; i < monsterLen; i++) 
				{
					if ( e.other.GetBody().GetUserData() is CSObjects.MONSTERS[i]) {
						var monster:* = e.other.GetBody().m_userData;					
						if( monster != null ){
							isAddEffect = monster.hit(  currentDirection, true );
							addHitEffect( isAddEffect );
							removeME();
						}
					}
				}
				
				var bossLen:int = CSObjects.BOSS.length;
				for (var i:int = 0; i < bossLen; i++) 
				{
					if ( e.other.GetBody().GetUserData() is CSObjects.BOSS[i]) {
						var monster:* = e.other.GetBody().m_userData;					
						if( monster != null ){							
							isAddEffect = monster.hit(  currentDirection, true, 1 );
							addHitEffect( isAddEffect );							
							removeME();
						}
					}
				}			
				
				if ( e.other.GetBody().GetUserData() is PooMC	){
					var pooMC:PooMC = e.other.GetBody().m_userData;
					if ( pooMC != null ) {
						pooMC.hit();
						isAddEffect = true;
						addHitEffect( isAddEffect );
						removeME();
					}
				}else if ( e.other.GetBody().GetUserData() is MoveableBase	){
					var moveableBlockMC:MoveableBase = e.other.GetBody().m_userData;
					if ( moveableBlockMC != null && !isAddEffect ) {
						if ( currentDirection == DIRECTION_RIGHT ) {
							moveableBlockMC.moveRight();							
						}else {
							moveableBlockMC.moveLeft();
						}
						
						isAddEffect = true;
						addHitEffect( isAddEffect );
						removeME();
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
						removeME();
					}
				}else if ( e.other.GetBody().GetUserData() is BombMC){
					var bombMC:BombMC = e.other.GetBody().m_userData;
					if ( bombMC != null && !isAddEffect ) {
						if ( currentDirection == DIRECTION_RIGHT ) {
							bombMC.moveRight();							
						}else {
							bombMC.moveLeft();
						}
						
						isAddEffect = true;
						addHitEffect( isAddEffect );
						removeME();
					}
				}else if ( e.other.GetBody().GetUserData() is DarkBossRockMC){
					var darkBossRockMC:DarkBossRockMC = e.other.GetBody().m_userData;
					if ( darkBossRockMC != null && !isAddEffect ) {
						darkBossRockMC.isEnemyBullet = false;
						if ( currentDirection == DIRECTION_RIGHT ) {
							darkBossRockMC.forwardForce();
						}else {
							darkBossRockMC.backwardForce();
						}
						
						isAddEffect = true;
						addHitEffect( isAddEffect );
						removeME();
					}
				}				
			}
		}		
	}
}