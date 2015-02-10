package com.isartdigital.shmup.game.sprites 
{
	import com.isartdigital.utils.game.StateGraphic;
	
	/**
	 * Tags de special feature qui lorsqu'ils sont tirés
	 * créent une ligne électrique entre les deux 
	 * @author Baptiste 
	 */
	public class Tag extends StateGraphic 
	{
		
		/**
		 * Liste des tags 
		 */
		public static var list:Vector.<Tag> = new Vector.<Tag>();
		
		/**
		 * Vitesse de déplacement 
		 */
		public var speed:Number = 8;
		
		
		public function Tag() 
		{
			super();
			
			// Activation dans GameObject
			start();
		}
		
		override protected function doActionNormal ():void {
			// Position statique 
			x += speed;
		}
	}
}