package vjyourself4.three{
	import flash.display.Sprite;
	import flash.events.Event;
	import vjyourself2.wave.WaveFollow;
	import flash.utils.getDefinitionByName;
	import flash.geom.Vector3D;
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import away3d.entities.SegmentSet;
	import away3d.primitives.LineSegment;
	public class DrawWaveLines{
		
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
		
		
		public var col=0xffffff;
		var lines;
		var linesNum=250;
		var lineSegments:Array;
		public var width=800;
		
		public function DrawWaveLines(){}
		
		public function init(){
			vis = new ObjectContainer3D();
			
		}
		public function buildUp(){
				if(lines!=null) vis.removeChild(lines);
				lines = new SegmentSet();
				vis.addChild(lines);
				/*
				var ss=0.3+iii/lineSetsNum*3;
				lines.y=iii/lineSetsNum*100;
				lines.scaleX=ss;
				lines.scaleY=ss;
				lines.scaleZ=ss;*/
				//contLines=[];
			
				// Add lots of lines to the segment set
				var i:uint = 0;
				var vx:Number = 0;
				var vy:Number = 0;
				var vz:Number = 0;
				var radius=0;
				var prevV:Vector3D=new Vector3D(0,0,0);
				var newV:Vector3D;
				
				for (i = 0; i < linesNum; i++)
				{
					//vx = Math.sin(i/linesNum*Math.PI*2) * radius;
					//vy = Math.cos(i/linesNum*Math.PI*2) * radius;
					
					newV = new Vector3D(width/linesNum*(i-linesNum/2),musicMeta.waveData[i]*100,0);
			
					var lineSegment = new LineSegment(prevV,newV,col,col,2);
					//lineSegments.push(lineSegment);
					lines.addSegment(lineSegment);
					prevV=newV;
				}
			
		}
		
		public function onEF(e=null){
			buildUp();
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