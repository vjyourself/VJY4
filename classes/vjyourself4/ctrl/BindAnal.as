package vjyourself4.ctrl{
	import flash.events.Event;
	import flash.display.Sprite;
	import away3d.filters.*;
	import vjyourself4.dson.Eval;
	public class BindAnal{
		public var ns:Object;
		public var params:Object;
		public var input;
	
		
		public var meta:Object={};
		public var list:Array;
		
		public var defBind:Array=[
			/*
		
			{ch:0,tar:"all",prop:"scale1",v0:1,v1:0},
			{ch:1,tar:"all",prop:"scale0",v0:1,v1:0},
			{ch:2,tar:"Pipe",prop:"texDistro",v0:0,v1:1},
			{ch:2,tar:"Objs",prop:"scale",v0:1,v1:4},
			{ch:3,tar:"Pipe",prop:"texShift",v0:0,v1:2},
			{ch:3,tar:"Pipe",prop:"texZoom",v0:1,v1:3},
			{ch:3,tar:"Objs",prop:"scale",v0:1,v1:0},

			{ch:4,tar:"all",prop:"scale",v0:1,v1:3},
			{ch:5,tar:"Pipe",prop:"texZoom",v0:1,v1:4},
			{ch:6,tar:"Objs",prop:"rotY",v0:0,v1:3},
			{ch:7,tar:"Pipe",prop:"texZoomY",v0:1,v1:0.03}
			*/	
		];
		var channels:Array;
		public var multiMerge:Boolean=false;

		public function BindAnal(){}
		public function init(){
			channels=[];
		}
		public function setBind(b){
			unBind();
		
			var bb:Object;
			var bind:Object;
			var tar:Array;

			//create channels
			var maxInd=-1;
			for(var i=0;i<b.length;i++) if(b[i].ch>maxInd)maxInd=b[i].ch;
			for(var i=0;i<=maxInd;i++) channels.push({ch:i,bind:[],val:0,valSet:0,changed:false});

			//add binds to channels
			for(var ii=0;ii<b.length;ii++){
				bb=b[ii];
				bind={tar:{type:"channel"},trans:{type:"none"}};
				//resolve target
				bind.tar._obj=Eval.evalString(ns,bb.tar.obj);
				bind.tar.ch=bb.tar.ch;
				channels[bb.ch].bind.push(bind);
			}
		}
		public function unBind(){
			channels=[];
		}
		public function getVal(ind):Number{
			return channels[ind].val;
		}
		public function setInput(ind,val){
			if(ind<channels.length){
				var ch=channels[ind];
				//trace("setInput",ind,val,ch);
				
				if(multiMerge){
					if(!ch.changed) ch.val=val;
					else ch.val=ch.val+val;
					ch.changed=true;
					ch.valSet++;
				}else{
					ch.val=val;
					for(var i=0;i<ch.bind.length;i++){
						var bb=ch.bind[i];
						bb.tar._obj.setInput(bb.tar.ch,ch.val);
					}
				}
			
			}
		}

		public function onEF(e=null){
			if(multiMerge){
				for(var ind=0;ind<channels.length;ind++){
					var ch=channels[ind];
					if(ch.changed){
						ch.val=ch.val/ch.valSet;
						if(ch.val<0) ch.val=0;
						if(ch.val>1) ch.val=1;
						for(var i=0;i<ch.bind.length;i++){
							var bb=ch.bind[i];
							bb.tar._obj.setInput(bb.tar.ch,ch.val);
						}
						ch.changed=false;
						ch.valSet=0;
					}
				}
			}
		}
/*
		public function unbind(){
			list=[];

		}
		public function setBind(l){
			//go through list
			for(var i=0;i<l.length;i++){
				//skybox
				if(l[i].tar=="skybox"){
					ns.skybox.trans[l[i].f]=l[i];
					ns.skybox.trans[l[i].f].active=true;
				//space stream
				}else{
					//search for stream
					var ind=-1;
					for(var ii=0;ii<synthPath.streams.list.length;ii++) if(synthPath.streams.list[ii].id==l[i].tar) ind=ii;
					//found:
					if(ind>=0){
						var strm=synthPath.streams.list[ind];
						strm.trans[l[i].f]=l[i];
						strm.trans[l[i].f].active=true;
					}
				}
			}
		}
			
		public function onEF(e=null){
			
		}
		*/
		
	}
}