package com.isartdigital.shmup.ui 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import com.isartdigital.shmup.game.planes.GamePlane;
	import com.isartdigital.shmup.game.GameManager;
	import flash.text.TextField;
	import com.isartdigital.utils.game.GameObject;
	import com.isartdigital.shmup.ui.hud.Hud;	
	import com.isartdigital.shmup.game.sprites.Player;
	import com.isartdigital.utils.game.GameStage;
	import com.isartdigital.shmup.game.sprites.Enemies.EnemyManager;
	import com.isartdigital.shmup.game.levelDesign.GameObjectsGenerator;
	import com.isartdigital.shmup.game.sprites.Obstacle;
	import com.isartdigital.shmup.game.sprites.ShootEnemy;
	import com.isartdigital.shmup.game.sprites.SmartBomb;
	import com.isartdigital.shmup.game.sprites.Tag;
	import com.isartdigital.shmup.game.sprites.ElectricLine;
	import com.isartdigital.shmup.game.sprites.ShootPlayer;
	import com.isartdigital.shmup.game.sprites.Explosion;
	import com.isartdigital.shmup.game.sprites.Collectables.CollectableManager;
	
	/**
	 * Ecran de Victoire (Singleton)
	 * @author Mathieu ANTHOINE
	 */
	public class WinScreen extends EndScreen 
	{
		/**
		 * instance unique de la classe WinScreen
		 */
		protected static var instance: WinScreen;
		
		/**
		 * Score 
		 */
		public var mcWinScore;
		
		
		public function WinScreen() 
		{
			super();
			
			// Appui sur le bouton next 
			btnNext.addEventListener(MouseEvent.CLICK, restartGame);
		}
		
		/**
		 * Relancement du jeu 
		 */
		private function restartGame (e:MouseEvent):void {
			// Remise à zéro du score
			Hud.score = 0;
			GameManager.getInstance().start();
		}
		
		/**
		 * Affichage du score 
		 */
		public function displayWinScore ():void {
			var txtWinScore:TextField = mcWinScore.getChildByName("endScore"); 
			txtWinScore.text = "Score : " + Hud.score;
		}
		
		/**
		 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
		 * @return instance unique
		 */
		public static function getInstance (): WinScreen {
			if (instance == null) instance = new WinScreen();
			return instance;
		}
		
		/**
		 * détruit l'instance unique et met sa référence interne à null
		*/
		override public function destroy (): void {
			btnNext.removeEventListener(MouseEvent.CLICK, restartGame);
			instance = null;
			super.destroy();
		}
		
	}

}