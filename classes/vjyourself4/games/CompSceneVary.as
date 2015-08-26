package vjyourself4.games{
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import vjyourself4.dson.TransJson;

	public class CompScene{
		public var ns:Object;
		public var params:Object;
		
		var scenes:Array;
		var scenesInd:Number=-1;
		
		//Scene Variations
		public var vary:Object;
		//Current State
		public var state:Object;

		public var bind:Object;

		public function CompScene(){}
		
		public function init(){
			
			vary={
				spaceG:{e:[],i:-1},
				space:{e:[],i:-1},
				context:{
					texture:{
						A:{e:[],i:-1},
						B:{e:[],i:-1},
						A_mul:{e:[],i:-1},
						B_mul:{e:[],i:-1}
					},
					color:{
						//Lights:{e:[],i:-1},
						A:{e:[],i:-1},
						B:{e:[],i:-1}
					}
				},
				skybox:{e:[],i:-1},
				path:{e:[],i:-1},
				lights:{e:[],i:-1},
				filters:{e:[],i:-1},
				blend:{e:[],i:-1},
				scenes:{e:[],i:-1},
				mclp:{e:[{name:false},{name:true}],i:0}
			};

			state={
				spaceG:"",
				space:"",
				context:{
					texture:{
						A:{},
						A_mul:1,
						B:{},
						B_mul:1
						},
					color:{
						//Lights:"",
						A:"",
						B:""
					}
				},
				skybox:"",
				path:"",
				lights:"",
				filters:"",
				blend:"",
				scenes:"",
				mclp:false
			}

			scenes=ns.cloud.scenes;
			scenesInd=-1; //no active saved scene

			if(params.init!=null){
				if(params.init.scene!=null){
					if(params.init.flags==null)params.init.flags={};
					setScene(params.init.scene,params.init.flags);
				}
			}
			
		}
		
		public function next(path,flags=null){
			stepVary(path,1,flags);
		}

		public function prev(path,flags=null){
			stepVary(path,-1,flags);
		}
		public function stepVary(name,inc,flags=null){
			trace("> Step Vary "+name);
			if(flags==null) flags={};
			if(flags.rebuild==null) flags.rebuild=false;
			//if((flags.rebuild)&&(name=="space")) ns.GP.synthPath.timeline.destroyAll();
			
			var path=name.split(".");

			var o=state;
			for(var i=0;i<path.length-1;i++) o=o[path[i]];
			var vStateO=o;
			var vStateN=path[path.length-1];

			o=vary;
			for(var i=0;i<path.length;i++) o=o[path[i]];
			var vVary=o;

			vVary.i=(vVary.i+inc+vVary.e.length)%vVary.e.length;
			vStateO[vStateN]=vVary.e[vVary.i].name;
			updateScenePart(name,flags);
			ns.sys.mstream.logSimple(vStateN+":"+vStateO[vStateN]);

			if((!flags.rebuild)&&((name=="space")||(name=="spaceG"))) ns.GP.synthPath.timeline.startSpace(ns.cloud.RPrg.cont.programs.path[state.space]);
			if(flags.rebuild){
				ns.GP.restart({path:{type:state.path},space:ns.cloud.RPrg.cont.programs.path[state.space]});
				if(ns.bind!=null) if(bind!=null)ns.bind.setBind(bind);
			}
		}

		public function updateScenePart(name,flags=null){
			switch(name){
				case "context.texture.A":
				ns.GP.context.setStream({type:"texture",stream:"A",params:state.context.texture.A});
				break;
				case "context.texture.A_mul":
				ns.GP.context.setStream({type:"texture",stream:"A",params:{delayMul:state.context.texture.A_mul}});
				break;
				case "context.texture.B":
				ns.GP.context.setStream({type:"texture",stream:"B",params:state.context.texture.B});
				break;
				case "context.texture.B_mul":
				ns.GP.context.setStream({type:"texture",stream:"B",params:{delayMul:state.context.texture.B_mul}});
				break;
				
				case "path":
				//ns.GP.restart({path:{type:state.path}});
				break;

				/*case "context.color.Lights":
				ns.GP.context.setStream({type:"color",stream:"Lights",params:state.context.color.Lights});
				break;*/
				case "context.color.A":
				ns.GP.context.setStream({type:"color",stream:"A",params:state.context.color.A});
				break;
				case "context.color.B":
				ns.GP.context.setStream({type:"color",stream:"B",params:state.context.color.B});
				break;

				case "spaceG":
				var spaceGInd=0;
				for(var i in ns.cloud.spacesG) if(ns.cloud.spacesG[i].name==state.spaceG) spaceGInd=i;
				vary.space.e=ns.cloud.spacesG[spaceGInd].e;
				//choose first space
				vary.space.i=0;
				state.space=ns.cloud.spacesG[spaceGInd].e[0].name;
				//ns.GP.synthPath.timeline.startSpace(ns.cloud.RPrg.cont.programs.path[state.space]);
				applySpaceParams();
				break;
				case "space":
				//find group
				var spaceGInd=0; var spaceInd=0;
				for(var i in ns.cloud.spacesG) for(var ii in ns.cloud.spacesG[i].e) if(ns.cloud.spacesG[i].e[ii].name==state.space){
					spaceGInd=i;
					spaceInd=ii;
				}
				vary.space.e=ns.cloud.spacesG[spaceGInd].e;
				vary.space.i=spaceInd;
				applySpaceParams();
				//ns.GP.synthPath.timeline.startSpace(ns.cloud.RPrg.cont.programs.path[state.space]);
				break;
				case "skybox":
				ns.skybox.setTexture(state.skybox);
				break;
				case "filters":
				ns.filters.setFilters(state.filters);
				break;
				case "lights":
				ns.lights.setLights(state.lights);
				break;
				case "blend":
				ns.blend.setBlend(state.blend)
				break;
				case "mclp":
				ns.cloud.R3D.enableMCLightPicker(state.mclp);
				break;
				case "scenes":
				setScene(state.scenes,flags);
				break;

			}
			
		}
		function applySpaceParams(){
			var sp=ns.cloud.RPrg.cont.programs.path[state.space];
			var delay=1;
			if(sp.params.texADelay!=null) delay=sp.params.texADelay;
			ns.GP.context.setStream({type:"texture",stream:"A",params:{delay:delay}});
			delay=1;
			if(sp.params.texADelay!=null) delay=sp.params.texBDelay
			ns.GP.context.setStream({type:"texture",stream:"B",params:{delay:delay}});
		}
		/*
		flags:
		- rebuild: true/false :: rebuild space after changes
		- updateVary: true/false :: update vary object too
		- updateState: true/false :: update current state
		- updateInd: Number :: if update current state, to which sub variations
		- affectSpace: true/false :: space / textures
		- affectLighting: true/false :: skybox / light / filter / blend / color
		*/
		var flagsDef={
        	"rebuild":false,
			"updateVary":false,
            "updateState":true,
            "updateStateVaryInd":0,
            "tier1":true,
            "tier2":true,
			"sceneFlags":true
        };

		public function setScene(s,$flags=null){
			trace("*************************************************************************");
			trace("SET SCENE");
			if(s is String){
				trace(" name: "+s);
				setScene(ns.cloud.RScenes.NS[s],$flags);
				return;
			}

			//BINDING
			if(ns.bind!=null) ns.bind.unbind();
			//OVER 
			// flagsDef.sceneFlags <- $flags.sceneFlags
			// flagsDef <- (sceneFlags ? scene.flags) <- $flags
			var flags:Object = TransJson.clone(flagsDef);
			if($flags==null) $flags={};
			if($flags.sceneFlags!=null) flags.sceneFlags=$flags.sceneFlags;
			if((flags.sceneFlags)&&(s.flags!=null)) TransJson.over(flags,s.flags);
			TransJson.over(flags,$flags);

			if(flags.rebuild) ns.GP.synthPath.timeline.destroyAll();
			
			//basic vary definition
			if(s.vary!=null) setScene(ns.cloud.RScenes.NS[s.vary],{rebuild:false,updateVary:true,updateState:false,updateStateVaryInd:"random"});
			
			var l:Array;
			var i:Number;
			var v;

			//context
			if(s.context!=null){
				if((s.context.texture!=null)&&(flags.tier1)){
					if(s.context.texture.A!=null){
						processValue2(s,flags,"context.texture.A",ns.cloud.themes);
						if(flags.updateState) updateScenePart("context.texture.A");
					}
					if(s.context.texture.A_mul!=null){
						processValue2(s,flags,"context.texture.A_mul",[{name:1},{name:2},{name:3},{name:4},{name:0}]);
						if(flags.updateState) updateScenePart("context.texture.A_mul");
					}
					if(s.context.texture.B!=null){
						processValue2(s,flags,"context.texture.B",ns.cloud.themes);
						if(flags.updateState) updateScenePart("context.texture.B");
					}
					if(s.context.texture.B_mul!=null){
						processValue2(s,flags,"context.texture.B_mul",[{name:1},{name:2},{name:3},{name:4},{name:0}]);
						if(flags.updateState) updateScenePart("context.texture.B_mul");
					}
				}
				if(s.context.color!=null){
					/*if((s.context.color.Lights!=null)&&(flags.tier2)){
						processValue2(s,flags,"context.color.Lights",ns.cloud.colors);
						if(flags.updateState) updateScenePart("context.color.Lights");
					}*/
					if((s.context.color.A!=null)&&(flags.tier2)){
						processValue2(s,flags,"context.color.A",ns.cloud.colors);
						if(flags.updateState) updateScenePart("context.color.A");
					}
					if((s.context.color.B!=null)&&(flags.tier2)){
						processValue2(s,flags,"context.color.B",ns.cloud.colors);
						if(flags.updateState) updateScenePart("context.color.B");
					}
				}
			}

			//path
			if((s.path!=null)&&(flags.tier1)){
				processValue2(s,flags,"path",ns.cloud.paths);
				if(flags.updateState) updateScenePart("path");
			}

			//spaceG
			if((s.spaceG!=null)&&(flags.tier1)){
				processValue2(s,flags,"spaceG",ns.cloud.spacesG);
				if(flags.updateState) updateScenePart("spaceG");
			}
			//space
			if((s.space!=null)&&(flags.tier1)){
				processValue2(s,flags,"space",ns.cloud.spaces);
				if(flags.updateState) updateScenePart("space");
			}

			//skybox
			if((s.skybox!=null)&&(flags.tier2)){
				processValue2(s,flags,"skybox",ns.cloud.skyboxes);
				if(flags.updateState) updateScenePart("skybox");
			}
			if(s.skyboxMode!=null) ns.skybox.setMode(s.skyboxMode);

			//filters
			if((s.filters!=null)&&(flags.tier2)){
				processValue2(s,flags,"filters",ns.cloud.filters);
				if(flags.updateState) updateScenePart("filters");
			}

			//mclp
			if((s.mclp!=null)&&(flags.tier2)){
				if(flags.updateState){
					state.mclp=s.mclp;
					trace("MCLP!!!!!!!!!!!!!!"+state.mclp);
					updateScenePart("mclp");
				}
			}

			//lights
			if((s.lights!=null)&&(flags.tier2)){
				processValue2(s,flags,"lights",ns.cloud.lights);
				if(flags.updateState) updateScenePart("lights");
			}

			//blend
			if((s.blend!=null)&&(flags.tier2)){
				processValue2(s,flags,"blend",ns.cloud.blends);
				if(flags.updateState) updateScenePart("blend");
			}
			
			//scenes - only vary
			if(s.scenes!=null){
				var f=TransJson.clone(flags);
				f.updateState=false;
				processValue2(s,f,"scenes",ns.cloud.scenes);
			}
			trace("SCENE DONE");
			if(flags.rebuild) ns.GP.restart({path:{type:state.path},space:ns.cloud.RPrg.cont.programs.path[state.space]});
			if(ns.bind!=null) if(s.bind!=null){
				bind=s.bind;
				ns.bind.setBind(s.bind);
			}
		}
		function setState(name,val,flags){
			var path=name.split(".");
			var o;

			o=state;
			for(var i=0;i<path.length-1;i++) o=o[path[i]];
			var vStateO=o;
			var vStateN=path[path.length-1];

			o=vary;
			for(var i=0;i<path.length;i++) o=o[path[i]];
			var vVary=o;

			vStateO[vStateN]=val;
			for(var i=0;i<vVary.e.length;i++)if(vVary.e[i].name==val) vVary.i=i;
			updateScenePart(name,flags);
			//trace("State Set "+name+":"+val+"  -vary.i:"+vVary.i+" v:"+vVary.e[vVary.i].name);
			ns.sys.mstream.logSimple(vStateN+":"+vStateO[vStateN]);
		}

		function processValue2(s,flags,name:String,eCloud){
			trace("> ProcessValue "+name);
			var path=name.split(".");

			var o=s;
			for(var i=0;i<path.length;i++) o=o[path[i]];
			var val=o;

			o=state;
			for(var i=0;i<path.length-1;i++) o=o[path[i]];
			var vStateO=o;
			var vStateN=path[path.length-1];

			o=vary;
			for(var i=0;i<path.length;i++) o=o[path[i]];
			var vVary=o;

			processValue(val,flags,vStateO,vStateN,vVary,eCloud);
		}
		function processValue(val,flags,vStateO,vStateN,vVary,eCloud){

			var e;
			var i;
			// {vary:[],state:"",stateInd:-1};
			var o:Object; 

			o=val;
			if (val is String) o={vary:[val],varyInd:0};
			else if (val is Number) o={vary:[val],varyInd:0};

			if (val is Array) o={vary:val,varyInd:flags["updateStateVaryInd"]};
			if(o.vary=="*") o.vary=["*"];
			
			//compute list
			if(o.vary[0]=="*") e=TransJson.clone(eCloud);
			else {
				e=[];for(var i=0;i<o.vary.length;i++)e.push({name:o.vary[i]});
			}
			//compute index
			i=-1;
			if(o.varyInd!=null){
				if(o.varyInd=="random") i=Math.floor(Math.random()*e.length);
				else i=o.varyInd;
			}
			if(o.state==null){
				o.state=e[i].name;
			}else{
				for(var ii=0;ii<e.length;ii++) if(e[ii].name==o.state) i=ii;
			}

			if(flags.updateVary){
				vVary.e=e;
				vVary.i=i
				trace("   vary: "+i+" > "+e);
			}
			if(flags.updateState){
				vStateO[vStateN]=o.state;
				trace("   state: "+vStateO[vStateN]);
			}
		}
		

	}
}