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

	public class TriDir{
		
		public var ns:Object;
		public var input;
		public var cloud;
		public var path;
		public var me;
		public var cont:Scene3D;
		var beat:MetaBeat;
		var mixer:MusicMetaMixer;

		public var stream:String;
		public var params:Object;
		
		var lights:Array;
		var elems:Object;
		var alpha=0;
		
		public var presets:Object;
		var presetName:String;
		var preset:Object;
		public function TriDir(){
			
		}
		
		
		public function init(){
			beat = ns.ns._sys.music.meta.beat;
			mixer = ns.ns._sys.music.meta.mixer;
			
			elems={};
			lights=[];
			
			var dl = new DirectionalLight();
			dl.direction=new Vector3D(1, 0, 0);
			dl.castsShadows = false;
			elems.a={l:dl};
			lights.push(dl);
						
			dl = new DirectionalLight();
			dl.direction=new Vector3D(-1, 0, 0);
			dl.castsShadows = false;
			elems.b={l:dl};
			lights.push(dl);
			
			dl = new DirectionalLight();
			dl.direction=new Vector3D(0, 0, -1);
			dl.castsShadows = false;
			elems.c={l:dl};
			lights.push(dl);
			
			setPreset("Norm");
		}

		public function setPreset(name){
			presetName=name;
			preset=presets[presetName];
			//set values
			var l;var p;
			for(var i in elems){
				l=elems[i].l;
				p=preset[i];
				l.ambient=p.ambient;
				l.diffuse=p.diffuse;
				l.specular=p.specular;
			}
			
			//updateColors
			updateColors();
		}
		
		var colors:Array=[];
		var colorsAmb:Array=[];
		
		public function updateColors(){
			var l;var p;var col;var ii=0;
			for(var i in elems){
				l=elems[i].l;var p=preset[i];
				col=ns.context.getNext({type:"color",stream:stream,params:{ind:ii}});
				l.color=ColorTrans.mix(p.color_val,col,p.color/100);//trace("DirColor>"+l.color);
				colors[ii]=l.color;
				l.ambientColor=ColorTrans.mix(p.ambientColor_val,col,p.ambientColor/100);//trace("DirColorAmb>"+l.ambientColor);
				colorsAmb[ii]=l.ambientColor;
				ii++;
			}
			colInd=0;
			
		}
		
		var beatChs:Array=[2,1,0,0];
		var colInd:Number=0;
		var prevBeat;
		public function onEF(e=null){
			alpha+=preset.speed;
			elems.a.l.direction=ns.me.rot.transformVector(new Vector3D(1,0,0));
			elems.b.l.direction=ns.me.rot.transformVector(new Vector3D(-1,0,0));
			elems.c.l.direction=ns.me.rot.transformVector(new Vector3D(0,0,1));

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
					colInd=(colInd+1)%colors.length;
					elems.a.l.color=colors[(colInd+0)%colors.length];
					elems.b.l.color=colors[(colInd+1)%colors.length];
					elems.c.l.color=colors[(colInd+2)%colors.length];

					elems.a.l.ambientColor=colorsAmb[(colInd+0)%colors.length];
					elems.b.l.ambientColor=colorsAmb[(colInd+1)%colors.length];
					elems.c.l.ambientColor=colorsAmb[(colInd+2)%colors.length];
				}
			}
		}
	}
}