package vjyourself4.three{
	import flash.geom.Vector3D;
	import flash.geom.Matrix3D;
	public class Path{
		public var startPos:Vector3D;
		public var startRot:Matrix3D;		
		public var synth;
		public var ctrl;
		
		//public look :D
		public var p0:Number=0;
		public var p1:Number=0;
		public var pMe:Number=0;

		//segments
		public var curveLength:Number=200;
		public var continuePath:Function;
		public var initPath:Function;
		public var segments:Array=[];
		public var pSeg0:Number=0;
		public var pSeg1:Number=0;	
		

		function Path(){ }

		public function setp0(v){
			p0=v;
			if(segments.length>0) while(pSeg0+segments[0].length<p0) delSegment();
		}

		public function setp1(v){
			p1=v;
			while(pSeg1<p1) continuePath();
		}
		public function setpMe(v){ pMe=v;}
		//public function setMePos(pos){pMe=pos;synth.setViewPos(pos);}

		public function restart(){
			/*
			length=0;
			for(var i=0;i<segments.length;i++) segments[i].destroy();
			while(segments.length>0) segments.pop();
			continuePath();
			continuePath();
			continuePath();
			*/
		}
		public function dispose(){
			destroyPath();
		}
		public function destroyPath(){
			for(var i=0;i<segments.length;i++) segments[i].destroy();
			while(segments.length>0) segments.pop();
			p0=0;
			pMe=0;
			p1=0;
			pSeg0=0;
			pSeg1=0;
		}

/*
		public function step(l:Number){
			while(l>segments[0].length){
				l-=segments[0].length;
				segments.splice(0,1);
			}
		}
*/		
		
		
		public function coordShift(shift:Vector3D){
			startPos.incrementBy(shift);
			//trace("****************** COORD SHIFT ***********************");
			//for(var i=0;i<segments.length;i++) //trace(i+":"+segments[i].globPos0+"-"+segments[i].globPos1);
			for(var i=0;i<segments.length;i++){
				var seg=segments[i];
				seg.globPos0.x+=shift.x;
				seg.globPos0.y+=shift.y;
				seg.globPos0.z+=shift.z;
				seg.globPos1.x+=shift.x;
				seg.globPos1.y+=shift.y;
				seg.globPos1.z+=shift.z;
			}
			//trace("******************");
			//for(var i=0;i<segments.length;i++) trace(i+":"+segments[i].globPos0+"-"+segments[i].globPos1);
		}

		/*****************************************************************************
		 GET PATH
		 ********************************************************************************/
		public function getPos(l:Number):Vector3D{
			if(l>p1) l=p1;
			if(l<p0) l=p0;
			var ind=0;
			l-=pSeg0;
			while(segments[ind].length<l) {l-=segments[ind].length;ind++};
			return segments[ind].getGlobPos(l/segments[ind].length);
		}
		public function getRot(l:Number):Matrix3D{
			if(l>p1) l=p1;
			if(l<p0) l=p0;
			var ind=0;
			l-=pSeg0;
			while(segments[ind].length<l) {l-=segments[ind].length;ind++};
			return segments[ind].getGlobRot(l/segments[ind].length);
		}
		
		public function getPath(i0:Number=0,i1:Number=-1,step:Number=100):Array{
			if(i1==-1) i1=p1;
			
			var ret=[];
			var num=Math.ceil((i1-i0)/step)-1;if(num<0)num=0;
			
			var segInd=0;
			var segOffset=i0-pSeg0;
			while(segments[segInd].length<segOffset) {segOffset-=segments[segInd].length;segInd++};
			
			//i0:
			ret.push(segments[segInd].getGlobPos(segOffset/segments[segInd].length));
			//num inbetween
			for(var i=0;i<num;i++){
				segOffset+=step;
				if(segOffset>segments[segInd].length){
					segOffset-=segments[segInd].length;
					segInd++;
				}
				ret.push(segments[segInd].getGlobPos(segOffset/segments[segInd].length));
			}
			//i1:
			ret.push(getPos(i1));
			return ret;
		}
		
		public function getPathRot(i0:Number=0,i1:Number=-1,step:Number=100):Array{
			if(i1==-1) i1=p1;
			
			var ret=[];
			var num=Math.ceil((i1-i0)/step)-1;if(num<0)num=0;
			
			var segInd=0;
			var segOffset=i0-pSeg0;
			while(segments[segInd].length<segOffset) {segOffset-=segments[segInd].length;segInd++};
			
			//i0:
			ret.push(segments[segInd].getGlobRot(segOffset/segments[segInd].length));
			//num inbetween
			for(var i=0;i<num;i++){
				segOffset+=step;
				if(segOffset>segments[segInd].length){
					segOffset-=segments[segInd].length;
					segInd++;
				}
				ret.push(segments[segInd].getGlobRot(segOffset/segments[segInd].length));
			}
			//i1:
			ret.push(getRot(i1));
			return ret;
		}
		
		/*********** GENERATE SEGMENTS ***********************************************/
		public function setParams(o:Object){
			if(o==null) o={};
			if(o.type!=""){
				continuePath=this["path"+o.type];
				if(this.hasOwnProperty("init"+o.type)){
					initPath=this["init"+o.type];
					initPath();
				}
			}
			if(o.ll!=null) curveLength=o.ll;
		}

		public function addSegment(seg:Object){
			pSeg1+=seg.length;
			if(segments.length==0) seg.setGlobTrans(startPos,startRot);
			else seg.setGlobTrans(segments[segments.length-1].globPos1,segments[segments.length-1].globRot1);
			segments.push(seg);
		}
		public function delSegment(){
			if(segments.length>0){
				pSeg0+=segments[0].length;
				segments.shift();
				//startPos=segments[0].globPos0.clone();
			}
		}
		/*
			CURVES ::
			Random
			RandomSoftCurves
			Nice
			RandomCurvy
			Straight

			NEW ::
			ZigZag
			Spiral
			Break
		*/
		var zTwist:Object={alpha:0};
		function addZTwist(aa):Object{
			var o={alpha0:zTwist.alpha,alpha1:zTwist.alpha+aa};
			zTwist.alpha=0;
			return o;
		}
		public function pathRandom(){
				if(Math.random()<=0.75){
					addSegment(new PathSegment({type:"Line",length:curveLength}));
				}else switch(Math.floor(Math.random()*4)){
					case 0:addSegment(new PathSegment({type:"CurveXZ",alpha:90,length:curveLength}));break;
					case 1:addSegment(new PathSegment({type:"CurveXZ",alpha:-90,length:curveLength}));break;
					case 2:addSegment(new PathSegment({type:"CurveYZ",alpha:90,length:curveLength}));break;
					case 3:addSegment(new PathSegment({type:"CurveYZ",alpha:-90,length:curveLength}));break;
				}
				addSegment(new PathSegment({type:"Line",length:curveLength}));
				//trace("Add Segment:"+length);
			
		
		}
		public function pathCurvy(){
				switch(Math.floor(Math.random()*4)){
					case 0:addSegment(new PathSegment({type:"CurveXZ",alpha:90,length:curveLength}));break;
					case 1:addSegment(new PathSegment({type:"CurveXZ",alpha:-90,length:curveLength}));break;
					case 2:addSegment(new PathSegment({type:"CurveYZ",alpha:90,length:curveLength}));break;
					case 3:addSegment(new PathSegment({type:"CurveYZ",alpha:-90,length:curveLength}));break;
				}
		}

		public function pathSpiral(){
			
				switch(Math.floor(Math.random()*4)){
					case 0:addSegment(new PathSegment({type:"SpiralXZ",alpha:360,length:curveLength*8,depth:1200}));break;
					case 1:addSegment(new PathSegment({type:"SpiralXZ",alpha:-360,length:curveLength*8,depth:1200}));break;
					case 2:addSegment(new PathSegment({type:"SpiralXZ",alpha:360,length:curveLength*12,depth:1000}));break;
					default:addSegment(new PathSegment({type:"SpiralXZ",alpha:-360,length:curveLength*12,depth:1000}));break;
					//default:addSegment(new PathSegment({type:"SpiralXZ",alpha:-180,length:curveLength*6}));break;
					//case 2:addSegment(new PathSegment({type:"CurveYZ",alpha:90,length:curveLength}));break;
					//case 3:addSegment(new PathSegment({type:"CurveYZ",alpha:-90,length:curveLength}));break;
				}
		}

	
		public function pathLinearTurn(){
			switch(0){
				case 0:
				addSegment(new PathSegment({type:"Line",zTwist:addZTwist(90),length:curveLength*16}));
				break;
				case 1:
				addSegment(new PathSegment({type:"Line",zTwist:addZTwist(-90),length:curveLength*16}));
				break;
				case 2:
				addSegment(new PathSegment({type:"Line",length:curveLength*4}));
				break;
			}
		}
		
		public function pathSpiralSoft(){
			addSegment(new PathSegment({type:"SpiralXY",alpha:360,length:curveLength*16,depth:2400}));
			/*
				switch(Math.floor(Math.random()*4)){
					case 0:addSegment(new PathSegment({type:"SpiralXY",alpha:30,length:curveLength*8,depth:1200}));break;
					case 1:addSegment(new PathSegment({type:"SpiralXY",alpha:-30,length:curveLength*8,depth:1200}));break;
					case 2:addSegment(new PathSegment({type:"Line",length:curveLength*4}));break;
					case 3:addSegment(new PathSegment({type:"Line",length:curveLength*4}));break;
				}*/
					/*
					case 0:addSegment(new PathSegment({type:"SpiralXZ",alpha:360,length:curveLength*8,depth:1200}));break;
					case 1:addSegment(new PathSegment({type:"SpiralXZ",alpha:-360,length:curveLength*8,depth:1200}));break;
					case 2:addSegment(new PathSegment({type:"SpiralXZ",alpha:360,length:curveLength*12,depth:1000}));break;
					default:addSegment(new PathSegment({type:"SpiralXZ",alpha:-360,length:curveLength*12,depth:1000}));break;
					//default:addSegment(new PathSegment({type:"SpiralXZ",alpha:-180,length:curveLength*6}));break;
					//case 2:addSegment(new PathSegment({type:"CurveYZ",alpha:90,length:curveLength}));break;
					//case 3:addSegment(new PathSegment({type:"CurveYZ",alpha:-90,length:curveLength}));break;
				}*/
		}

		public function pathRandomSoftCurves(){pathNice();}
		public function pathNice(){
			var zTwist={alpha0:0,alpha1:0};
				if(Math.random()<=0.6){
					addSegment(new PathSegment({type:"Line",length:curveLength,zTwist:zTwist}));
				}else switch(Math.floor(Math.random()*8)){
					case 0:addSegment(new PathSegment({type:"CurveXZ",alpha:30,length:curveLength*6,zTwist:zTwist}));break;
					case 1:addSegment(new PathSegment({type:"CurveXZ",alpha:-30,length:curveLength*6,zTwist:zTwist}));break;
					case 2:addSegment(new PathSegment({type:"CurveYZ",alpha:30,length:curveLength*6,zTwist:zTwist}));break;
					case 3:addSegment(new PathSegment({type:"CurveYZ",alpha:-30,length:curveLength*6,zTwist:zTwist}));break;
					case 4:addSegment(new PathSegment({type:"CurveXZ",alpha:60,length:curveLength*6,zTwist:zTwist}));break;
					case 5:addSegment(new PathSegment({type:"CurveXZ",alpha:-60,length:curveLength*6,zTwist:zTwist}));break;
					case 6:addSegment(new PathSegment({type:"CurveYZ",alpha:60,length:curveLength*6,zTwist:zTwist}));break;
					case 7:addSegment(new PathSegment({type:"CurveYZ",alpha:-60,length:curveLength*6,zTwist:zTwist}));break;
						}
				addSegment(new PathSegment({type:"Line",length:curveLength,zTwist:zTwist}));
				//trace("Add Segment:"+length);
		}
		
		public function pathComplex(){
			var zTwist={alpha0:0,alpha1:(Math.random()*2-1)*100};
			if(Math.random()<=0.6){
				switch(Math.floor(Math.random()*9)){
					case 0:addSegment(new PathSegment({type:"CurveXZ",alpha:30,length:curveLength*6,zTwist:zTwist}));break;
					case 1:addSegment(new PathSegment({type:"CurveXZ",alpha:-30,length:curveLength*6,zTwist:zTwist}));break;
					case 2:addSegment(new PathSegment({type:"CurveYZ",alpha:30,length:curveLength*6,zTwist:zTwist}));break;
					case 3:addSegment(new PathSegment({type:"CurveYZ",alpha:-30,length:curveLength*6,zTwist:zTwist}));break;
					case 4:addSegment(new PathSegment({type:"CurveXZ",alpha:60,length:curveLength*6,zTwist:zTwist}));break;
					case 5:addSegment(new PathSegment({type:"CurveXZ",alpha:-60,length:curveLength*6,zTwist:zTwist}));break;
					case 6:addSegment(new PathSegment({type:"CurveYZ",alpha:60,length:curveLength*6,zTwist:zTwist}));break;
					case 7:addSegment(new PathSegment({type:"CurveYZ",alpha:-60,length:curveLength*6,zTwist:zTwist}));break;
					case 8:addSegment(new PathSegment({type:"Line",length:curveLength,zTwist:zTwist}));
				}
			}else{
				switch(Math.floor(Math.random()*8)){
					case 0:addSegment(new PathSegment({type:"Line",length:curveLength*3,zTwist:{alpha0:0,alpha1:360}}));break;
					case 1:addSegment(new PathSegment({type:"Line",length:curveLength*3,zTwist:{alpha0:0,alpha1:360}}));break;
					case 2:addSegment(new PathSegment({type:"SpiralXZ",alpha:360,length:curveLength*12,depth:1000}));break;
					case 3:addSegment(new PathSegment({type:"SpiralXZ",alpha:-360,length:curveLength*12,depth:1000}));break;
					//case 4:addSegment(new PathSegment({type:"SpiralXZ",alpha:180,length:curveLength*10,depth:1000}));break;
					//case 5:addSegment(new PathSegment({type:"SpiralXZ",alpha:-180,length:curveLength*10,depth:1000}));break;
					case 4:addSegment(new PathSegment({type:"SpiralYZ",alpha:360,length:curveLength*12,depth:1000}));break;
					case 5:addSegment(new PathSegment({type:"SpiralYZ",alpha:360,length:curveLength*12,depth:-1000}));break;
					case 6:addSegment(new PathSegment({type:"Line_ZigZag",width:60,height:0,length:curveLength*6}));break;
					case 7:addSegment(new PathSegment({type:"Line_ZigZag",width:0,height:60,length:curveLength*6}));break;
				}
			}
			//	addSegment(new PathSegment({type:"Line",length:curveLength,zTwist:zTwist}));
				
			
		
		}

		public function pathNiceOld(){
				if(Math.random()<=0.6){
					addSegment(new PathSegment({type:"Line",length:curveLength}));
				}else{
					var ext=(Math.random()>0.6)?1:3;
					switch(Math.floor(Math.random()*4)){
					case 0:addSegment(new PathSegment({type:"CurveXZ",alpha:90,length:curveLength*ext}));break;
					case 1:addSegment(new PathSegment({type:"CurveXZ",alpha:-90,length:curveLength*ext}));break;
					case 2:addSegment(new PathSegment({type:"CurveYZ",alpha:90,length:curveLength*ext}));break;
					case 3:addSegment(new PathSegment({type:"CurveYZ",alpha:-90,length:curveLength*ext}));break;
				}}
				addSegment(new PathSegment({type:"Line",length:curveLength}));
				//trace("Add Segment:"+length);
			
		
		}
		public function pathRandomCurvy(){
			
				switch(Math.floor(Math.random()*6)){
					case 0:addSegment(new PathSegment({type:"Line",length:curveLength}));break;
					case 1:addSegment(new PathSegment({type:"Line",length:curveLength}));break;
					case 2:addSegment(new PathSegment({type:"CurveXZ",alpha:90,length:curveLength}));break;
					case 3:addSegment(new PathSegment({type:"CurveXZ",alpha:-90,length:curveLength}));break;
					case 4:addSegment(new PathSegment({type:"CurveYZ",alpha:90,length:curveLength}));break;
					case 5:addSegment(new PathSegment({type:"CurveYZ",alpha:-90,length:curveLength}));break;
				}
				
				switch(Math.floor(Math.random()*6)){
					case 0:addSegment(new PathSegment({type:"Line",length:curveLength}));break;
					case 1:addSegment(new PathSegment({type:"Line",length:curveLength}));break;
					case 2:addSegment(new PathSegment({type:"CurveXZ",alpha:90,length:curveLength}));break;
					case 3:addSegment(new PathSegment({type:"CurveXZ",alpha:-90,length:curveLength}));break;
					case 4:addSegment(new PathSegment({type:"CurveYZ",alpha:90,length:curveLength}));break;
					case 5:addSegment(new PathSegment({type:"CurveYZ",alpha:-90,length:curveLength}));break;
				}
				
				trace("Add Segment Curvy:"+length);
			
		}
		
		public function pathStraight(){
				addSegment(new PathSegment({type:"Line",length:curveLength}));
		}

		public function pathZigZagFast(){
					addSegment(new PathSegment({type:"Line_ZigZag",width:60,height:0,length:curveLength*3}));
					addSegment(new PathSegment({type:"Line_ZigZag",width:60,height:0,length:curveLength*3}));
					addSegment(new PathSegment({type:"Line_ZigZag",width:0,height:60,length:curveLength*3}));
					addSegment(new PathSegment({type:"Line_ZigZag",width:0,height:60,length:curveLength*3}));
		}

		public function pathZigZag(){
					addSegment(new PathSegment({type:"Line_ZigZag",width:68,height:0,length:curveLength*6}));
					addSegment(new PathSegment({type:"Line_ZigZag",width:68,height:0,length:curveLength*6}));
					addSegment(new PathSegment({type:"Line_ZigZag",width:0,height:68,length:curveLength*6}));
					addSegment(new PathSegment({type:"Line_ZigZag",width:0,height:68,length:curveLength*6}));
		}

		public function pathTest(){
					addSegment(new PathSegment({type:"Line_ZigZag",width:60,height:0,length:curveLength*3}));
					addSegment(new PathSegment({type:"Line_ZigZag",width:60,height:0,length:curveLength*3}));
					addSegment(new PathSegment({type:"Line_ZigZag",width:0,height:60,length:curveLength*3}));
					addSegment(new PathSegment({type:"Line_ZigZag",width:0,height:60,length:curveLength*3}));
		}
	}
}