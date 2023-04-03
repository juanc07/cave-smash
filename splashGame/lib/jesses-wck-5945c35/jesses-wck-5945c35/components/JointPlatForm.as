package components 
{
	import shapes.Box;
	
	/**
	 * ...
	 * @author testko
	 */
	public class JointPlatForm extends Box
	{
		
		
		override public function create() : void
        {            
			super.create();
			allowDragging = false;
		}		
	}

}