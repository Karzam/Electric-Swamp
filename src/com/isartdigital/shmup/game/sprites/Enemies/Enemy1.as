package com.isartdigital.shmup.game.sprites.Enemies {
	
	import com.isartdigital.shmup.game.planes.GamePlane;
	import com.isartdigital.utils.sound.SoundFX;
	import com.isartdigital.shmup.game.sprites.ShootEnemy;
	
	/**
	 * Ennemi de deuxième type (moyen)
	 * @author Baptiste 
	 */
	public class Enemy1 extends EnemyManager 
	{
		
		/**
		 * Timer de shoot
		 */
		protected var timerShoot:Number = 40;
		
		/**
		 * Timer de déplacement  
		 */
		private var timerMove:Number = 0;
		
		
		public function Enemy1(pAsset:String) 
		{
			super(pAsset);
			
			// Points de vie 
			lifePoints = 2;
			
			// Vitesse 
			speed = 3;
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
			timerMove += 0.2;
			x -= speed;
			y += Math.sin(timerMove) * 10;
		}
		
		/**
		 * Tir (2 directions) 
		 */
		private function shoot ():void {
			// Incrémentation du timer de shoot 
			timerShoot++; 
			if (x < GamePlane.getInstance().currentScreenLimits.right && timerShoot > 40) {
				// Réinitialisation du timer de shoot 
				timerShoot = 0;
				for (var i:int = -2; i <= 2; i += 4)
				{
					// Création des shoots 
					var lShoot:ShootEnemy = new ShootEnemy();
					lShoot.x = x;
					lShoot.y = y;
					lShoot.speedX = 10;
					lShoot.speedY = i;
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