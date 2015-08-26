package vjyourself4.media{
	import org.audiofx.mp3.MP3FileReferenceLoader;
	import org.audiofx.mp3.MP3SoundEvent;
	import flash.events.EventDispatcher;
	import flash.events.Event;

	public class SoundResource{
		import flash.media.Sound;
		import flash.net.URLRequest;
		import flash.utils.getDefinitionByName;
//		public var classHandler:Object;

		var fRLoader : MP3FileReferenceLoader;
		public var snd:Sound;
		public var events:EventDispatcher = new EventDispatcher();
		public function SoundResource(){
			fRLoader=new MP3FileReferenceLoader();
			fRLoader.addEventListener(MP3SoundEvent.COMPLETE,mp3LoaderCompleteHandler);
		}
		public function getResource(p:Object){
			var sndReady=false;
			//if(p.srcClassInfo!=null){var c:Class = p.srcClassInfo.classHandler.getDefinition(p.srcClassInfo);snd= new c();sndReady=true;}
			if((p.srcCN!=null)&&(p.srcCN!="")){var c:Class = getDefinitionByName(p.srcCN) as Class;snd = new c();sndReady=true;}
			if(p.srcC!=null){snd = p.srcC();sndReady=true;}
			if(p.srcO!=null){snd = p.srcO;sndReady=true;}
			if(p.srcURL!=null){snd = new Sound(); snd.load(new URLRequest(p.srcURL));sndReady=true;};
			if(p.url!=null){snd = new Sound(); snd.load(new URLRequest(p.url));sndReady=true;};
			if(p.srcURLR!=null){snd = new Sound(); snd.load(p.srcURLR);sndReady=true;};
			if(p.fileReference!=null){fRLoader.getSound(p.fileReference);}
			
			if(sndReady){
				trace("return:"+snd);
				snd.addEventListener(Event.ID3,onID3,0,0,1);
				events.dispatchEvent(new Event(Event.COMPLETE));
			}
			//return snd;
		}
		private function mp3LoaderCompleteHandler(ev:MP3SoundEvent):void
		{
			snd=ev.sound;
			events.dispatchEvent(new Event(Event.COMPLETE));
		}
		function onID3(e){
			trace("ID3");
			trace(snd.id3);
			trace(snd.id3.songName+" : "+snd.id3.artist+" : "+snd.id3.album);
		}
	}
}