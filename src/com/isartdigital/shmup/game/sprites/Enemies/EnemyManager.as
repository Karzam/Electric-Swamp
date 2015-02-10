package com.isartdigital.shmup.game.sprites.Enemies {
	import com.isartdigital.utils.game.StateGraphic;
	import com.isartdigital.shmup.ui.hud.Hud;
	import com.isartdigital.shmup.game.sprites.Player;
	import com.isartdigital.shmup.game.sprites.Collectables.CollectableManager;
	import com.isartdigital.shmup.game.sprites.Collectables.Upgrade;
	import com.isartdigital.shmup.game.sprites.Collectables.Life;
	import com.isartdigital.shmup.game.sprites.Collectables.Power;
	import com.isartdigital.shmup.game.sprites.Collectables.Bomb;
	import com.isartdigital.shmup.game.sprites.Collectables.Shield;
	import com.isartdigital.shmup.game.sprites.ShootEnemy;
	import com.isartdigital.shmup.game.planes.GamePlane;
	import com.isartdigital.shmup.game.sprites.Explosion;
	import flash.utils.getQualifiedClassName;
	import com.isartdigital.utils.sound.SoundFX;
	
	/**
	 * Gère les fonctions communes aux ennemis 
	 * ainsi que la liste les regroupants
	 * @author Baptiste 
	 */
	public class EnemyManager extends StateGraphic 
	{
		
		/**
		 * Liste des ennemis 
		 */
		public static var list:Vector.<EnemyManager> = new Vector.<EnemyManager>();
		
		/**
		 * État d'invinvibilité 
		 */
		public var invincible:Boolean = false; 
		
		/**
		 * Points de vie 
		 */
		public var lifePoints:int; 
		
		/**
		 * Vitesse de déplacement 
		 */
		protected var speed:int;
		
		
		public function EnemyManager(pAsset:String) 
		{
			assetName = pAsset;
			simpleBox = true;
			
			super();
			
			// Activation dans GameObject
			start();
		}
		
		override protected function doActionNormal ():void {
			
			// Invinvibilité lors du pop
			invincibleTime();
			
			// Sortie de l'écran 
			checkLeftScreen();
			
			// Vérification des points de vie 
			checkLifePoints();
			
			// Fin de l'animation en cours de lecture 
			endAnim();
		}
	
		/**
		 * Destruction si 0 points de vie 
		 */
		private function checkLifePoints ():void {
			if (lifePoints < 1) {		
				// Suppression de l'ennemi 
				destroy();
				list.splice(list.indexOf(this), 1)
				// Création d'un collectable 
				createCollectable();
				// Animation d'explosion 
				var lExplosion:Explosion = new Explosion();
				lExplosion.x = x;
				lExplosion.y = y; 
				Explosion.list.push(lExplosion);
				GamePlane.getInstance().addChild(lExplosion);
				// Son d'explosion  
				var lSound:SoundFX = new SoundFX("enemy_explosion");
				lSound.start();
				// Mis à jour du score 
				Hud.getInstance().updateScore();
			}
		}
		
		/**
		 * Création des collectables à la position de l'ennemi détruit 
		 */
		private function createCollectable ():void {
			var randValue:Number = Math.random(); 
			// Upgrade 
			if (randValue < 0.1) {
				var upgrade:Upgrade = new Upgrade();
				upgrade.x = x; 
				upgrade.y = y;
				CollectableManager.list.push(upgrade);
				GamePlane.getInstance().addChild(upgrade);
			}
			// Vie 
			else if (randValue >= 0.1 && randValue < 0.2) {
				var life:Life = new Life();
				life.x = x; 
				life.y = y;
				CollectableManager.list.push(life);
				GamePlane.getInstance().addChild(life);
			}
			// Smart bomb 
			else if (randValue >= 0.2 && randValue < 0.3) {
				var bomb:Bomb = new Bomb();
				bomb.x = x;
				bomb.y = y;
				CollectableManager.list.push(bomb);
				GamePlane.getInstance().addChild(bomb);
			}
			// Power 
			else if (randValue >= 0.3 && randValue < 0.4) {
				var power:Power = new Power();
				power.x = x;
				power.y = y;
				CollectableManager.list.push(power);
				GamePlane.getInstance().addChild(power);
			}
			// Shield 
			else if (randValue >= 0.4 && randValue < 0.5) {
				var shield:Shield = new Shield();
				shield.x = x;
				shield.y = y;
				CollectableManager.list.push(shield);
				GamePlane.getInstance().addChild(shield);
			}
		}
		
		/**
		 * Invinvibilité temporaire lors de l'entrée dans l'écran 
		 */
		private function invincibleTime ():void {
			// Si entrée dans l'écran, alors invincible 
			if (x > GamePlane.getInstance().currentScreenLimits.right - 200) {
				alpha = 0.5;
				invincible = true;
			}
			// Sinon, passage en mode normal
			else {
				alpha = 1;
				invincible = false;
			}
		}
		
		/**
		 * Changement d'animation
		 */
		public function setAnim(pState:String):void {
			setState(pState);
		}
		
		/**
		 * Fin de l'animation lancée 
		 */
		private function endAnim ():void {
			if (state != "static" && isAnimEnd()) setState("static");
		}
		
		/**
		 * Sortie de l'écran 
		 */
		private function checkLeftScreen ():void {
			if (x < GamePlane.getInstance().currentScreenLimits.left - width) {
				destroy();
				list.splice(list.indexOf(this), 1);
			}
		}
		
		override public function destroy ():void {
			super.destroy();
		}
	}
}