package vjyourself4.colors{
	import vjyourself4.model.NumberRef;
	public class ColorStepper{
		
		public static var classMeta:Object=
		{
			cn:"vjyourself4.colors.ColorStepper",
			name:"ColorStepper",categories:"Color",
			desc:"",
			//////////////////////////////////////////////
			params:{},
			system:{input:{}},
			needs:{
				items:{cn:"Array"}
			},
			//////////////////////////////////////////////
			vis:{},
			data:{
				colors:{cn:"Array"}
			},
			functions:{},
			events:{}
		}
		
		public var colors:Array;
		public var length=4;
		public var input:Object;
		var colorInd=0;
		public var items:Array;
		
		function ColorStepper(){
			colors=[];
			for(var i=0;i<length;i++) colors.push( new NumberRef(0));
		}
		public function init(){
			if(input.gamepad_enabled){
				//input.gamepadManager.events.addEventListener("Gamepad0_LB",pushLB,0,0,1);
				//input.gamepadManager.events.addEventListener("Gamepad0_RB",pushRB,0,0,1);
				//input.gamepadManager.events.addEventListener("Gamepad0_A",pushA,0,0,1);
				input.gamepadManager.events.addEventListener("Gamepad0_B",pushB,0,0,1);
			}
			if(input.mkb_enabled){
				input.events.addEventListener("CLICK",onClick,0,0,1);
			}
			setColor(0);
		}
		function pushB(e=null){
			setColor((colorInd+1)%items.length);
		}
		function onClick(e){
			setColor((colorInd+1)%items.length);
		}
		function setColor(ind){
			colorInd=ind;
			var currColor=items[colorInd];
			for(var i=0;i<length;i++) colors[i].val=currColor[i];
		}
		
	}
}