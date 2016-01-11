package vjyourself4.three.lights{
	import flash.geom.Matrix3D;
	import away3d.cameras.Camera3D;
	import away3d.materials.lightpickers.*;
	import away3d.lights.DirectionalLight;
	import away3d.lights.PointLight;
	import away3d.containers.Scene3D;
	import flash.geom.Vector3D;
	import flash.events.MouseEvent;
	import vjyourself4.patt.colors.ColorTrans;
	import vjyourself4.media.MetaBeat;
	import vjyourself4.media.MusicMetaMixer;

	public class PointDir{
		
		public var ns:Object;

		public var stream:String;

		var beat:MetaBeat;
		var mixer:MusicMetaMixer;
		
		var lights:Array;
		var elems:Object;
		
		public var presets:Object;
		var presetName:String;
		var preset:Object;
		var colorUp:Number;
		var colorDown:Number;
		

		public function PointDir(){}
		
		
		public function init(){
			beat = ns.ns._sys.music.meta.beat;
			mixer = ns.ns._sys.music.meta.mixer;

			elems={};
			lights=[];
			
			var dl = new DirectionalLight();
			dl.direction=new Vector3D(0, 0, 1);
			dl.castsShadows = false;
			elems.dir={l:dl};
			lights.push(dl);
						
			var pl = new PointLight();
			pl.castsShadows = false;
			elems.point={l:pl};
			lights.push(pl);	
			
			setPreset("Norm");
		}

		public function setPreset(name){
			presetName=name;
			preset=presets[presetName];
			//set values
			var l=elems.dir.l;
			l.ambient=preset.dir.ambient;
			l.diffuse=preset.dir.diffuse;
			l.specular=preset.dir.specular;
			l=elems.point.l;
			l.ambient=preset.point.ambient;
			l.diffuse=preset.point.diffuse;
			l.specular=preset.point.specular;
			
			//updateColors
			updateColors();
		}
		
		public function updateColors(){
			
			var l=elems.dir.l;var p=preset.dir;
			var col=ns.context.getNext({type:"color",stream:stream,params:{ind:0}});//trace("COLOR0>"+col);
			colorUp=col;
			l.color=ColorTrans.mix(p.color_val,col,p.color/100);//trace("DirColor>"+l.color);
			l.ambientColor=ColorTrans.mix(p.ambientColor_val,col,p.ambientColor/100);//trace("DirColorAmb>"+l.ambientColor);
			//colorUp=l.color;

			l=elems.point.l;var p=preset.point;
			var col=ns.context.getNext({type:"color",stream:stream,params:{ind:1}}); //(presetName=="Dark2")?1:0}}); //trace("COLOR0>"+col);
			colorDown=col;
			l.color=ColorTrans.mix(p.color_val,col,p.color/100);//trace("PointColor>"+l.color);
			l.ambientColor=ColorTrans.mix(p.ambientColor_val,col,p.ambientColor/100);//trace("PointColorAmb>"+l.ambientColor);
			
			currCol=colorUp;
			currColInd=0;
		}
		
		var beatChs:Array=[2,1,0,0];
		var currCol:Number=0;
		var currColInd:Number=0;
		var prevBeat;
		public function onEF(e=null){
			elems.dir.l.direction=ns.me.rot.transformVector(new Vector3D(0,0,-1));
			elems.point.l.x=ns.me.pos.x;
			elems.point.l.y=ns.me.pos.y;
			elems.point.l.z=ns.me.pos.z;

			if(beat.enabled){
				var doStep:Boolean=false;
				
				switch(mixer.litInd){
					case 0:
						doStep=(prevBeat!=beat.C[1])&&(beat.C[1]==0);
						prevBeat=beat.C[1];
					break;
					case 1:
						doStep=beat.beatFrame;
					break;
					case 3:doStep=beat.beatFractions[2].beatFrame;break;
					case 2:doStep=beat.beatFractions[1].beatFrame;break;
				}
				//doStep=beat.beatFrame;
				if(doStep){
					currColInd=(currColInd+1)%2;
					currCol=(currColInd==0)?colorUp:colorDown;
					elems.dir.l.color=currCol;
					elems.dir.l.ambientColor=currCol;
					elems.point.l.color=currCol;
					elems.point.l.ambientColor=currCol;
				}
			}
		}
	}
}