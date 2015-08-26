/*
	MAIN LISTINGS
	spaces / RPrg / CPrg
	themes / R3D / C3D
	skyboxes
	paths
	colors / CCol
	lights / RLights
	filters / RFilters
	scenes / RScenes
	timelines / RTimelines

	presets - general preset namespace
*/
package vjyourself4.cloud{
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.events.Event;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.net.URLLoaderDataFormat;
	import flash.utils.getDefinitionByName;
	import flash.system.LoaderContext;
	import flash.system.ApplicationDomain;
	import flash.events.ProgressEvent;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import vjyourself4.sys.MetaStream;
	import com.adobe.serialization.json.*;
	import vjyourself4.media.Music;

	public class Cloud{
		public var _debug:Object;
		public var _meta:Object={name:"Cloud"};
		public function setDLevels(l1,l2,l3,l4){dLevels=[l1,l2,l3,l4];}
		var dLevels:Array=[true,true,false,false];
		function log(level,msg){if(dLevels[level-1])_debug.log(this,level,msg);}
		
		

		public var music:Music;
		
		public var events:EventDispatcher;
		public var ready=false;
		public var urlRnd:Boolean=false;
		
		///////new
		public var context:LoaderContext;
		public var baseURL:String="cloud/";

		/*
		packages:
		-url : file to load
		-src : file loaded
		-data : package data : static data or data from file
		-cont : swf container if loaded
		*/
		// url -> src -> data
		public var packages:Array=[];
		var pInit:Object;
		public var packagesNS:Object={};
		public var packagesInd:Number=-1;
		var urlLoader:URLLoader;
		var contLoader:Loader;
		var imagesLoader:Loader;
		var imagesInd:Number=0;
		
		public var res:Object;
		public var resSrc:String=""; // online - local
		// GLOBAL DB
		public var DB:DBHandler;
		
		// Spaces
		public var RPrg:ResourcesPrg;
		public var CPrg:Cycles;
		public var spaces:Array;
		public var spacesG:Array;
		public var spacesMap:Array=[];
		public var spacesP:Array; // all spaces files :: for total reload

		//Paths
		public var paths:Array=[];

		// 3D
		public var R3D:Resources3D;
		public var C3D:Cycles;
		public var themes:Array;
		public var skyboxes:Array;

		// Colors
		public var CCol:Cycles;
		public var colors:Array;

		//Lights
		public var RLights:ResSimple;
		public var lights:Array;

		//Filters
		public var RFilters:ResSimple;
		public var filters:Array;

		//Blend
		public var blends:Array=[];

		// Scenes
		public var RScenes:ResSimple;
		public var scenes:Array=[];

		// Timelines
		public var RTimelines:ResSimple;
		public var timelines:Array=[];

		// Presets
		public var presets:Presets;
		
		
		public var cont:Object={};
		
		
		
		public function Cloud(){
			events= new EventDispatcher();

		}
		
		public function init(p:Object=null){
			log(1,"init");
			pInit=p;
			packagesInd=-1;
			if(p.baseURL!=null)baseURL=p.baseURL;
			
			//DB - General DB
			DB = new DBHandler();
			DB.cloud = this;

			//////////////////////////////////////////////////////////////////////////////////////////////
			
			//SPACES
			RPrg = new ResourcesPrg();
			CPrg = new Cycles();
			spaces=[];
			spacesMap=[]; // obsolete
			spacesG=[];

			//TEXTURES / THEMES / GEOM - 3D Resources
			R3D = new Resources3D();
			R3D.music=music;
			R3D.baseURL=baseURL;
			R3D.events.addEventListener(Event.COMPLETE,R3DProcessComplete,0,0,1);
			if(pInit.R3D!=null) for(var i in pInit.R3D) R3D[i]=pInit.R3D[i];
			R3D.init();
			C3D = new Cycles();
			C3D.name="Cyc3D";
			themes=[];
			skyboxes=[];

			//COLORS
			CCol = new Cycles();
			CCol.name="CycColor";
			colors=[];

			//LIGHTS
			RLights = new ResSimple();
			RLights.name="ResLights";
			lights=[];

			//FILTERS
			RFilters = new ResSimple();
			RFilters.name="ResFilters";
			filters=[];

			////////////////////////////////////////////////////////////////////////////////////////

			//SCENES
			RScenes = new ResSimple();
			RScenes.name="ResScenes";
			scenes=[];

			//TIMELINES
			RTimelines = new ResSimple();
			RTimelines.name="ResTimeline";
			timelines=[];

			////////////////////////////////////////////////////////////////////////////////////////////

			//PRESETS
			presets = new Presets();

			////////////////////////////////////////////////////////////////////////////////////////////

			urlLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE,urlLoader_COMPLETE,0,0,1);
			contLoader = new Loader();
			contLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,contLoader_COMPLETE,0,0,1);
			contLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,contLoader_PROGRESS,0,0,1);
			imagesLoader = new Loader();
			imagesLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,imagesLoaderComplete,0,0,1);
			log(1,"collect resources..."); 
			
			
			/***************************************************************************************
			    Resources -> files
			****************************************************************************************/
			if(p.resources==null) p.resources={textures:{themes:[]},spaces:[],colors:[],lights:[],filters:[],scenes:[]};
			res=p.resources;
			resSrc=p.src;
			if(resSrc=="online") urlRnd=true;
			//Not in DB at all :: skyboxes
			if(res.skyboxes!=null) for(var i=0;i<res.skyboxes.length;i++)skyboxes.push({name:res.skyboxes[i]});
			if(res.paths!=null) for(var i=0;i<res.paths.length;i++) paths.push({name:res.paths[i]});
			//No DB filtering yet :: skyboxes / lights / filters
			if(res.colors!=null) for(var i=0;i<res.colors.length;i++)colors.push({name:res.colors[i]});
			if(res.lights!=null) for(var i=0;i<res.lights.length;i++)lights.push({name:res.lights[i]});
			if(res.filters!=null) for(var i=0;i<res.filters.length;i++)filters.push({name:res.filters[i]});
			if(res.blends!=null) for(var i=0;i<res.blends.length;i++)blends.push({name:res.blends[i]});
			var fff = getPackageFiles(p.resources);
			for(var i=0;i<fff.length;i++)p.all.includes.push(fff[i]);
			

			/*****************************************************************************************
				START TO PROCESS PACKAGES
			*******************************************************************************************/
			log(1,"load packages");
			//Process files
			if(p.all!=null){
				packages.push({src:p.all});
				packagesStartNext();
			}else{
				if(p.packages!=null){
					for(var i=0;i<p.packages.length;i++){
						if(p.packages[i].data!=null){
							packages.push({data:p.packages[i].data});
						}
					
						if(p.packages[i].url!=null){
							packages.push({url:p.packages[i].url});
						}
					}
					packagesStartNext();
				}else{
					packages_COMPLETE();
				}
			}
		}
		
		public function getPackageFiles(res){
			var fff=[];
			var list;

			//Spaces
			spacesP=[];
			if(res.spaces!=null){
				var grp=res.spaces;
				for(var i in grp){
					var grpE={name:i,e:[]};
					list=grp[i];
					for(var ii=0;ii<list.length;ii++){
						grpE.e.push({name:"Prg"+list[ii]});
						spaces.push({name:"Prg"+list[ii],prg:"Prg"+list[ii]});
						//spacesMap.push(RPrg.cont.programs.path["Prg"+list[ii]]);
						if(resSrc=="online"){
							//fff.push("spaces/export.php?name="+list[ii]);
							fff.push("programs/path/Prg"+list[ii]+".json");
							spacesP.push("programs/path/Prg"+list[ii]+".json");
						}else{
							fff.push("programs/path/Prg"+list[ii]+".json");
							spacesP.push("programs/path/Prg"+list[ii]+".json");
						}
					}
					spacesG.push(grpE);
				}
			}
		
			//Textures
			if(res.textures!=null){
			//Texture themes
			if(res.textures.themes!=null){
			list=res.textures.themes;
			for(var i=0;i<list.length;i++){
				if(resSrc=="online"){
					fff.push("images/textures.php?tag="+escape(list[i]));
					fff.push("images/themes.php?tag="+escape(list[i]));
				}else{
					var nn=list[i];nn=nn.replace(",","_");nn=nn.replace("#","Ser_");
					fff.push("images/textures_"+nn+".json");
					fff.push("images/themes_"+nn+".json");
				}
			}
			}
			//Texture quries
			if(res.textures.queries!=null){
			list=res.textures.queries;
			for(var i=0;i<list.length;i++){
				if(resSrc=="online"){
					fff.push("images/texNcyc.php?q="+JSON.stringify(list[i]));
				}else{
					fff.push("images/texNcyc_"+list[i].name+".json");
				}
			}
			}

			}
			
			//Colors
			if(res.colors!=null){
				if(res.colors.length>0){
					if(resSrc=="online"){
						fff.push("colors/export.php?q=all");
					}else{
						fff.push("colors/colors.json");
					}
				}
			}

			//Lights
			if(res.lights!=null){
				if(res.lights.length>0){
					if(resSrc=="online"){
						fff.push("lights/lights.json");
						fff.push("lights/presets.json");
					}else{
						fff.push("lights/lights.json");
						fff.push("lights/presets.json");
					}
				}
			}

			//Filters
			if(res.filters!=null){
				if(res.filters.length>0){
					if(resSrc=="online"){
						fff.push("filters/filters.json");
						//fff.push("lights/presets.json");
					}else{
						fff.push("filters/filters.json");
						//fff.push("lights/presets.json");
					}
				}
			}

			//Scenes
			if(res.scenes!=null){
			list=res.scenes;
			for(var i=0;i<list.length;i++){
				if(resSrc=="online"){
					fff.push("scenes/"+list[i]+".json?rnd="+Math.random());
				}else{
					fff.push("scenes/"+list[i]+".json");
				}
			}
			}

			//Timelines
			if(res.timelines!=null){
			list=res.timelines;
			for(var i=0;i<list.length;i++){
				if(resSrc=="online"){
					fff.push("timelines/timelines_"+list[i]+".json?rnd="+Math.random());
				}else{
					fff.push("timelines/timelines_"+list[i]+".json");
				}
			}
			}

			return fff;
		}
		public function reload(){
			init(pInit);
		}
		public function loadPackage(p){
			//p.url p.src
			packagesInd=-1;
			packages=[];
			packages.push(p);
			packagesStartNext();
		}
		function packagesStartNext(){
			packagesInd++;
			if(packagesInd<packages.length){
				//URL or DATA
				//log(2,"*****************************************************************************"); 
				if(packages[packagesInd].url!=null){
					log(2,"load "+packages[packagesInd].url); 
					var bURL=baseURL;//if(packages[packagesInd].cloud2)bURL=baseURL2;
					var url=bURL+packages[packagesInd].url;
					if(urlRnd) url+=((url.indexOf("?")<0)?"?":"&")+"rnd="+Math.random();
					urlLoader.load(new URLRequest(url));
				}else{
					if(packages[packagesInd].src!=null){
						log(2,"load data ( "+packages[packagesInd].src+" )"); 
						processPackageSource();
					}
				}
			}else{
				packages_COMPLETE();
			}
		}
		public function addPackage(pp){
			log(4,"include package DATA: "+pp);
			this.packages.push({src:pp});
		}
		function urlLoader_COMPLETE(e){
			log(4,"package DATA loaded");
			var pack=new JSONDecoder( urlLoader.data,false ).getValue();
			//trace("pack:"+new JSONEncoder(pack).getString());
			packages[packagesInd].src=pack;
			processPackageSource();
		}
		function processPackageSource(){
			var pack=packages[packagesInd];
			var src=packages[packagesInd].src
			//push includes
			if(src.includes!=null){
				log(4,"process includes");
				for(var i=0;i<src.includes.length;i++){
					var oo={url:src.includes[i]};
					if(src.includesPath!=null) oo.path=src.includesPath;
					packages.push(oo);
					log(4,"process include: "+src.includes[i]);
				}
			}
			
			//process data
			if(src.data!=null){
				//if multi data
				if(src.data is Array){
					pack.data=src.data[0];
					for(var i=1;i<src.data.length;i++) addPackage({data:src.data[i]});
				} else pack.data=src.data;
				if(pack.path!=null) pack.data.path=pack.path;
				log(4,"data name: "+pack.data.name);
				if(pack.data.cont!=null)log(4,"data cont: "+pack.data.cont);
				log(4,"data target: "+pack.data.target);
				if(pack.data.path!=null)log(4,"data path: "+pack.data.path);
				//packagesNS[packages[packagesInd].data.name]=packages[packagesInd];
				processPackage();
			}else{
				packagesStartNext();
			}
		}
		
		function processPackage(){
			//cont needed
			if(packages[packagesInd].data.cont!=null){
				contLoader.load(new URLRequest(baseURL+packages[packagesInd].data.cont),context);
			}else{
				if(packages[packagesInd].data.images!=null){
					imagesStart();
				}else{
					if(packages[packagesInd].data.path=="tex") processClasses();
					processPackage2();
				}
			}
		}
		
		// ************* LOADING CONT ***************************************************
		function contLoader_PROGRESS(e:ProgressEvent){
			log(4,"progress "+Math.round(contLoader.contentLoaderInfo.bytesLoaded/contLoader.contentLoaderInfo.bytesTotal*100)+"%");
		}
		function contLoader_COMPLETE(e){
			log(2,"package CONT loaded");
			packages[packagesInd].cont=contLoader.content;
			processClasses();
			processPackage2();
		}
		
		function processClasses(){
			//process classes
			var data=packages[packagesInd].data.data;
			for(var i in data){
				var dd=data[i];
				//trace(i+":"+dd+" bmpD:"+dd.bmpD);
				//bitmap
				if(dd.sp==null){
					if(dd.file==null) {dd.file=dd.bmpD;dd.bmpD=null;} //backwards compatibility
					var cn=dd.file;if(cn.lastIndexOf(".")>0) cn=cn.substring(0,cn.lastIndexOf("."));
					if(dd.pre!=null) cn=dd.pre+cn;
					var c= getDefinitionByName(cn) as Class;
					dd.bmpD= new c();
					dd.name=cn;
				}else{
					dd.name=dd.sp;
				}
			}
		}
		// ************ LOADING IMAGES *****************************************************
		function imagesStart(){
			log(2,"Loading Images from: "+packages[packagesInd].data.images);
			imagesInd=-1;
			imagesLoadNext();
		}
		function imagesLoadNext(){
			imagesInd++;
			if(imagesInd==packages[packagesInd].data.data.length){
				imagesComplete();
			}else{
				log(2,"Load "+packages[packagesInd].data.data.length+"/"+(imagesInd+1)+" : "+packages[packagesInd].data.data[imagesInd].file);
				var bURL=baseURL;//if(packages[packagesInd].data.cloud2)bURL=baseURL2;
				imagesLoader.load(new URLRequest(bURL+packages[packagesInd].data.images+packages[packagesInd].data.data[imagesInd].file));
			}
		}
		function imagesLoaderComplete(e){
			//var bmpD = new BitmapData(imagesLoader.content.width,imagesLoader.content.height,true,0);
			//bmpD.draw(imagesLoader.content);
			var bmp:Bitmap=imagesLoader.content as Bitmap;
			var bmpD=bmp.bitmapData;
			packages[packagesInd].data.data[imagesInd].bmpD=bmpD;
			packages[packagesInd].data.data[imagesInd].transparent=false;
			var filename:String=packages[packagesInd].data.data[imagesInd].file;
			
			if(filename.substr(-3)=="png") packages[packagesInd].data.data[imagesInd].transparent=true;
			if(packages[packagesInd].data.data[imagesInd].name==null){
				var cn=filename;
				if(cn.lastIndexOf(".")>0) cn=cn.substring(0,cn.lastIndexOf("."));
				packages[packagesInd].data.data[imagesInd].name=cn;
			}

			log(4,"this image DONE");
			imagesLoadNext();
		}
		function imagesComplete(){
			log(4,"Images DONE");
			processPackage2();
		}
		
		// **************************************************************************************
		// ************* PROCESS #2 ***********************************************************
		// *************************************************************************************
		function processPackage2(){
			var ready=false;
			switch(packages[packagesInd].data.target){
				case "DB":DB.processData(packages[packagesInd].data,packages[packagesInd].url);ready=true;break;
				
				case "RPrg":RPrg.processData(packages[packagesInd].data.path,packages[packagesInd].data.data);ready=true;break;
				case "CPrg":CPrg.add(packages[packagesInd].data.data);ready=true;break;

				case "R3D":ready=R3D.processData(packages[packagesInd].data.path,packages[packagesInd].data.data);break;
				case "C3D":C3D.add(packages[packagesInd].data.data);ready=true;break;
				
				case "CCol":CCol.add(packages[packagesInd].data.data);ready=true;break;
				case "RLights":RLights.add(packages[packagesInd].data.path,packages[packagesInd].data.data);ready=true;break;
				case "RFilters":RFilters.add(packages[packagesInd].data.path,packages[packagesInd].data.data);ready=true;break;

				case "RScenes":RScenes.add(packages[packagesInd].data.path,packages[packagesInd].data.data);ready=true;break;
				case "RTimelines":RTimelines.add(packages[packagesInd].data.path,packages[packagesInd].data.data);ready=true;break;

				case "presets":presets.add(packages[packagesInd].data.path,packages[packagesInd].data.data);ready=true;break;
			}
			if(ready) packagesStartNext();
		}
		function R3DProcessComplete(e){
			packagesStartNext();
		}
		
		function packages_COMPLETE(e=null){
				
				//Spaces
				// GENERATED AT FILE INJECTION
				spacesMap=[];
				var pathprgs=RPrg.cont.programs.path;
				for(var i in pathprgs){
					switch(i){
						default:
			
						spacesMap.push(RPrg.cont.programs.path[i]);
					}
				}
				
				//Colors
				if((colors.length>0)&&(colors[0].name=="*")){
					colors=[];
					for(var i in CCol.NS){
						switch(i){
							default:
							el={name:i,cycN:i};
							colors.push(el);
							//trace("Found Color> "+i);
						}
					}
				}

				//Lights
				if((lights.length>0)&&(lights[0].name=="*")){
					lights=[];
					for(var i in RLights.NS){
						switch(i){
							default:
							el={name:i,cycN:i};
							lights.push(el);
							//trace("Found Lights> "+i);
						}
					}
				}

				//Filters
				if((filters.length>0)&&(filters[0].name=="*")){
					filters=[];
					for(var i in RFilters.NS){
						switch(i){
							default:
							el={name:i,cycN:i};
							filters.push(el);
							//trace("Found Filters> "+i);
						}
					}
				}

				//Scenes
				scenes=[];
				for(var i in RScenes.NS){
					switch(i){
						default:
						var lll=true;
						if(RScenes.NS[i].listed!=null) lll=RScenes.NS[i].listed;
						if(lll){
							el={name:i};
							scenes.push(el);
							//trace("Found Scene> "+i);
						}
					}
				}
				scenes.sortOn("name");

				//Timelines
				timelines=[];
				for(var i in RTimelines.NS){
					switch(i){
						default:
						el={name:i};
						timelines.push(el);
						//trace("Found Timeline> "+i);
					}
				}
				
			if(!ready){
				//all packages loaded, calculate metas
				
				
				var el:Object;
				//themes from artists
				if(DB.cont.artists.length>0){
					var art=DB.cont.artists;
					for(var i=0;i<art.length;i++){
						el={code:art[i].n,meta:{name:art[i].name,colcode:art[i].code}};
						//trace("FOUND :"+el.code+" "+el.meta.name+" "+el.meta.colcode);
						themes.push(el);
					}
				//themes from cycles
				}else{
					for(var i in C3D.NS){
					switch(i){
						case "multiA":
						case "multiB":
						case "Empty":
						case "empty":
						break;
						default:
						//trace("THEME: "+i);
						el={code:i,name:i};
						if(C3D.NS[i][0].meta!=null){
							el.meta=C3D.NS[i][0].meta;
							//trace("FOUND :"+el.meta.name+" "+el.meta.colcode);
						}else{
							el.meta={name:i,colcode:""};
						}
						themes.push(el);
						}
					}
				}
				
				cont.light={l:lights,e:RLights.NS,m:RLights}
				cont.filter={l:filters,e:RFilters.NS,m:RFilters}
				cont.scene={l:scenes,e:RScenes.NS,m:RScenes}
				cont.color={l:colors,e:CCol.NS,m:CCol}
				cont.texture={l:themes,e:R3D.NS,m:R3D}
				cont.spaceG={l:spacesG,e:spaces};
				
				//first init
				log(1,"COMPLETE");
				ready=true;
				events.dispatchEvent(new Event(Event.COMPLETE));
			}else{
				log(1,"PACKAGE COMPLETE");
				events.dispatchEvent(new Event("PACKAGE_COMPLETE"));
			}
			
		}
		public function themeColcodeToInd(colcode:String):int{
			var ret=-1;
			for(var i=0;i<themes.length;i++) if(themes[i].meta.colcode==colcode) ret=i;
			//trace(colcode+" -> "+ret);
			return ret;
		}
		public function onEF(e){
			R3D.onEF(e);
		}
	}
}