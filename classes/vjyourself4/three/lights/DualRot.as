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

	public class DualRot{
		
		public var ns:Object;
		public var input;
		public var cloud;
		public var path;
		public var me;
		public var cont:Scene3D;
		var rhythm;

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
			rhythm = ns.ns._sys.music.meta.rhythm;
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
		
		public function onEF(e=null){
			//alpha+=preset.speed/20;
			alpha=Math.PI/2;
			//elems.up.l.direction=ns.me.rot.transformVector(new Vector3D(Math.sin(alpha),Math.cos(alpha),0));
			//elems.down.l.direction=ns.me.rot.transformVector(new Vector3D(Math.sin(-alpha),Math.cos(-alpha),0));
		
			elems.up.l.direction=ns.me.rot.transformVector(new Vector3D(Math.sin(alpha),Math.cos(alpha),0));
			elems.down.l.direction=ns.me.rot.transformVector(new Vector3D(Math.sin(-alpha),Math.cos(-alpha),0));
			if(rhythm!=null){
			if(rhythm.counter[1]==0){
				elems.up.l.color=0;
				elems.down.l.color=colorDown;
			}else{
				elems.up.l.color=colorUp;
				elems.down.l.color=0;
			}
			}
		}
	}
}