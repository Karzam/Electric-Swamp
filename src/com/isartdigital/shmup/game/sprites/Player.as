package com.isartdigital.shmup.game.sprites
{
	import com.isartdigital.shmup.controller.Controller;
	import com.isartdigital.shmup.controller.Keyboard;
	import com.isartdigital.shmup.controller.Pad;
	import com.isartdigital.shmup.controller.Touch;
	import com.isartdigital.shmup.game.GameManager;
	import com.isartdigital.shmup.game.planes.GamePlane;
	import com.isartdigital.shmup.game.sprites.Collectables.Bomb;
	import com.isartdigital.shmup.game.sprites.Collectables.CollectableManager;
	import com.isartdigital.shmup.game.sprites.Collectables.Life;
	import com.isartdigital.shmup.game.sprites.Collectables.Power;
	import com.isartdigital.shmup.game.sprites.Collectables.Shield;
	import com.isartdigital.shmup.game.sprites.Collectables.Upgrade;
	import com.isartdigital.shmup.game.sprites.Enemies.EnemyManager;
	import com.isartdigital.shmup.game.sprites.ShootPlayer;
	import com.isartdigital.shmup.ui.hud.Hud;
	import com.isartdigital.utils.game.StateGraphic;
	import com.isartdigital.utils.sound.SoundFX;
	
	/**
	 * Classe du joueur (Singleton)
	 * En tant que classe héritant de StateGraphic, Player contient un certain nombre d'états définis par les constantes LEFT_STATE, RIGHT_STATE, etc.
	 * @author Mathieu ANTHOINE
	 */
	public class Player extends StateGraphic
	{
		
		/**
		 * instance unique de la classe Player
		 */
		protected static var instance:Player;
		
		/**
		 * controleur de jeu
		 */
		public var controller:Controller;
		
		/**
		 * Vitesse de base
		 */
		private const PLAYER_SPEED:uint = 8;
		
		/**
		 * Accélération
		 */
		private const PLAYER_ACCELERATION:uint = 16;
		
		/**
		 * Ralentissement
		 */
		private const PLAYER_BRAKE:uint = 14;
		
		/**
		 * God mode 
		 */
		public var invincible:Boolean = false;
		
		/**
		 * Timer de god mode 
		 */
		private var timerGod:Number = 30;  
		
		/**
		 * Timer de shoot
		 */
		private var timerShoot:Number = 0;
		
		/**
		 * Timer de smart bomb 
		 */
		private var timerBomb:Number = 0;
		
		/**
		 * Nombre de smart bombs 
		 */
		private var numberBomb:int = 0;
		
		/**
		 * Points de vie 
		 */
		public var lifePoints:int = 5;
		
		/** 
		 * Mode de shoot 
		 */
		private var shootMode:String = "First";
		
		/**
		 * Bouclier activé 
		 */
		private var shieldActivate:Boolean = false;
		
		/**
		 * Timer de bouclier 
		 */
		private var timerShield:Number = 300;
		
		/**
		 * Tag posé 
		 */
		private var placedTag:int = 0;
		
		/**
		 * Tag déjà déplacé 
		 */
		private var tagAlreadyMoved:Boolean = false;
		
		/**
		 * Deux tags placés 
		 */
		private var tagsReady:Boolean = false;
		
		/**
		 * Timer de special feature 
		 */
		private var timerSpecial:Number = 500;
		
		/**
		 * marge par rapport aux bords de l'écran
		 */
		private const MARGIN_SCREEN:int = 100;
		
		/**
		 * Etats graphiques du joueur
		 */
		private const LEFT_STATE:String = "left";
		private const RIGHT_STATE:String = "right";
		private const UP_STATE:String = "up";
		private const DOWN_STATE:String = "down";
		
		
		public function Player()
		{
			simpleBox = true;
			
			super();
			
			// crée le controleur correspondant à la configuration du jeu
			// upcasting du controleur: controller (new Pad()) -> On lui assigne un nouvel objet Pad, Touch ou Keyboard et on l'upcast pour correspondre au type de la propriété controller
			if (Controller.type == Controller.PAD)
				controller = Controller(new Pad());
			else if (Controller.type == Controller.TOUCH)
				controller = Controller(new Touch());
			else
				controller = Controller(new Keyboard());
			
			// Activation dans GameObject 
			start();
			
			// Position de départ 
			x = GamePlane.getInstance().getScreenLimits().width / 10;
			y = GamePlane.getInstance().getScreenLimits().height / 2;
		}
		
		override protected function doActionNormal():void
		{
			// God mode 
			setGodMode();
			
			// Déplacement 
			move();
			
			// Collision avec les shoots ennemis 
			checkCollisionShoot();
			
			// Collision avec les shoots du boss 
			checkCollisionShootBoss();
			
			// Collision avec les obstacles 
			checkCollisionObstacle();
			
			// Collision avec les collectables
			checkCollisionCollectable();
			
			// Tir  
			shoot();
			
			// Smart Bomb
			smartBomb();
			
			// Shield
			shield();
			
			// Special Feature 
			createFirstTag();
			createSecondTag();
			createElectricLine();
			
			// Fin de la special feature 
			endSpecial();
			
			// Vérification des points de vie 
			checkLifePoints();
			
			// Fin des animations 
			endAnim();
		}
		
		/**
		 * Déplacement
		 */
		private function move ():void {
			
			// Vitesse et animation de base 
			x += PLAYER_SPEED;
			if (state == LEFT_STATE || state == RIGHT_STATE || 
				state == UP_STATE || state == DOWN_STATE) setState(DEFAULT_STATE);
			
			// Déplacement et changement d'animation
			if (controller.left > 0 && x - width / 2 > GamePlane.getInstance().currentScreenLimits.left)
			{
				x += PLAYER_BRAKE * (controller.right - controller.left);
				if (state == DEFAULT_STATE) setState(LEFT_STATE);
			}
			if (controller.right > 0 && x + width / 2 < GamePlane.getInstance().currentScreenLimits.right)
			{
				x += PLAYER_ACCELERATION * (controller.right - controller.left);
				if (state == DEFAULT_STATE) setState(RIGHT_STATE);
			}
			if (controller.up > 0 && y - height / 2 > GamePlane.getInstance().currentScreenLimits.top + 150)
			{
				y += PLAYER_ACCELERATION * (controller.down - controller.up);
				if (state == DEFAULT_STATE) setState(UP_STATE);
			}
			if (controller.down > 0 && y + height / 2 < GamePlane.getInstance().currentScreenLimits.bottom)
			{
				y += PLAYER_ACCELERATION * (controller.down - controller.up);
				if (state == DEFAULT_STATE) setState(DOWN_STATE);
			}
		}
		
		/**
		 * Destruction si 0 points de vie 
		 */
		private function checkLifePoints ():void {
			if (lifePoints < 1) {
				// Animation d'explosion 
				createExplosion();
				// Son d'explosion 
				var lSound0:SoundFX = new SoundFX("player_explosion");
				lSound0.start();
				// Suppression 
				destroy();
				// Game over 
				GameManager.getInstance().playerDestroyed = true;
				// Son de game over 
				var lSound1:SoundFX = new SoundFX("gameover_jingle");
				lSound1.start();
			}
		}
		
		/**
		 * Shoot selon le mode en cours 
		 */
		private function shoot ():void {
			// Incrémentation du timer de shoot 
			timerShoot++;
			// Exécution du mode de shoot 
			if (shootMode == "First") shootFirstLevel();
			else if (shootMode == "Second") shootSecondLevel();
			else if (shootMode == "Third") shootThirdLevel();
		}
		
		/**
		 * Tir niveau 1 (basique) 
		 */
		private function shootFirstLevel():void
		{
			if (controller.fire && timerShoot > 20)
			{
				// Réinitialisation du timer de shoot 
				timerShoot = 0;
				// Création du nouveau shoot 
				var lShoot:ShootPlayer = new ShootPlayer();
				lShoot.x = x;
				lShoot.y = y;
				lShoot.speedX = 60;
				ShootPlayer.list.push(lShoot);
				GamePlane.getInstance().addChild(lShoot);
				// Son de tir 
				var lSound:SoundFX = new SoundFX("player_shoot");
				lSound.start();
				// Animation de tir 
				shootAnim();
			}
		}
		
		/**
		 * Tir niveau 2 (rapide)
		 */
		private function shootSecondLevel():void
		{	
			if (controller.fire && timerShoot > 10)
			{
				// Réinitialisation du timer de shoot 
				timerShoot = 0;
				// Création du nouveau shoot 
				var lShoot:ShootPlayer = new ShootPlayer();
				lShoot.x = x;
				lShoot.y = y;
				lShoot.speedX = 60;
				ShootPlayer.list.push(lShoot);
				GamePlane.getInstance().addChild(lShoot);
				// Son de tir 
				var lSound:SoundFX = new SoundFX("player_shoot");
				lSound.start();
				// Animation de tir 
				shootAnim();
			}
		}
		
		/**
		 * Tir niveau 3 (multiple)
		 */
		private function shootThirdLevel():void
		{
			if (controller.fire && timerShoot > 20)
			{
				// Réinitialisation du timer de shoot 
				timerShoot = 0;
					
				for (var i:int = -1; i <= 1; i++)
				{
					// Création du nouveau shoot 
					var lShoot:ShootPlayer = new ShootPlayer();
					lShoot.x = x;
					lShoot.y = y;
					lShoot.speedX = 60;
					lShoot.speedY = i * 6;
					ShootPlayer.list.push(lShoot);
					GamePlane.getInstance().addChild(lShoot);
					// Son de tir 
					var lSound:SoundFX = new SoundFX("player_shoot");
					lSound.start();
					// Animation de tir 
					shootAnim();
				}
			}
		}
		
		/**
		 * Smart Bomb 
		 */
		private function smartBomb ():void {
			// Incrémentation du timer de smart bomb 
			timerBomb++;
			// Tir de la smart bomb 
			if (controller.bomb && timerBomb > 180 && numberBomb > 0) {
				// Suppression de l'inventaire  
				numberBomb--;
				Hud.getInstance().loseSmartBombs();
				// Création de la bombe 
				timerBomb = 0;
				var lBomb:SmartBomb = new SmartBomb();
				lBomb.x = x;
				lBomb.y = y;
				SmartBomb.list.push(lBomb);
				GamePlane.getInstance().addChild(lBomb);
				// Suppression des ennemis 
				for each (var lEnemy:EnemyManager in EnemyManager.list) lEnemy.lifePoints = 0;
				// Son 
				var lSound:SoundFX = new SoundFX("bomb");
				lSound.start();
			}
		}
		
		/**
		 * Shield 
		 */
		private function shield ():void {
			// Si timer supérieur à 0, mode shield 
			if (shieldActivate && timerShield > 0) {
				timerShield--;
				if (state != "shield") setState("shield");
			}
			// Sinon réinitialisation du shield 
			else if (timerShield == 0) {
				timerShield = 300;
				shieldActivate = false;
			}
		}
		
		/**
		 * Création du premier tag 
		 */
		private function createFirstTag ():void {
			// Si aucun tag sur l'écran 
			if (controller.special && placedTag == 0 && Hud.specialReady) {
				placedTag++;
				// Création du tag
				var lTag:Tag = new Tag();
				lTag.x = x;
				lTag.y = y;
				Tag.list.push(lTag);
				GamePlane.getInstance().addChild(lTag);
			}
			// Sinon si tag sur l'écran 
			else if (placedTag == 1) {
				// Si tag pas déjà déplacé, déplacement 
				if (controller.special && !tagAlreadyMoved) {
					Tag.list[0].speed = 20;
				}
				// Si touche relachée, fin du déplacement 
				else if (!controller.special) {
					Tag.list[0].speed = 8;
					tagAlreadyMoved = true;
				}
			}
		}
		
		/**
		 * Création du deuxième tag 
		 */
		private function createSecondTag ():void {
			// Si précédent tag déjà placé sur l'écran 
			if (controller.special && tagAlreadyMoved) {
				tagAlreadyMoved = false;
				placedTag++;
				// Création du nouveau tag 
				var lTag:Tag = new Tag();
				lTag.x = x;
				lTag.y = y; 
				Tag.list.push(lTag);
				GamePlane.getInstance().addChild(lTag);
			}
			// Déplacement automatique jusqu'à la position en x du précédent
			if (placedTag == 2 && !tagsReady) {
				var firstTag:Tag = Tag.list[0];
				var secondTag:Tag = Tag.list[1];
				// Si position du deuxième tag inférieure à celle du premier
				if (secondTag.x < firstTag.x) {
					secondTag.speed = 20;
					// Si tag bien placé 
					if (firstTag.x - secondTag.x <= 20) {
						secondTag.speed = 8;
						secondTag.x = firstTag.x;
						tagsReady = true;
					}
				}
				// Si position du deuxième tag supérieure à celle du premier
				else if (secondTag.x > firstTag.x) {
					secondTag.speed = -20;
					// Si tag bien placé 
					if (secondTag.x - firstTag.x <= 20) {
						secondTag.speed = 8;
						secondTag.x = firstTag.x;
						tagsReady = true;
					}
				}
			}
		}
		
		/** 
		 * Création de la ligne électrique 
		 */
		private function createElectricLine ():void {
			// Décrémentation du timer de special feature 
			if (tagsReady && timerSpecial > 0) timerSpecial--;	
			// Si deux tags déjà placés sur l'écran 
			if (tagsReady && ElectricLine.list.length == 0) {
				var firstTag:Tag = Tag.list[0];
				var secondTag:Tag = Tag.list[1];
				// Création de la ligne  
				var line:ElectricLine = new ElectricLine(); 
				line.x = firstTag.x;
				// Son de special feature 
				var lSound:SoundFX = new SoundFX("special");
				lSound.start();
				// Définition de la taille et placement de la ligne 
				if (firstTag.y < secondTag.y) {
					line.height = secondTag.y - firstTag.y; 
					line.y = firstTag.y + line.height / 2;
				}
				else {
					line.height = firstTag.y - secondTag.y; 
					line.y = secondTag.y + line.height / 2;
				}
				ElectricLine.list.push(line);
				GamePlane.getInstance().addChild(line);
			}
		}
		
		/**
		 * Fin de la special feature 
		 */
		private function endSpecial ():void {
			// Si timer épuisé, alors fin 
			if (timerSpecial < 1) {
				placedTag = 0;
				tagAlreadyMoved = false;
				tagsReady = false;
				// Suppression des tags et de la ligne
				if (Tag.list.length > 0) {
					// Suppression de l'animation du player 
					setState(DEFAULT_STATE);
					destroySpecialFeature();
				}
				// Réinitialisation du timer 
				else timerSpecial = 500;
			}
		}
		
		/**
		 * Suppression de la special feature  
		 */
		private function destroySpecialFeature ():void {
			// Suppression des tags 
			for each (var lTag:Tag in Tag.list) {
				lTag.destroy();
				Tag.list.splice(Tag.list.indexOf(lTag), 1);
			}
			// Suppression de la ligne électrique 
			for each (var lLine:ElectricLine in ElectricLine.list) {
				lLine.destroy();
				ElectricLine.list.splice(ElectricLine.list.indexOf(lLine), 1);
			}
		}
		
		/** 
		 * Collision avec les collectables 
		 */
		private function checkCollisionCollectable ():void {
			for each (var lCollectable:CollectableManager in CollectableManager.list) {
				if (hitTestObject(lCollectable.hitBox)) {
					// Upgrade 
					if (lCollectable is Upgrade) {
						if (shootMode == "First") shootMode = "Second";
						else if (shootMode == "Second") shootMode = "Third";
						// Son 
						var lSound:SoundFX = new SoundFX("powerup_fireUpgrade");
						lSound.start();
					}
					// Life
					else if (lCollectable is Life) {
						if (lifePoints < 5) {
							lifePoints++;
							Hud.getInstance().getLife();
							// Son 
							var lSound0:SoundFX = new SoundFX("powerup_life");
							lSound0.start();
						}
					}
					// Smart bomb 
					else if (lCollectable is Bomb) {
						if (numberBomb < 4) {
						numberBomb++;
						Hud.getInstance().getSmartbombs();
						// Son   
						var lSound1:SoundFX = new SoundFX("powerup_bomb");
						lSound1.start();
						}
					}
					// Power 
					else if (lCollectable is Power && !ShootPlayer.powerActivate) {
						ShootPlayer.powerActivate = true;
						// Son 
						var lSound2:SoundFX = new SoundFX("powerup_firePower");
						lSound2.start();
					}
					// Shield
					else if (lCollectable is Shield && !shieldActivate) {
						shieldActivate = true;
						// Son 
						var lSound3:SoundFX = new SoundFX("powerup_special");
						lSound3.start();
					}
					// Suppression 
					lCollectable.destroy();
					CollectableManager.list.splice(CollectableManager.list.indexOf(lCollectable), 1); 
				}
			}	
		}
		
		/**
		 * Collision avec les shoots ennemis 
		 */
		private function checkCollisionShoot ():void {
			for each (var lShoot:ShootEnemy in ShootEnemy.list) {
				if (hitBox.hitTestObject(lShoot.hitBox) && !invincible) {
					// Suppression du shoot ennemi 
					lShoot.destroy();
					ShootEnemy.list.splice(ShootEnemy.list.indexOf(lShoot), 1);
					// Si pas de bouclier activé 
					if (!shieldActivate) {
						// Retirement d'un point de vie   
						lifePoints--;
						Hud.getInstance().loseLife();
						setState("touched");
						// Son de perte de vie  
						var lSound:SoundFX = new SoundFX("loselife");
						lSound.start();
					}
				}
			}
		}
		
		/**
		 * Collision avec les shoots du boss 
		 */
		private function checkCollisionShootBoss ():void {
			for each (var lShoot:ShootBoss in ShootBoss.list) {
				if (hitBox.hitTestObject(lShoot.hitBox) && !invincible) {
					// Suppression du shoot du boss 
					lShoot.destroy();
					ShootBoss.list.splice(ShootBoss.list.indexOf(lShoot), 1);
					// Si pas de bouclier activé 
					if (!shieldActivate) {
						// Retirement d'un point de vie 
						lifePoints--;
						Hud.getInstance().loseLife();
						setState("touched");
						// Son de perte de vie 
						var lSound:SoundFX = new SoundFX("loselife");
						lSound.start();
					}
				}
			}
		}
		
		/**
		 * Collision avec les obstacles
		 */
		private function checkCollisionObstacle ():void {
			for each (var lObstacle:Obstacle in Obstacle.list) {
				// Si collision et pas de bouclier et de god mode
				if (hitTestObject(lObstacle.hitBox) && !shieldActivate && !invincible) {
					// Animation de collision
					if (state != "collision") collisionAnim();
				}
			}
		}
		
		/**
		 * Animation de collision (avec le boss et les obstacles)
		 */ 
		public function collisionAnim ():void {
			if (state != "collision") {
				Hud.getInstance().loseLife();
				lifePoints--;
				setState("collision");
			}
		}
		
		/*
		 * Animation de tir 
		 */ 
		private function shootAnim ():void {
			if (state == DEFAULT_STATE) setState("shootStatic");
			else if (state == RIGHT_STATE) setState("shootRight");
			else if (state == LEFT_STATE) setState("shootLeft");
			else if (state == UP_STATE) setState("shootUp");
			else if (state == DOWN_STATE) setState("shootDown");
		}
		
		/**
		 * Animation d'explosion 
		 */
		private function createExplosion ():void {
			var lExplosion:Explosion = new Explosion();
			lExplosion.x = x;
			lExplosion.y = y;
			Explosion.list.push(lExplosion);
			GamePlane.getInstance().addChild(lExplosion);
		}
		
		/**
		 * Gestion de la fin des animations
		 */
		private function endAnim ():void {
			if (state != DEFAULT_STATE && state != LEFT_STATE && 
				state != RIGHT_STATE && state != DOWN_STATE && state != UP_STATE && 
				isAnimEnd()) {
				setState(DEFAULT_STATE);
			}
		}
		
		/**
		 * God mode 
		 */
		private function setGodMode ():void {
			// Décrémentation du timer de special feature 
			timerGod--;
			// Si touche de god mode et timer de clavier à zéro
			if (controller.god && timerGod < 1) {
				// Passage en god mode
				if (!invincible) {
					invincible = true;
					timerGod = 30;
				}
				// Sinon, sortie du mode
				else invincible = false;
				timerGod = 30;
			}
		}
		
		/**
		 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
		 * @return instance unique
		 */
		public static function getInstance():Player
		{
			if (instance == null)
				instance = new Player();
			return instance;
		}
		
		/**
		 * détruit l'instance unique et met sa référence interne à null
		 */
		override public function destroy():void
		{
			instance = null;
			super.destroy();
		}
	}
}