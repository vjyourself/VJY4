package vjyourself4.three.logic{
	import vjyourself4.patt.ColorScale;
	public class LogicMusicMattColor{
		var logic:Object;
		var target:String;
		var color0:Number;
		var color1:Number;
		var colorScale:ColorScale;
		var delay:Number=0;
		var cc:Number=0;
		public function LogicMusicMattColor(lg,p){
			logic=lg;
			for(var i in p) this[i]=p[i];
			colorScale = new ColorScale();
			colorScale.colors=[color0,color1];
		}
		public function init(){}
		
		public function onEF(e=null){
			cc++;
			if(cc>=delay){
				cc=0;
				var col = colorScale.getColor(logic.musicmeta.peak);
				logic.obj.res[target].color=col;
			}
		}
	}
}