package vjyourself4.ctrl{
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import vjyourself4.dson.Eval;
	import vjyourself4.DynamicEvent;
	import vjyourself4.VJYBase;
	
	public class CtrlMIDI extends VJYBase{
		
		public var ns:Object;
		public var params:Object;
		//public var input;
		var midi;
		var enabled:Boolean=false;
		var device:Object;
		var litBackground:Boolean=false;
		var selectedColor:int=1;
		
		public function CtrlMIDI(){}
		
		public function init(){
			enabled=ns.sys.io.midi.enabled;
			if(enabled){
				ns.globalVary.events.addEventListener("CHANGED",onVaryChange,0,0,1);
				midi=ns.io.midi.manager;
				device=midi.params.device;
				midi.events.addEventListener("NOTE",onNote,0,0,1);
				litBackground=midi.params.device.litBackground;
				selectedColor=midi.params.device.selectedColor;
				for(var i=0;i<device.digi.length;i++){
					var dd=device.digi[i];
					if(dd.t=="index") {
						dd.i=0;
						for(var ii=0;ii<dd.e.length;ii++) midi.setLight(dd.e[ii],litBackground?dd.col:0);
					}
				}
			}
		}
		
		public function onVaryChange(d:DynamicEvent){
			var varyCh=d.data.ch;
			var varyInd=d.data.ind;
			for(var i=0;i<device.digi.length;i++){
					var dd=device.digi[i];
					if(dd.t=="index") {
						if((dd.command[0]=="globalVary")&&(dd.command[2][0]==varyCh)){
							midi.setLight(dd.e[dd.i],litBackground?dd.col:0);
							dd.i=varyInd;
							midi.setLight(dd.e[dd.i],selectedColor);
						}
					}
				}
		}
		public function onNote(e:DynamicEvent){
			if(e.data.val==1){
				log(1,"NOTE "+e.data.pitch);
				for(var i=0;i<device.digi.length;i++){
					var dd=device.digi[i];
					if(dd.t=="index") for(var ii=0;ii<dd.e.length;ii++) if(dd.e[ii]==e.data.pitch){
						//switch off perv
						execCommInd(dd.command,ii);
					}
					if(dd.t=="trig") if(dd.e==e.data.pitch) {
						midi.setLight(dd.e,dd.col);
						execComm(dd.command);
					}
				}
			}else{
				for(var i=0;i<device.digi.length;i++){
					var dd=device.digi[i];
					if(dd.t=="trig") if(dd.e==e.data.pitch) {
						midi.setLight(dd.e,0);
					}
				}
			}
		}
		function execCommInd(comm,i){
			log(1,"EXEC"+comm+" i:"+i);
			var tar=Eval.evalString(ns,comm[0]);
			var para=[];for(var ii=0;ii<comm[2].length;ii++) para.push(comm[2][ii]); para.push(i);
			tar[comm[1]].apply(tar,para);
		}
		function execComm(comm){
			log(1,"EXEC"+comm);
			var tar=Eval.evalString(ns,comm[0]);
			var para=comm[2];
			tar[comm[1]].apply(tar,para);
		}
		public function onEF(e=null){
			/*
			if(enabled){
				for(var i=0;i<4;i++) ns.scene.anal.setInput(i,midi.cc[params.anal[i]]);
				ns.game.lens_fov=0+midi.cc[24]*300;
			}
			*/
		}	
		
	
		
	}
}