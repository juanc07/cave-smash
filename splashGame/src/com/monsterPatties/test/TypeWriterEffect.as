package com.monsterPatties.test 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import com.greensock.TweenLite;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.plugins.TypewriterPlugin;
	
	/**
	 * ...
	 * @author jc
	 */
	public class TypeWriterEffect extends Sprite
	{
		private var textField:TextField;
		private var _scriptTracker:int;
		private var scripts:Vector.<String>;
		private var _isActivated:Boolean = false;
		private var format:TextFormat;
		private var speed:Number;
		
		public function TypeWriterEffect() 
		{
			addEventListener( Event.ADDED_TO_STAGE, init );
		}
		
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
		
		private function setDisplay():void 
		{
			activateScript();			
			addEventListener(  MouseEvent.CLICK , onClick );
		}
		
		
		private function activateScript():void 
		{		
			if ( !_isActivated ) {
				_isActivated = true;
				
				scripts = Vector.<String>([  "Hi Im Geezer and who are you?", "I see you are also an adventurer?" , "What's your Goal?", "I think that's a Bad Idea", "You will Just Die If you will Continue this journey", "Give up young Adventurer!!"  ]);				
				
				format = new TextFormat();
				format.color = 0x00FF00;
				format.size = 30;
				
				textField = new TextField();
				addChild( textField );			
				textField.width = 500;
				textField.height = 500;
				textField.text = "";			
				textField.defaultTextFormat = format;
				textField.setTextFormat(format);
				textField.wordWrap = true;
				
				
				textField.x = 50;
				textField.y = 50;
				
				speed = 1;
				TweenPlugin.activate([TypewriterPlugin]); //activation is permanent in the SWF, so this line only needs to be run once.
			}
			
			if( _scriptTracker < scripts.length ){
				textField.text = "";
				TweenLite.to(textField, speed, { typewriter:scripts[ _scriptTracker ] } );		
			}
		}
		
		private function onClick(e:MouseEvent):void 
		{
			_scriptTracker++;
			activateScript();
			trace( "click!!!" );
		}
		
		
		private function removeDisplay():void 
		{
			if ( textField != null ) {
				if ( this.contains( textField ) ) {
					this.removeChild( textField );
					textField = null;
				}
			}
		}
	}

}