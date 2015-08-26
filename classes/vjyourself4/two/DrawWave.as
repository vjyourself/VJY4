package vjyourself4.two{
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	import flash.geom.Point;
	
	public class DrawWave{
		
		//draw area
		public var wDimX=960;
		public var wDimY=540;
		public var y0=0;
		public var x0=0;
		public var baseCurve="circle";
		public var curveCircle_radius=0;
		
		//wave transform
		public var offset=0;
		public var gain=1;
		public var waveAbs=0;
		
		//DRAW IT !!
		public var doFill=false;
		public var doLine=false;
		public var doStars=true;
		
		//colors
		public var fillColor=0x000000;
		public var lineColor0=0xffff00;
		public var lineT0=1;
		public var lineColor1=0x336633;
		public var lineT1=2;
		public var lineColor2=0x66ff66;
		public var lineT2=2;
		
		
		public var waveData:Array;
		public var canvas:Sprite;
		public var vis:Sprite;
		
		
		function DrawWave(){}
		public function init(){
			if(canvas==null) canvas = new Sprite();
			vis=canvas;
			if(curveCircle_radius==0){
				var ll=wDimY;if(wDimX<wDimY) ll=wDimX;
				curveCircle_radius=ll/3;
			}
		}
		public function onEF(e=null){if(waveData!=null) draw(waveData);}
		
		public function draw(ww:Array){
			//trace("draw:"+ww);
			var cont:Sprite=canvas;
			cont.graphics.clear();
			
			var num = ww.length/2;
			var step=1/(num-1);
			var p={x:0,y:0};
			var val=0
			
			if(doFill){
				cont.graphics.beginFill(fillColor);
				p=curveCoord({x:0,y:0});cont.graphics.moveTo(p.x, p.y);
				for(var i=0;i<num;i++){
					val=(waveAbs==0)?(ww[i]*gain+offset):waveAbs*Math.abs(ww[i]*gain+offset);
					p=curveCoord({x:i*step,y:val});cont.graphics.lineTo(p.x,p.y);
				}
				//p=curveCoord({x:1,y:0});cont.graphics.lineTo(p.x, p.y);
				var endDiv=12;
				for(i=0;i<=endDiv;i++){
					p=curveCoord({x:1-i/endDiv,y:0});cont.graphics.lineTo(p.x, p.y);
				}
				
				cont.graphics.endFill();
			}
			
			if(doLine){
				cont.graphics.lineStyle(lineT0,lineColor0,1);
				p=curveCoord({x:0,y:0});cont.graphics.moveTo(p.x, p.y);
				for(var i=0;i<num;i++){
					val=ww[i]*gain+offset;
					p=curveCoord({x:i*step,y:val});cont.graphics.lineTo(p.x,p.y);
				}
				p=curveCoord({x:1,y:0});cont.graphics.lineTo(p.x, p.y);
			}
			
			if(doStars){
				var ss=0.5;
				var div=2;
				var curve0=0;
				var curve1=0;
				var polar=(ww[0]==0)?1:ww[0]/Math.abs(ww[0]);
				var cc=0;
				var numD=Math.floor(num/div);
				for(var ii=0;ii<numD;ii++){
					var i=ii*div;
					val=ww[i]*gain+offset;
					var np=(ww[i]==0)?1:ww[i]/Math.abs(ww[i]);
					if((np!=polar)||(ii==numD-1)){
						cc=polar/2+0.5+1;
						cont.graphics.lineStyle((cc%2)?lineT1:lineT2,(cc%2)?lineColor1:lineColor2,1);
						curve1=i-1;
						for(var iii=curve0;iii<curve1;iii+=div){
							p=curveCoord({x:(curve0+(curve1-curve0)*(1-ss)/2+(iii-curve0)*ss)*step,y:0});cont.graphics.moveTo(p.x,p.y);  
							p=curveCoord({x:iii*step,y:ww[iii]});cont.graphics.lineTo(p.x,p.y);
						}
						curve0=i;
						polar=np;
						//cc++;
					}
				}
				
			}
		}
		function curveCoord(p):Object{
			var x=p.x;
			var y=p.y;
			switch(baseCurve){
				case "line":
				p.x=wDimX*(x-0.5);
				p.y=wDimY/2*y;
				break;
				case "circle":
				p.x=Math.sin(x*Math.PI*2)*curveCircle_radius*(1+y/2);
				p.y=Math.cos(x*Math.PI*2)*curveCircle_radius*(1+y/2);
				break;
			}
			return p;
		}
		
	}
}