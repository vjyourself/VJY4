package vjyourself4.streams{
	import vjyourself4.three.Path;
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import vjyourself4.three.assembler.AssemblerObj3D;
	import flash.geom.Vector3D;
	import flash.geom.Matrix3D;
	import vjyourself4.dson.DSON;
	import vjyourself4.dson.TransVar;
	//import vjyourself4.prgs.PRG;
	import vjyourself4.streams.logic.*;
	
	public class StreamObjs{
		public var type:String="Objs";
		public var cloud;
		public var lengthPos:Number=0;
		public var lengthRun:Number=0;
		public var elems:Array;
		public var path:Path;
		public var cont:ObjectContainer3D;
		public var global:Object;
		public var contextHandler:Object;
		public var inputVJY:Object;
		
		public var prgObj:Object;
		public var prgPos:Object;
		public var prg:Object;
		var dsonPrg:DSON;
		
		public var id:String="";
		public var name:String="";
		public var gap:Number=0;
		
		public var rotate:Boolean=false;
		public var rotateZ:Number =0;
		public var rotateRnd:Boolean=false;
		public var catchit:Boolean=false;
		public var firstElem:Boolean=true;
		public var calculateFullRot:Boolean=true;
		
		var parity:int=0;
		public var context:Object={texture:"A",color:"A"};
		public var transVar:TransVar;
		public var trans:Object={
			scale:1,
			scale0:1,
			scale1:1,
			rot:0,
			rotX:0,
			rotY:0,
			rotZ:0
		};
		public var state:String="";
		
		public var assemblerObj3D:AssemblerObj3D;

		public var logic;
		var logicList:Array=[];

		public function StreamObjs(){
			transVar = new TransVar();
			transVar.NS = trans;
			transVar.init();
		}
		
		public function init(){
			if(contextHandler==null) contextHandler={};
			elems=[];
			state="Running";
			if(prgObj!=null) dsonPrg = new DSON(prgObj,{cloud:cloud,context:contextHandler});
			else dsonPrg = new DSON(prg,{cloud:cloud,context:contextHandler});
		
			//var ll= new ColorRun();
			//ll.stream=this;
			//logicList.push(ll);
		}
		
		//if path's own coordinate space (p0,p1) is shifted
		public function updateLength(d:Number){
			lengthPos+=d;
			for(var i=0;i<elems.length;i++)elems[i].lengthPos+=d;
		}

		//if world's whole coord space shifted ( resetToOrigo )
		public function coordShift(shift:Vector3D){
			for(var i=0;i<elems.length;i++){
				var el=elems[i];
				el.obj3D.x+=shift.x;
				el.obj3D.y+=shift.y;
				el.obj3D.z+=shift.z;
			}
		}
		
		
		public function onEF(e:Object=null){
			transVar.update();
			//ADD NEXT
			if((path.p1>=lengthPos+gap)&&(state=="Running")){
				lengthPos+=gap;
				lengthRun+=gap;
				
				var pathPos=path.getPos(lengthPos);
				var pathRot=path.getRot(lengthPos);
			//	trace("ROT "+pathRot);
				//var vv=pathRot.transformVector(new Vector3D(1,0,0));
				//trace(vv.x+","+vv.y+","+vv.z);
				
				var objM=dsonPrg.getNext();
				if(objM.gap!=null) gap=objM.gap;
				var obj = assemblerObj3D.build(objM);
				
				var transM=new Matrix3D();
				transM.append(obj.obj3D.transform);
				transM.append(pathRot);
				transM.appendTranslation(pathPos.x,pathPos.y,pathPos.z);
				obj.obj3D.transform = transM;
				cont.addChild(obj.obj3D);
				if(obj.logicActive) obj.logic.init();

				parity=(parity+1)%2;
				var el={
					logic:{},
					pos:pathPos,
					sX:obj.obj3D.scaleX,
					sY:obj.obj3D.scaleY,
					sZ:obj.obj3D.scaleZ,
					obj3D:obj.obj3D,
					obj:obj,
					lengthPos:lengthPos,
					parity:parity,
					catchitAniState:0 // obsolete
				}
				//caluculate animated params
				//global overwrite :: OBSOLETE
				if(rotate){
					var rotSpeed=2;
					if(rotateRnd) rotSpeed=(Math.random()-0.5)*6;
					objM.rot=rotSpeed;
				}
				if(rotateZ>0) objM.rotZ=rotateZ;
				//process objM rot/rotZ/rotX/rotY
				if((objM.rot!=null)||(calculateFullRot)){
					el.rot_bool=true;
					el.rot=0;if(objM.rot!=null) el.rot=objM.rot;
				}else el.rot_bool=false;
				
				if((objM.rotX!=null)||(calculateFullRot)){
					el.rotX_bool=true;
					el.rotX=0;if(objM.rotX!=null) el.rotX=objM.rotX;
					el.locX=pathRot.transformVector(new Vector3D(1,0,0));
				}else el.rotX_bool=false;
				
				if((objM.rotY!=null)||(calculateFullRot)){
					el.rotY_bool=true;
					el.rotY=0;if(objM.rotY!=null) el.rotY=objM.rotY;
					el.locY=pathRot.transformVector(new Vector3D(0,1,0));
				}else el.rotY_bool=false;

				if((objM.rotZ!=null)||(calculateFullRot)){
					el.rotZ_bool=true;
					el.rotZ=0;if(objM.rotZ!=null) el.rotZ=objM.rotZ;
					el.locZ=pathRot.transformVector(new Vector3D(0,0,1));
				}else el.rotZ_bool=false;
			
				
				
				//var vecZ=obj.obj3D.forwardVector;
				elems.push(el);
			}
			//animate / remove elems
			for(var i=0;i<elems.length;i++){
				var el=elems[i];

				// TRANS SCALE
				var tscale=trans.scale0;
			 	if(el.parity==1) tscale=trans.scale1;
			 	tscale*=trans.scale;
				//if(tscale!=1){
					if(tscale<0.05){
						el.obj3D.visible=false;
					}else{
						el.obj3D.visible=true;
						el.obj3D.scaleX=el.sX*tscale;
						el.obj3D.scaleY=el.sY*tscale;
						el.obj3D.scaleZ=el.sZ*tscale;
					}
				//}
					
				if(el.obj.logicActive) el.obj.logic.onEF();

				if(el.rot_bool) el.obj3D.rotationY+=el.rot+trans.rot;
				if(trans.rot!=0) el.obj3D.rotationY+=trans.rot;

				var t;var v;
				if(el.rotX_bool){
					v=el.rotX+trans.rotX;
					if(v!=0){
						t=el.obj3D.transform.clone();
						t.appendRotation(v,el.locX,t.position);
						el.obj3D.transform=t;
					}
				}
				if(el.rotY_bool){
					v=el.rotY+trans.rotY;
					if(v!=0){
						t=el.obj3D.transform.clone();
						t.appendRotation(v,el.locY,t.position);
						el.obj3D.transform=t;
					}
				}
				if(el.rotZ_bool){
					v=el.rotZ+trans.rotZ;
					if(v!=0){
						t=el.obj3D.transform.clone();
						t.appendRotation(v,el.locZ,t.position);
						el.obj3D.transform=t;
					}
				}
				/*
				if(catchit){
					if((el.lengthPos<lengthPos+80)&&(el.catchitAniState==0)){
						el.catchitAniState=1;
						el.catchitAni={cc:0,length:60};
						trace("CATCH IT!!!");
					}
				}
				if(el.catchitAniState==1){
					el.catchitAni.cc++;
					var perc=el.catchitAni.cc/el.catchitAni.length;
					if(el.catchitAni.cc>=el.catchitAni.length){
						perc=1;
						el.catchitAniState=2;
					}
					var ss=1+Math.sin(Math.PI/2*perc)*5;
					el.obj3D.scaleX=ss;
					el.obj3D.scaleY=ss;
					el.obj3D.scaleZ=ss;
				}*/
				if(el.lengthPos<path.p0){
					cont.removeChild(el.obj3D);
					for(var di=0;di<el.obj.dispose.length;di++){ 
						try {
							el.obj.dispose[di].dispose();
						}catch ( error : Error ){
 							trace('DISPOSE error: '+error);
						} 
						
						//trace("Happily disposed "+el.obj.dispose[di]);
						el.obj.dispose[di]=null;
					}
					el.obj.dispose=null;
					el.obj.obj3D=null;
					elems.splice(i,1);
					i--;
				}
			}
			for(var i=0;i<logicList.length;i++) logicList[i].onEF();

			if( (state=="Decomposing") && (elems.length==0))state="Finished";
		}
		
		public function updateColors(){}
		public function updateTex(str:String){
			if((state=="Running")&&(str==context.texture)){
			for(var i=0;i<elems.length;i++){
				var elm=elems[i];
				if(elm.obj3D is away3d.entities.Mesh)elm.obj3D.material=cloud.R3D.cont.mat[contextHandler.getNext({type:"texture",stream:str,params:{}})];
			}
		}
		}
		public function decompose(){
			state="Decomposing";
		}
		public function destroy(){
			for(var i=0;i<elems.length;i++){
				var el=elems[i];
				cont.removeChild(el.obj3D);
				el.obj3D.dispose();
				elems[i]=null;
			
			}
			elems=[];
			cloud=null;
			path=null;
			
			cont=null;
			global=null;
			contextHandler=null;
			inputVJY=null;
			dsonPrg=null;
		
			state="Finished";
		}
	}
}