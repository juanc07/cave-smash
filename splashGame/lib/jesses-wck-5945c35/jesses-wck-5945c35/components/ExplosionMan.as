package components
{
    import Box2DAS.Dynamics.*;
    import flash.display.*;
    import flash.events.*;
    import shapes.*;
    import wck.*;

    public class ExplosionMan extends Circle
    {
        private var ndx:Number = 0;
        private var ndy:Number = 0;
        private var bulletSpeed:int = 1;
        private var mouseAngle:Number = 0;
        private var bombPower:Number = 7;
        public var contacts:ContactList;
        private var dx:Number = 0;
        private var dy:Number = 0;
        private var quake:Number = 0;
        private var quakevalue:int = 10;

        public function ExplosionMan()
        {
            return;
        }// end function

        function newFrameListener(event:Event) : void
        {
            if (this.quake > 0)
            {
                this.quake = this.quake - 0.2;
                MovieClip(this.parent).x = Math.random() * this.quake - this.quake * 0.5;
            }
            return;
        }// end function

        override public function create() : void
        {
            reportBeginContact = true;
            reportEndContact = true;
            fixedRotation = true;
            allowDragging = true;
            this.quake = this.quakevalue;
            //MovieClip(root).bomb_channel = MovieClip(root).bomb_sound.play();
            isSensor = true;
            type = "Animated";
            super.create();
            listenWhileVisible(this, ContactEvent.BEGIN_CONTACT, this.handleContact);
            listenWhileVisible(this, Event.ENTER_FRAME, this.newFrameListener);
            this.contacts = new ContactList();
            this.contacts.listenTo(this);
            return;
        }// end function

        public function handleContact(event:ContactEvent) : void
        {
            var _loc_2:* = event.other.m_userData as BodyShape;
            if (_loc_2)
            {
				trace( "[ExplosionMan]: started to explode......." );
                _loc_2.awake = true;
                this.dx = this.x - _loc_2.x;
                this.dy = this.y - _loc_2.y;
                this.mouseAngle = Math.atan2(-this.dy, -this.dx) * 180 / Math.PI;
                this.ndx = this.x - (this.x + this.bulletSpeed * Math.cos(this.mouseAngle * Math.PI / 180));
                this.ndy = this.y - (this.y + this.bulletSpeed * Math.sin(this.mouseAngle * Math.PI / 180));
                _loc_2.linearVelocityX = (-this.ndx) * this.bombPower;
                _loc_2.linearVelocityY = (-this.ndy) * this.bombPower;
            }
            return;
        }// end function

    }
}
