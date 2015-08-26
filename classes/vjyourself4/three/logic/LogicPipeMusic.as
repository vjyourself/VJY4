package vjyourself4.three.logic{
	public class LogicPipeMusic{
		var logic:Object;
		var ctrl:Number;
		var delay:Number=0;
		var cc:Number=0;
		public function LogicPipeMusic(lg,p){
			logic=lg;
			for(var i in p) this[i]=p[i];
		}
		
		public function onEF(e=null){
			cc++;
			if(cc>=delay){
				cc=0;
			logic.obj.obj3D.wf.data=logic.musicmeta.waveDataDamped;
			logic.obj.obj3D.wf.updateGeometry();
			}
		}
	}
}