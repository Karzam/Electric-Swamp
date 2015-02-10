package com.isartdigital.shmup.game.sprites 
{
	import com.isartdigital.shmup.game.planes.GamePlane;
	import com.isartdigital.shmup.game.sprites.Enemies.EnemyManager;
	import com.isartdigital.utils.game.StateGraphic;

	/**
	 * Shoot du player
	 * @author Baptiste 
	 */
	public class ShootPlayer extends StateGraphic
	{	
		
		/**
		 * Liste des shoots
		 */
		public static var list:Vector.<ShootPlayer> = new Vector.<ShootPlayer>();
		
		/**
		 * Vitesse des shoots en X
		 */
		public var speedX:int = 0;
		
		/**
		 * Vitesse des shoots en Y
		*/
		public var speedY:int = 0;
		
		/**
		 * Dégats des tirs 
		 */
		public var damage:int = 1;
		
		/**
		 * Tirs puissants activés 
		 */
		public static var powerActivate:Boolean = false;
		
		/**
		 * Timer de tirs puissants 
		 */
		private static var timerPower:Number = 300;
		
		
		public function ShootPlayer() 
		{
			simpleBox = true;
			
			super(); 
			
			cacheAsBitmap = true;
			
			// Activation dans GameObject
			start();
		}
		
		override protected function doActionNormal ():void {
			
			// Déplacement 
			move();
			
			// Si sortie de l'écran, alors suppression 
			checkLeftScreen();
			
			// Collision avec les ennemis 
			checkCollisionEnemy();
			
			// Tirs puissants (upgrade)
			powerShoot();
		} 
		
		/**
		 * Déplacement 
		 */
		private function move ():void {
			x += speedX; 
			y += speedY;
		}
		
		/**
		 * Collision avec les ennemis 
		 */
		private function checkCollisionEnemy ():void {
			for each (var lEnemy:EnemyManager in EnemyManager.list) {
				// Si ennemi non invincible, destruction du shoot et de l'ennemi  
				if (lEnemy.hitBox.hitTestObject(this) && !lEnemy.invincible) {
					// Reset de l'animation  
					setState(DEFAULT_STATE);
					// Suppression du shoot (et pas de l'anim si shoot puissant) 
					list.splice(list.indexOf(this), 1); 
					if (!powerActivate) destroy();
					else GamePlane.getInstance().removeChild(this);
					// Perte de points de vie de l'ennemi  
					lEnemy.lifePoints -= damage;
					// Animation d'ennemi touché 
					lEnemy.setAnim("touched");
				}
				// Sinon, destruction du shoot 
				else if (lEnemy.hitBox.hitTestObject(this) && lEnemy.invincible) { 
					list.splice(list.indexOf(this), 1); 
					// Suppression (sans supprimer l'animation pour les tirs puissants) 
					if (!powerActivate) destroy();
					else GamePlane.getInstance().removeChild(this);
				}
			}
		}
		
		/**
		 * Tirs puissants 
		 */
		private function powerShoot ():void {
			// Passage en mode power
			if (powerActivate && timerPower > 0) {
				timerPower--;
				setState("power");
				damage = 2;
			}
			// Retour à l'état normal
			else if (timerPower == 0) {
				powerActivate = false;
				timerPower = 300; 
			}
		}
		
		/**
		 * Sortie de l'écran 
		 */
		private function checkLeftScreen ():void {
			if (x > GamePlane.getInstance().currentScreenLimits.right || 
				y < GamePlane.getInstance().currentScreenLimits.top || y > GamePlane.getInstance().currentScreenLimits.bottom) { 
				// Suppression (sans supprimer l'animation pour les tirs puissants) 
				list.splice(list.indexOf(this), 1);
				if (!powerActivate) destroy();
				else GamePlane.getInstance().removeChild(this);
			}
		}
	}
}