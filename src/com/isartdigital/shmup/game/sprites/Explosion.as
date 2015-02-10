package com.isartdigital.shmup.game.sprites 
{
	import com.isartdigital.utils.game.StateGraphic;
	
	/**
	 * Animation d'explosion des ennemis et du player 
	 * @author Baptiste 
	 */
	public class Explosion extends StateGraphic 
	{
		
		/**
		 * Liste des explosions 
		 */
		public static var list:Vector.<Explosion> = new Vector.<Explosion>();
		
		
		public function Explosion() 
		{
			super();
			
			// Activation dans GameObject
			start();
		}
		
		override protected function doActionNormal ():void {
			// Suppression à la fin de l'animation 
			if (anim.currentFrame == anim.totalFrames) {
				destroy();
				list.splice(list.indexOf(this), 1);
			}
		}
		
		override public function destroy ():void {
			setModeVoid();
			super.destroy();
		}
	}
}