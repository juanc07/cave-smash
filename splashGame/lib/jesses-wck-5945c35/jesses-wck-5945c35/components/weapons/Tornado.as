package components.weapons 
{
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.ContactEvent;
	import com.greensock.TweenLite;
	import com.monsterPatties.config.CaveSmashConfig;
	import components.players.Player2;
	import flash.events.Event;
	/**
	 * ...
	 * @author jc
	 */
	public class Tornado extends DynamicWeaponBase
	{		
		/*----------------------------------------------------------------------Constants-------------------------------------------------------------*/
		private static const DIRECTION_RIGHT:int = 0;
		private static const DIRECTION_LEFT:int = 1;
		private static const MOVE_POWER:Number = CaveSmashConfig.TORNADO_SPEED;
		/*----------------------------------------------------------------------Properties-------------------------------------------------------------*/				
		private var currentDirection:int = DIRECTION_RIGHT;
		private var hasRemoved:Boolean;		
		
		private var target:Player2;
		private var monster:MonsterMC;
		
		public function Tornado() 
		{
			super();
		}
		
		public function setDirection( dir:int ):void 
		{
			currentDirection = dir;
		}
		
		private function removeME():void 
		{
			if ( !hasRemoved ) {
				this.mc.addFrameScript( this.mc.totalFrames - 2, null );
				this.mc.addFrameScript( this.mc.totalFrames * 0.5 , null );
				hasRemoved = true;
				this.remove();
			}
		}
		
		override public function shapes():void 
		{
			super.shapes();
			//box();
			//isSensor = true;
			if ( this != null && this.mc != null ) {
				if ( currentDirection == DIRECTION_RIGHT ) {
					//this.mc.scaleX = -1;
					//this.collider.x = this.collider.width * 0.5;
				}
				//this.mc.addFrameScript( this.mc.totalFrames - 2, onEndAnimation );				
			}			
		}
		
		private function killSelf():void 
		{
			TweenLite.killDelayedCallsTo( killSelf );
			clearMe();
		}
		
		override public function create():void 
		{
			super.create();			
		}
		
		
		/* methods*/
		
		private function checkIfHitTarget():void 
		{
			TweenLite.killDelayedCallsTo(checkIfHitTarget );
			if (this != null){
				if( target != null ){
					if ( !target.isDead ){						
						target.hit( 4, 1, currentDirection );
						target = null;
					}
				}
			}else {
				return;
			}
		}
		
		private function checkIfHitMonster():void 
		{
			TweenLite.killDelayedCallsTo(checkIfHitMonster );
			if ( this != null){
				if ( monster != null ){					
					monster.kill();
					monster = null;
				}
			}else {
				return;
			}
		}	
		
		/*
		private function onEndAnimation():void 
		{
			if ( this != null ) {
				this.mc.addFrameScript( this.mc.totalFrames - 2, null );				
				removeME();
				this.dispatchEvent( new Event( Event.COMPLETE ) );
			}
		}*/
		
		private function clearMe():void 
		{
			if( this != null ){
				removeME();
				this.dispatchEvent( new Event( Event.COMPLETE ) );
			}
		}
		
		private function goLeft( ):void 
		{		
			if( this != null && !hasRemoved ){	
				b2body.SetLinearVelocity( new V2( -MOVE_POWER, 0) );
			}
		}
		
		private function goRight(  ):void 
		{			
			if( this != null && !hasRemoved ){
				b2body.SetLinearVelocity( new V2( MOVE_POWER, 0) );
			}
		}
		
		private function checkSpeedX():void
		{
			if( this != null && !hasRemoved && world != null ){
				var speedX:Number = this.b2body.m_linearVelocity.x;
				var limit:Number = CaveSmashConfig.TORNADO_SPEED;
				
				var clipped_linear_velocity:V2 = this.b2body.GetLinearVelocity().normalize();
				
				if ( speedX < 0 ){
					speedX *= -1;
				}
				
				if ( speedX >= limit ){
					this.b2body.m_linearVelocity.x = clipped_linear_velocity.multiplyN(limit).x;
				}
			}
		}
		
		
		/*------------------------------------------------EventHanlders---------------------------------------------*/
		
		override public function handleContact(e:ContactEvent):void 
		{
			super.handleContact(e);			
			if ( this != null ) {
				TweenLite.delayedCall( 5, killSelf );
				//trace( "[ Tornado ]: begin contact with: === >" + e.other.GetBody().GetUserData() );
				if( e.other.GetBody().m_userData is Player ){
					target = e.other.GetBody().m_userData;
					clearMe();
					TweenLite.delayedCall(0.2, checkIfHitTarget );
				}else if( e.other.GetBody().m_userData is MonsterMC ){
					monster = e.other.GetBody().m_userData;
					clearMe();
					TweenLite.delayedCall(0.2, checkIfHitMonster );
				}			
				
				if ( e.other.GetBody().m_userData is CatcherMC ) {
					clearMe();
				}
			}
		}
		
		override public function endContact(e:ContactEvent):void 
		{
			super.endContact(e);			
			if ( this != null ){
				if( e.other.GetBody().m_userData is Player ){
					target = null;
				}else if( e.other.GetBody().m_userData is MonsterMC ){
					monster = null;
				}			
			}		
		}
		
		override public function parseInput(e:Event):void 
		{
			super.parseInput(e);
			if (!world  || this == null && hasRemoved ) return;
			
			if( currentDirection == DIRECTION_RIGHT ){
				goRight();
			}else {
				goLeft();
			}
			checkSpeedX();			
			//checkIfHitTarget();
			//checkIfHitMonster();
		}
		
	}

}