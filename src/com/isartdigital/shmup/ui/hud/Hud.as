package com.isartdigital.shmup.ui.hud 
{
	import com.isartdigital.shmup.controller.Controller;
	import com.isartdigital.utils.Config;
	import com.isartdigital.shmup.ui.GameOver;
	import com.isartdigital.shmup.game.GameManager;
	import com.isartdigital.shmup.ui.TitleCard;
	import com.isartdigital.utils.sound.SoundFX;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import com.isartdigital.utils.ui.Screen;
	import com.isartdigital.shmup.ui.UIManager;
	import com.isartdigital.shmup.game.sprites.ElectricLine;
	import com.isartdigital.utils.ui.UIPosition;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * Classe en charge de gérer les informations du Hud
	 * @author Baptiste MENARD
	 */
	public class Hud extends Screen 
	{
		
		/**
		 * instance unique de la classe Hud
		 */
		protected static var instance: Hud;
		
		public var mcTopLeft:Sprite;
		public var mcTopCenter:Sprite;
		public var mcTopRight:Sprite;
		public var mcBottomRight:Sprite;
		
		/**
		 * Etat de la jauge de special feature 
		 */
		public static var specialReady:Boolean = false;
		
		/**
		 * Score 
		 */
		public static var score:int = 0;
		
		
		public function Hud() 
		{
			super();
			if (!Config.debug && Controller.type != Controller.TOUCH) {
				removeChild(mcBottomRight);
				mcBottomRight = null;
			}
			
			// Evènement pause 
			addEventListener(MouseEvent.MOUSE_DOWN, setPause);
		}
		
		/**
		 * Activation de la pause 
		 */
		private function setPause (pEvent:MouseEvent) {			
			if (!GameManager.getInstance().isPause) GameManager.getInstance().pause();
			else GameManager.getInstance().resume();
			// Son de click 
			var lSound:SoundFX = new SoundFX("click");
			lSound.start();
		}
		
		/**
		 * Gestion de la jauge de special feature 
		 */
		public function incrementSpecialBar ():void {
			// Récupération des movieclips de la special bar 
			var specialBar = mcTopLeft.getChildByName("mcSpecialBar");
			var bar = specialBar.getChildByName("mcBar");
			// Si jauge non remplie, remplissage 
			if (bar.x < specialBar.x - 40) bar.x += 0.2;
			// Sinon, special feature prête 
			else specialReady = true;
			// Si special lancée, jauge vidée 
			if (specialReady && ElectricLine.list.length > 0) {
				bar.x = -300;
				specialReady = false;
			}
		}							
		
		/**
		 * Mise à jour du score 
		 */
		public function updateScore ():void {
			var txtScore = mcTopCenter.getChildByName("txtScore");
			score += 100;
			txtScore.text = score;
		}
		
		/**
		 * Récupération de vie
		 */ 
		public function getLife ():void {
			if (mcTopRight.getChildByName("mcLife0").alpha < 1) mcTopRight.getChildByName("mcLife0").alpha = 1; 
			else if (mcTopRight.getChildByName("mcLife1").alpha < 1) mcTopRight.getChildByName("mcLife1").alpha = 1; 
			else if (mcTopRight.getChildByName("mcLife2").alpha < 1) mcTopRight.getChildByName("mcLife2").alpha = 1; 
			else if (mcTopRight.getChildByName("mcLife3").alpha < 1) mcTopRight.getChildByName("mcLife3").alpha = 1; 
			else if (mcTopRight.getChildByName("mcLife4").alpha < 1) mcTopRight.getChildByName("mcLife4").alpha = 1; 
		}
		
		/**
		 * Suppression de vie  
		 */
		public function loseLife ():void {
			if (mcTopRight.getChildByName("mcLife4").alpha == 1) mcTopRight.getChildByName("mcLife4").alpha = 0.2;
			else if (mcTopRight.getChildByName("mcLife3").alpha == 1) mcTopRight.getChildByName("mcLife3").alpha = 0.2;
			else if (mcTopRight.getChildByName("mcLife2").alpha == 1) mcTopRight.getChildByName("mcLife2").alpha = 0.2;
			else if (mcTopRight.getChildByName("mcLife1").alpha == 1) mcTopRight.getChildByName("mcLife1").alpha = 0.2;
			else if (mcTopRight.getChildByName("mcLife0").alpha == 1) mcTopRight.getChildByName("mcLife0").alpha = 0.2;
		}
		
		/**
		 * Récupération de smart bomb
		 */
		public function getSmartbombs ():void {
			if (mcTopLeft.getChildByName("mcBomb0").alpha < 1) mcTopLeft.getChildByName("mcBomb0").alpha = 1; 
			else if (mcTopLeft.getChildByName("mcBomb1").alpha < 1) mcTopLeft.getChildByName("mcBomb1").alpha = 1; 
			else if (mcTopLeft.getChildByName("mcBomb2").alpha < 1) mcTopLeft.getChildByName("mcBomb2").alpha = 1; 
			else if (mcTopLeft.getChildByName("mcBomb3").alpha < 1) mcTopLeft.getChildByName("mcBomb3").alpha = 1; 
		}
		
		/**
		 * Suppression de smart bomb 
		 */
		public function loseSmartBombs ():void {
			if (mcTopLeft.getChildByName("mcBomb3").alpha == 1) mcTopLeft.getChildByName("mcBomb3").alpha = 0.2;
			else if (mcTopLeft.getChildByName("mcBomb2").alpha == 1) mcTopLeft.getChildByName("mcBomb2").alpha = 0.2;
			else if (mcTopLeft.getChildByName("mcBomb1").alpha == 1) mcTopLeft.getChildByName("mcBomb1").alpha = 0.2;
			else if (mcTopLeft.getChildByName("mcBomb0").alpha == 1) mcTopLeft.getChildByName("mcBomb0").alpha = 0.2;
		}
		
		/**
		 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
		 * @return instance unique
		 */
		public static function getInstance (): Hud {
			if (instance == null) instance = new Hud();
			return instance;
		}
		
		/**
		 * repositionne les éléments du Hud
		 * @param	pEvent
		 */
		override protected function onResize (pEvent:Event=null): void {
			UIManager.getInstance().setPosition(mcTopLeft, UIPosition.TOP_LEFT);
			UIManager.getInstance().setPosition(mcTopCenter, UIPosition.TOP);
			UIManager.getInstance().setPosition(mcTopRight, UIPosition.TOP_RIGHT);
			if (mcBottomRight!=null) UIManager.getInstance().setPosition(mcBottomRight, UIPosition.BOTTOM_RIGHT);
		}
		
		/**
		 * détruit l'instance unique et met sa référence interne à null
		 */
		override public function destroy (): void {
			instance = null;
			super.destroy();
		}

	}
}