package components.weapons 
{
	import Box2DAS.Dynamics.ContactEvent;
	import components.players.Player2;
	import flash.events.Event;
	/**
	 * ...
	 * @author jc
	 */
	public class GroundSpike extends StaticWeaponBase
	{		
		/*----------------------------------------------------------------------Constants-------------------------------------------------------------*/
		private static const DIRECTION_RIGHT:int = 0;
		private static const DIRECTION_LEFT:int = 1;		
		/*----------------------------------------------------------------------Properties-------------------------------------------------------------*/				
		private var currentDirection:int = DIRECTION_RIGHT;
		private var hasRemoved:Boolean;
		private var takeHitEffect:Boolean = false;
		
		private var target:Player2;
		private var monster:MonsterMC;
		
		public function GroundSpike() 
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
					this.mc.scaleX = -1;
					this.collider.x = this.collider.width * 0.5;
				}
				this.mc.addFrameScript( this.mc.totalFrames - 2, onEndAnimation );
				this.mc.addFrameScript( this.mc.totalFrames * 0.5 , onTakeHit );
			}
		}
		
		override public function create():void 
		{
			super.create();			
		}
		
		
		/* methods*/
		
		private function checkIfHitTarget():void 
		{
			if ( this != null && takeHitEffect ){
				if( target != null ){
					if( !target.isDead ){
						target.hit( 6,2, currentDirection );
						target = null;
					}
				}
			}else {
				return;
			}
		}
		
		private function checkIfHitMonster():void 
		{
			if ( this != null && takeHitEffect ){
				if( monster != null ){					
					monster.kill();
					monster = null;
				}
			}else {
				return;
			}
		}
		
		private function onTakeHit():void {
			takeHitEffect = true;
		}
		
		private function onEndAnimation():void 
		{
			if ( this != null ) {
				this.mc.addFrameScript( this.mc.totalFrames - 2, null );				
				removeME();
				this.dispatchEvent( new Event( Event.COMPLETE ) );
			}
		}
		
		
		/*------------------------------------------------EventHanlders---------------------------------------------*/
		
		override public function handleContact(e:ContactEvent):void 
		{
			super.handleContact(e);		
			trace( "[ GroundSpike ]: begin contact with: === >" + e.other.GetBody().GetUserData() );
			if ( this != null ){
				if( e.other.GetBody().m_userData is Player ){
					target = e.other.GetBody().m_userData;
				}else if( e.other.GetBody().m_userData is MonsterMC ){
					monster = e.other.GetBody().m_userData;
				}else if( e.other.GetBody().m_userData is NormalBlockMC ){					
					var normalBlockMC:NormalBlockMC = e.other.GetBody().m_userData;
					if ( normalBlockMC ){
						normalBlockMC.animate();
					}
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
			checkIfHitTarget();
			checkIfHitMonster();
		}
		
	}

}