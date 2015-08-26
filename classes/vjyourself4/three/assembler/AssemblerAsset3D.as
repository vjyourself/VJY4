package vjyourself4.three.assembler{
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import vjyourself4.three.*;
	import vjyourself4.three.logic.*;
	import away3d.containers.ObjectContainer3D;
	import vjyourself4.three.vef.GeometryVEF;
	import vjyourself4.three.vef.WireframeVEF;
	import flash.display.BlendMode;
	import away3d.tools.helpers.MeshHelper;
	import flash.utils.getDefinitionByName;
	import away3d.primitives.*;
	import vjyourself4.three.vef.*;

	public class AssemblerAsset3D{
		public var R:Object;
		public var input:Object;
		public var musicmeta:Object;
		public function AssemblerAsset3D(){
			TorusGeometry;
			SphereGeometry;
			CubeGeometry;
			CylinderGeometry;
			PlaneGeometry;
			
			VEFDiamond;
			VEFPlatonicSolid;
			
			CubeGeometryDouble
			
		}
		
		public function build(code:Object){
			var ret;
			var cnShort=code.cn;if(code.cn.lastIndexOf(".")>=0) cnShort=code.cn.substr(code.cn.lastIndexOf(".")+1);
			switch(cnShort){
				case "ColorMaterial":ret = new ColorMaterial(code.p.color);if(code.p.alpha!=null) ret.alpha=code.p.alpha;break;
				case "GeometryVEF":var vef=createInstance(code.vef);ret=new GeometryVEF(vef);break;
				case "WireframeVEF":var vef=createInstance(code.vef);ret=new WireframeVEF(vef);break;
				default:
				ret = createInstance(code);
				if(code.applyPosition!=null){
					var hm = new Mesh(ret,new ColorMaterial());
					MeshHelper.applyPosition(hm,code.applyPosition[0],code.applyPosition[1],code.applyPosition[2]);
				}
				if(code.applyRotation!=null){
					var hm = new Mesh(ret,new ColorMaterial());
					hm.rotationX=code.applyRotation[0];
					hm.rotationY=code.applyRotation[1];
					hm.rotationZ=code.applyRotation[2];
					MeshHelper.applyRotations(hm);
				}
				if(code.invertFaces!=null){
					var hm = new Mesh(ret,new ColorMaterial());
					MeshHelper.invertFaces(hm);
				}
			}
			return ret;
		}
		
		function createInstance(code){
			var ret;
			var cc:Class=getDefinitionByName(code.cn) as Class;
			var pc=code.pc; if(pc==null) pc=[];
			switch(pc.length){
				case 0:ret= new cc();break;
				case 1:ret= new cc(pc[0]);break;
				case 2:ret= new cc(pc[0],pc[1]);break;
				case 3:ret= new cc(pc[0],pc[1],pc[2]);break;
				case 4:ret= new cc(pc[0],pc[1],pc[2],pc[3]);break;
				case 5:ret= new cc(pc[0],pc[1],pc[2],pc[3],pc[4]);break;
				case 6:ret= new cc(pc[0],pc[1],pc[2],pc[3],pc[4],pc[5]);break;
				case 7:ret= new cc(pc[0],pc[1],pc[2],pc[3],pc[4],pc[5],pc[6]);break;
				case 8:ret= new cc(pc[0],pc[1],pc[2],pc[3],pc[4],pc[5],pc[6],pc[7]);break;
				case 9:ret= new cc(pc[0],pc[1],pc[2],pc[3],pc[4],pc[5],pc[6],pc[7],pc[8]);break;
				case 10:ret= new cc(pc[0],pc[1],pc[2],pc[3],pc[4],pc[5],pc[6],pc[7],pc[8],pc[9]);break;
			}
			return ret;
		}
	}
}