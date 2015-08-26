package vjyourself2.media{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.net.FileReference;
	import flash.net.FileFilter;
	import flash.events.Event;

	public class JukeBox extends MovieClip{
		public var radios=[
			{name:"Frisky Radio - feelin' frisky? [Deep House, Progressive]",title:"Frisky Radio",url:"http://scfire-dtc-aa01.stream.aol.com:80/stream/1015"},
			{name:"Soma FM - a nicely chilled plate of ambient beats",title:"Soma FM",url:"http://scfire-ntc-aa02.stream.aol.com:80/stream/1018"},
			{name:"SKY.FM - absolutely smooth JAZZ",title:"SKY.FM - Smooth Jazz",url:"http://stream-200.shoutcast.com:80/smoothjazz_skyfm_mp3_96kbps"},
			{name:"Musik House - Funky, Pop, House",title:"Musik House (Funky)",url:"http://stream-03.shoutcast.com:8006/musik_house_mp3_128kbps"},
			];
		public var music:Music;
		public var title:String="";
		var fileReference:FileReference;
		
		function JukeBox(){
			fileReference= new FileReference();
			fileReference.addEventListener(Event.SELECT,fileReference_OnSelect);
		}
		public function init(){
			
			//playRadio({ind:Math.floor(Math.random()*(radios.length-1))});
			openURL("test.mp3","Intro Music");
		}
		
		//play Radio
		public function playRadio(p:Object){
			if(p.ind!=null){
				music.extract=true;
				music.play({url:radios[p.ind].url});
				title=radios[p.ind].title;
			}
		}
			
		//open URL
		public function openURL(url,tt){
			if(tt==null) title=url;
			else title=tt;
			music.extract=false;
			music.play({url:url});
		}
		
		//open local MP3
		public function openMP3(){fileReference.browse([new FileFilter("mp3 files","*.mp3")]);title="mp3"}
		function fileReference_OnSelect(e){
			music.extract=false;
			music.play({fileReference:fileReference});
		}
		
		//use Mic
		public function useMic(){title="Microphone"}
	}
}