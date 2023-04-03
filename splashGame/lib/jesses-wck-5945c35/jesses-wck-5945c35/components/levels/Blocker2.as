package components.levels 
{
	import misc.Util;
	/**
	 * ...
	 * @author jc
	 */
	public class Blocker2 extends BlockerBase
	{
		
		public function Blocker2() 
		{
			super();
		}
		
		
		override public function removeBlocker():void 
		{
			super.removeBlocker();			
			if ( this != null && !_hasBeenRemove && world != null ) {
				if( id == 2 ){
					_hasBeenRemove = true;				
					trace( "[Blocker]: switch is now on activated remove this blocker.........." );
					removeControllers();
					Util.addChildAtPosOf(world, new FX1(), this );  
					this.remove();
				}
			}
		}
		
	}

}