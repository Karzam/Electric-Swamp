package com.isartdigital.shmup.game.sprites.Enemies {
	
	import com.isartdigital.shmup.game.planes.GamePlane;
	import com.isartdigital.utils.sound.SoundFX;
	import com.isartdigital.shmup.game.sprites.ShootEnemy;
	
	/**
	 * Ennemi de premier type (faible) 
	 * @author Baptiste 
	 */
	public class Enemy0 extends EnemyManager 
	{	
		
		/**
		 * Timer de shoot
		 */
		private var timerShoot:Number = 90;
		
		/**
		 * Timer de déplacement  
		 */
		private var timerMove:Number = 0;
		
		
		public function Enemy0(pAsset:String) 
		{
			super(pAsset);
			
			// Points de vie 
			lifePoints = 1;
			
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
			x -= speed;
			y += Math.sin(timerMove) * 8;
		}
		
		/**
		 * Tir (basique) 
		 */
		private function shoot ():void {
			// Incrémentation du timer de shoot 
			timerShoot++;
			// Création du shoot 
			if (x < GamePlane.getInstance().currentScreenLimits.right && timerShoot > 90) {
				// Réinitialisation du timer de shoot 
				timerShoot = 0;
				// Création du shoot 
				var lShoot:ShootEnemy = new ShootEnemy();
				lShoot.x = x - width / 2;
				lShoot.y = y;
				lShoot.speedX = 20;
				ShootEnemy.list.push(lShoot);
				GamePlane.getInstance().addChild(lShoot);
				// Son de tir 
				var lSound:SoundFX = new SoundFX("enemy_shoot");
				lSound.start();
			}
		}
	}

}