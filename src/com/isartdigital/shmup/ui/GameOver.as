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
	 * Classe Game Over (Singleton)
	 * @author Baptiste MENARD
	 */
	public class GameOver extends EndScreen 
	{
		
		/**
		 * instance unique de la classe GameOver
		 */
		protected static var instance: GameOver;
		
		/**
		 * Score 
		 */
		public var mcEndScore;
		
		
		public function GameOver() 
		{
			super();
			
			// Appui sur le bouton next 
			btnNext.addEventListener(MouseEvent.CLICK, restartGame);
		}
		
		/**
		 * Relancement du jeu 
		 */
		private function restartGame (e:MouseEvent):void {
			// Si score bas, ouverture de l'aide 
			if (Hud.score <= 1000) {
				// Remise à zéro du score
				Hud.score = 0;
				UIManager.getInstance().addScreen(Help.getInstance());
			}
			// Sinon, lancement direct du jeu 
			else {
				Hud.score = 0;
				GameManager.getInstance().start();
			}
		}
		
		/**
		 * Affichage du score 
		 */
		public function displayEndScore ():void {
			var txtEndScore:TextField = mcEndScore.getChildByName("endScore"); 
			txtEndScore.text = "Score : " + Hud.score;
		}
		
		/**
		 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
		 * @return instance unique
		 */
		public static function getInstance (): GameOver {
			if (instance == null) instance = new GameOver();
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