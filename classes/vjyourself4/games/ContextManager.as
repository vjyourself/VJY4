package vjyourself4.games{
	import vjyourself4.patt.colors.ColorScale;
	import vjyourself4.patt.Pattern;
	public class ContextManager{
		public var _debug:Object;
		public var _meta:Object={name:"Context"};
		public function setDLevels(l1,l2,l3,l4){dLevels=[l1,l2,l3,l4];}
		var dLevels:Array=[true,false,false,false];
		function log(level,msg){if(dLevels[level-1])_debug.log(this,level,msg);}

		public var ns:Object;
		public var params:Object;

		var cloud;
		public var cont:Object;
		var texBLink:Boolean=false;
		
		public function ContextManager(){

		}
		public function init(){
			log(1,"init");
			cloud=ns.cloud;
			cont={};
			cont.multiA="";
			cont.multiB="";
			
			cont.textureStreamBack = new Pattern();
			cont.textureStreamBack.type="texture";
			cont.textureStreamBack.context=cloud["C3D"];
			cont.textureStreamA = new Pattern();
			cont.textureStreamA.type="texture";
			cont.textureStreamA.context=cloud["C3D"];
			cont.textureStreamB = new Pattern();
			cont.textureStreamB.type="texture";
			cont.textureStreamB.context=cloud["C3D"];
			cont.colorStreamBack = new Pattern();
			cont.colorStreamBack.type="color";
			cont.colorStreamBack.context=cloud["CCol"];
			cont.colorStreamA = new Pattern();
			cont.colorStreamA.type="color";
			cont.colorStreamA.context=cloud["CCol"];
			cont.colorStreamB = new Pattern();
			cont.colorStreamB.type="color";
			cont.colorStreamB.context=cloud["CCol"];
			cont.colorStreamLights = new Pattern();
			cont.colorStreamLights.type="color";
			cont.colorStreamLights.context=cloud["CCol"];
			
			if(params==null) params={};
		}

		/* 
			type: color / texture
			stream: A,B,Lights
			params:
		*/
		public function reset(){
			log(2,"Reset");
			cont.textureStreamBack.reset();
			cont.textureStreamA.reset();
			cont.textureStreamB.reset();
			cont.colorStreamBack.reset();
			cont.colorStreamA.reset();
			cont.colorStreamB.reset();
			cont.colorStreamLights.reset();
		}

		public function getNext(p){
			if(p.params==null) p.params={};
			var stream=p.stream;
			//if((p.type=="texture")&&(p.stream=="B")&&(texBLink)) stream="A";
			//trace("texBLink:"+texBLink);
			return cont[p.type+"Stream"+stream].getNext(p.params);
		}

		public function setStream(p){
			log(2,"setStream: "+JSON.stringify(p));
			var setit=true;
			if((p.type=="texture")&&(p.stream=="B")){
				if(p.params is String){
					texBLink=p.params=="A";
					setit=!texBLink;
				}else{
					if(p.params.name!=null){
						texBLink=p.params.name=="A";
						setit=!texBLink;
					}
				}
			}
			if(setit) cont[p.type+"Stream"+p.stream].setParams(p.params);
			if(texBLink&&(p.type=="texture")&&(p.stream=="A")) cont[p.type+"Stream"+"B"].setParams(p.params);
			if(texBLink&&(p.type=="texture")&&(p.stream=="B")) cont[p.type+"Stream"+"B"].setParams(cont[p.type+"Stream"+"A"].getParams());
			
			if((p.type=="color")&&(p.stream=="A")) cont[p.type+"Stream"+"Lights"].setParams(p.params);
		}
		
		public function dispose(){
			cloud=null;
		}
		
	}
}