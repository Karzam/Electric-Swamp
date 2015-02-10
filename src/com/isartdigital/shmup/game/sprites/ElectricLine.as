package com.isartdigital.shmup.game.sprites 
{
	import com.isartdigital.utils.game.StateGraphic;
	import com.isartdigital.shmup.game.sprites.Enemies.EnemyManager;
	import com.isartdigital.utils.sound.SoundFX;
	
	/**
	 * Ligne électrique de la special feature reliant les deux tags 
	 * @author Baptiste 
	 */
	public class ElectricLine extends StateGraphic 
	{
		
		/**
		 * Liste des lignes
		 */
		public static var list:Vector.<ElectricLine> = new Vector.<ElectricLine>();
		
		/**
		 * Vitesse de déplacement 
		 */
		private var speed:Number = 8;
		
		
		public function ElectricLine() 
		{
			super();
			
			// Activation dans GameObject
			start();
		}
		
		override protected function doActionNormal ():void {
			// Position statique 
			x += speed;
			
			// Collision avec les ennemis 
			checkCollisionEnemy();
			
			// Collision avec les shoots ennemis 
			checkCollisionShootEnemy();
			
			// Collision avec les shoots du boss 
			checkCollisionShootBoss();
		}
		
		/**
		 * Collision avec les ennemis 
		 */
		private function checkCollisionEnemy ():void {
			for each (var lEnemy:EnemyManager in EnemyManager.list) {
				// Si ennemi non invincible, destruction de l'ennemi  
				if (lEnemy.hitBox.hitTestObject(this) && !lEnemy.invincible) {
					lEnemy.lifePoints -= 10;
					// Son de special feature 
					var lSound:SoundFX = new SoundFX("special");
					lSound.start();
				}
			}
		}
		
		/*
		 * Collision avec les shoots ennemis
		 */
		private function checkCollisionShootEnemy ():void {
			for each (var lShoot:ShootEnemy in ShootEnemy.list) {
				if (lShoot.hitBox.hitTestObject(this)) {
					lShoot.destroy();
					ShootEnemy.list.splice(ShootEnemy.list.indexOf(lShoot), 1);
					// Son de special feature 
					var lSound:SoundFX = new SoundFX("special");
					lSound.start();
				}
			}
		}
		
		/*
		 * Collision avec les shoots du boss 
		 */
		private function checkCollisionShootBoss ():void {
			for each (var lShoot:ShootBoss in ShootBoss.list) {
				if (lShoot.hitBox.hitTestObject(this)) {
					lShoot.destroy();
					ShootBoss.list.splice(ShootBoss.list.indexOf(lShoot), 1);
					// Son de special feature 
					var lSound:SoundFX = new SoundFX("special");
					lSound.start();
				}
			}
		}
	}
}