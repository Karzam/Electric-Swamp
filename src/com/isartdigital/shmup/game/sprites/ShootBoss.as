package com.isartdigital.shmup.game.sprites 
{
	import com.isartdigital.utils.game.StateGraphic;
	import com.isartdigital.shmup.game.planes.GamePlane;
	
	/**
	 * Shoots tirés par le Boss 
	 * @author Baptiste 
	 */
	public class ShootBoss extends StateGraphic 
	{
		
		/**
		 * Liste des shoots
		 */
		public static var list:Vector.<ShootBoss> = new Vector.<ShootBoss>();
		
		/**
		 * Vitesse des shoots en X
		 */
		public var speedX:int;
		
		/**
		 * Vitesse des shoots en Y
		*/
		public var speedY:int;
		
		
		public function ShootBoss() 
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