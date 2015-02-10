package com.isartdigital.shmup.game.sprites.Collectables {
	import com.isartdigital.utils.game.StateGraphic;
	
	/**
	 * Classe manager contenant la liste des collectables 
	 * des différents types
	 * @author Baptiste 
	 */
	public class CollectableManager extends StateGraphic 
	{
		
		/**
		 * Liste des collectables 
		 */
		public static var list:Vector.<CollectableManager> = new Vector.<CollectableManager>();
		
		
		public function CollectableManager() 
		{
			super();
		}
		
	}

}