package components.levels 
{
	import com.monsterPatties.events.CaveSmashEvent;
	import components.colliders.SwitchBase;
	/**
	 * ...
	 * @author jc
	 */
	public class Switch extends SwitchBase
	{
		
		public function Switch() 
		{
			super();			
		}
		
		override public function create():void 
		{
			super.create();
			id = 1;
		}
		
		override public function activate():void 
		{
			super.activate();
			
			if ( !_isSwitch && this.mc.currentFrameLabel != LABEL_ANIMATE && this.mc != null && this.collider != null ) {
				trace( "[switch1]: switch is activating.........." );
				_isSwitch = true;
				this.mc.addFrameScript( this.mc.totalFrames - 2, onEndAnimation );
				this.mc.gotoAndPlay( LABEL_ANIMATE );
			}
		}
		
		private function onEndAnimation():void 
		{			
			if ( this != null ){
				trace( "[switch1]: switch is now on activated.........." );
				this.mc.addFrameScript( this.mc.totalFrames - 2, null );
				_caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.SWITCH_ACTIVATED );
				_caveSmashEvent.obj.id = id;
				_es.dispatchESEvent( _caveSmashEvent );				
			}
		}
		
	}

}