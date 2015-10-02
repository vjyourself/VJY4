package vjyourself4.games{
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import vjyourself4.dson.TransJson;
	import vjyourself4.dson.Eval;

	public class SceneVary{
		public var _debug:Object;
		public var _meta:Object={name:"Scene"};
		public function setDLevels(l1,l2,l3,l4){dLevels=[l1,l2,l3,l4];}
		var dLevels:Array=[true,true,false,false];
		function log(level,msg){if(dLevels[level-1])_debug.log(this,level,msg);}

		//var ccloud:Object;
		//var scene:SceneManager;

		public var ns:Object;
		public var params:Object;
		public var autoEvalObjPath:Boolean=true;
		
		var channels:Array;
		
		/*
		public var cont:Object={
			filter:{e:[],i:-1},
			scene:{e:[],i:-1}
		}
		*/

		public function SceneVary(){
			channels=[];
		}
		
		public function init(){
			setParams(params);
		}
		public function setParams(p){
			if(p.channels!=null){
				for(var i in channels) channels[i].obj=null;
				channels=[];
				for(var i=0;i<p.channels.length;i++){
					var ch={};
					var chm=p.channels[i];
					if((chm.link!=null)&&(chm.link)){
						ch.act="link";
						ch.ch=chm.ch;
						ch.lev=chm.lev;
					}else{
					if(chm.tar.func!=null){
						ch.act="func";
						ch.func=chm.tar.func;
						if(autoEvalObjPath) ch.obj=Eval.evalString(ns,chm.tar.obj);
						ch.objPath=chm.tar.obj;
					}
					if(chm.tar.prop!=null){
						ch.act="prop";
						ch.path=chm.tar.obj+"."+chm.tar.prop;
						if(autoEvalObjPath) ch.obj=Eval.evalString(ns,chm.tar.obj);
						ch.objPath=chm.tar.obj;
						ch.prop=chm.tar.prop;
						var vals:Array;

						//NESTED e,i,v e2,i2,v2
						if(chm.nested!=null){
							ch.nested=true;
							if(chm.vals is String){
								vals=[];
								var cv=ns._sys.cloud.cont[chm.vals].l;
								for(var vi=0;vi<cv.length;vi++){
									var vvv =[];
									var cvv=cv[vi].e;
									for(var vii=0;vii<cvv.length;vii++) vvv.push(cvv[vii].name.substring(3));
									vals.push(vvv);
								}
							}else{
								vals=chm.vals;
							}
							ch.e2=vals;
							ch.i2=0;
							if(chm.i2!=null){
								if(chm.i2 is String){
									switch(chm.i2){
										case "random": ch.i2=Math.floor(Math.random()*ch.e2.length);break;
									}
								}else{
									ch.i2=chm.i2;
								}
							}
							ch.v2=ch.e2[ch.i2];
							
							ch.e=ch.v2;
							ch.i=0;
							if(chm.i!=null){
								if(chm.i is String){
									switch(chm.i){
										case "random": ch.i=Math.floor(Math.random()*ch.e.length);break;
									}
								}else{
									ch.i=chm.i;
								}
							}
							ch.v=ch.e[ch.i];

						//SINGLE e,i,v
						}else{
							ch.nested=false;
							if(chm.val_type!=null) ch.val_type=chm.val_type;
							if(chm.vals is String){
								vals=[];
								var cv=ns._sys.cloud.cont[chm.vals].l;
								for(var vi=0;vi<cv.length;vi++){
									vals.push(cv[vi].name);
								}
							}else{
								vals=[];
								for(var ii=0;ii<chm.vals.length;ii++)vals.push(chm.vals[ii]);
							}
							ch.e=vals;
							ch.i=0;
							if(chm.i!=null){
								if(chm.i is String){
									switch(chm.i){
										case "random": ch.i=Math.floor(Math.random()*ch.e.length);break;
									}
								}else{
									ch.i=chm.i;
								}
							}
							
							ch.v=ch.e[ch.i];
						}
					}
					}
					
					channels.push(ch);
				}
			}
			/*
			ccloud=ns.cloud.cont;

			var list:Array;
			var elems:Array;
			var i:int;
			
			list=ccloud.filter.l;
			elems=cont.filter.e;
			for(var i=0;i<list.length;i++) elems.push(list[i].name);
			cont.filter.i=0;

			list=ccloud.scene.l;
			elems=cont.scene.e;
			for(var i=0;i<list.length;i++) elems.push(list[i].name);
			cont.scene.i=0;
			*/
		}
		public function evalObjPath(){
			for(var i=0;i<channels.length;i++){
				var ch=channels[i];
				if((ch.act=="prop")||(ch.act=="func") ) ch.obj=Eval.evalString(ns,ch.objPath);
			}
		}
		public function getState():Object{
			var s={};
			for(var i=0;i<channels.length;i++){
				var ch=channels[i];
				if(ch.act=="prop"){
					var pp=ch.path.split(".");
					var tar=s;
					for(var ii=0;ii<pp.length-1;ii++){
						if(tar[pp[ii]]==null) tar[pp[ii]]={};
						tar=tar[pp[ii]];
					}
					tar[pp[pp.length-1]]=ch.v;
				}
				
			}
			return s;
		}
		public function getVal(ch){
			return channels[ch].v;
		}
		public function getValName(ind){
			var ch=channels[ind];
			if(ch.val_type!=null){
				var e=ns._sys.cloud.cont[ch.val_type].e;
				if(ch.val_type=="space"){
					return e["Prg"+ch.v].n;
				}else{
					var el=e[ch.v];
					return el[0].n;
				}
			}else return ch.v
		}
		public function next(ind:Number,lev:Number=0){
			trace("NEXT",ind,lev,channels.length);
			if(ind<channels.length){
				var ch=channels[ind];
				trace("act",ch.act);
				switch(ch.act){
					case "link":
					next(ch.ch,ch.lev);
					break;
					case "prop":
					if((ch.nested)&&(lev>0)){
						ch.i2=(ch.i2+1)%ch.e2.length;
						ch.v2=ch.e2[ch.i2];
						ch.e=ch.v2;
						ch.i=0;
					}else{
						ch.i=(ch.i+1)%ch.e.length;
					}
					ch.v=ch.e[ch.i];
					//var p={};
					//p[ch.prop]=ch.v;
					trace("VARY");
					trace(ch.e);
					trace(ch.v);
					trace(ch.prop,ch.v);
					ch.obj.compParams.setParam(ch.prop,ch.v);
					break;
					case "func":
					ch.obj[ch.func]();
					break;
				}
			}
		}
		/*
		public function next(name:String,p:Object=null){
			if(p==null) p={};
			var obj:Object=cont[name];
			obj.i=(obj.i+1)%obj.e.length;
			obj.v=obj.e[obj.i];
			log(1,"NEXT");
			ns.scene.setVal(name,obj.v,p);
		}
		*/
		

	}
}