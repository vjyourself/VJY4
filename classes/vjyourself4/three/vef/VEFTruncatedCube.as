package vjyourself4.three.vef{
	public class VEFTruncatedCube{
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
		
		var dimX:Number=0;
		var dimY:Number=0;
		var dimZ:Number=0;
		var dimCut:Number=0;
		
		public var verts:Array;
		public var edges:Array;
		public var faces:Array;
		public var uvs:Array;
		
		function VEFTruncatedCube(dimX_,dimY_,dimZ_,dimCut_){
			dimX=dimX_;
			dimY=dimY_;
			dimZ=dimX_;
			dimCut=dimCut_;
			generateGeometry();
		}
		
		function generateGeometry(){
				var dX=dimX/2;
				var dY=dimY/2;
				var dZ=dimZ/2;
				var dXC=dX-dimCut;
				var dYC=dY-dimCut;
				var dZC=dZ-dimCut;
				
				verts=[
					  {x:-dXC,		y:dY,		z:dZC},
					  {x:dXC,		y:dY,		z:dZC},
					  {x:dXC,		y:dY,		z:-dZC},
					  {x:-dXC,		y:dY,		z:-dZC},
					  
					  {x:-dX,		y:dYC,		z:dZ},
					  {x:dX,		y:dYC,		z:dZ},
					  {x:dX,		y:dYC,		z:-dZ},
					  {x:-dX,		y:dYC,		z:-dZ},
					  
					  {x:-dX,		y:-dYC,		z:dZ},
					  {x:dX,		y:-dYC,		z:dZ},
					  {x:dX,		y:-dYC,		z:-dZ},
					  {x:-dX,		y:-dYC,		z:-dZ},
						
					  {x:-dXC,		y:-dY,		z:dZC},
					  {x:dXC,		y:-dY,		z:dZC},
					  {x:dXC,		y:-dY,		z:-dZC},
					  {x:-dXC,		y:-dY,		z:-dZC}
					  
					  ];
				edges=[0,1, 1,2, 2,3, 3,0,
					   4,5, 5,6, 6,7, 7,4,
					   0,4, 1,5, 2,6, 3,7,
					   
					   4,8, 5,9, 6,10, 7,11,
					   
					    8, 9,  9,10, 10,11, 11,8,
					   12,13, 13,14, 14,15, 15,12,
					    8,12,  9,13, 10,14, 11,15
					   ];
				
				faces=[
					   //top
					   2,1,0, 3,2,0,
					   //top cut faces
					   1,5,0, 5,4,0,
					   1,2,6, 1,6,5,
					   3,7,6, 3,6,2,
					   4,3,0, 4,7,3,
					   //sides
					   5,9,8, 5,8,4,
					   6,10,9, 6,9,5,
					   7,11,10, 7,10,6,
					   4,8,11, 4,11,7,
					   //bottom cut faces
					   8,9,13, 8,13,12,
					   9,10,14, 9,14,13,
					   10,11,15, 10,15,14,
					   11,8,12, 11,12,15,
					   //bottom
					   12,14,15, 12,13,14
					   ];
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