package com.monsterPatties.ui 
{
	import com.monsterPatties.events.CaveSmashEvent;
	import com.monsterPatties.utils.eventSatellite.EventSatellite;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author jc
	 */
	public class MessageInfoBox extends Sprite
	{
		/*------------------------------------------------------------------------Constants----------------------------------------------------------------*/
		
		/*------------------------------------------------------------------------Properties--------------------------------------------------------------*/
		private var _mc:MessageInfoBoxMC;
		private var _id:int;
		private var _msg:String;
		private var _es:EventSatellite;
		private var _caveSmashEvent:CaveSmashEvent;
		/*------------------------------------------------------------------------Constructor--------------------------------------------------------------*/
		public function MessageInfoBox( id:int , msg:String ) 
		{
			this._id = id;
			this._msg = msg;
			addEventListener( Event.ADDED_TO_STAGE, init );
		}
		
		
		/*------------------------------------------------------------------------Methods--------------------------------------------------------------*/
		private function setDisplay():void 
		{
			_es = EventSatellite.getInstance();
			
			_mc = new MessageInfoBoxMC();
			addChild( _mc );
			_mc.txtInfo.text = _msg;
			if ( id == 0 ) {
				_mc.coin.visible = false;
				_mc.crystal.visible = true;
			}else {
				_mc.coin.visible = true;
				_mc.crystal.visible = false;
			}
			
			_mc.xButton.buttonMode = true;
			_mc.xButton.addEventListener( MouseEvent.CLICK, onClickXButton );
		}		
		
		private function removeDisplay():void 
		{
			if ( _mc != null ) {
				_mc.xButton.buttonMode = false;
				_mc.xButton.removeEventListener( MouseEvent.CLICK, onClickXButton );
				if ( this.contains( _mc ) ) {
					this.removeChild( _mc );
					_mc = null;
				}
			}
		}
		/*------------------------------------------------------------------------Setters---------------------------------------------------------*/
		public function set id(value:int):void 
		{
			_id = value;
		}
		
		public function set msg(value:String):void 
		{
			_msg = value;
		}
		
		/*------------------------------------------------------------------------Getters---------------------------------------------------------*/		
		public function get id():int 
		{
			return _id;
		}
		
		public function get msg():String 
		{
			return _msg;
		}		
		/*------------------------------------------------------------------------EventHandlers---------------------------------------------------------*/
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener( Event.REMOVED_FROM_STAGE, destroy );
			setDisplay();
		}
		
		private function destroy(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			removeDisplay();
		}		
		
		private function onClickXButton(e:MouseEvent):void 
		{
			_caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.ON_REMOVE_INFO );
			_es.dispatchESEvent( _caveSmashEvent );			
		}
		
	}

}