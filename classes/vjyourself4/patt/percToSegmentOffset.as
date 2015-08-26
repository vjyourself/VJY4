package neuralbox2.wave{
	public function percToSegmentOffset(perc:Number,offsetNum:Number,segmentNum:Number){
		
		var segment=Math.floor(perc/segmentNum);
		var offset=Math.floor(perc-segment*offsetNum);
		
		if(segment>=segmentNum){
			segment=segmentNum-1;
			offset=offsetNum-1;
		}
		return {offset:offset,segment:segment};
	}
}