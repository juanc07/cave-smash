package components 
{	
	import shapes.Box;
	/**
	 * ...
	 * @author testko
	 */
	public class PirateMonster extends Box
	{
		
		/*-------------------------------------------------------------------------Constant---------------------------------------------------------------*/
		
		/*-------------------------------------------------------------------------Properties-------------------------------------------------------------*/
		
		/*-------------------------------------------------------------------------Constructor------------------------------------------------------------*/
		
		override public function create() : void
        {            
			super.create();
			
			//b2body.SetMassData( 500 );
			//density = 500;
			friction = 3;
			restitution = 0.1;
			categoryBits = 2;			
			//categoryBits = 0x0002;
			//_categoryBits =0x0002;
			//_maskBits = 0x0004;
			//maskBits = 0x0004;
		}
		
		/*-------------------------------------------------------------------------Methods---------------------------------------------------------------*/
		
		/*-------------------------------------------------------------------------Setters---------------------------------------------------------------*/
		/*-------------------------------------------------------------------------Getters---------------------------------------------------------------*/
		/*-------------------------------------------------------------------------EventHandlers---------------------------------------------------------*/
		
	}

}