package vjyourself4.three.assembler{
	public class Assembler{
		import flash.utils.getDefinitionByName;
		public function Assembler(){

		}

		public static function createObject(code){
			// cn:class name // pc: params of constructor // p: params after constructor
			trace("Assembler "+code.cn);
			var obj;
			var cc:Class=getDefinitionByName(code.cn) as Class;
			var pc=code.pc; if(pc==null) pc=[];
			switch(pc.length){
				case 0:obj= new cc();break;
				case 1:obj= new cc(pc[0]);break;
				case 2:obj= new cc(pc[0],pc[1]);break;
				case 3:obj= new cc(pc[0],pc[1],pc[2]);break;
				case 4:obj= new cc(pc[0],pc[1],pc[2],pc[3]);break;
				case 5:obj= new cc(pc[0],pc[1],pc[2],pc[3],pc[4]);break;
				case 6:obj= new cc(pc[0],pc[1],pc[2],pc[3],pc[4],pc[5]);break;
				case 7:obj= new cc(pc[0],pc[1],pc[2],pc[3],pc[4],pc[5],pc[6]);break;
				case 8:obj= new cc(pc[0],pc[1],pc[2],pc[3],pc[4],pc[5],pc[6],pc[7]);break;
				case 9:obj= new cc(pc[0],pc[1],pc[2],pc[3],pc[4],pc[5],pc[6],pc[7],pc[8]);break;
				case 10:obj= new cc(pc[0],pc[1],pc[2],pc[3],pc[4],pc[5],pc[6],pc[7],pc[8],pc[9]);break;
			}
			if(code.p!=null) for(var i in code.p) obj[i]=code.p[i];
			trace(" obj:"+obj);
			return obj;
		}
	}
}