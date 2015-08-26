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

	public class TriDir{
		
		public var ns:Object;
		public var input;
		public var cloud;
		public var path;
		public var me;
		public var cont:Scene3D;

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
		
		public function updateColors(){
			var l;var p;var col;var ii=0;
			for(var i in elems){
				l=elems[i].l;var p=preset[i];
				col=ns.context.getNext({type:"color",stream:stream,params:{ind:ii}});
				l.color=ColorTrans.mix(p.color_val,col,p.color/100);//trace("DirColor>"+l.color);
				l.ambientColor=ColorTrans.mix(p.ambientColor_val,col,p.ambientColor/100);//trace("DirColorAmb>"+l.ambientColor);
				ii++;
			}
			
		}
		
		public function onEF(e=null){
			alpha+=preset.speed;
			elems.a.l.direction=ns.me.rot.transformVector(new Vector3D(1,0,0));
			elems.b.l.direction=ns.me.rot.transformVector(new Vector3D(-1,0,0));
			elems.c.l.direction=ns.me.rot.transformVector(new Vector3D(0,0,1));
		}
	}
}