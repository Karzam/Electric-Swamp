package com.isartdigital.shmup.game.levelDesign 
{
	import com.isartdigital.shmup.game.sprites.Enemies.EnemyManager;
	import com.isartdigital.shmup.game.sprites.Enemies.Enemy0;
	import com.isartdigital.shmup.game.sprites.Enemies.Enemy1;
	import com.isartdigital.shmup.game.sprites.Enemies.Enemy2;
	import com.isartdigital.shmup.game.planes.GamePlane;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * Classe qui permet de générer des classes d'ennemis
	 * TODO: S'inspirer de la classe ObstacleGenerator pour le développement
	 * @author Baptiste MENARD
	 */
	public class EnemySpawnsGenerator extends GameObjectsGenerator 
	{
		
		public function EnemySpawnsGenerator() 
		{
			super();		
		}
	
		
		/**
		 * Génération d'ennemis et suppression du générateur 
		 */
		override public function generate ():void {
			
			// Création ennemi 0
			if (getQualifiedClassName(this) == "EnemySpawn0") {
				var lEnemy0:Enemy0 = new Enemy0(getQualifiedClassName(this)); 
				
				lEnemy0.x = x; 
				lEnemy0.y = y;
				
				EnemyManager.list.push(lEnemy0);
				parent.addChild(lEnemy0);
			}
			// Création ennemi 1
			if (getQualifiedClassName(this) == "EnemySpawn1") {
				var lEnemy1:Enemy1 = new Enemy1(getQualifiedClassName(this)); 
				
				lEnemy1.x = x; 
				lEnemy1.y = y;
				
				EnemyManager.list.push(lEnemy1);
				parent.addChild(lEnemy1);
			}
			// Création ennemi 2
			if (getQualifiedClassName(this) == "EnemySpawn2") {
				var lEnemy2:Enemy2 = new Enemy2(getQualifiedClassName(this)); 
				
				lEnemy2.x = x; 
				lEnemy2.y = y;
				
				EnemyManager.list.push(lEnemy2);
				parent.addChild(lEnemy2);
			}
			
			super.generate();
		}
	}
}