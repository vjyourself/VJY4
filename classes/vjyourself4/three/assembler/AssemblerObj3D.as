package vjyourself4.three.assembler{
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import vjyourself4.three.*;
	import vjyourself4.three.logic.*;
	import away3d.containers.ObjectContainer3D;
	import vjyourself4.three.vef.GeometryVEF;
	import vjyourself4.three.vef.WireframeVEF;
	import flash.display.BlendMode;
	import com.adobe.serialization.json.JSONEncoder;
	import vjyourself4.cloud.Cloud;
	import vjyourself4.dson.ColorType;

	public class AssemblerObj3D{
		public var cloud:Cloud;
		public var context:Object;
		public var R3Dcont:Object;
		public var input:Object;
		public var musicmeta:Object;
		public function AssemblerObj3D(){
	
		}
		
		/***********************************************
		OUTPUT STRUCT (what we need to dispose)
		> OBJ :: SimpleObj
		obj3d -> Mesh

		elem.obj3D.dispose();
		
		>OBJ :: MultiObjs
		obj3d -> ObjectContainer3D
		> PIPE
		obj3d -> {}
		obj3d.wf -> Wireframe
		obj3d.mesh -> Mesh

		elem.wf.dispose();
		elem.mesh.dispose();


		--> res ... all the stuff must be disposed must come here
		 - generated geometry
		 - own color material
		*******************************************************/
		var params:Object;
		public function build(code:Object,p:Object=null){
			if(p==null) params={};
			else params=p;
			R3Dcont=cloud.R3D.cont;
			var obj3D;
			var res={};
			var dispose=[];
			var obj={res:res,logicActive:false,dispose:dispose};
			if(code.cn==null) code.cn="SimpleObj";
			
			switch(code.cn){
				
				case "WFPipeBasic":
				case "WFPipeLegacy":
				obj3D={};
				var poss=code.path.pos;
				var pos0=poss[0].clone();
				for(var i=0;i<poss.length;i++) poss[i].decrementBy(pos0);
				//trace("PARAMS: "+new JSONEncoder(code.params).getString());
				if(code.wf.color!=null) {
					code.wf.color=ColorType.toNumber(code.wf.color);
					//temp rechanel...
					if(context!=null) code.wf.color=context.getNext({type:"color",stream:"A"});
					//code.wf.color=0;
				}
				var wf;
				switch(code.cn){
					case "WFPipeBasic": wf= new WireframePipeBasic(poss,code.path.rot,code.params,code.wf);break;
					case "WFPipeLegacy": wf= new WireframePipeLegacy(poss,code.path.rot,code.params,code.wf);break;
				}
				wf.x=pos0.x;
				wf.y=pos0.y;
				wf.z=pos0.z;
				obj3D.wf=wf;
				obj.obj3D=obj3D;
				addLogic(obj,code);
				break;

				case "MeshPipeBasic":
				case "MeshPipeLegacy":
				obj3D={};
				var poss=code.path.pos;
				var pos0=poss[0].clone();
				for(var i=0;i<poss.length;i++) poss[i].decrementBy(pos0);
				
				switch(code.cn){
					case "MeshPipeLegacy":var geom = new GeometryPipeLegacy(poss,code.path.rot,code.params);break;
					case "MeshPipeBasic":var geom = new GeometryPipeBasic(poss,code.path.rot,code.params);break;
				}
				var mat = createMat(code.mesh.mat,res,"mat",dispose);
				var mesh = new Mesh(geom,mat);
				mesh.x=pos0.x;
				mesh.y=pos0.y;
				mesh.z=pos0.z;
				obj3D.mesh=mesh;
				res.geom=geom;
				res.mat=mat;
				obj.obj3D=obj3D;
				addLogic(obj,code);
				break;

				/***** PathPipe *****************************************************************************/
				case "PathPipe":
				obj3D={};
				var poss=code.path.pos;
				var pos0=poss[0].clone();
				for(var i=0;i<poss.length;i++) poss[i].decrementBy(pos0);
				
				if((code.wf!=null)&&((code.wf_visible==null)||(code.wf_visible==true))){
					//trace("PARAMS: "+new JSONEncoder(code.params).getString());
					if(code.wf.color!=null){
						code.wf.color=ColorType.toNumber(code.wf.color);
						//temp rechanel...
					code.wf.color=context.getNext({type:"color",stream:"A"});
					//code.wf.color=0;
				}
					var wf = new WireframePipeLegacy(poss,code.path.rot,code.params,code.wf);
					wf.x=pos0.x;
					wf.y=pos0.y;
					wf.z=pos0.z;
					obj3D.wf=wf;
				}
				if( (code.mesh!=null) && ((code.mesh_visible==null)||(code.mesh_visible==true)) ){
					//relative
					/*
					var pos0=code.path.pos[0].clone();
					var poss=[];
					for(var i=0;i<code.path.pos.length;i++) poss.push( code.path.pos[i].subtract(pos0) );
					*/
					
					
					var geom = new GeometryPipeLegacy(poss,code.path.rot,code.params);
					var mat = createMat(code.mesh.mat,res,"mat",dispose);
					//if(code.mesh.matt!=null ) mat = R3Dcont.mat[code.mesh.matt];
					//if(code.mesh.mat!=null ) mat = R3Dcont.mat[code.mesh.mat];
					//trace("********************************** "+code.mesh.mat+" : "+R3Dcont.mat[code.mesh.mat]);
					var mesh = new Mesh(geom,mat);
					mesh.x=pos0.x;
					mesh.y=pos0.y;
					mesh.z=pos0.z;
					obj3D.mesh=mesh;
					res.geom=geom;
					res.mat=mat;
				}
				obj.obj3D=obj3D;
				addLogic(obj,code);
				break;
				
				/****** SimpleObj ******************************************************************************/
				/*
					geom
					mat
					trans
					logic
				*/

				case "SimpleObj":
				//for(var i in code) if((i!="matt")&&(i!="geom")) mesh[i]=code[i];
				var geom=R3Dcont.geom[code.geom];
				var mat = createMat(code.mat,{},"a",dispose);
				var mesh = new Mesh(geom,mat);
				if(code.trans!=null){
					if(code.trans.scale!=null){
						var ss=code.trans.scale;
						mesh.scaleX=ss;
						mesh.scaleY=ss;
						mesh.scaleZ=ss;
					}
					for(var i in code.trans){
						if(i!="scale") mesh[i]=code.trans[i];
					}
					
				}
				obj.obj3D=mesh;
				res.obj3D=obj.obj3D;
				addLogic(obj,code);
				break;
				
				/***** MultiObjs **************************************************************************/
				case "MultiObjs":
				obj3D=new ObjectContainer3D();
				res.obj3D=obj3D;
				//Sort Codes
				var itemsRes=[];
				var itemsMesh=[];
				for(var i in code){
					if((i!="logic")&&(i!="cn")&&(i!="trans")){
						var subcode=code[i];
						var cn="Mesh";
						if(subcode.cn!=null) cn=subcode.cn;
						if(cn=="Mesh") itemsMesh.push({n:i,code:subcode});
						else itemsRes.push({n:i,cn:cn,code:subcode});
					}
				}
				
				//Resources
				for(var i=0;i<itemsRes.length;i++){
					var subcode=itemsRes[i].code;
					var name=itemsRes[i].n;
					var cn=itemsRes[i].cn;
					switch(cn){
						case "ColorMaterial":
						trace("Create Matterial: "+name);
						var mat = new ColorMaterial(subcode.color);
						if(subcode.alpha!=null) mat.alpha=subcode.alpha;
						mat.lightPicker = R3Dcont.lightPicker;
						res[name]=mat;
						break;
					}
				}
				
				//Meshes
				for(var i=0;i<itemsMesh.length;i++){
					var subcode=itemsMesh[i].code;
					var name=itemsMesh[i].n;
					if(subcode.matt!=null)subcode.mat=subcode.matt;
					// vef, mesh or wf
					var type="mesh";
					if(subcode.vef!=null) type="vef";
					
					switch(type){
						
						case "mesh":
						var geom=R3Dcont.geom[subcode.geom];
						var matt = createMat(subcode.mat,res,name,dispose);
						
						var mesh = new Mesh(geom,matt);
						if(subcode.trans!=null){
							if(subcode.trans.scale!=null){
								var ss=subcode.trans.scale;
								mesh.scaleX=ss;
								mesh.scaleY=ss;
								mesh.scaleZ=ss;
							}
						}
						if(subcode.trans!=null) applyTrans(mesh,subcode.trans);
						res[name]=mesh;
						obj3D.addChild(mesh);
						dispose.push(mesh);
						break;
						
						case "vef":
						var objVEF=new ObjectContainer3D();
						obj3D.addChild(objVEF);
						if(subcode.mat!=null){
							var mat = createMat(subcode.mat,res,name,dispose);
							var geom = R3Dcont.geom[subcode.vef].getGeometry();
							var mesh = new Mesh(geom,mat);
							objVEF.addChild(mesh);
						}
						if(subcode.wf!=null){
							var col=0xffffff;if(subcode.wf.color!=null) col=subcode.wf.color;
							//temp rechanel...
							col=context.getNext({type:"color",stream:"A"});
							
							var thickness=1;if(subcode.wf.thickness!=null) thickness=subcode.wf.thickness;
							var wf= new WireframeVEF(R3Dcont.geom[subcode.vef],col,thickness);
							objVEF.addChild(wf);
							dispose.push(wf);
						}
						if(subcode.trans!=null) applyTrans(objVEF,subcode.trans);
						if(subcode.p!=null) for(var pi in subcode.p) objVEF[pi]=subcode.p[pi];
						res[name]=objVEF;
						break;
					}
							
				}
				if(code.trans!=null) applyTrans(obj3D,code.trans);
				
				obj.obj3D=obj3D;
				dispose.push(obj3D);
				addLogic(obj,code);
				break;
			}
			return obj;
		}
		
		function applyTrans(obj3D,trans){
			if(trans.scale!=null){
						var ss=trans.scale;
						obj3D.scaleX=ss;
						obj3D.scaleY=ss;
						obj3D.scaleZ=ss;
			}
			for(var i in trans){
						if(i!="scale") obj3D[i]=trans[i];
			}
					
		}
		function createMat(code,res,name,dispose){
			var mat;
			if(code is String){
				var resPath=code.split(".");
				if(resPath.length==1) mat=R3Dcont.mat[resPath[0]];
				else mat=res[resPath[1]];
			}else {
				if(code.color!=null) mat = new ColorMaterial(ColorType.toNumber(code.color));
				if(code.alpha!=null) mat.alpha=code.alpha;
				if(code.blend!=null) mat.blendMode=BlendMode[code.blend];
				mat.lightPicker = cloud.R3D.globalLightPicker;
				res[name+"_matt"]=mat;
				dispose.push(mat);
			}
			if(params.lp!=null) mat.lightPicker=params.lp; 
			return mat;
		}
		/*
		
				if(code.mat!=null) mat=R3Dcont.mat[code.mat];
				if(code.matColor!=null){
					if(code.matColor is Number){
						mat = new ColorMaterial(code.matColor);
					}else{
						mat = new ColorMaterial(code.matColor.col);
						mat.alpha=code.matColor.alpha;
					}
					mat.lightPicker = R3Dcont.lightPicker;
				}
		*/
		/*
		function createMesh(code){
			var geom=R[code.geom];
				var matt;
				if(code.matt!=null) matt=R[code.matt];
				if(code.mattColor!=null){
					matt = new ColorMaterial(code.mattColor);
					matt.lightPicker = R["lightPicker"];
				}
				var mesh = new Mesh(geom,matt);
				return mesh;
		}*/
		function addLogic(obj,code){
			if(code.logic!=null) {
					var logic = new Logic();
					logic.input=input;
					logic.musicmeta=musicmeta;
					logic.obj=obj;
					logic.code=code.logic;
					logic.init();
					obj.logicActive=true;
					obj.logic=logic;
			}
		}
	}
}