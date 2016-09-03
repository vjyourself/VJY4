package vjyourself4.ctrl{
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import vjyourself4.dson.Eval;
	import vjyourself4.DynamicEvent;
	import vjyourself4.patt.WaveFollow;
	
	public class CtrlSky{
		public var _debug:Object;
		public var _meta:Object={name:""};
		public function setDLevels(l1,l2,l3,l4){dLevels=[l1,l2,l3,l4];}
		var dLevels:Array=[true,false,false,false];
		function log(level,msg){if(dLevels[level-1])_debug.log(this,level,msg);}

		public var ns:Object;
		public var params:Object;

		var me;
		var cont3D;
		var rotSpeed:Number=0;
		var rotX:Number=0;
		var rotY:Number=0;
		
		
		public function CtrlSky(){}
		
		public function init(){
			if(params.rotate!=null) rotSpeed=params.rotate;
			cont3D= ns.cont3D;
			me = ns.me;
		}

		public function setInput(ch,val){
			switch(ch){
				case 0:rotSpeed=val;break;
			}
		}
		
		
		
		public function onEF(e){
			log(4,"SET"+cont3D.rotationX);
			cont3D.position=me.pos;
			rotX=(rotX+rotSpeed*0.7)%360;
			rotY=(rotY+rotSpeed*1.1)%360;
			cont3D.rotationX=rotX;
			cont3D.rotationY=rotY;
		}
		
	}
}