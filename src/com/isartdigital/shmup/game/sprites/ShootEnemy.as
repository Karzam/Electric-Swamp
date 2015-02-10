package com.isartdigital.shmup.game.sprites 
{
	import com.isartdigital.utils.game.StateGraphic;
	import com.isartdigital.shmup.game.planes.GamePlane;
	
	/**
	 * Shoot des ennemis 
	 * @author Baptiste 
	 */
	public class ShootEnemy extends StateGraphic 
	{
		
		/**
		 * Liste des shoots
		 */
		public static var list:Vector.<ShootEnemy> = new Vector.<ShootEnemy>();
		
		/**
		 * Vitesse des shoots en X
		 */
		public var speedX:int = 0;
		
		/**
		 * Vitesse des shoots en Y
		*/
		public var speedY:int = 0;
		
		
		public function ShootEnemy() 
		{
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
		} 
		
		/**
		 * Déplacement 
		 */
		private function move ():void {
			x -= speedX; 
			y += speedY;
		}
		
		/**
		 * Sortie de l'écran 
		 */
		private function checkLeftScreen ():void {
			if (x < GamePlane.getInstance().currentScreenLimits.left || y < GamePlane.getInstance().currentScreenLimits.top ||
				y > GamePlane.getInstance().currentScreenLimits.bottom) {
				destroy();
				list.splice(list.indexOf(this), 1); 
			}
		}
	}
}