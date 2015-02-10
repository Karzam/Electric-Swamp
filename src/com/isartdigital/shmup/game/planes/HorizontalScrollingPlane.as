package com.isartdigital.shmup.game.planes 
{
	import com.isartdigital.utils.Config;
	import com.isartdigital.utils.game.GameStage;
	import com.isartdigital.utils.game.GameObject;
	import com.isartdigital.shmup.game.GameManager; 
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * Classe "Plan de scroll", chaque plan de scroll (y compris le GamePlane) est une instance de HorizontalScrollingPlane ou d'une classe fille de HorizontalScrollingPlane
	 * TODO: A part GamePlane, toutes les instances de HorizontalScrollingPlane contiennent 3 MovieClips dont il faut gérer le "clipping" afin de les faire s'enchainer correctement
	 * alors que l'instance de HorizontalScrollingPlane se déplace
	 * @author Mathieu ANTHOINE
	 */


	public class HorizontalScrollingPlane extends GameObject
	{	
		
		/**
		 * Liste des movieclips contenus dans les plans de décor 
		 */
		public var planeClipping:Vector.<MovieClip> = new Vector.<MovieClip>(); 
		
		/**
		 * Vitesse de scrolling de base 
		 */
		protected const SCROLLING_SPEED:uint = 8;
		
		/**
		 * Coefficient multiplicateur de la vitesse de scrolling
		 */
		public var coeffScrollingSpeed:Number;
		
		/** 
		 * Largeur des plans de décor 
		 */ 
		private static const PART_WIDTH:int = 1219;
		
		
		public function HorizontalScrollingPlane() 
		{
			super();
		
			// Tableau des 3 plans de décor
			for (var i:uint = 0; i < numChildren; i++) planeClipping.push(getChildAt(i)); 
			planeClipping.sort(function (pA:MovieClip, pB:MovieClip) : int { return pA.x < pB.x ? -1 : 1 } );
			
			// Activation dans GameObject 
			start();
		}
		
		override protected function doActionNormal():void 
		{	
			// Scrolling
			scrolling();
			
			// Clipping 
			clipping();
		}		
		
		/**
		 * Scrolling (en fonction du coefficient de vitesse des instances) 
		 */
		private function scrolling ():void {
			x -= SCROLLING_SPEED * coeffScrollingSpeed;
		}
		
		/** 
		 * Clipping des movieclips
		 */
		private function clipping ():void {
			
			for (var i:int = 0; i < planeClipping.length; i++) {
				
				if (planeClipping[i].x + PART_WIDTH < getScreenLimits().left) {
					
					// Création d'un nouveau plan identique à celui qui va être supprimé 
					var newPlane:MovieClip = planeClipping[i];
					
					// Suppression du plan 
					removeChild(getChildAt(i)); 
					planeClipping.shift(); 
					
					// Ajout du nouveau plan  
					addChild(newPlane);  
					newPlane.x = planeClipping[planeClipping.length - 1].x + PART_WIDTH;  
					planeClipping.push(newPlane); 
				}
			}
		}
	
		/**
		 * Retourne les coordonnées des 4 coins de l'écran dans le repère du plan de scroll concerné 
		 * @return Rectangle dont la position et les dimensions correspondant à la taille de l'écran dans le repère local
		 */
		public function getScreenLimits ():Rectangle {
			var lTopLeft:Point = new Point (0, 0);
			var lBottomRight:Point = new Point (Config.stage.stageWidth, 0);
			
			lTopLeft = globalToLocal(lTopLeft);
			lBottomRight = globalToLocal(lBottomRight);
			
			return new Rectangle(lTopLeft.x, 0, lBottomRight.x-lTopLeft.x, GameStage.SAFE_ZONE_HEIGHT);
		}
		
	}

}