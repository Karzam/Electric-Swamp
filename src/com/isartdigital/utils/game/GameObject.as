package com.isartdigital.utils.game 
{
	import flash.display.Sprite;
	/**
	 * Classe de base des objets interactifs dans le jeu
	 * expose de façon publique sa méthode doAction qui peut faire référence à différentes méthodes prévues (doActionVoid, doActionNormal) ou spécifiques définies par ses classes filles
	 * Par convention le changement de référence de doAction se fait via des méthodes setMode (setModeVoid, setModeAction) qui peuvent aussi contenir des paramètres d'initialisation
	 * @author Baptiste MENARD
	 */
	public class GameObject extends Sprite 
	{
		
		/**
		 * méthode appelée à chaque gameLoop. Elle peut faire référence à différentes méthodes au cours du temps
		 */
		public var doAction:Function;
		
		public function GameObject() 
		{	
			super();
			setModeVoid();	
		}
			
		/**
		 * applique le mode "ne fait rien"
		 */
		protected function setModeVoid (): void {
			doAction = doActionVoid;
		}
		
		/**
		 * fonction vidé destinée à maintenir la référence de doAction sans rien faire
		 */
		protected function doActionVoid (): void {}

		
		/**
		 * applique le mode normal (mode par defaut)
		 */
		protected function setModeNormal(): void {
			doAction = doActionNormal;
		}
		
		/**
		 * Applique le premier état du boss 
		 */
		protected function setModeFirstState ():void {
			doAction = doActionFirstState;
		}
		
		/**
		 * Applique le deuxième état du boss 
		 */
		protected function setModeSecondState ():void {
			doAction = doActionSecondState;
		}
		
		/**
		 * Applique le troisième état du boss 
		 */
		protected function setModeThirdState ():void {
			doAction = doActionThirdState;
		}
		
		/**
		 * fonction destinée à appliquer un comportement par defaut
		 */
		protected function doActionNormal (): void {
		}
		
		/** 
		 * Premier état du boss 
		 */
		protected function doActionFirstState ():void {
		}
		
		/** 
		 * Second état du boss 
		 */
		protected function doActionSecondState ():void {
		}
		
		/** 
		 * Troisième état du boss 
		 */
		protected function doActionThirdState ():void {
		}
		
		/**
		 * Activation
		 */
		public function start (): void {
			setModeNormal();
		}
		
		/**
		 * nettoie et détruit l'instance
		 */
		public function destroy (): void {
		}
		
		/**
		 * Suppression de toutes les instances de la liste d'une classe donnée  
		 */
		public static function destroyAll (pClass:Class):void {
			for each (var lObj in pClass.list) {
				lObj.destroy();
				pClass.list.splice(0, pClass.list.length);
			}
		}
		
	}
}