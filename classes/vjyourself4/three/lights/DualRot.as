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

	public class DualRot{
		
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
		var colorUp:Number;
		var colorDown:Number;
		public function DualRot(){}
		
		
		public function init(){
			beat = ns.ns._sys.music.meta.beat;
			mixer = ns.ns._sys.music.meta.mixer;
			elems={};
			lights=[];
			
			var dl = new DirectionalLight();
			dl.direction=new Vector3D(0, 0, 1);
			dl.castsShadows = false;
			elems.up={l:dl};
			lights.push(dl);
						
			dl = new DirectionalLight();
			dl.direction=new Vector3D(0, 0, 1);
			dl.castsShadows = false;
			elems.down={l:dl};
			lights.push(dl);
			
			setPreset("Norm");
		}

		public function setPreset(name){
			presetName=name;
			preset=presets[presetName];
			//set values
			var l=elems.up.l;
			l.ambient=preset.up.ambient;
			l.diffuse=preset.up.diffuse;
			l.specular=preset.up.specular;
			l=elems.down.l;
			l.ambient=preset.down.ambient;
			l.diffuse=preset.down.diffuse;
			l.specular=preset.down.specular;
			
			//updateColors
			updateColors();
		}
		
		public function updateColors(){
			var l=elems.up.l;var p=preset.up;
			var col=ns.context.getNext({type:"color",stream:stream,params:{ind:0}});//trace("COLOR0>"+col);
			l.color=ColorTrans.mix(p.color_val,col,p.color/100);//trace("DirColor>"+l.color);
			colorUp=l.color;
			l.ambientColor=ColorTrans.mix(p.ambientColor_val,col,p.ambientColor/100);//trace("DirColorAmb>"+l.ambientColor);
			
			l=elems.down.l;var p=preset.down;
			var col=ns.context.getNext({type:"color",stream:stream,params:{ind:1}});
			l.color=ColorTrans.mix(p.color_val,col,p.color/100);//trace("PointColor>"+l.color);
			colorDown=l.color;
			l.ambientColor=ColorTrans.mix(p.ambientColor_val,col,p.ambientColor/100);//trace("PointColorAmb>"+l.ambientColor);
		}
		
		// Slow / Norm / Fast
		var beatChs:Array=["Saw8_1","Saw4_1","Saw2_1","Saw1_1"];
		public function onEF(e=null){
			//trace(beat.enabled);
			if(beat.enabled){
				alpha=Math.PI*2*beat.A[beatChs[mixer.litInd]].val;
			}else{
				alpha+=preset.speed;
			}
		
			elems.up.l.direction=ns.me.rot.transformVector(new Vector3D(Math.sin(alpha),Math.cos(alpha),0.5*Math.sin(alpha)));
			elems.down.l.direction=ns.me.rot.transformVector(new Vector3D(Math.sin(-alpha),Math.cos(-alpha),0.5*Math.sin(alpha+Math.PI)));

		}
	}
}