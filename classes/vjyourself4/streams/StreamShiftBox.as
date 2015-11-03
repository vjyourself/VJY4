package vjyourself4.streams{
	import vjyourself4.three.Path;
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import vjyourself4.three.assembler.AssemblerObj3D;
	import flash.geom.Vector3D;
	import flash.geom.Matrix3D;
	import vjyourself4.dson.DSON;
	//import vjyourself4.prgs.PRG;
	import vjyourself4.games.Me;
	
	public class StreamShiftBox{
		//not used
		public var path;
		public var ctrlPath;
		public var context:Object;
		public var ctrlMovement:Object;
		public var lengthPos:Number=0;
		public var viewPos:Number=0;
		
		//connect
		public var cloud;
		public var me:Me;
		public var cont:ObjectContainer3D;
		public var global:Object;
		public var assemblerObj3D:AssemblerObj3D;
		
		//params
		public var name:String="";
		public var dim:Number=1000;
		public var gap:Number=100;
		public var spread:String="random";
		public var density:Number=100;
		public var prgObj:Object;
		
		/*public var rotate:Boolean=false;
		public var rotateZ:Number =0;
		public var rotateRnd:Boolean=false;
		public var catchit:Boolean=false;
		public var firstElem:Boolean=true;
		*/
		
		public var elems:Array;
		public var boxPos:Vector3D;
		public var state:String="";
		
		
		public function StreamShiftBox(){

		}
		
		public function init(){
			elems=[];
			state="Running";
			prgObj=createDSON(prgObj);
			boxPos=me.pos.clone();
			fillBox(boxPos,dim,dim,dim);
		}
		
		function createDSON(obj):DSON{
			var ret=obj;
			if(!((obj is DSON))){
			   ret= new DSON(obj,{cloud:cloud});
			}
			return ret;
		}
		
		//not in use
		public function updateLength(d:Number){lengthPos+=d;}
	
		public function coordShift(shift:Vector3D){
			boxPos.x+=shift.x;
			boxPos.y+=shift.y;
			boxPos.z+=shift.z;
			
			for(var i=0;i<elems.length;i++){
				var el=elems[i];
				el.obj3D.x+=shift.x;
				el.obj3D.y+=shift.y;
				el.obj3D.z+=shift.z;
			}
		}
		
		public function fillBox(origo,dimX,dimY,dimZ){
			trace("fillBox "+dimX+","+dimY+","+dimZ);
			var num=dimX*dimY*dimZ/1000/1000/1000*density;
			trace("+"+num);
			var x=0;
			var y=0;
			var z=0;
			var objM:Object;
			var obj;
			for(var i=0;i<num;i++){
				x=origo.x+(Math.random()*2-1)*dimX;
				y=origo.y+(Math.random()*2-1)*dimY;
				z=origo.z+(Math.random()*2-1)*dimZ;
				objM=prgObj.getNext();
				//trace(i+","+objM);
				obj = assemblerObj3D.build(objM);
				obj.obj3D.x=x;obj.obj3D.y=y;obj.obj3D.z=z;
				cont.addChild(obj.obj3D);
				elems.push(obj);
			}
		}
		public function clearLim(type,lim){
			trace("clearLim "+type+","+lim);
			var obj;
			switch(type){
				case "z1":for(var i=0;i<elems.length;i++){obj=elems[i];if(obj.obj3D.z<lim){cont.removeChild(obj.obj3D);obj.obj3D.dispose();elems.splice(i,1);i--;}}break;
				case "z-1":for(var i=0;i<elems.length;i++){obj=elems[i];if(obj.obj3D.z>lim){cont.removeChild(obj.obj3D);obj.obj3D.dispose();elems.splice(i,1);i--;}}break;
				case "y1":for(var i=0;i<elems.length;i++){obj=elems[i];if(obj.obj3D.y<lim){cont.removeChild(obj.obj3D);obj.obj3D.dispose();elems.splice(i,1);i--;}}break;
				case "y-1":for(var i=0;i<elems.length;i++){obj=elems[i];if(obj.obj3D.y>lim){cont.removeChild(obj.obj3D);obj.obj3D.dispose();elems.splice(i,1);i--;}}break;
				case "x1":for(var i=0;i<elems.length;i++){obj=elems[i];if(obj.obj3D.x<lim){cont.removeChild(obj.obj3D);obj.obj3D.dispose();elems.splice(i,1);i--;}}break;
				case "x-1":for(var i=0;i<elems.length;i++){obj=elems[i];if(obj.obj3D.x>lim){cont.removeChild(obj.obj3D);obj.obj3D.dispose();elems.splice(i,1);i--;}}break;
			}
			trace("all:"+elems.length);
		}
		public function onEF(e:Object=null){
			//trace("onEF "+name);
			//check gap
			var dx=me.pos.x-boxPos.x;var sx=(dx<0)?-1:1;
			var dy=me.pos.y-boxPos.y;var sy=(dy<0)?-1:1;
			var dz=me.pos.z-boxPos.z;var sz=(dz<0)?-1:1;
			if(Math.abs(dx)>gap){
				fillBox(new Vector3D(boxPos.x+sx*dim/2+dx/2,boxPos.y,boxPos.z),Math.abs(dx),dim,dim);
				//clearBox(new Vector3D(boxPos.x-sx*dim/2-dx/2,boxPos.y,boxPos.z),Math.abs(dx),dim,dim);
				clearLim("x"+sx,me.pos.x-sx*dim/2);
				boxPos.x=me.pos.x;}
			if(Math.abs(dy)>gap){
				fillBox(new Vector3D(boxPos.x,boxPos.y+sy*dim/2+dy/2,boxPos.z),dim,Math.abs(dy),dim);
				//clearBox(new Vector3D(boxPos.x,boxPos.y-sy*dim/2-dy/2,boxPos.z),dim,Math.abs(dy),dim);
				clearLim("y"+sy,me.pos.y-sy*dim/2);
				boxPos.y=me.pos.y;}
			if(Math.abs(dz)>gap){
				fillBox(new Vector3D(boxPos.x,boxPos.y,boxPos.z+sz*dim/2+dz/2),dim,dim,Math.abs(dz));
				clearLim("z"+sz,me.pos.z-sz*dim/2);
				boxPos.z=me.pos.z;}
			
			/*
			if(((path.length>=lengthPos+gap)||(firstElem))&&(state=="Running")){
				if(firstElem){
					firstElem=false;
				}else{
					lengthPos+=gap;
					lengthRun+=gap;
				}
				
				var pathPos=path.getPos(lengthPos);
				var pathRot=path.getRot(lengthPos);
				
				var objM=prgObj.getNext();
				//var objPos=prgPos.getNext();
				var obj = assemblerObj3D.build(objM);
				
				var trans=new Matrix3D();
				trans.append(obj.obj3D.transform);
				
				trans.append(pathRot);
				trans.appendTranslation(pathPos.x,pathPos.y,pathPos.z);
				obj.obj3D.transform = trans;
				trace("cont:"+cont);
				cont.addChild(obj.obj3D);
				var rotSpeed=1;
				if(rotateRnd){
					rotSpeed=Math.random()-0.5;
				}
				elems.push({rotSpeed:rotSpeed,obj3D:obj.obj3D,obj:obj,lengthPos:lengthPos,catchitAniState:0,locZ:pathRot.transformVector(new Vector3D(0,0,1))});
			}
			//animate / remove elems
			for(var i=0;i<elems.length;i++){
				var el=elems[i];
				if(el.obj.logicActive) el.obj.logic.onEF();
				if(rotate) el.obj3D.rotationY+=el.rotSpeed;
				if(rotateZ>0) el.obj3D.rotate(new Vector3D(0,0,1),rotateZ);
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
				}
				if(el.lengthPos<0){
					cont.removeChild(el.obj3D);
					el.obj3D.dispose();
					elems.splice(i,1);
					i--;
				}
			}
			if( (state=="Decomposing") && (elems.length==0))state="Finished";
			*/
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
			state="Finished";
		}
	}
}