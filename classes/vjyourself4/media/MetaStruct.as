package vjyourself4.media{
	import vjyourself4.patt.TrigChannel;
	import vjyourself4.dson.TransJson;
	public class MetaStruct{
		public var params:Object;
		public var rhythm:MetaRhythm;
		public var struct:Array;
		public var structInd:Number=0;
		public var beatInd:Number=0;

		var beatCount:Number=0;
		public function MetaStruct(){
			
		}
		public function init(){
			struct=TransJson.clone(params.struct);

			var sb=1;
			for(var i=0;i<struct.length;i++) {
				struct[i].startBeat=sb;
				sb+=struct[i].b;
			}
		
		}
		public function beatToTime(pos:String){
			var pp=pos.split(".");
			var beats=struct[parseInt(pp[0])-1].startBeat+parseInt(pp[1])-1;
			var time=rhythm.beatToTime(beats);
		//	trace("hell");
			return time;
		}

		public function update(){
			if(beatCount!=rhythm.absBeatCount){
				beatCount=rhythm.absBeatCount;
				var bi=0;
				for(var i=0;(i<struct.length)&&(bi<=beatCount);i++) bi+=struct[i].b;
				structInd=i-1;
				bi-=struct[structInd].b;
				beatInd=beatCount-bi;
				if(beatInd>=struct[structInd].b) beatInd=struct[structInd].b-1;
			}
		}
	}
}
