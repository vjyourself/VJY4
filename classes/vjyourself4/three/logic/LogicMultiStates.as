package vjyourself4.three.logic{
	import flash.geom.Vector3D;
	import vjyourself4.DynamicEvent;

	public class LogicMultiStates{
		var logic:Object;
		var target:String;
		var states:Array;
		var stateInd:Number=0;

		public function LogicMultiStates(lg,p){
			logic=lg;
			for(var i in p) this[i]=p[i];
		}
		
		public function init(){
			stateInd=0;
			stateInd=Math.floor(Math.random()*states.length);
		}
		public function onEF(e:DynamicEvent){
			if(logic.musicmeta.beat.beatFrame){
				logic.obj.res[states[stateInd]].visible=false;
				stateInd=(stateInd+1)%states.length;
				logic.obj.res[states[stateInd]].visible=true;
			}
				
		}
	}
}