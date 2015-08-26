package vjyourself4.games.lights{
	import flash.geom.Matrix3D;
	import away3d.cameras.Camera3D;
	import away3d.materials.lightpickers.*;
	import away3d.lights.DirectionalLight;
	import away3d.lights.PointLight;
	import away3d.containers.Scene3D;
	import flash.geom.Vector3D;
	import flash.events.MouseEvent;
	import vjyourself4.patt.colors.ColorScale;
	import flash.events.Event;

	public class Lights{
		
		public var ns:Object;
		public var input;
		public var cloud;
		public var path;
		public var me;
		public var cont:Scene3D;

		public var params:Object;
		
		
		var effects:Object;
		var effect:Object;
		var effectName:String="";
		
		public var lp:StaticLightPicker;
		var blackout:Boolean=false;
		var lightsBlackout:Array;
		
		public var colorScale:ColorScale;
		
		
		public function Lights(){}
		
		
		public function init(){
			
			cloud=ns.sys.cloud;
			cont=ns.view.scene;
			path = ns.GP.path;
			me = ns.me;

			colorScale=new ColorScale();
			colorScale.events.addEventListener(Event.CHANGE,colorsCHANGE,0,0,1);
			
			effects={};
			effects.PointDir = new PointDir();
			effects.PointDir.ns=this;
			effects.PointDir.init();
			
			effects.DualRot = new DualRot();
			effects.DualRot.ns=this;
			effects.DualRot.init();
			
			lp = new StaticLightPicker([]);
			cloud.R3D.applyLightPicker(lp);
			
			lightsBlackout=[new PointLight()];
			lightsBlackout[0].color=0;
			lightsBlackout[0].ambientColor=0;
			
			
			//setLights("PointDir","Norm","Static",[0xffffff]);
		}

		public function colorsCHANGE(e){
			if(effect!=null) effect.updateColors();
		}
		public function setLights(eff,effPres,colorMode,colors=null){
			trace("SETLIGHTS> "+eff+effPres+colorMode+" "+(colors?colors.toString():"null"));
			effectName=eff;
			effect=effects[effectName];
			updateLpLights();
			effect.setPreset(effPres);
			colorScale.setColors(colorMode,colors);
		}
		
		public function setBlackout(vv){
			trace("Set blackout "+vv);
			if(blackout&&!vv){
				blackout=false;
				updateLpLights();
			}
			if(!blackout&&vv){
				blackout=true;
				lp.lights=lightsBlackout;
			}
		}
		public function updateLpLights(){if((!blackout)&&(effect!=null)) lp.lights=effect.lights;}
		
		public function onEF(e=null){
			if(effect!=null) effect.onEF();
		}
	}
}

/*

			
			if(lightsInd==6){
				
			}
			
			

			if(lightsInd==7){
					alpha+=0.5;
					if(alpha>100) alpha=0;
					lights[0].perc=alpha/100;
					lights[1].perc=((alpha+5)%100)/100;
					lights[2].perc=((alpha+50)%100)/100;
					lights[3].perc=((alpha+55)%100)/100;
					for(var i=0;i<lights.length;i++){
						var ll=lights[i];
						var pos=path.getPos(path.length*ll.perc);
						ll.l.x=pos.x;
						ll.l.y=pos.y;
						ll.l.z=pos.z;
					}
			}
		*/
/*
	switch(lightsInd){
				case 0:
				lp.lights=[dirLight,pointLight];
				lightsAni=false;
   				dirLight.castsShadows = false;
				dirLight.color = 0xFFffff;
				dirLight.ambientColor = 0xFFffff;
				dirLight.ambient = 0;
				dirLight.diffuse = 0;
				dirLight.specular =0;
				pointLight.color=0xffffff;
				pointLight.ambientColor=0xffffff;
				pointLight.diffuse =0;
				pointLight.specular =0;
				pointLight.ambient =1;
				break;
				case 1:
				lp.lights=[dirLight,pointLight];
				lightsAni=false;
   				dirLight.castsShadows = false;
				dirLight.color = 0xFFffff;
				dirLight.ambientColor = 0xFFffff;
				dirLight.ambient = 0;
				dirLight.diffuse = 0.3;
				dirLight.specular =0.7;
				pointLight.color=0xffffff;
				pointLight.ambientColor=0xffffff;
				pointLight.diffuse =0;
				pointLight.specular =0;
				pointLight.ambient =0.5;
				break;
				case 2:
				lp.lights=[dirLight,pointLight];
				lightsAni=false;
   				dirLight.castsShadows = false;
				dirLight.color = 0xFF0000;
				dirLight.ambientColor = 0xFF6666;
				dirLight.ambient = 0.1;
				dirLight.diffuse = 0.6;
				dirLight.specular =1;
				pointLight.color=0xffffff;
				pointLight.ambientColor=0xffffff;
				pointLight.diffuse =0;
				pointLight.specular =0;
				pointLight.ambient =0;
				break;
				case 3:
				lp.lights=[dirLight,pointLight];
				lightsAni=false;
   				dirLight.castsShadows = false;
				dirLight.color = 0x0000FF;
				dirLight.ambientColor = 0xFF6666;
				dirLight.ambient = 0.25;
				dirLight.diffuse = 0.7;
				dirLight.specular =1;
				pointLight.color=0xffffff;
				pointLight.ambientColor=0xffffff;
				pointLight.diffuse =0;
				pointLight.specular =0;
				pointLight.ambient =0;
				break;
				case 4:
				lp.lights=[dirLight,pointLight];
				lightsAni=false;
   				dirLight.castsShadows = false;
				dirLight.color = 0xFFFFFF;
				dirLight.ambientColor = 0xFF6666;
				dirLight.ambient = 0;
				dirLight.diffuse = 0.4;
				dirLight.specular =1;
				pointLight.color=0xffffff;
				pointLight.ambientColor=0xffffff;
				pointLight.diffuse =0;
				pointLight.specular =0;
				pointLight.ambient =0;
				break;
				case 5:
				lp.lights=[dirLight,pointLight];
				lightsAni=true;
   				dirLight.castsShadows = false;
				dirLight.color = 0xFFffff;
				dirLight.ambientColor = 0xFFffff;
				dirLight.ambient = 0;
				dirLight.diffuse = 0.3;
				dirLight.specular =0.7;
				pointLight.color=0xffffff;
				pointLight.ambientColor=0xffffff;
				pointLight.diffuse =0;
				pointLight.specular =0;
				pointLight.ambient =1;
				break;
				case 6:
				lp.lights=[dirLightUp,dirLightDown];
				break;
				
				case 7:
				lights=[];
				var ll=[];
				
				lp.lights=ll;
				
				dirLight.castsShadows = false;
				dirLight.color = 0x000000;
				dirLight.ambientColor = 0x000000;
				dirLight.ambient = 0;
				dirLight.diffuse = 0;
				dirLight.specular =0;
				break;
			}
			*/