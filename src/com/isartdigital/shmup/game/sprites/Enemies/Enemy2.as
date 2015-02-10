package com.isartdigital.shmup.game.sprites.Enemies {
	
	import com.isartdigital.shmup.game.planes.GamePlane;
	import com.isartdigital.utils.sound.SoundFX;
	import com.isartdigital.shmup.game.sprites.ShootEnemy;
	
	/**
	 * Ennemi de troisième type (fort)
	 * @author Baptiste 
	 */
	public class Enemy2 extends EnemyManager 
	{
		
		/**
		 * Timer de shoot
		 */
		protected var timerShoot:Number = 120;
		
		/**
		 * Timer de déplacement  
		 */
		private var timerMove:Number = 0;
		
		
		public function Enemy2(pAsset:String) 
		{
			super(pAsset);
			
			// Points de vie 
			lifePoints = 3;
			
			// Vitesse 
			speed = 2;
		}
		
		override protected function doActionNormal ():void {
			
			super.doActionNormal();
			
			// Déplacement 
			move();
			
			// Tir 
			shoot();
		}
		
		/**
		 * Déplacement 
		 */
		private function move ():void {
			// Déplacement 
			timerMove += 0.1;
			// Position statique sur l'écran 
			if (x < GamePlane.getInstance().currentScreenLimits.right - 600) x += 6;
			else x -= speed;
			y += Math.sin(timerMove) * 20;
		}
		
		/**
		 * Tir (7 directions) 
		 */
		private function shoot ():void {
			// Incrémentation du timer de shoot  
			timerShoot++;
			if (x < GamePlane.getInstance().currentScreenLimits.right && timerShoot > 90) {
				// Réinitialisation du timer de shoot 
				timerShoot = 0;
				for (var i:int = -3; i <= 3; i++)
				{
					// Création des shoots 
					var lShoot:ShootEnemy = new ShootEnemy();
					lShoot.x = x;
					lShoot.y = y;
					lShoot.speedX = 10;
					lShoot.speedY = i * 4;
					ShootEnemy.list.push(lShoot);
					GamePlane.getInstance().addChild(lShoot);
					// Son de tir 
					var lSound:SoundFX = new SoundFX("enemy_shoot");
					lSound.start();
				}
			}
		}
	}

}