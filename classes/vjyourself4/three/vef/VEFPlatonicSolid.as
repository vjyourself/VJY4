package vjyourself4.three.vef{
	public class VEFPlatonicSolid{
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
		
		var edge:Number=0;
		var height:Number=0;
		var radius:Number=0;
		
		public var verts:Array;
		public var edges:Array;
		public var faces:Array;
		public var uvs:Array;
		
		function VEFPlatonicSolid(n:String,p:Object){
			name=n;
			params=p;
			generateGeometry();
		}
		
		function generateGeometry(){
			switch(name){
				case "Tetrahedron":
				if(params.edge!=null){edge=params.edge;height=Math.sin(Math.PI/3)*edge;radius=height/3*2;}
				if(params.height!=null){height=params.height;radius=height/3*2;edge=height/Math.sin(Math.PI/3);}
				if(params.radius!=null){radius=params.radius;height=radius/2*3;edge=height/Math.sin(Math.PI/3);}
				verts=[
					  {x:0,			y:height*2/3,		z:0},
					  {x:edge/2,	y:-height/3,		z:-height/3},
					  {x:-edge/2,	y:-height/3,		z:-height/3},
					  {x:0,			y:-height/3,		z:height*2/3}
					  ];
				edges=[0,1,
					   0,2,
					   0,3,
					   1,2,
					   2,3,
					   3,1
					   ];
				faces=[ 0,1,2,
					 0,2,3,
					 0,3,1,
					 2,1,3];
				break;
				
				case "Octahedron":
				if(params.edge!=null){edge=params.edge;radius=Math.sqrt(2)*edge/2;height=radius*2;}
				if(params.height!=null){height=params.height;radius=height/2;edge=radius/Math.sqrt(2)*2;}
				if(params.radius!=null){radius=params.radius;height=radius*2;edge=radius/Math.sqrt(2)*2;}
				verts=[
					  {x:0,			y:height/2,		z:0},
					  {x:edge/2,	y:0,		z:-edge/2},
					  {x:-edge/2,	y:0,		z:-edge/2},
					  {x:-edge/2,	y:0,		z:edge/2},
					  {x:edge/2,	y:0,		z:edge/2},
					  {x:0,			y:-height/2,		z:0}
					  ];
				edges=[1,2,
					   2,3,
					   3,4,
					   4,1,
					   3,1,
					   2,4,
					   0,1,
					   0,2,
					   0,3,
					   0,4,
					   5,1,
					   5,2,
					   5,3,
					   5,4,
					   0,5];
				
				faces=[0,1,2,
					   0,2,3,
					   0,3,4,
					   0,4,1,
					   5,2,1,
					   5,3,2,
					   5,4,3,
					   5,1,4];
				break;
				
				case "Icosahedron":
				var gr:Number=0;
				if(params.edge!=null){edge=params.edge;gr= (1 + Math.sqrt(5)) / 2*edge;}
				trace("gr:"+gr+" edge:"+edge);
				verts=[
					   //XY
					   {x:-gr/2,y:edge/2,z:0},
					   {x:gr/2,y:edge/2,z:0},
					   {x:gr/2,y:-edge/2,z:0},
					   {x:-gr/2,y:-edge/2,z:0},
					   //XZ
					   {x:edge/2,y:0,z:-gr/2},
					   {x:-edge/2,y:0,z:-gr/2},
					   {x:-edge/2,y:0,z:gr/2},
					   {x:edge/2,y:0,z:gr/2},
					   //YZ
					   {x:0,y:gr/2,z:-edge/2},
					   {x:0,y:gr/2,z:edge/2},
					   {x:0,y:-gr/2,z:edge/2},
					   {x:0,y:-gr/2,z:-edge/2}
					   ];
				edges=[
					   //upper pentagon 5 * triangles
					   8,4,
					   4,5,
					   5,8,
					   8,1,
					   1,4,
					   8,9,
					   9,1,
					   8,0,
					   0,9,
					   5,0,
					   
					   //stripe 10* triangles
					   5,11,
					   4,11,
					   4,2,
					   2,11,
					   1,2,
					   1,7,
					   7,2,
					   9,7,
					   9,6,
					   6,7,
					   0,6,
					   0,3,
					   3,6,
					   5,3,
					   11,3,
					  
					   //bottom pentagon 5*triangle (just central lines)
					   10,3,
					   10,11,
					   10,2,
					   10,7,
					   10,6
					   ];
					   
				faces=[
					   8,4,5,
					   8,1,4,
					   8,9,1,
					   8,0,9,
					   8,5,0,
					   
					   5,4,11,
					   4,2,11,
					   4,1,2,
					   1,7,2,
					   1,9,7,
					   9,6,7,
					   9,0,6,
					   0,3,6,
					   0,5,3,
					   5,11,3,
					   
					   10,11,2,
					   10,2,7,
					   10,7,6,
					   10,6,3,
					   10,3,11
					   ];
				break;
			}
		}
		
	}
}