package com.isartdigital.shmup.game.sprites.Collectables {
	
	/**
	 * Collectable de Vie
	 * @author Baptiste 
	 */
	public class Life extends CollectableManager 
	{
			
		public function Life() 
		{
			super();
		}
		
		override public function destroy ():void {
			super.destroy();
		}
	}
}