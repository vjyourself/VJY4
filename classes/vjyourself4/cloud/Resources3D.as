package vjyourself4.cloud{
	import flash.geom.Vector3D;
	import flash.geom.Matrix3D;
	import flash.display.BlendMode;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.filters.BlurFilter;
	import flash.events.MouseEvent;
	import flash.utils.getDefinitionByName;
	import flash.geom.ColorTransform;
	import away3d.loaders.misc.AssetLoaderContext;
	import away3d.materials.TextureMaterial;
	import away3d.textures.BitmapTexture;
	import vjyourself4.three.assembler.AssemblerAsset3D;
	import vjyourself4.media.Music;
	import vjyourself4.two.DrawWave;
	import away3d.materials.ColorMaterial;
	import vjyourself4.patt.ColorScale;
	import flash.display.BlendMode;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.filters.BlurFilter;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	
	import flash.net.URLRequest;
	import away3d.loaders.parsers.Parsers;
	import away3d.events.AssetEvent;
	import away3d.events.LoaderEvent;
	import away3d.loaders.AssetLoader;
	import away3d.core.base.Geometry;
	import away3d.entities.Mesh;
	import away3d.tools.helpers.MeshHelper;
	import away3d.materials.lightpickers.StaticLightPicker;
	import vjyourself4.three.VideoTexture2;
	import vjyourself4.dson.ColorType;
	
	public class Resources3D{
		var assembler:AssemblerAsset3D;
		public var NS:NamespaceTree;
		public var cont:Object;
		public var music:Music;
		public var musicMaterials:Boolean=false;
		public var musicMaterials2:Boolean=false;
		public var musicMaterialDim:Number=512;
		public var videoMaterials:Object;
		public var globalBlend:String="DEF";
		public var events:EventDispatcher;
		public var baseURL:String="";
		
		public var postItems:Array;
		public var postInd:Number;
		var assetLoader:AssetLoader;

		public var mcLightPicker:StaticLightPicker = new StaticLightPicker([]);
		public var globalLightPicker:StaticLightPicker = new StaticLightPicker([]);
		public var mclp:Boolean=false;

		public function Resources3D(){
			events = new EventDispatcher();
			Parsers.enableAllBundled();
			
		}
		
		public function init(){
			if(videoMaterials==null) videoMaterials={enabled:false,videos:{}};
			assembler= new AssemblerAsset3D();
			NS = new NamespaceTree();
			NS.eval("tex");
			NS.eval("mat");
			NS.eval("geom");
			cont=NS.cont;
			
			//cont.lightPicker = new StaticLightPicker([]);
			//if(musicMaterials)
			initMusicMaterials();
			initVideoMaterials();
		}
		
		
		
		public function applyLightPicker(lp){
			globalLightPicker=lp;
			////trace("APPLY lights");
			
			for(var i in cont.mat){
				cont.mat[i].lightPicker = lp;
				////trace(i+" : "+cont.mat[i]);
			}

			//Music Color Light Picker
			if(mclp==true){
				for(var i=0;i<musicColors.length;i++){
					var mc=musicColors[i];
					cont.mat[mc.n].lightPicker = mcLightPicker;
				}
			}
			cont.lightPicker=lp;
			
		}
		public function setMCLP(v:Boolean){
			enableMCLightPicker(v);
		}
		public function toggleMCLP(){
			enableMCLightPicker(!mclp);
		}
		
		public function enableMCLightPicker(b:Boolean){
			mclp=b;
			if(globalLightPicker!=null){
				for(var i=0;i<musicColors.length;i++){
					var mc=musicColors[i];
					cont.mat[mc.n].lightPicker = mclp?mcLightPicker:globalLightPicker;
				}
			}
		}

		var blendAdd:Boolean=false;
		public function setBlendAdd(v){
			blendAdd=v;
			applyBlendMode(blendAdd?"ADD":"NORMAL");
		}
		public function toggleBlendAdd(){
			blendAdd=!blendAdd;
			applyBlendMode(blendAdd?"ADD":"NORMAL");
		}
		public function applyBlendMode(mode){
			////trace("APPLY BLEND> "+mode);
			for(var i in cont.mat){
				switch(i){
					case "MCBWADD":break;
					default:cont.mat[i].blendMode = BlendMode[mode];
				}
				
				////trace(i+" : "+cont.mat[i]);
			}
			cont.mat["MusicWaveADD"].blendMode=BlendMode.ADD;
		}
		
		public function processData(path:String,data:Object){
			var tar=NS.eval(path);
			postItems=[];
			
			for(var i in data){
				var ret;
				var name=i;
				switch(path){
					case "tex":ret=createTexture(name,data[i]);break;
					case "mat":ret=createMaterial(name,data[i]);break;
					case "geom":
						if(data[i].url!=null) postItems.push({path:path,tar:tar,code:data[i],name:i});
						else ret=createGeom(name,data[i]);
					break;
				}
				if(path=="tex"){
					tar[ret.name]=ret.objTex;
					NS.cont.mat[ret.name]=ret.objMat;
				}else {
					if(ret!=null) tar[ret.name]=ret.obj;
				}
			}
			
			if(postItems.length>0) postStart();
			return (postItems.length==0);
		}
		
		function postStart(){postInd=-1;postNext();}
		function postNext(){
			postInd++;
			if(postInd==postItems.length){
				////trace("R3D complete");
				events.dispatchEvent(new Event(Event.COMPLETE));
			}else{
				var url=baseURL+postItems[postInd].code.url;
				//url="deer.awd";
				//trace("url:"+url);
				assetLoader= new AssetLoader();
				assetLoader.addEventListener(AssetEvent.GEOMETRY_COMPLETE,geometryComplete);
				assetLoader.addEventListener(LoaderEvent.RESOURCE_COMPLETE,assetComplete);
				var ctx=new AssetLoaderContext();
				ctx.includeDependencies=false;
				assetLoader.load(new URLRequest(url),ctx);
			}
		}
		function geometryComplete(a:AssetEvent){
			var it=postItems[postInd];
			////trace("geom complte");
			//trace("type:"+a.asset.assetType);
			////trace("type:"+a.asset);
			var geom:Geometry=Geometry(a.asset);
			it.tar[it.name]=geom;
			var m = new Mesh(geom);
			if(it.code.scale!=null) MeshHelper.applyScales(m,it.code.scale,it.code.scale,it.code.scale);
			if(it.code.pos!=null){
				//trace("pos:"+it.code.pos.x+","+it.code.pos.y+","+it.code.pos.z);
				MeshHelper.applyPosition(m,it.code.pos.x,it.code.pos.y,it.code.pos.z);
				//MeshHelper.applyPosition(m,0,-60,0);
			}
		}
		function assetComplete(e:LoaderEvent){
			////trace("Asset Complte");
			assetLoader.removeEventListener(AssetEvent.GEOMETRY_COMPLETE,geometryComplete);
			assetLoader.removeEventListener(LoaderEvent.RESOURCE_COMPLETE,assetComplete);
			postNext();
		}
		
		function createMaterial(name,code){
			var obj = assembler.build(code);
			//trace("Material Created: "+name+" "+obj);
			return {name:name,obj:obj};
		}
		
		function createGeom(name,code){
			var obj = assembler.build(code);
			////trace("Geom Created: "+name+" "+obj);
			return {name:name,obj:obj};
		}
		
		public function createTexture(name,code:Object){
			var ret;
			if(code.bmpD!=null){
				if((code.mirr!=null)&&(code.mirr)) ret=createR_BmpDMirr(code);
				else ret=createR_BmpD(code);
			}
			if(code.sp!=null){
				ret=createR_Sprite(code);
			}
			return ret;
		}
		
		public function createR_BmpDMirr(code:Object){
			//var n=code.bmpD;
			//var nc=n;
			//var c:Class = getDefinitionByName(nc) as Class;
			//var oBmpD = new c();
			var oBmpD = code.bmpD;
			var oBmp = new Bitmap(oBmpD);
			var bmpD = new BitmapData(1024,1024,false);
			
			var m = new Matrix();
			bmpD.draw(oBmp,m);
			
			m.scale(-1,1);
			m.translate(1024,0);
			bmpD.draw(oBmp,m);
			
			m.scale(1,-1);
			m.translate(0,1024);
			bmpD.draw(oBmp,m);
			
			m.identity();
			m.scale(1,-1);
			m.translate(0,1024);
			bmpD.draw(oBmp,m);
			
			var objTex = new BitmapTexture(bmpD);
			var objMat = new TextureMaterial(objTex);
			objMat.repeat=true;
			////trace("TexMaterial Created: "+code.name+" : "+objMat);
			
			return {name:code.name,objMat:objMat,objTex:objTex};
			//R["mtex"+n].lightPicker = R.lightPicker;
		}
		
		public function createR_BmpD(p:Object){
			//var n=p.bmpD;
			//var cn=n;if(p.pre!=null) cn=p.pre+p.bmpD;
			var blend="NORMAL";
			if(globalBlend!="DEF") blend=globalBlend;
			if(p.blend!=null) blend=p.blend;
			
			
			//var c:Class = getDefinitionByName(cn) as Class;
			//var oBmpD = new c();
			var oBmpD = p.bmpD;
			
			var objTex = new BitmapTexture(oBmpD)
			var objMat = new TextureMaterial(objTex);
			objMat.repeat=true;
			objMat.alphaBlending=p.transparent;
			//trace("TexMaterial Created: "+p.name+" : "+objMat);
			//objMat.lightPicker = cont.lightPicker;
			switch(blend){
				case "NORMAL":break;
				case "ALPHA":objMat.alpha=0.99;break;
				case "ADD":objMat.blendMode=BlendMode.ADD;break;
				case "MULTIPLY":objMat.blendMode=BlendMode.MULTIPLY;break;
			}
			return {name:p.name,objTex:objTex,objMat:objMat};
		}
		
		public function createR_Sprite(p:Object){
			var n=p.sp;
			var nc=p.sp;
			var blend="NORMAL";
			if(globalBlend!="DEF") blend=globalBlend;
			if(p.blend!=null) blend=p.blend;
			
			
			var c:Class = getDefinitionByName("Tex"+nc) as Class;
			var sp = new c();
			var bmpD = new BitmapData(512,512,blend=="ALPHA",0x00000000);
			bmpD.draw(sp);
			var objTex = new BitmapTexture(bmpD);
			var objMat = new TextureMaterial(objTex);
			objMat.repeat=true;
			//trace("TexMaterial Created: "+n+" : "+objMat);
			//R["mtex"+n].lightPicker = R.lightPicker;
			switch(blend){
				case "NORMAL":break;
				case "ALPHA":objMat.alpha=0.99;break;
				case "ADD":objMat.blendMode=BlendMode.ADD;break;
				case "MULTIPLY":objMat.blendMode=BlendMode.MULTIPLY;break;
				
			}
			return {name:n,objTex:objTex,objMat:objMat};
		}
		
		/********************** MUSIC MATERIALS *********************************************/
		public var waveDrawMode:Number=0;
		public var waveDrawModeVary:Array=["Line","Cross","Circle"];
		public function nextWaveDrawMode(){
			waveDrawMode=(waveDrawMode+1)%waveDrawModeVary.length;
		}
		var musicColors:Array=[

			{n:"MusicColorBlack",synch:"peak",col0:0x000000,col1:0xffffff,alpha:1},

			{n:"MusicColor1",synch:"peak",col0:0x6633aa,col1:0xffffff,alpha:1},
			{n:"MusicColor2",synch:"peak",col0:0xaa0066,col1:0xffffff,alpha:1},
			{n:"MusicColor3",synch:"peak",col0:0x993399,col1:0xffffff,alpha:1},
			{n:"MCBW50",synch:"peak",col0:0x000000,col1:0xbbbbbb,alpha:1},
			{n:"MCBW100",synch:"peak",col0:0x000000,col1:0xffffff,alpha:1},
			{n:"MCBWADD",synch:"peak",col0:0x000000,col1:0xffffff,alpha:1,blend:"ADD"},
			
			{n:"Beat4_1","synch":"beat","ind":"Sin4_1",col0:0xffffff,col1:0xffffff,alpha0:0,alpha1:1},
			{n:"Beat4_2","synch":"beat","ind":"Sin4_2",col0:0xffffff,col1:0xffffff,alpha0:0,alpha1:1},
			{n:"Beat4_3","synch":"beat","ind":"Sin4_3",col0:0xffffff,col1:0xffffff,alpha0:0,alpha1:1},
			{n:"Beat4_4","synch":"beat","ind":"Sin4_4",col0:0xffffff,col1:0xffffff,alpha0:0,alpha1:1},
			{n:"Beat1A","synch":"beat","ind":"ASR4_1",col0:0x444444,col1:0xffffff,alpha0:0.2,alpha1:1},
			{n:"Beat2A","synch":"beat","ind":"ASR4_2",col0:0x444444,col1:0xffffff,alpha0:0.2,alpha1:1},
			{n:"Beat3A","synch":"beat","ind":"ASR4_3",col0:0x444444,col1:0xffffff,alpha0:0.2,alpha1:1},
			{n:"Beat4A","synch":"beat","ind":"ASR4_4",col0:0x444444,col1:0xffffff,alpha0:0.2,alpha1:1},
			{n:"Beat2_1A","synch":"beat","ind":"ASR2_1",col0:0xffffff,col1:0xffffff,alpha0:0,alpha1:1},
			{n:"Beat2_2A","synch":"beat","ind":"ASR2_2",col0:0xffffff,col1:0xffffff,alpha0:0,alpha1:1},
			
			//{n:"mc1ma",col0:0x6633aa,col1:0xffffff,alpha:0.7},
			//{n:"mc2ma",col0:0xaa0066,col1:0xffffff,alpha:0.7},
			//{n:"mc3ma",col0:0x993399,col1:0xffffff,alpha:0.7}
		];
		
		public var bmpDWave:BitmapData;
		public var bmpDWave2:BitmapData;
		var compDrawWave:DrawWave;
		var musicWaveTexture:BitmapTexture;
		var musicWaveTexture2:BitmapTexture;
		var mmm1:Matrix;
		var mmm2:Matrix;
		public function setParamsMM(mm){
			if(mm.drawWave!=null) for(var i in mm.drawWave) switch(i){
				case "fillColor":
				case "lineColor0":
				compDrawWave[i]=ColorType.toNumber(mm.drawWave[i]);
				break;
				default:
				compDrawWave[i]=mm.drawWave[i];
			}
		}
		function initMusicMaterials(){
			for(var i=0;i<musicColors.length;i++){
				var mc=musicColors[i];
				mc.colorScale = new ColorScale();
				mc.colorScale.colors=[mc.col0,mc.col1];
				mc.mat = new ColorMaterial(mc.col0);
				if(mc.alpha!=null) mc.mat.alpha=mc.alpha;
				if(mc.blend!=null) mc.mat.blendMode=BlendMode[mc.blend];
				//mc.mat.lightPicker = R.lightPicker;
				cont.mat[mc.n]=mc.mat;
			}
			
			// DRAW
			compDrawWave= new DrawWave();
			compDrawWave.baseCurve="line";
			compDrawWave.waveData=music.meta.waveDataDamped;
			compDrawWave.wDimX=musicMaterialDim;
			compDrawWave.wDimY=musicMaterialDim;
			compDrawWave.doStars=false;
			compDrawWave.doLine=true;
			compDrawWave.doFill=false;
			compDrawWave.fillColor=0xffffff;
			compDrawWave.lineColor0=0xffffff;
			compDrawWave.lineT0=3;
			compDrawWave.init();

			mmm1 = new Matrix();
			mmm1.translate(musicMaterialDim/2,musicMaterialDim/2);
			mmm2 = new Matrix();
			mmm2.rotate(Math.PI/2);
			mmm2.translate(musicMaterialDim/2,musicMaterialDim/2);

			bmpDWave = new BitmapData(musicMaterialDim,musicMaterialDim,false,0x000000);
			musicWaveTexture=new BitmapTexture(bmpDWave);
			cont.mat["MusicWaveADD"] = new TextureMaterial(musicWaveTexture);
			cont.mat["MusicWaveADD"].repeat=true;
			cont.mat["MusicWaveADD"].blendMode=BlendMode.ADD;
			cont.mat["MusicWave"] = new TextureMaterial(musicWaveTexture);
			cont.mat["MusicWave"].repeat=true;
			
			if(musicMaterials2){
				bmpDWave2 = new BitmapData(musicMaterialDim,musicMaterialDim,false,0x000000);
			musicWaveTexture2=new BitmapTexture(bmpDWave2);
			cont.mat["MusicWaveADD2"] = new TextureMaterial(musicWaveTexture2);
			cont.mat["MusicWaveADD2"].repeat=true;
			cont.mat["MusicWaveADD2"].blendMode=BlendMode.ADD;
			}
			
		}
		
		function initVideoMaterials(){
			for(var i in videoMaterials.videos){
				var t = new VideoTexture2(baseURL+videoMaterials.videos[i],512,512,true,true);
				var m = new TextureMaterial(t);
				cont.mat[i]=m;
			}
		}
		public function onEF(e){
			
			//MUSIC COLORS
			if(musicMaterials){
			for(var i=0;i<musicColors.length;i++){
				var mc=musicColors[i];
				switch(mc.synch){
					case "peak":
					//mc.col = mc.colorScale.getColor(music.meta.peak);
					mc.col = mc.colorScale.getColor(music.meta.mixer.A["peak"].val);
					mc.mat.color=mc.col;
					break;
					case "beat":
					mc.col = mc.colorScale.getColor(music.meta.beat.A[mc.ind].val);
					mc.mat.alpha=mc.alpha0+(mc.alpha1-mc.alpha0)*music.meta.beat.A[mc.ind].val; //0.3+music.meta.beat.chA[mc.ind].val*0.7; //mc.colorScale.getColor(music.meta.beat.chA[mc.ind].val);
					mc.mat.color=mc.col;
					
					break;
				}
			}
			////trace("PEKA:"+music.meta.peak);
			//MUSIC WAVE
			switch(waveDrawMode){
				// Line / Cross
				case 0:
				case 1:
				//compDrawWave.doStars=false;
				//compDrawWave.doLine=true;
				//compDrawWave.doFill=false;
				compDrawWave.baseCurve="line";
				break;
				case 2:
				//compDrawWave.doStars=true;
				//compDrawWave.doLine=false;
				//compDrawWave.doFill=false;
				compDrawWave.baseCurve="circle";
				break;
			}
		
			compDrawWave.onEF();
			

			//bmpDWave.fillRect(bmpDWave.rect, 0);
			bmpDWave.draw(compDrawWave.canvas,mmm1);
			if(waveDrawMode==1) bmpDWave.draw(compDrawWave.canvas,mmm2);
			bmpDWave.applyFilter(bmpDWave,bmpDWave.rect,new Point(0,0),new BlurFilter());
			var cmul=0.8;
			bmpDWave.colorTransform(bmpDWave.rect,new ColorTransform(cmul,cmul,cmul,1,0,0,0,0));
			musicWaveTexture.invalidateContent();

			/*
			if(musicMaterials2){
				//bmpDWave2.fillRect(bmpDWave2.rect, 0);
			//bmpDWave2.draw(compDrawWave.canvas,mmm1);
			bmpDWave2.draw(compDrawWave.canvas,mmm2);
			//bmpDWave2.applyFilter(bmpDWave2,new Rectangle(0,0,512,512),new Point(0,0),new BlurFilter());
			var cmul=0.95;
			bmpDWave2.colorTransform(bmpDWave2.rect,new ColorTransform(cmul,cmul,cmul,1,0,0,0,0));
			musicWaveTexture2.invalidateContent();
			}*/
			}

		}
	}
}