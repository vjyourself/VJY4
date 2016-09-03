package vjyourself4.overlay{
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	import vjyourself4.DynamicEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import vjyourself4.dson.TransJson;
	
	public class OverlayDecScene{
		public var _debug:Object;
		public var _meta:Object={name:"Overlay DecScene"};
		public function setDLevels(l1,l2,l3,l4){dLevels=[l1,l2,l3,l4];}
		var dLevels:Array=[true,false ,false,false];
		function log(level,msg){if(dLevels[level-1])_debug.log(this,level,msg);}
		
		public var ns:Object;
		public var params:Object;

		var tfConsole:TextField;
		var tfJson:TextField;
		
		public var vis:Sprite;

		var width:Number=300;
		var height:Number=600;

		public function OverlayDecScene(){
		}
		
		public function init(){
			//if(filter.act) rule = new RuleAB_C(filter.rule);

			vis = new Sprite();
			vis.x=ns.sys.screen.wDimX-width;
			vis.y=0;
			if(params.visible!=null) vis.visible=params.visible;
			
			

			var tf:TextFormat = new TextFormat();
			tf.size = 16;
			tf.leading = 4;
			tf.bold = false;
			tf.font = "Arial"
			tf.color = 0xffffff;
	
			tfConsole = new TextField();
			tfConsole.width=width;
			tfConsole.height=height;
			tfConsole.defaultTextFormat = tf;
			tfConsole.backgroundColor=0x333333;
			tfConsole.background=true;
			vis.addChild(tfConsole);

			tfJson = new TextField();
			tfJson.width=width;
			tfJson.height=width/2;
			tfJson.defaultTextFormat = tf;
			tfJson.backgroundColor=0x222222;
			tfJson.background=true;
			tfJson.visible=false;
			vis.addChild(tfJson);

			tfConsole.text="SCENE DEF";

			//_debug.events.addEventListener("LOG",onLog,0,0,1);
			update();
			ns.scene.events.addEventListener(Event.CHANGE,onSceneChange,0,0,1);
		}
		function onSceneChange(e){
			if(vis.visible) update();
		}

		public function generateJSON(){
			update();
			tfJson.visible=true;
			var ssd=TransJson.clone(sd);
			ssd.state.back={preset:"BackBoxBallGrid",params:ssd.state.back};
			ssd.state.mid={preset:"PathSpace",params:ssd.state.mid};
			ssd.state.fore={preset:"ForeOverlayAni",params:ssd.state.fore};

			tfJson.text=JSON.stringify(ssd,null,4);
		}
		var sd:Object;
		public function update(){
			sd=ns.scene.getDef();

			var s:String="WORLD : "+ns.cloud.World4.m.n+"\n\n";

			s+="Last Scene : "+sd.name+" \n\n";

			var mid=sd.state.mid;
			s+="Space : <b>"+mid.GP.space+"</b>\n";
			s+="Path : <b>"+mid.GP.path.type+"</b>\n";
			s+="TexA : <b>"+mid.context.texA.name+"</b>\n";
			s+="TexB : <b>"+mid.context.texB.name+"</b>\n";
			s+="ColA : <b>"+mid.context.colA.name+"</b>\n";
			s+="Lights : <b>"+mid.lights.mode+"</b>\n";

			var back=sd.state.back;
			s+="\n";
			s+="BACK.TexA : <b>"+back.context.texA.name+" #"+back.context.texA.ind+" </b>\n";
			s+="BACK.ColA : <b>"+back.context.colA.name+"</b>\n";
			s+="BACK.Lights : <b>"+back.lights.mode+"</b>\n";

			var extro=sd.state;
			s+="\n";
			s+="Filter : <b>"+extro.filter.type+"</b>\n";
			s+="Blend : <b>"+(extro.blendAdd?"ADD":"NORMAL")+"</b>\n";
			s+="MCLP : <b>"+extro.mclp+"</b>\n";
			
			s+="\nMM\n\n";
			s+="\nProgress\n\n";

			tfConsole.htmlText=s;

		}
		public function onEF(e){
			
		}
		/*
		public function show(v=null){
			if(v==null) visible=!visible;
			else visible=v;
			vis.visible=visible;
		}

		public function onLog(e:DynamicEvent){
			var show:Boolean=true;
			if(filter.act) show=rule.getVal(e.data.level,e.data.n);
					
			if(show){
				var txt=e.data.n+"> "+e.data.msg;
				tfConsole.text+=txt+"\n";
				tfConsole.scrollV=tfConsole.maxScrollV;
			}
		}
		*/
		public function onResize(e){
			vis.x=ns.sys.screen.wDimX-width;
			vis.y=0;
			tfJson.y=height;
		}

		public function dispose(){

		}
	}
}