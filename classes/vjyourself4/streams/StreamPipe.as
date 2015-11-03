package vjyourself4.streams{
	import vjyourself4.three.Path;
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	//import vjyourself4.three.WireframePath;
	//import vjyourself4.three.GeometryPath;
	import vjyourself4.three.assembler.AssemblerObj3D;
	import flash.geom.Vector3D;
	import vjyourself4.dson.DSON;
	import vjyourself4.dson.TransVar;
	//import vjyourself4.prgs.PRG;
	
	public class StreamPipe{
		public var type:String="Pipe";
		public var cloud;
		public var musicMeta;
		public var path:Path;
		public var cont:ObjectContainer3D;
		public var assemblerObj3D:AssemblerObj3D;
		public var global:Object;
		public var contextHandler:Object;
		public var ctrlMovement:Object;
		
		public var viewPos:Number=0;
		
		public var lengthPos:Number=0;
		public var lengthRun:Number=0;
		public var elems:Array;
		
		
		public var dsonPrg:Object;
		public var prgPipe:Object; //old name
		public var prg:Object; //new name
		public var id:String="";
		public var name:String="";
		public var elemLength:Number=200;
		public var radius:Number=80;
		public var segCirc:Number=12;
		
		public var state:String="";
		public var globalPRG:Object;
		public var parity:int=0;
	
		public var context:Object={texture:"A",color:"A"};
		public var transVar:TransVar;
		public var trans:Object={
			scale:1,
			scale0:1,
			scale1:1,
			texDistro:0,
			texShift:0,
			texZoom:1,
			texZoomY:1
			//rot:0,
			//rotX:0,
			//rotY:0,
			//rotZ:0
		};
		public function StreamPipe(){
			transVar = new TransVar();
			transVar.NS = trans;
			transVar.init();
		}
		
		public function init(){
			if(contextHandler==null) contextHandler={};
			elems=[];
			state="Running";
			if(prgPipe!=null) dsonPrg = new DSON(prgPipe,{cloud:cloud,context:contextHandler});
			else dsonPrg=new DSON(prg,{cloud:cloud,context:contextHandler});
			
		}
		
		//if path's own coordinate space (p0,p1) is shifted
		public function updateLength(d:Number){
			lengthPos+=d;
			for(var i=0;i<elems.length;i++)elems[i].lengthPos+=d;
		}

		//if world's whole coord space shifted ( resetToOrigo )
		public function coordShift(shift:Vector3D){
			for(var i=0;i<elems.length;i++){
				var elm=elems[i];
				if(elm.wf!=null){
						elm.wf.x+=shift.x;
						elm.wf.y+=shift.y;
						elm.wf.z+=shift.z;
				}
				if(elm.mesh!=null){
						elm.mesh.x+=shift.x;
						elm.mesh.y+=shift.y;
						elm.mesh.z+=shift.z;
				}
			}
		}
		
		// ADD > ANIMATE > REMOVE
		public function onEF(ev:Object){
			transVar.update();
			var ff=ev.delta/(1000/60);
			//trace("streamPipe "+elems.length+" : "+path.length+" ? "+lengthPos+"+"+elemLength);
			
			//***** ADD NEW ELEM *************************************************************************
			if((path.p1>=lengthPos+elemLength)&&(state=="Running")){
				//new elem holder 
				parity=(parity+1)%2;
				var elm={lengthPos:lengthPos+elemLength,parity:parity};
				
				//***** create next Prg *****************************************************
				var prg=dsonPrg.getNext();
				//global modifiers
				if(prg.global!=null) global.setGlobals(prg.global);
				//add path to Prg
				var planeCount=(prg.planeCount==null)?Math.floor(elemLength/100):prg.planeCount;
				var pathPos=path.getPath(lengthPos,lengthPos+elemLength,elemLength/planeCount);
				var pathRot=path.getPathRot(lengthPos,lengthPos+elemLength,elemLength/planeCount);
				var pos0=pathPos[0].clone();
				for(var i=0;i<pathPos.length;i++) pathPos[i].decrementBy(pos0);
				prg.path={pos:pathPos,rot:pathRot}

				//***** Prg -> Obj **********************************************************
				var obj=assemblerObj3D.build(prg);
				elm.obj=obj;
				var obj3D=obj.obj3D;

				if(obj3D.mesh!=null){
					obj3D.mesh.x=pos0.x;
					obj3D.mesh.y=pos0.y;
					obj3D.mesh.z=pos0.z;
					cont.addChild(obj3D.mesh);
					elm.mesh=obj3D.mesh;
				}
				if(obj3D.wf!=null) {
					obj3D.wf.x=pos0.x;
					obj3D.wf.y=pos0.y;
					obj3D.wf.z=pos0.z;
					cont.addChild(obj3D.wf);
					elm.wf=obj3D.wf
				}
				elm.locZ=pathRot[0].transformVector(new Vector3D(0,0,1))
				
				//add new elem to the elems list
				elems.push(elm);

				//increment stream's length
				lengthPos+=elemLength;
				lengthRun+=elemLength;
			}

			// ******** ANI + REMOVE ******************************************************************
			for(var i=0;i<elems.length;i++){
				var elm=elems[i];
				
				// TRANS TEX
				if(elm.obj.res.geom!=null) if(elm.obj.res.geom.onEF!=null){		
						elm.obj.res.geom.zoomVal=trans.texZoom;
						elm.obj.res.geom.zoomYVal=trans.texZoomY;
						elm.obj.res.geom.shiftAniVal=trans.texShift;
						elm.obj.res.geom.distroVal=trans.texDistro;
						elm.obj.res.geom.onEF();
				}
				

				// TRANS SCALE
				var tscale=trans.scale0;
			 	if(elm.parity==1) tscale=trans.scale1;
			 	tscale*=trans.scale;
				//if(tscale!=1){
					if(tscale<0.05){
						if(elm.mesh!=null){elm.mesh.visible=false;}
						if(elm.wf!=null){elm.wf.visible=false;}
					}else{
						if(elm.mesh!=null){
							elm.mesh.visible=true;
							elm.mesh.scaleX=tscale;
							elm.mesh.scaleY=tscale;
							elm.mesh.scaleZ=tscale;
						}
						if(elm.wf!=null){
							elm.wf.visible=true;
							elm.wf.scaleX=tscale;
							elm.wf.scaleY=tscale;
							elm.wf.scaleZ=tscale;
						}
					}
				//}
				
				
				if(elm.lengthPos<path.p0){
						if(elm.wf!=null){
							cont.removeChild(elm.wf);
							elm.wf.dispose();
						}
						if(elm.mesh!=null){
							cont.removeChild(elm.mesh);
							elm.mesh.dispose();
						}
						elems.splice(i,1);
					i--;
				}else{
					if(elm.obj.logicActive) elm.obj.logic.onEF();
				}
			}
		if( (state=="Decomposing") && (elems.length==0))state="Finished";

		
		}
		
		//****** UPDATE Context Changes *********************************************************************************
		public function updateColors(){
			if(state=="Running"){
			for(var i=0;i<elems.length;i++){
				var elm=elems[i];
				if(elm.wf!=null){
					elm.wf.color=contextHandler.getNext({type:"color",stream:"A",params:{}});
				}
			}
		}
		}

		public function updateTex(str:String){
			if((state=="Running")&&(str==context.texture)){
			for(var i=0;i<elems.length;i++){
				var elm=elems[i];
				if(elm.mesh!=null){
					elm.mesh.material=cloud.R3D.cont.mat[contextHandler.getNext({type:"texture",stream:str,params:{}})];
				}
			}
			}
		}
		
		//****** DECOMPOSE / DESTROY  the whole stream ***************************************************************
		public function decompose(){
			state="Decomposing";
		}

		public function destroy(){
			for(var i=0;i<elems.length;i++){
				var elm=elems[i];
		
				if(elm.wf!=null){
					cont.removeChild(elm.wf);
					elm.wf.dispose();
				}
				if(elm.mesh!=null){
					cont.removeChild(elm.mesh);
					elm.mesh.dispose();
				}
				elems[i]=null;
			}
			elems=[];
			cont=null;
			cloud=null;
			path=null;
			cont=null;
			assemblerObj3D=null;
			global=null;
			contextHandler=null;
			ctrlMovement=null;
			state="Finished";
		}
	}
}
