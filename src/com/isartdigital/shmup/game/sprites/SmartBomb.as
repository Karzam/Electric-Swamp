package com.isartdigital.shmup.game.sprites 
{
	import com.isartdigital.utils.game.StateGraphic;
	
	/**
	 * Smart Bomb 
	 * @author Baptiste 
	 */
	public class SmartBomb extends StateGraphic
	{
		
		/**
		 * Liste des smart bombs 
		 */
		public static var list:Vector.<SmartBomb> = new Vector.<SmartBomb>();
		
		
		public function SmartBomb() 
		{
			super();
			
			// Activation dans GameObject
			start();
		}
		
		override protected function doActionNormal ():void {
			// Position statique sur le GamePlane 
			x += 8;
			
			// Suppression à la fin de l'animation 
			if (anim.currentFrame == anim.totalFrames) {
				destroy(); 
				list.splice(list.indexOf(this), 1);
			}
		}
	}
}