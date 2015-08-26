package vjyourself4.games{
	import vjyourself4.patt.colors.ColorScale;
	import vjyourself4.patt.Pattern;
	public class ContextLocal{
		public var _debug:Object;
		public var _meta:Object={name:"Context"};
		public function setDLevels(l1,l2,l3,l4){dLevels=[l1,l2,l3,l4];}
		var dLevels:Array=[true,true,false,false];
		function log(level,msg){if(dLevels[level-1])_debug.log(this,level,msg);}

		public var ns:Object;
		public var params:Object;

		var cloud;
		public var cont:Object;
		public var cs:Object;
		var texBLink:Boolean=false;
		
		public function ContextLocal(){

		}
		public function init(){
			log(1,"init"+JSON.stringify(params));
			cloud=ns._sys.cloud;
			cont={};cs=cont;
			cont.texA = new Pattern();
			cont.texA.type="texture";
			cont.texA.context=cloud["C3D"];
			cont.texB = new Pattern();
			cont.texB.type="texture";
			cont.texB.context=cloud["C3D"];
			cont.texC = new Pattern();
			cont.texC.type="texture";
			cont.texC.context=cloud["C3D"];
			cont.colA = new Pattern();
			cont.colA.type="color";
			cont.colA.context=cloud["CCol"];
			cont.colB = new Pattern();
			cont.colB.type="color";
			cont.colB.context=cloud["CCol"];
			
			if(params==null) params={};
			setParams(params);
		}

		/* 
			type: color / texture
			stream: A,B,Lights
			params:
		*/
		public function reset(){
			log(2,"Reset");
		
			cont.texA.reset();
			cont.texB.reset();
			cont.texC.reset();
		
			cont.colA.reset();
			cont.colB.reset();
	
		}

		public function setParams(p:Object){
			
			for(var i in p){
				var pp=p[i];
				
				switch(i){
					
					case "texA":
					case "texB":
					case "texC":
					case "colA":
					case "colB":
					cs[i].setParams(pp);
					break;
				}
			}
		}
		//depr
		public function getNext(p){
			if (p.params==null)p.params={};
			return cs[(p.type=="texture"?"tex":"col")+p.stream].getNext(p.params);
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
			
			//if((p.type=="color")&&(p.stream=="A")) cont[p.type+"Stream"+"Lights"].setParams(p.params);
		}
		
		public function dispose(){
			cloud=null;
		}
		
	}
}