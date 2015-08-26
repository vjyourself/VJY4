package vjyourself4.cloud{
	public class DBHandler{
		public var cont:Object={};
		public var lastName:String="";
		var cloud:Cloud;
		public function DBHandler(){
			cont={
				artists:[
						 //{"n":"Empty","name":"Empty"}
						 ]
			}
			
		}
		public function log(level,msg){cloud.log(level,msg);}
		public function processData(dd,url){
			switch(dd.type){
				case "Theme":
				var wurl="images/";
				var dR3D=[];
				var dC3D={};
				var cycle=[{}];dC3D[dd.name]=cycle;
				var texts=dd.data.textures;
				for(var i=0;i<texts.length;i++){
					var cn=dd.name+"_"+wname+(i+1);
					dR3D.push(texts[i]);
					cycle.push(texts[i].name);
					log(1,"process work"+i);
				}
				cloud.addPackage({data:{name:"Tex"+dd.name,target:"R3D",path:"tex",cloud2:true,images:wurl,data:dR3D}});
				cloud.addPackage({data:{name:"TexCycle"+dd.name,target:"C3D",data:dC3D}});
				lastName=dd.name;
				break;
				
				case "Artist":
				if(dd.name==null){
					dd.name=url.substring(0,url.lastIndexOf("/"));
					dd.name=dd.name.substring(dd.name.lastIndexOf("/")+1);
				}
				log(1," DB Artist : "+dd.name);
				lastName=dd.name;
				dd.data.artist.n=dd.name;
				cont.artists.push(dd.data.artist);
				
				//generate works cycle + textures
				var wnum=dd.data.works.num;
				var wname=dd.data.works.name;
				var wurl;
				if(dd.data.works.url!=null) wurl=dd.data.works.url
				else wurl=url.substring(0,url.lastIndexOf("/")+1);
				var dR3D=[];
				var dC3D={};
				var cycle=[{}];dC3D[dd.name]=cycle;
				for(var i=0;i<wnum;i++){
					var cn=dd.name+"_"+wname+(i+1);
					dR3D.push({file:wname+(i+1)+".jpg",mirr:false,name:cn});
					cycle.push(cn);
					log(1,"process work"+i);
				}
				cloud.addPackage({data:{name:"Tex"+dd.name,target:"R3D",path:"tex",images:wurl,data:dR3D}});
				cloud.addPackage({data:{name:"TexCycle"+dd.name,target:"C3D",data:dC3D}});
				
				break;
				
				case "Group":
				break;
				case "Univers":
				break;
			}
		}
		public function eval(path:String):Object{
			var pp=path.split(".");
			var tar=cont;
			
			for(var i=0;i<pp.length;i++){
				if(tar[pp[i]]==null)tar[pp[i]]={};
				tar=tar[pp[i]];
			}
			
			return tar;
		}
	}
}