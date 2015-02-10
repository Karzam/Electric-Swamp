package com.isartdigital.shmup.game {
	
	import com.isartdigital.shmup.game.planes.GamePlane;
	import com.isartdigital.shmup.game.planes.HorizontalScrollingPlane;
	import com.isartdigital.shmup.game.sprites.Boss;
	import com.isartdigital.shmup.game.sprites.Collectables.CollectableManager;
	import com.isartdigital.shmup.game.sprites.ElectricLine;
	import com.isartdigital.shmup.game.sprites.Enemies.EnemyManager;
	import com.isartdigital.shmup.game.sprites.Explosion;
	import com.isartdigital.shmup.game.sprites.Obstacle;
	import com.isartdigital.shmup.game.sprites.Player;
	import com.isartdigital.shmup.game.sprites.ShootBoss;
	import com.isartdigital.shmup.game.sprites.ShootEnemy;
	import com.isartdigital.shmup.game.sprites.ShootPlayer;
	import com.isartdigital.shmup.game.sprites.SmartBomb;
	import com.isartdigital.shmup.game.sprites.Tag;
	import com.isartdigital.shmup.ui.GameOver;
	import com.isartdigital.shmup.ui.hud.Hud;
	import com.isartdigital.shmup.ui.UIManager;
	import com.isartdigital.shmup.ui.WinScreen;
	import com.isartdigital.utils.Config;
	import com.isartdigital.utils.Debug;
	import com.isartdigital.utils.game.GameObject;
	import com.isartdigital.utils.game.GameStage;
	import com.isartdigital.utils.sound.SoundFX;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	
	/**
	 * Manager (Singleton) en charge de gérer le déroulement d'une partie
	 * @author Mathieu ANTHOINE
	 */
	public class GameManager
	{
		
		/**
		 * instance unique de la classe GameManager
		 */
		protected static var instance: GameManager;
		
		/**
		 * Plans de décor
		 */
		private var background1:HorizontalScrollingPlane;
		private var background2:HorizontalScrollingPlane;
		private var foreground:HorizontalScrollingPlane;
		
		/**
		 * Création des classes des plans de décor
		 */  
		private var Background1:Class = Class(getDefinitionByName("Background1")); 
		private var Background2:Class = Class(getDefinitionByName("Background2")); 
		private var Foreground:Class = Class(getDefinitionByName("Foreground")); 
		
		/*
		 * jeu en pause ou non
		 */
		public var isPause:Boolean = true;
		
		/**
		 * Timer de touche pause 
		 */
		private var timerPause:Number = 20;
		
		/*
		 * Player détruit 
		 */ 
		public var playerDestroyed;
		
		/**
		 * Son du level 
		 */
		public var soundLevel:SoundFX;
		
		
		public function GameManager() 
		{
			instance = this;
		}
		
		/**
		 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
		 * @return instance unique
		 */
		public static function getInstance (): GameManager {
			if (instance == null) instance = new GameManager();
			return instance;
		}
		
		public function init (): void {
		}
		
		public function start (): void {
			
			// Player non détruit 
			playerDestroyed = false;
			
			Debug.getInstance().addButton("game over",cheatGameOver);
			Debug.getInstance().addButton("win", cheatWin);
			
			UIManager.getInstance().startGame();
			
			// Démarrage du son du niveau 
			soundLevel = new SoundFX("level_loop");
			soundLevel.start(0, 8);
			
			// Ajout du Background1 
			background1 = new Background1(); 
			GameStage.getInstance().getGameContainer().addChild(background1); 
			background1.coeffScrollingSpeed = 1;
			
			// Ajout du Background2
			background2 = new Background2(); 
			GameStage.getInstance().getGameContainer().addChild(background2);
			background2.coeffScrollingSpeed = 1.4;
			
			// Ajout du Player 
			GamePlane.getInstance().addChild(Player.getInstance()); 
			
			// Ajout du GamePlane 
			GameStage.getInstance().getGameContainer().addChild(GamePlane.getInstance()); 
			GamePlane.getInstance().coeffScrollingSpeed = 1; 
			
			// Ajout du ForeGround 
			foreground = new Foreground();
			GameStage.getInstance().getGameContainer().addChild(foreground);
			foreground.coeffScrollingSpeed = 2.2;
			
			resume();
		}
		
		// ==== Mode Cheat =====
		
		protected function cheatGameOver (pEvent:Event): void {
			/* les fonctions callBack des méthodes de cheat comme addButton retournent
			 * un evenement qui contient la cible pEvent.target (le composant de cheat)
			 * et sa valeur (pEvent.target.value) à exploiter quand c'est utile */
			Debug.getInstance().clear();
			gameOver();
		}
		
		protected function cheatWin (pEvent:Event): void {
			/* les fonctions callBack des méthodes de cheat comme addButton retournent
			 * un evenement qui contient la cible pEvent.target (le composant de cheat)
			 * et sa valeur (pEvent.target.value) à exploiter quand c'est utile */
			Debug.getInstance().clear();
			win();
		}
		
		/**
		 * boucle de jeu (répétée à la cadence du jeu en fps)
		 * @param	pEvent
		 */
		protected function gameLoop (pEvent:Event): void {
			
			// Scrolling et clipping des plans de décors 
			background1.doAction(); 
			background2.doAction(); 
			foreground.doAction(); 
			
			// Augmentation de la jauge de special feature 
			Hud.getInstance().incrementSpecialBar();
			
			// Pause 
			setPause();
			
			// Game Over si player détruit 
			if (playerDestroyed) {
				gameOver();
			}
			
			/* ------------ Actions des objets ------------ */ 
			
			// Player
			Player.getInstance().doAction(); 
			
			// Boss 
			if (GamePlane.getInstance().timerBoss == 0) Boss.getInstance().doAction();
			
			// GamePlane
			GamePlane.getInstance().doAction();
			
			// Shoots player  
			for each (var lShootPlayer:ShootPlayer in ShootPlayer.list) {
				lShootPlayer.doAction();	
			}
			
			// Shoots ennemis 
			for each (var lShootEnemy:ShootEnemy in ShootEnemy.list) {
				lShootEnemy.doAction();
			}
			
			// Shoots boss 
			for each(var lShootBoss:ShootBoss in ShootBoss.list) {
				lShootBoss.doAction();
			}
			
			// Ennemis 
			for each (var lEnemy in EnemyManager.list) {
				lEnemy.doAction();
			}
			
			// Explosions 
			for each (var lExplosion in Explosion.list) {
				lExplosion.doAction();
			}
			
			// Smart bombs 
			for each (var lBomb in SmartBomb.list) {
				lBomb.doAction();
			}
			
			// Tags  
			for each (var lTag:Tag in Tag.list) {
				lTag.doAction();
			}
			
			// Lignes électrique 
			for each (var lLine:ElectricLine in ElectricLine.list) {
				lLine.doAction();
			}
		}
		
		/**
		 * Pause 
		 */
		private function setPause ():void {
			// Décrémentation du timer de touche pause 
			timerPause--;
			if (Player.getInstance().controller.pause) {
				if (isPause) resume();
				else pause(); 
			}
		}
		
		/**
		 * Game Over 
		 */
		protected function gameOver ():void {
			pause();
			// Suppression du hud 
			UIManager.getInstance().removeHud();
			// Suppression du niveau 
			destroyLevel();
			// Affichage de game over
			UIManager.getInstance().addScreen(GameOver.getInstance());
			// Son du level stoppé 
			soundLevel.stop();
			// Son de Game over 
			var lSound:SoundFX = new SoundFX("gameover_jingle");
			lSound.start();
			// Affichage du score de fin 
			GameOver.getInstance().displayEndScore();
		}
		
		/**
		 * Winscreen 
		 */
		public function win():void {
			pause();
			// Suppression du hud 
			UIManager.getInstance().removeHud();
			// Suppression du niveau 
			destroyLevel();
			// Affichage du winscreen 
			UIManager.getInstance().addScreen(WinScreen.getInstance());
			// Son du level stoppé 
			soundLevel.stop();
			// Son de victoire 
			var lSound:SoundFX = new SoundFX("win_jingle");
			lSound.start();
			// Affichage du score de fin 
			WinScreen.getInstance().displayWinScore();
		}
		
		/**
		 * Suppression du niveau en cours 
		 */
		private function destroyLevel ():void {
			// Réinitialisation des tirs puissants 
			ShootPlayer.powerActivate = false;
			// Destruction des plans 
			background1.destroy();
			background2.destroy();
			foreground.destroy();
			// Destruction des objets sur l'écran 
			Player.getInstance().destroy();
			Boss.getInstance().destroy();
			GameObject.destroyAll(Obstacle);
			GameObject.destroyAll(ShootPlayer);
			GameObject.destroyAll(ShootEnemy);
			GameObject.destroyAll(ShootBoss);
			GameObject.destroyAll(Explosion);
			GameObject.destroyAll(CollectableManager);
			GameObject.destroyAll(EnemyManager);
			GameObject.destroyAll(SmartBomb);
			GameObject.destroyAll(Tag);
			GameObject.destroyAll(ElectricLine);
			// Effacement du conteneur de jeu 
			GameStage.getInstance().getGameContainer().removeChildren();
			// Effacement du hud 
			Hud.getInstance().destroy();
			// Effacement du gamePlane
			GamePlane.getInstance().destroy();
		}
		
		public function pause (): void {
			if (!isPause) {
				isPause = true;
				Config.stage.removeEventListener (Event.ENTER_FRAME, gameLoop);
			}
		}
		
		public function resume (): void {
			if (isPause) {
				isPause = false;
				Config.stage.addEventListener (Event.ENTER_FRAME, gameLoop);
			}
		}
		
		/**
		 * détruit l'instance unique et met sa référence interne à null
		 */
		public function destroy (): void {
			Config.stage.removeEventListener (Event.ENTER_FRAME, gameLoop);
			instance = null;
		}

	}
}