package vjyourself4.games{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import vjyourself4.dson.TransJson;
	import vjyourself4.ctrl.BindAnal;
	import vjyourself4.dson.TransJson;

	public class SceneManager{
		public var _debug:Object;
		public var _meta:Object={name:"Scene"};
		public function setDLevels(l1,l2,l3,l4){dLevels=[l1,l2,l3,l4];}
		var dLevels:Array=[true,true,false,false];
		function log(level,msg){if(dLevels[level-1])_debug.log(this,level,msg);}

		public var ns:Object;
		public var params:Object;
		
		public var state:Object;
		public var anal:BindAnal;

		public var events:EventDispatcher = new EventDispatcher();
		var currScene:Object;
		public function SceneManager(){

			compParams=this;
		}
		
		public function init(){
			log(1,"Init");
			anal = new BindAnal();
			anal.multiMerge=true;
			anal.ns=ns;

			
			if(params.init!=null){
				if(params.init.scene!=null){
					if(params.init.flags==null)params.init.flags={};
					if(params.init.scene=="World4") setScene(ns._sys.cloud.World4.d.startScene,params.init.flags);
					else setScene(params.init.scene,params.init.flags);
				}
			}
			
		}
		public var compParams:Object;
		public function setParam(n,v){
			if(n=="scene") setScene(v);
		}
		public function setScene(s,$flags=null){
			trace("SETSCENE "+s);
			if($flags==null)$flags={};

			if( s==null) s="All";
			
			if(s is String){
				if(s=="") s="All";
				setScene(ns.cloud.RScenes.NS[s],$flags);
				return;
			}

			currScene=TransJson.clone(s);

			log(1,"setScene: "+currScene.name);
			if(currScene.init==null) currScene.init={varyToState:false,stateToVary:false};
			/*
			log(2,"< Context >");

			//context
			if(s.context!=null){
				if((s.context.texture!=null)){
					if(s.context.texture.Back!=null) setVal("context.texture.Back",s.context.texture.Back);
					if(s.context.texture.Back_mul!=null) setVal("context.texture.Back_mul",s.context.texture.Back_mul);
					if(s.context.texture.A!=null) setVal("context.texture.A",s.context.texture.A);
					if(s.context.texture.A_mul!=null) setVal("context.texture.A_mul",s.context.texture.A_mul);
					if(s.context.texture.B!=null) setVal("context.texture.B",s.context.texture.B);
					if(s.context.texture.B_mul!=null) setVal("context.texture.B_mul",s.context.texture.B_mul);
				}
				if(s.context.color!=null){
					if(s.context.color.Back!=null) setVal("context.color.Back",s.context.color.Back);
					if(s.context.color.A!=null) setVal("context.color.A",s.context.color.A);
					if(s.context.color.B!=null) setVal("context.color.A",s.context.color.B);	
				}
			}*/

			//vary
			log(2,"< Vary >");
			ns.sceneVary.autoEvalObjPath=false;
			ns.sceneVary.setParams(currScene.vary);
			if(currScene.init.varyToState){
				var varyState=ns.sceneVary.getState();
				for(var i in varyState) switch(i){
					case "back":
					case "fore":
					case "mid":
					TransJson.over(currScene.state[i].params,varyState[i]);
					break;
					default:
					currScene.state[i]=varyState[i];	
					break;
				}
				//TransJson.over(currScene.state,varyState);
			}
			
			//back
			log(2,"< Back Comps >");
			ns.back.build(currScene.state.back);

			//mid
			log(2,"< Mid Comps >");
			ns.mid.build(currScene.state.mid);

			//fore
			log(2,"< Fore Comps >");
			ns.fore.build(currScene.state.fore);

			//mclp
			if(currScene.state.mclp!=null){
				ns._sys.cloud.R3D.setMCLP(currScene.state.mclp);
			}else{
				currScene.state.mclp=ns._sys.cloud.R3D.mclp;
			}

			//blendAdd
			if(currScene.state.blendAdd!=null){
				ns._sys.cloud.R3D.setBlendAdd(currScene.state.blendAdd);
			}else{
				currScene.state.blendAdd=ns._sys.cloud.R3D.blendAdd;
			}

			//MM
			if(currScene.state.mm!=null) ns._sys.cloud.R3D.setParamsMM(currScene.state.mm);
			
			//filter
			log(2,"< Filter >");
			if(currScene.state.filter!=null){
				ns.filter.setParams(currScene.state.filter);
			}else{
				ns.filter.setParams({type:"Normal"});
				currScene.state.filter={type:"Normal"};
			}

			ns.sceneVary.evalObjPath();
			ns.sceneVary.autoEvalObjPath=true;

			//anal
			log(2,"< Anal >");
			if(currScene.anal!=null) anal.setBind(currScene.anal.bind);

			events.dispatchEvent(new Event(Event.OPEN));
			events.dispatchEvent(new Event(Event.CHANGE));
		}

		public function paramsChanged(){
			events.dispatchEvent(new Event(Event.CHANGE));
		}

		public function getDef(){
			currScene.state.back=TransJson.clone(ns.back.compParams.params);
			currScene.state.back.context.texA.ind=ns.back.cs.context.cs.texA.elemsInd;
			currScene.state.mid=TransJson.clone(ns.mid.compParams.params);
			currScene.state.fore=TransJson.clone(ns.fore.compParams.params);
			currScene.state.mclp=ns._sys.cloud.R3D.mclp;
			currScene.state.filter={type:ns.filter.type};
			currScene.state.blendAdd=ns._sys.cloud.R3D.blendAdd;
			return currScene;
		}
		/*
		function setVal(name,val,flags=null){
			if(name=="scene") setScene(val,flags);

			var path=name.split(".");
			var o;

			o=state;
			for(var i=0;i<path.length-1;i++) o=o[path[i]];
			var vStateO=o;
			var vStateN=path[path.length-1];
			vStateO[vStateN]=val;
			updateScenePart(name,flags);
			
			log(2,vStateN+":"+vStateO[vStateN]);
		}

		public function updateScenePart(name,flags=null){
			switch(name){
				case "context.texture.Back":
				ns.context.setStream({type:"texture",stream:"Back",params:state.context.texture.Back});
				break;
				case "context.texture.Back_mul":
				ns.context.setStream({type:"texture",stream:"Back",params:{delayMul:state.context.texture.Back_mul}});
				break;
				case "context.texture.A":
				ns.context.setStream({type:"texture",stream:"A",params:state.context.texture.A});
				break;
				case "context.texture.A_mul":
				ns.context.setStream({type:"texture",stream:"A",params:{delayMul:state.context.texture.A_mul}});
				break;
				case "context.texture.B":
				ns.context.setStream({type:"texture",stream:"B",params:state.context.texture.B});
				break;
				case "context.texture.B_mul":
				ns.context.setStream({type:"texture",stream:"B",params:{delayMul:state.context.texture.B_mul}});
				break;
			
				case "context.color.Back":
				ns.context.setStream({type:"color",stream:"Back",params:state.context.color.Back});
				break;
				case "context.color.A":
				ns.context.setStream({type:"color",stream:"A",params:state.context.color.A});
				break;
				case "context.color.B":
				ns.context.setStream({type:"color",stream:"B",params:state.context.color.B});
				break;
				case "filter":
				ns.filter.setVal(state.filter);

			}
			
		}*/
		public function onEF(e=null){
			anal.onEF();
		}
		
	}
}