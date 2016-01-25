package vjyourself4.media{
	import vjyourself4.patt.TrigChannel;
	import vjyourself4.dson.TransJson;
	public class MetaTimeline{
		public var params:Object;
		public var enabled:Boolean=false;
		public var beat:MetaBeat;
		public var struct:Array;
		public var structInd:Number=0;
		public var beatInd:Number=0;

		var beatCount:Number=0;
		public function MetaTimeline(){
			
		}
		public function init(){
			enabled = params.enabled;
			if(enabled){
				struct=TransJson.clone(params.struct);

				var sb=1;
				for(var i=0;i<struct.length;i++) {
					struct[i].startBeat=sb;
					sb+=struct[i].b;
				}
			}
		}
		public function beatToTime(pos:String){
			if(enabled){
			var pp=pos.split(".");
			var beats=struct[parseInt(pp[0])-1].startBeat+parseInt(pp[1])-1;
			var time=beat.beatToTime(beats);
		//	trace("hell");
			return time;
			}else{
					return 0;
				}
		}

		public function update(){
			if(enabled&&(beat.beatCounter>=0)){
				if(beatCount!=beat.beatCounter){
					beatCount=beat.beatCounter;
					trace("TIMELINE "+beatCount);
					
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
}
