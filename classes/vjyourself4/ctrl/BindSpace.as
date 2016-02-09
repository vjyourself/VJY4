package vjyourself4.ctrl{
	import flash.events.Event;
	import flash.display.Sprite;
	import away3d.filters.*;
	import vjyourself4.three.assembler.Assembler;
	import vjyourself4.games.PathSpace;
	public class BindSpace{
		public var ns:Object;
		public var params:Object;
		public var input;
		public var pathSpace:PathSpace;
		
		public var meta:Object={};
		public var list:Array;
		
		public var defBind:Array=[
			
		
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
				
		];
		var currBind:Array;

		var channels:Array;

		public function BindSpace(){}
		public function init(){
			channels=[];
		}
		public function setBind(b){
			unBind();
			currBind=b;
			list=pathSpace.streams;
			var bb:Object;
			var bind:Object;
			var tar:Array;

			//create channels
			var maxInd=-1;
			for(var i=0;i<b.length;i++) if(b[i].ch>maxInd)maxInd=b[i].ch;
			for(var i=0;i<=maxInd;i++) channels.push({ch:i,bind:[],val:0});

			//add binds to channels
			for(var ii=0;ii<b.length;ii++){
				bb=b[ii];
				bind={prop:bb.prop,v0:bb.v0,v1:bb.v1,tar:[]};
				//resolve target
				switch(bb.tar){
					case "all":for(var i in list) if (list[i].active) bind.tar.push(i);break;
					case "Pipe":for(var i in list) if (list[i].active) if(list[i].strm.type=="Pipe") bind.tar.push(i);break;
					case "Objs":for(var i in list) if (list[i].active) if(list[i].strm.type=="Objs") bind.tar.push(i);break;
					default:
					for(var i in list) if (list[i].active) if (list[i].strm.id==bb.tar) bind.tar.push(i);break;
					break;
				} 
				channels[bb.ch].bind.push(bind);
			}
			reset();
		}

		public function updateBind(){
			var b=currBind;
			var bb:Object;
			var bind:Object;
			var tar:Array;

			//empty channel binds
			for(var i=0;i<channels.length;i++) channels[i].bind=[];

			//add binds to channels
			for(var ii=0;ii<b.length;ii++){
				bb=b[ii];
				bind={prop:bb.prop,v0:bb.v0,v1:bb.v1,tar:[]};
				//resolve target
				switch(bb.tar){
					case "all":for(var i in list) if (list[i].active) bind.tar.push(i);break;
					case "Pipe":for(var i in list) if (list[i].active) if(list[i].strm.type=="Pipe") bind.tar.push(i);break;
					case "Objs":for(var i in list) if (list[i].active) if(list[i].strm.type=="Objs") bind.tar.push(i);break;
					default:
					for(var i in list) if (list[i].active) if (list[i].strm.id==bb.tar) bind.tar.push(i);break;
					break;
				} 
				channels[bb.ch].bind.push(bind);
			}
			sendAll();
		}

		public function unBind(){
			channels=[];
		}
		public function reset(){
			for(var i=0;i<channels.length;i++) setInput(i,0);
			
		}
		public function sendAll(){
			for(var i in channels) setInput(i,channels[i].val);
		}
		public function setInput(ind,val){
			if(ind<channels.length){
				var ch=channels[ind];
				ch.val=val;
				//trace("setInput",ind,val,ch);
				for(var i=0;i<ch.bind.length;i++){
					var bb=ch.bind[i];
					var val2=bb.v0+(bb.v1-bb.v0)*val;
					for(var ii=0;ii<bb.tar.length;ii++) if((list[bb.tar[ii]]!=null)&&list[bb.tar[ii]].active&&((list[bb.tar[ii]].strm.state=="Running")||(list[bb.tar[ii]].strm.state=="Decomposing"))) list[bb.tar[ii]].strm.transVar.setVal(bb.prop,val2);
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
					for(var ii=0;ii<pathSpace.streams.list.length;ii++) if(pathSpace.streams.list[ii].id==l[i].tar) ind=ii;
					//found:
					if(ind>=0){
						var strm=pathSpace.streams.list[ind];
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