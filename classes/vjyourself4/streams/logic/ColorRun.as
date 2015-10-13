package vjyourself4.streams.logic{
	import vjyourself4.three.Path;
	import away3d.materials.ColorMaterial;
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import vjyourself4.three.assembler.AssemblerObj3D;
	import flash.geom.Vector3D;
	import flash.geom.Matrix3D;
	import vjyourself4.dson.DSON;
	import vjyourself4.dson.TransVar;
	//import vjyourself4.prgs.PRG;
	
	public class ColorRun{
		public var stream;
		var cc=0;
		var delay=10;
		public	function ColorRun(){

		}

		public function onEF(){
			cc++;
			if(cc>delay){
				cc=0;
				nextStep();
			}
		}

		function nextStep(){
			trace("NextStep");
			var e;
			var el;
			var ind=-1;
			for(var i=0;i<stream.elems.length;i++){
				el=stream.elems[i].logic;
				if(el.ColorRun==null) el.ColorRun={active:false};
				if(el.ColorRun.active) ind=i;
			}
			//put prev back
			if(ind!=-1){
				e=stream.elems[ind];
				e.obj3D.material=e.logic.ColorRun.origMat;
				e.logic.ColorRun.active=false;
				ind=(ind+1)%stream.elems.length;
			}else{
				ind=0;
			}
			trace(ind);
			//light next
			if(stream.elems.length>0){
				e=stream.elems[ind];
				e.logic.ColorRun.active=true;
				e.logic.ColorRun.origMat=e.obj3D.material;
				e.obj3D.material= new ColorMaterial(0xffffff);

			}

		}
	}
}