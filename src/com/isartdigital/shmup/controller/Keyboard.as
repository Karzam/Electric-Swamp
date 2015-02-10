package com.isartdigital.shmup.controller 
{
	import com.isartdigital.utils.Config;
	import com.isartdigital.shmup.game.GameManager;
	import com.isartdigital.utils.game.GameStage; 
	import com.isartdigital.shmup.game.sprites.Player; 
	import flash.events.KeyboardEvent;
	
	import flash.ui.Keyboard;
	
	/**
	 * Controleur clavier
	 * @author Baptiste MENARD
	 */
	public class Keyboard extends Controller
	{	
		
		/**
		 * État des touches
		 */
		protected var keyboardLeft:Number = 0;
		protected var keyboardRight:Number = 0;
		protected var keyboardDown:Number = 0;
		protected var keyboardUp:Number = 0;
		protected var keyboardFire:Boolean = false; 
		protected var keyboardBomb:Boolean = false;
		protected var keyboardSpecial:Boolean = false; 
		protected var keyboardPause:Boolean = false;
		protected var keyboardGod:Boolean = false;
		
		
		public function Keyboard() 
		{
			super();
			
			// donne le focus au stage pour capter les evenements de clavier
			Config.stage.focus = Config.stage;
			
			// Listener d'évènements clavier
			Config.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
			Config.stage.addEventListener(KeyboardEvent.KEY_UP, keyReleased); 
		}
		
		
		/**
		 * Récupère la touche pressée 
		 */
		public function keyPressed (pEvent:KeyboardEvent):void
		{
			if (pEvent.keyCode == flash.ui.Keyboard.LEFT) {
				keyboardLeft = 1; 
			}
			if (pEvent.keyCode == flash.ui.Keyboard.RIGHT) {
				keyboardRight = 1; 
			}
			if (pEvent.keyCode == flash.ui.Keyboard.DOWN) {
				keyboardDown = 1; 
			}
			if (pEvent.keyCode == flash.ui.Keyboard.UP) {
				keyboardUp = 1; 
			}
			if (pEvent.keyCode == flash.ui.Keyboard.Q) {
				keyboardFire = true; 
			}	
			if (pEvent.keyCode == flash.ui.Keyboard.S) {
				keyboardBomb = true;
			}
			if (pEvent.keyCode == flash.ui.Keyboard.D) {
				keyboardSpecial = true; 
			}
			if (pEvent.keyCode == flash.ui.Keyboard.SPACE) {
				keyboardPause = true; 
			}
			if (pEvent.keyCode == flash.ui.Keyboard.G ) {
				keyboardGod = true; 
			}
		}
		
		/**
		 * Récupère la touche relâchée
		 */
		public function keyReleased (pEvent:KeyboardEvent):void
		{
			if (pEvent.keyCode == flash.ui.Keyboard.LEFT) {
				keyboardLeft = 0; 
			}
			if (pEvent.keyCode == flash.ui.Keyboard.RIGHT) {
				keyboardRight = 0; 
			}
			if (pEvent.keyCode == flash.ui.Keyboard.DOWN) {
				keyboardDown = 0; 
			}
			if (pEvent.keyCode == flash.ui.Keyboard.UP) {
				keyboardUp = 0; 
			}
			if (pEvent.keyCode == flash.ui.Keyboard.Q) {
				keyboardFire = false; 			
			}
			if (pEvent.keyCode == flash.ui.Keyboard.S) {
				keyboardBomb = false;
			}
			if (pEvent.keyCode == flash.ui.Keyboard.D) {
				keyboardSpecial = false; 
			}
			if (pEvent.keyCode == flash.ui.Keyboard.SPACE) {
				keyboardPause = false; 
			}
			if (pEvent.keyCode == flash.ui.Keyboard.G) {
				keyboardGod = false; 
			}
		}
		
		/* 
		 * Returne true si la touche correspondante est pressée 
		 */
		public override function get left ():Number 
		{
			return keyboardLeft; 
		}

		public override function get right ():Number 
		{
			return keyboardRight;
		}
		
		public override function get up ():Number 
		{
			return keyboardUp; 
		}
		
		public override function get down ():Number 
		{
			return keyboardDown; 
		}
		
		public override function get fire ():Boolean 
		{
			return keyboardFire; 
		}
		public override function get bomb ():Boolean 
		{
			return keyboardBomb;
		}
		public override function get special ():Boolean
		{
			return keyboardSpecial;
		}
		public override function get pause ():Boolean
		{
			return keyboardPause;
		}
		public override function get god ():Boolean
		{
			return keyboardGod;
		}
	}
}