package vjyourself4.games{
	import flash.events.Event;
	import flash.display.Sprite;
	import away3d.filters.*;
	import vjyourself4.three.assembler.Assembler;
	public class CompFilters{
		public var _debug:Object;
		public var _meta:Object={name:"Filters"};
		public function setDLevels(l1,l2,l3,l4){dLevels=[l1,l2,l3,l4];}
		var dLevels:Array=[true,true,false,false];
		function log(level,msg){if(dLevels[level-1])_debug.log(this,level,msg);}

		public var ns:Object;
		public var params:Object;
		public var input;
		
		public var meta:Object={};
		public var compParams;
		
		var ind:Number=0;
		var filters:Array;
		var ff:Array=[];
		var filterOn:Boolean=false;
		var filterCC:Number=0;
		var filterDelay:Number=60*10;
		var active:Boolean=false;
		var autoOff:Object;
		var firstSet:Boolean=true;
		var type:String="Normal";
		public function CompFilters(){
			away3d.filters.BlurFilter3D;
			away3d.filters.RadialBlurFilter3D;
			away3d.filters.MotionBlurFilter3D;
			away3d.filters.DepthOfFieldFilter3D;
			away3d.filters.BloomFilter3D;
			//away3d.filters.HueSaturationFilter3D;
			compParams=this;
		}
		public function init(){
			//Debug.active = true;
			/*
			input=ns.input;
			if(params.autoOff==null) autoOff={active:true,delay:60*15} else autoOff=params.autoOff;
			
			if(params.active) active=params.active;
			if(params.offDelay) filterDelay=params.offDelay*60;
			if(active){
				if(input.gamepad_enabled){
					input.gamepadManager.events.addEventListener("Gamepad0_"+params.gamepad,nextFilter,0,0,1);
				}
				if(input.mkb_enabled){
					if(params.click) input.stage.addEventListener(MouseEvent.CLICK,nextFilter,0,0,1);
				}
			
				filters=[];
				filters.push([]);
				//filters.push([new BlurFilter3D(4,4)]);
				filters.push([new RadialBlurFilter3D(0.5)]);
				filters.push([new RadialBlurFilter3D(1.5)]);
				filters.push([new RadialBlurFilter3D(3)]);
				filters.push([new RadialBlurFilter3D(1.5)]);
				filters.push([new RadialBlurFilter3D(0.5)]);
				//filters.push([new MotionBlurFilter3D(0.7)]);
				var filt=new DepthOfFieldFilter3D(32,32,1);
				filt.focusDistance=300;
				filt.range=700;
				filters.push([filt
				
								//filters.push([]);
			}
			*/
			setParams(params);
		}
		public function setParam(n,v){
			switch(n){
					case "type":setVal(v);
				}
		}
		public function setParams(p){
			for(var i in p){
				setParam(i,p[i]);
			}
		}
		public function setVal(name:String){
			if(type!=name){
				var code=ns.cloud.RFilters.NS[name];
				if(ff!=null){
					for(var i=0;i<ff.length;i++){
						ff[i].dispose();
						ff[i]=null;
					}
				}
				ff=[];
				for(var i=0;i<code.length;i++) ff.push(Assembler.createObject(code[i]));
				if(firstSet){
					//filter can't be set on the first frame... >> will cause crazy error
					active=true;
					filterCC=0;
					firstSet=false;
				}else{
					ns.view.filters3d=ff;
				}
			}
		}
		/*
		function nextFilter(e){
			if(filterOn) ind=(ind+1)%filters.length;
			setFilterInd(ind);
		}
		
		public function setFilterInd(ind){
			trace("filter>"+ind);
			trace("array:"+filters[ind]);
			if(filters[ind]!=null){
				ns.view.filters3d = filters[ind];
				filterOn=true;
				filterCC=0;
			}
		}
		*/
		public function onEF(e=null){
			if(active){
				filterCC++;
				if(filterCC>=60){
					active=false;
					ns.view.filters3d=ff;
				}
			}
			/*
			if(active){
				if(autoOff.active){
					if(filterOn){
						filterCC++;
						if(filterCC>=autoOff.delay){
							ns.view.filters3d = [];
							filterOn=false;
						}
					}
				}
			}
			*/
		}
		
		
	}
}