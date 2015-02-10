package com.isartdigital.shmup.game.planes 
{
	import com.isartdigital.shmup.game.levelDesign.GameObjectsGenerator;
	import com.isartdigital.shmup.game.planes.HorizontalScrollingPlane;
	import com.isartdigital.shmup.game.sprites.Boss;
	import flash.geom.Rectangle;
	import com.isartdigital.utils.sound.SoundFX;
	import com.isartdigital.shmup.game.GameManager;
	
	/**
	 * Classe "plan de jeu", elle contient tous les éléments du jeu, Generateurs, Player, Ennemis, shoots...
	 * @author Baptiste MENARD
	 */
	public class GamePlane extends HorizontalScrollingPlane 
	{
		
		/**
		 * instance unique de la classe GamePlane
		 */
		protected static var instance: GamePlane;
		
		/**
		 * Frame actuelle de getScreenLimits 
		 */
		public var currentScreenLimits:Rectangle
		
		/**
		 * Tableau des générateurs 
		 */
		private var generatorArray:Vector.<GameObjectsGenerator> = new Vector.<GameObjectsGenerator>();
		
		/**
		 * Timer d'apparition du boss 
		 */
		public var timerBoss:Number = 5400;
		
		
		public function GamePlane() 
		{
			super();	
			
			// Ajout des générateurs dans le tableau
			for (var i:int = 0; i < numChildren; i++) generatorArray.push(getChildAt(i)); 	
		}
		
		/**
		 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
		 * @return instance unique
		 */
		public static function getInstance (): GamePlane {
			if (instance == null) instance = new GamePlane();
			return instance;
		}
		
		
		override protected function doActionNormal ():void {
			
			// Scrolling 
			scrolling();
			
			// Génération des obstacles et ennemis 
			activateGenerator();
			
			// Génération du boss 
			activateBoss();
		}
		
		/**
		 * Scrolling (en fonction du coefficient de vitesse des instances) 
		 * et mise à jour des bords de l'écran 
		 */
		private function scrolling ():void {
			x -= SCROLLING_SPEED * coeffScrollingSpeed;
			currentScreenLimits = getScreenLimits();
		}
		
		/**
		 * Activation des generators 
		 */
		private function activateGenerator ():void {
			for (var i:int = 0; i < generatorArray.length; i++) {
				// Apparition avant le côté droit de l'écran 
				if (generatorArray[i].x < currentScreenLimits.right + 100) { 
					generatorArray[i].generate();
					generatorArray.splice(i, 1); 
				}
			} 
		}
		
		/**
		 * Activation du boss 
		 */
		private function activateBoss ():void {
			// Décrémentation du timer de boss 
			if (timerBoss > 0) timerBoss--;
			// Apparition du boss 
			if (timerBoss == 0) {
				GamePlane.getInstance().addChild(Boss.getInstance());
				// Son du niveau stoppé 
				GameManager.getInstance().soundLevel.stop();
			}
		}
		
		override public function destroy (): void {
			instance = null;
			super.destroy();
		}
		
	}
}