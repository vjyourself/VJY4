package vjyourself4.games.lights{
	import flash.geom.Matrix3D;
	import away3d.cameras.Camera3D;
	import away3d.materials.lightpickers.*;
	import away3d.lights.DirectionalLight;
	import away3d.lights.PointLight;
	import away3d.containers.Scene3D;
	import flash.geom.Vector3D;
	import flash.events.MouseEvent;
	import vjyourself4.patt.colors.ColorTrans;

	public class Running{
		
		public var ns:Object;
		public var input;
		public var cloud;
		public var path;
		public var me;
		public var cont:Scene3D;

		public var params:Object;
		
		var lights:Array;
		var elems:Array;
		var alpha=0;
		
		public var presets:Object;
		var presetName:String;
		var preset:Object;
		public function Running(){}
		
		
		public function init(){
			
			elems=[];
			lights=[];
			
			for(var i=0;i<4;i++){
				var pl = new PointLight();
				pl.castsShadows = false;
				pl.fallOff=200;
				elems.push({l:pl});
				lights.push(pl);
			}
			
			setPreset("Norm");
		}

		public function setPreset(name){
			presetName=name;
			preset=presets[presetName];
			//set values
			
			for(var i=0;i<elems.length;i++){
				var l=elems[i].l;
				l.ambient=preset.light.ambient;
				l.diffuse=preset.light.diffuse;
				l.specular=preset.light.specular;
			}
			//updateColors
			updateColors();
		}
		
		public function updateColors(){
			var p=preset.light;
			for(var i=0;i<elems.length;i++){
				var l=elems[i].l;
				var col=ns.context.getNext({type:"color",stream:"Lights",params:{ind:i}});//trace("COLOR0>"+col);
				l.color=ColorTrans.mix(p.color_val,col,p.color/100);//trace("DirColor>"+l.color);
				l.ambientColor=ColorTrans.mix(p.ambientColor_val,col,p.ambientColor/100);//trace("DirColorAmb>"+l.ambientColor);
			}
		}
		
		public function onEF(e=null){
			alpha+=preset.speed;
			if(alpha>100) alpha=0;
					elems[0].perc=((alpha+preset.spots[0])%100)/100;
					elems[1].perc=((alpha+preset.spots[1])%100)/100;
					elems[2].perc=((alpha+preset.spots[2])%100)/100;
					elems[3].perc=((alpha+preset.spots[3])%100)/100;
					for(var i=0;i<elems.length;i++){
						var ll=elems[i];
						var pos=ns.path.getPos(ns.path.length*ll.perc);
						ll.l.x=pos.x;
						ll.l.y=pos.y;
						ll.l.z=pos.z;
					}
			
		}
	}
}