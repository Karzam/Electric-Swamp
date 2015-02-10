package com.isartdigital.shmup.game.sprites 
{
	import com.isartdigital.shmup.game.GameManager;
	import com.isartdigital.shmup.game.planes.GamePlane;
	import com.isartdigital.utils.game.StateGraphic;
	import com.isartdigital.utils.sound.SoundFX;
	
	/**
	 * Gère le Boss
	 * @author Baptiste 
	 */
	public class Boss extends StateGraphic 
	{
		
		/**
		 * instance unique de la classe Boss
		 */
		protected static var instance: Boss;
		
		/**
		 * Etat invincible 
		 */
		private var invincible:Boolean = false;
		
		/**
		 * Points de vie 
		 */
		private var lifePoints:int = 100; 
		
		/**
		 * Vitesse en x 
		 */
		private var speedX:int = 8;
		
		/**
		 * Vitesse en y 
		 */
		private var speedY:int = 0;
		
		/**
		 * Timer d'apparition sur l'écran (premier état)  
		 */
		private var timerAppear:Number = 100;
		
		/**
		 * État sur l'écran (premier état) 
		 */
		private var onScreenFirstState:Boolean = false;
		
		/**
		 * Timer de shoot 
		 */
		private var timerShoot:Number = 30;
		
		/**
		 * Délai entre deux collisions avec la special 
		 */
		private var timerCollisionSpecial:Number = 40;
		
		/**
		 * Activation de l'explosion finale 
		 */
		private var explosionActivate:Number = 400;
		
		/**
		 * Sons d'ambiance 
		 */
		var lSound0:SoundFX = new SoundFX("boss_loop0");
		var lSound1:SoundFX = new SoundFX("boss_loop1");
		var lSound2:SoundFX = new SoundFX("boss_loop2");
		
		
		public function Boss() 
		{
			super();
			
			// Activation dans GameObject 
			start();
			
			// Position de départ 
			x = GamePlane.getInstance().currentScreenLimits.right - (Math.random() * 1000);
			y = GamePlane.getInstance().currentScreenLimits.bottom;	
			
			// Premier état graphique 
			setState("firstState");
			
			// Premier mode doAction 
			setModeFirstState();
			
			// Son 
			lSound0.start();
		}
		
		/**
		 * Premier état 
		 */
		override protected function doActionFirstState ():void {
			// Position statique 
			x += speedX;
			y += speedY;
			
			// Collision avec les shoots du player 
			checkCollisionShoot();
			
			// Déplacement 
			moveFirstState();
			
			// Collision avec le player 
			checkCollisionPlayer();
			
			// Collision avec la special 
			checkCollisionSpecial();
			
			// Attaque 
			attackFirstState();
			
			// Fin des animations 
			endAnim();
		}
		
		/**
		 * Second état 
		 */
		override protected function doActionSecondState ():void {
			// Position statique 
			x += speedX;
			y += speedY;
			
			// Collision avec les shoots du player 
			checkCollisionShoot();
			
			// Collision avec le player 
			checkCollisionPlayer();
			
			// Collision avec la special 
			checkCollisionSpecial();
			
			// Déplacement 
			moveSecondState();
			
			// Fin des animation 
			endAnim();
		}
		
		/**
		 * Troisième état 
		 */
		override protected function doActionThirdState ():void {
			// Position statique 
			x += speedX;
			y += speedY;
			
			// Orientation vers le player 
			rotation = Math.atan2(y - Player.getInstance().y, x - Player.getInstance().x) / (Math.PI / 180);
			
			// Collision avec les shoots du player 
			checkCollisionShoot();
			
			// Collision avec le player 
			checkCollisionPlayer();
			
			// Collision avec la special 
			checkCollisionSpecial();
			
			// Déplacement 
			moveThirdState();
			
			// Attaque 
			attackThirdState();
			
			// Fin des animation 
			endAnim();
		}
		
		/**
		 * Déplacement du premier état 
		 */
		private function moveFirstState ():void {
			// Décrémentation du timer d'apparition 
			if (timerAppear > 0) timerAppear--;
			// Entrée depuis le bas de l'écran 
			if (timerAppear == 0 && !onScreenFirstState && state != "destroyFirstState") {
				speedX = -24;
				speedY = -24;
				if (y <= GamePlane.getInstance().currentScreenLimits.bottom - width / 2) {
					speedX = 8;
					speedY = 0;
					onScreenFirstState = true;
					timerAppear = 100;
					// Animation de la bouche 
					setState("attack");
				}
			}
			// Sortie de l'écran 
			else if (timerAppear == 0 && onScreenFirstState && state != "destroyFirstState") {
				// Fin de l'animation de la bouche 
				setState("firstState");
				speedX = 24;
				speedY = 24;
				// Si boss en dehors de l'écran, alors respawn aléatoire 
				if (y >= GamePlane.getInstance().currentScreenLimits.bottom) {
					speedX = 8;
					speedY = 0;
					// Position en x aléatoire 
					x = GamePlane.getInstance().currentScreenLimits.right - (Math.random() * 1000);
					onScreenFirstState = false;
					timerAppear = 100;
				}
			}
		}
		
		/**
		 * Attaque du premier état 
		 */
		private function attackFirstState ():void {
			// Décrémentation du timer de shoot 
			if (timerShoot > 0 && onScreenFirstState) timerShoot--;
			// Tir 
			if (onScreenFirstState && timerShoot == 0 && y <= GamePlane.getInstance().currentScreenLimits.bottom - width / 2) {
				// Son 
				var lSound:SoundFX = new SoundFX("boss_shoot");
				lSound.start();
				for (var i:int = -4; i <= 4; i++) {
					// Création des shoots 
					var lShoot:ShootBoss = new ShootBoss();
					lShoot.x = x;
					lShoot.y = y;
					lShoot.speedX = 1;
					lShoot.speedY = (i * Math.random() * 3);
					ShootBoss.list.push(lShoot);
					GamePlane.getInstance().addChild(lShoot);
					// Réinitialisation du timer de shoot 
					if (i == 4) timerShoot = 30;
				}
			}
		}
		
		/**
		 * Déplacement du deuxième état 
		 */
		private function moveSecondState ():void {
			if (state != "destroySecondState") {
				// Déplacement en diagonale 
				speedX = -23 * scaleX;
				speedY = -24 * scaleY;
				// Changement de direction 
				if (x - width > GamePlane.getInstance().currentScreenLimits.right) scaleX = 1;
				else if (x + width < GamePlane.getInstance().currentScreenLimits.left) scaleX = -1;
				if (y - height > GamePlane.getInstance().currentScreenLimits.bottom) scaleY = 1;
				else if (y + height < GamePlane.getInstance().currentScreenLimits.top) scaleY = -1;
			}
		}
		
		/**
		 * Déplacement du troisième état 
		 */
		private function moveThirdState ():void {
			// Repositionnement
			if (x > GamePlane.getInstance().currentScreenLimits.right - 600) {
				// Tirs désactivés
				timerShoot = 30;
				speedX = 4;
				speedY = 0;
			}
			else {
				speedX = 8;
				speedY = 0;
			}
		}
		
		/**
		 * Attaque du premier état 
		 */
		private function attackThirdState ():void {
			// Décrémentation du timer de shoot 
			if (timerShoot > 0) timerShoot--;
			// Tir 
			if (timerShoot == 0) {
				// Son 
				var lSound:SoundFX = new SoundFX("boss_shoot");
				lSound.start();
				// Création du shoot 
				var lShoot:ShootBoss = new ShootBoss();
				lShoot.x = x;
				lShoot.y = y;
				lShoot.speedX = Math.cos(rotation * (Math.PI / 180)) * 16;
				lShoot.speedY = -Math.sin(rotation * (Math.PI / 180)) * 16;
				ShootBoss.list.push(lShoot);
				GamePlane.getInstance().addChild(lShoot);
				// Réinitialisation du timer de shoot 
				timerShoot = 15;
			}
		}
		
		/**
		 * Changement d'état d'animation en fonction des points de vie 
		 */
		private function changeMode ():void {
			// Passage dans le second état 
			if (lifePoints == 70) {
				invincible = true;
				// Animation de destruction  
				setState("destroyFirstState");
			}
			// Passage dans le troisième état 
			if (lifePoints == 40) {
				invincible = true;
				setState("destroySecondState");
			}
			if (lifePoints == 0) {
				invincible = true;
				setState("destroyThirdState");
			}
		}
		
		/**
		 * Gestion des animations et des transitions entre les états  
		 */
		private function endAnim ():void {
			// Fin de l'animation d'ennemi touché 
			if (state == "firstStateTouched" && isAnimEnd()) setState("attack");
			else if (state == "secondStateTouched" && isAnimEnd()) setState("secondState");
			else if (state == "thirdStateTouched" && isAnimEnd()) setState("thirdState");
			// Fin de l'animation de changement du second état 
			if (state == "destroyFirstState" && onScreenFirstState && !isAnimEnd()) {
				speedX = 8;
				speedY = 8;
			}
			// Passage dans le second état 
			if (state == "destroyFirstState" && isAnimEnd()) {
				// Son 
				lSound0.stop();
				lSound1.start(0, 100);
				setState("secondState");
				invincible = false;
				setModeSecondState();
			}
			// Passage dans le troisième état 
			else if (state == "destroySecondState" && isAnimEnd()) {
				// Son 
				lSound1.stop();
				lSound2.start(0, 100);
				setState("thirdState");
				invincible = false;
				setModeThirdState();
				scaleX = 1;
				scaleY = 1;
				x = GamePlane.getInstance().currentScreenLimits.right + 600;
				y = GamePlane.getInstance().currentScreenLimits.height / 2; 
			}
			// Explosions finales  
			else if (state == "destroyThirdState" && explosionActivate > 0) {
				// Arrêt des tirs 
				timerShoot = 10000;
				// Son
				lSound2.stop();
				explosionActivate--;
				if (explosionActivate == 390 || explosionActivate == 340 || explosionActivate == 290 || explosionActivate == 240) {
					// Son 
					var lSound:SoundFX = new SoundFX("boss_explosion");
					lSound.start();
					// Explosion 
					var lExplosion:Explosion = new Explosion();
					lExplosion.x = x + width / 2;
					lExplosion.y = y + height / 2;
					lExplosion.scaleX = 4;
					lExplosion.scaleY = 4;
					Explosion.list.push(lExplosion);
					GamePlane.getInstance().addChild(lExplosion);
				}
			}
			// Si animation finie, disparition du boss
			if (state == "destroyThirdState" && isAnimEnd()) {
				x = 10000;
			}
			// Destruction du boss et winscreen
			if (explosionActivate == 0) {
				destroy();
				GameManager.getInstance().win();
			}
		}
		
		/**
		 * Collision avec les shoots du player 
		 */
		private function checkCollisionShoot ():void {
			for each (var lShoot:ShootPlayer in ShootPlayer.list) {
				if (lShoot.hitTestObject(hitBox) && !invincible && onScreenFirstState) {
					// Destruction du shoot 
					ShootPlayer.list.splice(ShootPlayer.list.indexOf(lShoot), 1); 
					if (!ShootPlayer.powerActivate) lShoot.destroy();
					else GamePlane.getInstance().removeChild(lShoot);
					// Retirement des points de vie 
					lifePoints -= lShoot.damage;
					// Animation d'ennemi touché 
					if (state == "attack") setState("firstStateTouched");
					else if (state == "secondState") setState("secondStateTouched");
					else if (state == "thirdState") setState("thirdStateTouched");
					// Changement d'animation en fonction des points de vie 
					changeMode();
				}
			}
		}
		
		/**
		 * Collision avec le player 
		 */
		private function checkCollisionPlayer ():void {
			if (Player.getInstance().hitBox.hitTestObject(hitBox) && !Player.getInstance().invincible) {
				Player.getInstance().collisionAnim();
			}
		}
		
		/**
		 * Collision avec la special feature 
		 */
		private function checkCollisionSpecial ():void {
			for each (var lLine:ElectricLine in ElectricLine.list) {
				if (lLine.hitTestObject(hitBox) && timerCollisionSpecial == 40 && !invincible) {
					lifePoints--;
					if (state == "attack") setState("firstStateTouched");
					else if (state == "secondState") setState("secondStateTouched");
					else if (state == "thirdState") setState("thirdStateTouched");
					timerCollisionSpecial--;
				}
				else if (timerCollisionSpecial < 40) {
					if (timerCollisionSpecial > 0) timerCollisionSpecial--;
					else timerCollisionSpecial = 40;
				}
			}
		}
		
		/**
		 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
		 * @return instance unique
		 */
		public static function getInstance (): Boss {
			if (instance == null) instance = new Boss();
			return instance;
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