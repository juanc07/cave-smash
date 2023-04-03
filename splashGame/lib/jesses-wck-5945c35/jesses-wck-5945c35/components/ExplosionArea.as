package components
{
	import Box2DAS.Dynamics.*;
	import flash.display.*;
	import flash.events.*;
	import shapes.*;
	import wck.*;

    public class ExplosionArea extends Circle
    {
		/*----------------------------------------------------------------------------Constant------------------------------------------------------------*/
		
		/*----------------------------------------------------------------------------Properties------------------------------------------------------------*/
		private var speed:int = 1;
        private var mouseAngle:Number = 0;		
		private var shake:Number = 0;
        private var shakeValue:int = 10;
        private var explosionPower:Number = 7;		
		
        private var newDX:Number = 0;
        private var newDy:Number = 0;       		
        
        private var dx:Number = 0;
        private var dy:Number = 0;       
		
		public var contacts:ContactList;
		
		/*----------------------------------------------------------------------------Constructor------------------------------------------------------------*/

        public function ExplosionArea()
        {
            return;
        }
		
		/*----------------------------------------------------------------------------Methods------------------------------------------------------------*/
		override public function create() : void
        {
			super.create();
			
            reportBeginContact = true;
            reportEndContact = true;
            fixedRotation = true;
            allowDragging = true;            
            isSensor = true;
            type = "Animated";   
			
			this.shake = this.shakeValue;			
            
            this.contacts = new ContactList();
            this.contacts.listenTo(this);
			listenWhileVisible(this, ContactEvent.BEGIN_CONTACT, this.handleContact);
            listenWhileVisible(this, Event.ENTER_FRAME, this.shakeListener);			
            return;
        }
		
		/*----------------------------------------------------------------------------Setters----------------------------------------------------------------*/
		
		/*----------------------------------------------------------------------------Getters----------------------------------------------------------------*/
		
		/*----------------------------------------------------------------------------EventHandlers----------------------------------------------------------*/

       private function shakeListener(event:Event) : void
        {
            if (this.shake > 0)
            {
                this.shake = this.shake - 0.2;
                MovieClip(this.parent).x = Math.random() * this.shake - this.shake * 0.5;
            }
            return;
        }       

        public function handleContact(event:ContactEvent) : void
        {
            var _obj:* = event.other.m_userData as BodyShape;
            if (_obj)
            {
				trace( "[ExplosionArea]: started to explode......." );
                _obj.awake = true;
                this.dx = this.x - _obj.x;
                this.dy = this.y - _obj.y;
                this.mouseAngle = Math.atan2(-this.dy, -this.dx) * 180 / Math.PI;
                this.newDX = this.x - (this.x + this.speed * Math.cos(this.mouseAngle * Math.PI / 180));
                this.newDy = this.y - (this.y + this.speed * Math.sin(this.mouseAngle * Math.PI / 180));
                _obj.linearVelocityX = (-this.newDX) * this.explosionPower;
                _obj.linearVelocityY = (-this.newDy) * this.explosionPower;
            }
            return;
        }

    }
}
