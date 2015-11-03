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
	
	public class StreamStatic{
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
		public var contStatic:ObjectContainer3D;
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
		
		
		public function StreamStatic(){

		}
		
		public function init(){
			contStatic=new ObjectContainer3D();
			cont.addChild(contStatic);
			elems=[];
			state="Running";
			prgObj=createDSON(prgObj);
			var objM=prgObj.getNext();
			var obj = assemblerObj3D.build(objM);
			contStatic.addChild(obj.obj3D);
			elems.push(obj);
		}
		
		function createDSON(obj):DSON{
			var ret=obj;
			if(!((obj is DSON) )){
			   ret= new DSON(obj,{cloud:cloud});
			}
			return ret;
		}
		
		//not in use
		public function updateLength(d:Number){lengthPos+=d;}
	
		public function coordShift(shift:Vector3D){
			
		}
		

		
		public function onEF(e:Object=null){
			contStatic.x=me.pos.x;
			contStatic.y=me.pos.y;
			contStatic.z=me.pos.z;
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