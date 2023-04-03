package com.monsterPatties.utils 
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	/**
	 * ...
	 * @author jc
	 */
	public class Helper 
	{
		
		public function Helper() 
		{
			
		}
		
		public static function getCover():Sprite 
		{
			var _cover:Sprite = new Sprite();
			_cover.graphics.lineStyle( 1, 0x000000 );
			_cover.graphics.beginFill( 0x000000 );
			_cover.graphics.drawRect( 0, 0, 640, 480 );			
			
			return _cover;
		}
		
		
		public static function createTextField( fontText:String,fontSize:int = 18, fontWidth:int = 300, fontHeight:int = 110 ,fontColor:uint = 0xFF0000, fontName:String = "Times New Roman", fontAlignment:String = TextFormatAlign.CENTER, fontBorder:Boolean = false, fontMultiline:Boolean =false ):TextField {
			var txtFormat:TextFormat = new TextFormat();
			txtFormat.color =fontColor;
			txtFormat.size = fontSize;
			txtFormat.font =fontName;
			txtFormat.align = fontAlignment;
			
			var txtField:TextField = new TextField();						
			txtField.width = fontWidth;
			txtField.height = fontHeight;
			txtField.border = fontBorder;
			txtField.multiline = fontMultiline;			
			txtField.text = fontText;
			txtField.selectable = false;			
			
			txtField.embedFonts = true;
			txtField.setTextFormat( txtFormat );
			
			return txtField;
		}
		
	}

}