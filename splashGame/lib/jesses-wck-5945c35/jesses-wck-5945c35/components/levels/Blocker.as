package components.levels 
{
	import misc.Util;
	/**
	 * ...
	 * @author jc
	 */
	public class Blocker extends BlockerBase
	{
		
		public function Blocker() 
		{
			super();
		}
		
		
		override public function removeBlocker():void 
		{
			super.removeBlocker();			
			if ( this != null && !_hasBeenRemove && world != null ) {
				if( id == 1 ){
					_hasBeenRemove = true;				
					trace( "[Blocker1]: switch is now on activated remove this blocker.........." );
					removeControllers();
					Util.addChildAtPosOf(world, new FX1(), this );  
					this.remove();
				}
			}
		}
		
	}

}