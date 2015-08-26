package vjyourself4.three{
	import flash.display.Sprite;
	import flash.events.Event;
	import vjyourself2.wave.WaveFollow;
	import flash.utils.getDefinitionByName;
	import flash.geom.Vector3D;
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	public class ObjSphere{
		
		public static var classMeta={
			
			cn:"vjyourself4.comp.CompCraft",
			name:"CanvasMirror",categories:"Composition",
			desc:"",
			//////////////////////////////////////////////
			params:{
				cn:{t:"Array"},
				dimX:{def:960},
				dimY:{def:540}
			},
			system:{enterframe:{},input:{},musicMeta:{}},
			needs:{},
			//////////////////////////////////////////////
			vis:[{n:"vis",origo:"topleft",cn:"flash.display.Sprite"}],
			viscont:[],
			data:{},
			functions:{},
			events:{}	
		}
		
		public var vis:ObjectContainer3D;
		public var musicMeta:Object;
		public var input:Object;
		
		public var geom;
		public var material;
		public var r=600;
		public var rMin=600;
		public var rGap=200;
		public var rMax=1200;
		public var numY=4;
		public var elems:Array;
		public var objScale=1;
		
		public function ObjSphere(){}
		
		public function init(){
			vis = new ObjectContainer3D();
			generateSpheres(r,geom,material);
			/*
			switch(input.def){
				case "mkb":
				
				break;
			}*/
		}
		function generateSpheres(r,geom,material){
			elems=[];
			for(var i=0;i<=numY;i++){
				var numRing=3*i;if(numRing==0)numRing=1;
				var aRing=Math.PI/2*(i/numY);
				var rRing=r*Math.sin(aRing);
				var yRing=r*Math.cos(aRing);
				for(var ii=0;ii<numRing;ii++){
					var a=Math.PI*2/numRing*ii;
					var m = new Mesh(geom,material);
					m.z=rRing*Math.sin(a);
					m.x=rRing*Math.cos(a);
					m.y=yRing;
					//m.scaleY=-1;
					m.rotate(new Vector3D(0,1,0),-a/Math.PI*180+90);
					//var fv=Matrix3DUtils.getForward(view.camera.transform);
					m.rotate(new Vector3D(1,0,0),-(numY-i)*90/numY);//Matrix3DUtils.getForward(m.transform),45);

					vis.addChild(m);
					elems.push(m);
				}
			}
			for(var i=0;i<numY;i++){
				var numRing=3*i;if(numRing==0)numRing=1;
				var aRing=Math.PI/2*(i/numY);
				var rRing=r*Math.sin(aRing);
				var yRing=r*Math.cos(aRing);
				for(var ii=0;ii<numRing;ii++){
					var a=Math.PI*2/numRing*ii;
					var m = new Mesh(geom,material);
					m.z=rRing*Math.sin(a);
					m.x=rRing*Math.cos(a);
					m.y=-yRing;
					m.rotate(new Vector3D(0,1,0),-a/Math.PI*180+90);
					m.rotate(new Vector3D(1,0,0),(numY-i)*90/numY);//Matrix3DUtils.getForward(m.transform),45);
					vis.addChild(m);
					elems.push(m);
				}
			}
		}
		function update(){
			
			var iii=0;
			var alf=0.999;
			if(r<rMin+rGap) alf=(r-rMin)/rGap; 
			if(r>rMax-rGap) alf=(rMax-r)/rGap; 
			if(alf<0) alf=0;if(alf>0.999) alf=0.999;
			material.alpha=alf;
			for(var i=0;i<=numY;i++){
				var numRing=3*i;if(numRing==0)numRing=1;
				var aRing=Math.PI/2*(i/numY);
				var rRing=r*Math.sin(aRing);
				var yRing=r*Math.cos(aRing);
				for(var ii=0;ii<numRing;ii++){
					var a=Math.PI*2/numRing*ii;
					var m = elems[iii];iii++;
					m.z=rRing*Math.sin(a);
					m.x=rRing*Math.cos(a);
					m.y=yRing;
					m.scaleX=1+objScale/3;
					m.scaleY=1+objScale/3;
					m.scaleZ=1+objScale/3;
					m.rotate(new Vector3D(0,0,1),(objScale));
					//m.rotate(new Vector3D(0,1,0),-a/Math.PI*180+90);
					//var fv=Matrix3DUtils.getForward(view.camera.transform);
					//m.rotate(new Vector3D(1,0,0),-(numY-i)*90/numY);//Matrix3DUtils.getForward(m.transform),45);
				}
			}
			for(var i=0;i<numY;i++){
				var numRing=3*i;if(numRing==0)numRing=1;
				var aRing=Math.PI/2*(i/numY);
				var rRing=r*Math.sin(aRing);
				var yRing=r*Math.cos(aRing);
				for(var ii=0;ii<numRing;ii++){
					var a=Math.PI*2/numRing*ii;
					var m = elems[iii];iii++;
					m.z=rRing*Math.sin(a);
					m.x=rRing*Math.cos(a);
					m.y=-yRing;
					m.scaleX=1+objScale/3;
					m.scaleY=1+objScale/3;
					m.scaleZ=1+objScale/3;
					m.rotate(new Vector3D(0,0,1),(objScale));
					//m.rotate(new Vector3D(1,0,0),(numY-i)*90/numY);//Matrix3DUtils.getForward(m.transform),45);
					//cont.addChild(m);
				}
			}
		}
		public function onEF(e=null){
			update();
			/*
			switch(input.def){
				case "gamepad":
				var s0=input.gamepadManager.getState(0);
				var stickX=0;
				var stickY=0;
				switch(inputPos){
					case "right":
					stickX=s0.RightStick.x;
					stickY=s0.RightStick.y;
					break;
					case "left":
					stickX=s0.LeftStick.x;
					stickY=s0.LeftStick.y;
					break;
				}*/
		}
	}
}