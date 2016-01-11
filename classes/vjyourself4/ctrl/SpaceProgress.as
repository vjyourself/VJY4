package vjyourself4.ctrl{
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import vjyourself4.dson.Eval;
	import vjyourself4.DynamicEvent;
	import vjyourself4.patt.WaveFollow;
	
	public class SpaceProgress{
		public var _debug:Object;
		public var _meta:Object={name:""};
		public function setDLevels(l1,l2,l3,l4){dLevels=[l1,l2,l3,l4];}
		var dLevels:Array=[true,false,false,false];
		function log(level,msg){if(dLevels[level-1])_debug.log(this,level,msg);}

		public var ns:Object;
		public var params:Object;
		var cloud;
		var GP;

		var stepElem:Boolean =true;
		var stepDelay:Number=30;
        
        var stepGroup:Boolean = true;
        var repeatGroup:Number = 1;

		var cc:Number=0;
		var stepCC:Number=0;
		var groupCC:Number=0;
		
		var currSpace:Object;

		public function SpaceProgress(){}
		
		public function init(){
			if(params.stepElem!=null) stepElem=params.stepElem;
			if(params.stepDelay!=null) stepDelay=params.stepDelay;
			if(params.stepGroup!=null) stepGroup=params.stepGroup;
			if(params.repeatGroup!=null) repeatGroup=params.repeatGroup;
			
			cloud=ns.sys.cloud;
			GP=ns.mid.cs.GP;
			log(1,"Current Space is: "+GP.state.space);
			var space = cloud.getSpaceInd(GP.state.space);
			log(1,"["+space.gI+"]"+space.gN+" . ["+space.eI+"]"+space.eN);
			currSpace=space;
			GP.events.addEventListener("SPACE_CHANGE",onSpaceChange);
		}

		public function onSpaceChange(e){
			log(1,"Current Space is: "+GP.state.space);	
			if(GP.state.space!=currSpace.eN){
				log(1,"External change, updating position...");
				var space = cloud.getSpaceInd(GP.state.space);
				log(1,"["+space.gI+"]"+space.gN+" . ["+space.eI+"]"+space.eN);
				currSpace=space;
				cc=0;
				stepCC=0;
				groupCC=0;
			}
		}
		
		
		
		public function onEF(e){
			if(stepElem){
				cc++;
				if(cc>=stepDelay*60){
					cc=0;
					log(1,"NEXT STEP...");
					currSpace.eI=(currSpace.eI+1)%cloud.spacesG[currSpace.gI].e.length;
					stepCC++;
					if(stepGroup){
						if(stepCC>=cloud.spacesG[currSpace.gI].e.length*repeatGroup){
							stepCC=0;
							currSpace.gI=Math.floor(Math.random()*cloud.spacesG.length);
							currSpace.gN=cloud.spacesG[currSpace.gI].name;
							log(1,"group > "+currSpace.gN);
							currSpace.eI=0;
						}
					}

					currSpace.eN=cloud.spacesG[currSpace.gI].e[currSpace.eI].name;
					log(1,"space > "+currSpace.eN);
					GP.setParams({space:currSpace.eN,restart:false});
				}
			}
		}
		
	}
}