package vjyourself4.dson{
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import com.adobe.serialization.json.*;

	public class LoadJson{
		public var _debug:Object;
		public var _meta:Object;
		public var debug2:Boolean=true;
		public var debug4:Boolean=false;
		function log(level,msg){_debug.log(this,level,msg);}


		public var trans:TransJson;
		public var globals:Object={};
		
		var blocks:Array;
		var blocksInd:Number=-1;
		var currBlock:Object;
		public var state:String="";
		
		var urlLoader:URLLoader;
		public var events:EventDispatcher;

		
		public var online:Boolean=false;
		
		public function LoadJson(){
			blocks=[];
			trans=new TransJson();
			trans.data={};

			events = new EventDispatcher;
			urlLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE,urlLoader_COMPLETE,0,0,1);
		}

		/*******************************************
			+ file struct
			{
				"blocks":[
					{"data":(sdfsf),"rule":"over"},
					{"url":"[local]blablalb.json","include":"data/block/object","rule":"over"}
				]
			}
			
			+ include types
			data : file contains pure data only to merge
			block : file contains blocks, will all injected into it's place
			object : file will be evaluated as itself, and than as a chunk of data will be merged
	
		*******************************************/
		public function start(file){
			blocks.push({url:file,"include":"blocks"});
			blocksInd=-1;
			processNextBlock();
		}
		
		public function processNextBlock(){
			if(blocksInd>=blocks.length-1){
				state="Done";
				if(debug4) log(4,"DONE");
				events.dispatchEvent(new Event(Event.COMPLETE));
			}else{
				//check block
				blocksInd++;
				currBlock = blocks[blocksInd];
				if(debug4) log(4,"Process Block #"+blocksInd);
				if(currBlock.data!=null){
					if(debug4) log(4,"  data block");
					if(currBlock["target"]!=null) trans.set(currBlock.target,currBlock.data);
					else trans.process(currBlock.data,currBlock.rule);
					
					
					if(debug4) log(4," DONE");
					processNextBlock();
					return;
				}
				if(currBlock.url!=null){
					if(debug4) log(4,"  include block");
					state="loading...";
					var url=solveURL(currBlock.url);
					if(debug2) log(2,currBlock.url);
					urlLoader.load(new URLRequest(url));
					return;
				}
				
			}
		}
		
		public function urlLoader_COMPLETE(e:Event){
			if(debug4) log(4,"  raw data loaded ");
			currBlock.rawdata=new JSONDecoder( urlLoader.data,false ).getValue();

			processRawBlock(currBlock);
			processNextBlock();
		}
		
		public function processRawBlock(blo:Object){
			if(debug4) log(4,"  process raw data... ");
			switch(blo["include"]){
				case "data":
					if(blo["target"]!=null) trans.set(blo["target"],blo.rawdata);
					else trans.process(blo.rawdata,blo.rule);
					if(debug4) log(4,"  Data DONE");
				break;
				case "blocks":
					for(var i=0;i<blo.rawdata.blocks.length;i++) blocks.splice(blocksInd+1+i,0,blo.rawdata.blocks[i]);
					if(debug4) log(4,"  Blocks DONE");
				break;
				case "object": //create new LoadJson to go after this ....
					if(debug4) log(4,"  Object Not Implemented Yet");
				break;
			}
		}
		
		public function solveURL(str:String):String{
			if(str.charAt(0)!="[") str="[root]"+str;

			while(str.indexOf("[")>=0){
				var i0=str.indexOf("[");
				var i1=str.indexOf("]");
				var pre=str.substring(i0+1,i1);
				//log(4,pre);
				str=str.substr(0,i0)+globals[pre]+str.substr(i1+1);
			}
			
			return str+(online?"?rnd="+Math.random():"");
		}
	}
}