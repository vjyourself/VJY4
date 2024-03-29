﻿package vjyourself4.three.lights{
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

	public class Flashy{
		
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
		var elems:Array;
		var alpha=0;
		
		public var presets:Object;
		var presetName:String;
		var preset:Object;
		public function Flashy(){}
		
		
		public function init(){
			beat = ns.ns._sys.music.meta.beat;
			mixer = ns.ns._sys.music.meta.mixer;
			elems=[];
			lights=[];
			
			for(var i=0;i<4;i++){
				var pl = new PointLight();
				pl.castsShadows = false;
				pl.fallOff=300;
				elems.push({l:pl});
				lights.push(pl);
			}
			
			// update position
			elems[0].perc=0.05;
			elems[1].perc=0.15;
			elems[2].perc=0.25;
			elems[3].perc=0.35;

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
				var col=ns.context.getNext({type:"color",stream:stream,params:{ind:i+colorShift}});//trace("COLOR0>"+col);
				l.color=ColorTrans.mix(p.color_val,col,p.color/100);//trace("DirColor>"+l.color);
				l.ambientColor=ColorTrans.mix(p.ambientColor_val,col,p.ambientColor/100);//trace("DirColorAmb>"+l.ambientColor);
			}
		}
		var colorShift:int=0;
		var  strenghInd:int=0;

		// Slow / Norm / Fast
		var beatChs:Array=[0,2,2,2];
		public function onEF(e=null){
			var setStrength:Boolean=false;

			var update:Boolean=false;
			if(beat.enabled){
				update=beat.beatFractions[beatChs[mixer.litInd]].beatFrame;
			}else{
				alpha++;
				update=alpha>preset.delay;
			}

			if(update){
				alpha=0;
				setStrength=true;
				if(preset.shift>0){
					colorShift+=preset.shift;
					updateColors();
				}
					
			}
			
			if(setStrength) strenghInd++;
			for(var i=0;i<elems.length;i++){
				var ll=elems[i];
				var pos=ns.path.getPos((ns.path.p1-ns.path.p0)*ll.perc+ns.path.p0);
				ll.l.x=pos.x;
				ll.l.y=pos.y;
				ll.l.z=pos.z;
				if((setStrength)){
					ll.l.diffuse=(i+ strenghInd)%2;
					ll.l.specular=ll.l.diffuse;
					ll.l.ambient=ll.l.diffuse;
				}
			}
		}
	}
}