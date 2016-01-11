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

	public class TriRot{
		
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
		public function TriRot(){}
		
		
		public function init(){
			beat = ns.ns._sys.music.meta.beat;
			mixer = ns.ns._sys.music.meta.mixer;

			elems={};
			lights=[];
			
			var dl = new DirectionalLight();
			dl.direction=new Vector3D(0, 0, 1);
			dl.castsShadows = false;
			elems.a={l:dl};
			lights.push(dl);
						
			dl = new DirectionalLight();
			dl.direction=new Vector3D(0, 0, 1);
			dl.castsShadows = false;
			elems.b={l:dl};
			lights.push(dl);
			
			dl = new DirectionalLight();
			dl.direction=new Vector3D(0, 0, 1);
			dl.castsShadows = false;
			elems.c={l:dl};
			lights.push(dl);

			dl = new DirectionalLight();
			dl.direction=new Vector3D(0, 0, 1);
			dl.castsShadows = false;
			elems.d={l:dl};
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
		
		public function updateColors(){
			var l;var p;var col;var ii=0;
			for(var i in elems){
				if(i!="d"){
					l=elems[i].l;var p=preset[i];
					col=ns.context.getNext({type:"color",stream:stream,params:{ind:ii}});
					l.color=ColorTrans.mix(p.color_val,col,p.color/100);//trace("DirColor>"+l.color);
					l.ambientColor=ColorTrans.mix(p.ambientColor_val,col,p.ambientColor/100);//trace("DirColorAmb>"+l.ambientColor);
					ii++;
				}
			}
			
		}
		
		// Slow / Norm / Fast
		var beatChs:Array=["Saw8_1","Saw4_1","Saw2_1","Saw1_1"];
		public function onEF(e=null){
			if(beat.enabled){
				alpha=Math.PI*2*beat.A[beatChs[mixer.litInd]].val;
			}else{
				alpha+=preset.speed;
			}
			elems.a.l.direction=ns.me.rot.transformVector(new Vector3D(Math.sin(alpha),Math.cos(alpha),0.5*Math.sin(alpha)));
			elems.b.l.direction=ns.me.rot.transformVector(new Vector3D(Math.sin(alpha+Math.PI*2/3),Math.cos(alpha+Math.PI*2/3),0.5*Math.sin(alpha+Math.PI*2/3)));
			elems.c.l.direction=ns.me.rot.transformVector(new Vector3D(Math.sin(alpha+Math.PI*2/3*2),Math.cos(alpha+Math.PI*2/3*2),0.5*Math.sin(alpha+Math.PI*2/3*2)));
			elems.d.l.direction=ns.me.rot.transformVector(new Vector3D(0,0,1));
		
		}
	}
}