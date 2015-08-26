package vjyourself4.three.vef{
	public class VEFDiamond{
		public var name:String="";
		var params:Object;
		/*
		Tetrahedron
		4 * regular triangles
		
		Hexahedron(Cube)
		6 * squares
		
		Octahedron
		8 * regular triangles
		
		Dodecahedron
		12 * regular pentagon
		
		Icosahedron
		20 * regular triangles
		*/
		
		var r0:Number;
		var h0:Number;
		var r1:Number;
		var h1:Number;
		var segs:Number;
		
		public var verts:Array;
		public var edges:Array;
		public var faces:Array;
		public var uvs:Array;
		
		public var geom:GeometryVEF;
		
		public function getGeometry():GeometryVEF{if(geom==null) geom = new GeometryVEF(this);return geom;}
		public function cloneGeometry():GeometryVEF{return  new GeometryVEF(this);}

	
		
		function VEFDiamond(r0_,h0_,r1_,h1_,segs_){
			r0=r0_;
			h0=h0_;
			r1=r1_;
			h1=h1_;
			
			segs=segs_;
			generateGeometry();
		}
		
		function generateGeometry(){
				verts=[];
				var vInd=0;
				edges=[];
				var eInd=0;
				faces=[];
				var fInd=0;
				
				var aa=0;
				//Top
				addVert(0,h0,0);
				for(var i=0;i<segs;i++){
					aa=i/segs*Math.PI*2;
					addVert(Math.sin(aa)*r0,h0,Math.cos(aa)*r0);
					
					//addEdge(0,1+i);
					if(i<segs-1) addEdge(1+i,1+i+1);
					else addEdge(1+i,1);
					
					if(i<segs-1) addFace(0,1+i,1+i+1);
					else addFace(0,1+i,1);
				}
				
				//Middle
				for(var i=0;i<segs;i++){
					aa=(i+0.5)/segs*Math.PI*2;
					addVert(Math.sin(aa)*r1,0,Math.cos(aa)*r1);
					addEdge(1+i,1+segs+i);
					if(i<segs-1) addEdge(1+i+1,1+segs+i);
					else addEdge(1,1+segs+i);
					
					if(i<segs-1) addEdge(1+segs+i,1+segs+i+1);
					else addEdge(1+segs+i,1+segs);
					
					if(i<segs-1) addFace(1+i+1,1+segs+i,1+segs+i+1);
					else addFace(1,1+segs+i,1+segs);
					
					if(i<segs-1) addFace(1+i,1+segs+i,1+i+1);
					else addFace(1+i,1+segs+i,1);
				}
				
				//Bottom
				for(var i=0;i<segs;i++){
					addEdge(1+segs+i,1+segs+segs);
					if(i<segs-1) addFace(1+segs+i,1+segs+segs,1+segs+i+1);
					else addFace(1+segs+i,1+segs+segs,1+segs);
				}
				addVert(0,-h1,0);
				
		}
		
		function addVert(x,y,z){
			verts.push({x:x,y:y,z:z});
		}
		function addEdge(i0,i1){
			edges.push(i0);
			edges.push(i1);
		}
		function addFace(v0,v1,v2){
			faces.push(v0);
			faces.push(v1);
			faces.push(v2);
		}
		public function flipFaces(){
			for(var i=0;i<faces.length/3;i++){
				var t=faces[i*3];
				faces[i*3]=faces[i*3+2];
				faces[i*3+2]=t;
			}
		}
		
	}
}