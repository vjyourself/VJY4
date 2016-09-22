﻿package vjyourself4.comp{
    public class CompFlipFlowMaps{
        
        public static var maps:Object={
            Afro1:{
                    name:"Afro",
                    thumbMC:"ThumbB",
                    titleMC:"TitleLeoStripe",
                    clearAtStart:false,
                    drawScale:1,
                    drawScaleMobile:1,
                    filter:{
                        type:"ColorAdjust",
                        delay:1,
                        params:{
                            brightness:-4,
                            contrast:0,
                            hue:-3,
                            hueAni:{enabled:false},
                            saturation:0
                        }
                    },
                    blur:{enabled:true,val:3},
                    glitchEffect:false,
                    shiftEffect:{enabled:false,x:0,y:0},
                    layers:[
                    {cn:"MapAfroTextile1",dimX:3000,dimY:2000,mul:1,scale:1,alpha:1},
                        
                    {cn:"MapAfroDance",dimX:3000,dimY:2000,mul:1,scale:1,alpha:1},
                    {cn:"MapWavesBRed",dimX:3000,dimY:2000,mul:0.5,scale:1,alpha:1},
                        
                    ],
                    baseMap:{
                        enabled:false
                    }
                },
                Afro2:{
                    name:"Afro",
                    thumbMC:"ThumbB",
                    titleMC:"TitleLeoStripe",
                    clearAtStart:false,
                    drawScale:1,
                    drawScaleMobile:1,
                    filter:{
                        type:"ColorAdjust",
                        delay:1,
                        params:{
                            brightness:-4,
                            contrast:0,
                            hue:-3,
                            hueAni:{enabled:false},
                            saturation:0
                        }
                    },
                    blur:{enabled:true,val:3},
                    glitchEffect:false,
                    shiftEffect:{enabled:false,x:0,y:0},
                    layers:[
                    {cn:"MapAfroTextile2",dimX:3000,dimY:2000,mul:1,scale:1,alpha:1},
                        
                    {cn:"MapAfroCirc",dimX:3000,dimY:2000,mul:1,scale:1,alpha:1},
                   // {cn:"MapWavesBRed",dimX:3000,dimY:2000,mul:0.5,scale:1,alpha:1},
                        
                    ],
                    baseMap:{
                        enabled:false
                    }
                },
                Afro3:{
                    name:"Afro",
                    thumbMC:"ThumbB",
                    titleMC:"TitleLeoStripe",
                    clearAtStart:false,
                    drawScale:1,
                    drawScaleMobile:1,
                    filter:{
                        type:"ColorAdjust",
                        delay:1,
                        params:{
                            brightness:-4,
                            contrast:0,
                            hue:-3,
                            hueAni:{enabled:false},
                            saturation:0
                        }
                    },
                    blur:{enabled:true,val:3},
                    glitchEffect:false,
                    shiftEffect:{enabled:false,x:0,y:0},
                    layers:[
                    {cn:"MapAfroMudeka",dimX:3000,dimY:2000,mul:1,scale:1,alpha:1},
                        
                   // {cn:"MapAfroInst",dimX:3000,dimY:2000,mul:1,scale:1,alpha:1},
                    {cn:"MapWavesBRed",dimX:3000,dimY:2000,mul:0.5,scale:1,alpha:1},
                        
                    ],
                    baseMap:{
                        enabled:false
                    }
                },
            CarnivalGems:{
                    name:"CarnivalGems",
                    thumbMC:"ThumbCarnival",
                    titleMC:"TitleCarnival",
                    clearAtStart:false,
                    drawScale:1,
                    drawScaleMobile:1,
                    filter:{
                        type:"ColorAdjust",
                        delay:1,
                        params:{
                            brightness:-3,
                            contrast:0,
                            hue:4,
                            hueAni:{enabled:false},
                            saturation:0
                        }
                    },
                    blur:{enabled:true,val:3},
                    glitchEffect:false,
                    shiftEffect:{enabled:false,x:0,y:0},
                    layers:[
                        // {cn:"MapWavesBGreenBlue",dimX:3000,dimY:2000,mul:0.5,scale:1,alpha:1},
                        {cn:"MapGemsGreenBlue",dimX:3000,dimY:2000,mul:1,scale:1,alpha:1},
                        {cn:"MapCarnival",dimX:3000,dimY:2000,mul:1,scale:1,alpha:1}
                    ],
                    buildOrder:[1,0,2],
                    baseMap:{
                        enabled:false
                    }
                },
            Cameleons:{
                    name:"Cameleons",
                    thumbMC:"ThumbB",
                    titleMC:"TitleLeoStripe",
                    clearAtStart:false,
                    drawScale:1,
                    drawScaleMobile:1,
                    filter:{
                        type:"ColorAdjust",
                        delay:1,
                        params:{
                            brightness:-4,
                            contrast:0,
                            hue:-3,
                            hueAni:{enabled:false},
                            saturation:0
                        }
                    },
                    blur:{enabled:true,val:3},
                    glitchEffect:false,
                    shiftEffect:{enabled:false,x:0,y:0},
                    layers:[
                    {cn:"MapCameleons",dimX:3000,dimY:2000,mul:1,scale:1,alpha:1},
                        {cn:"MapWavesBRed",dimX:3000,dimY:2000,mul:1,scale:1,alpha:1},
                        //{cn:"MapPalms",dimX:3000,dimY:2000,mul:1,scale:1,alpha:1},
                        
                    ],
                    baseMap:{
                        enabled:false
                    }
                },
                
                Shilpa1:{
                    name:"LeoStripes",
                    thumbMC:"ThumbLeopard",
                    titleMC:"TitleLeoStripe",
                    clearAtStart:false,
                    drawScale:1,
                    drawScaleMobile:1,
                    filter:{
                        type:"ColorAdjust",
                        delay:1,
                        params:{
                            brightness:-3,
                            contrast:0,
                            hue:-10,
                            hueAni:{enabled:false},
                            saturation:0
                        }
                    },
                    blur:{enabled:false,val:2},
                    glitchEffect:false,
                    shiftEffect:{enabled:false,x:0,y:0},
                    layers:[
//{cn:"LeoStripeA",dimX:3000,dimY:2000,mul:1,scale:1,alpha:1},
                        {cn:"MapShilpa1",dimX:3000,dimY:2000,mul:1,scale:1,alpha:1}
                    ],
                    baseMap:{
                        enabled:false
                    }
                },
            LeoStripes:{
                    name:"LeoStripes",
                    thumbMC:"ThumbLeopard2",
                    titleMC:"TitleLeoStripe2",
                    clearAtStart:false,
                    drawScale:1,
                    drawScaleMobile:1,
                    filter:{
                        type:"ColorAdjust",
                        delay:1,
                        params:{
                            brightness:-4,
                            contrast:0,
                            hue:-3,
                            hueAni:{enabled:false},
                            saturation:0
                        }
                    },
                    blur:{enabled:false,val:2},
                    glitchEffect:false,
                    shiftEffect:{enabled:false,x:0,y:0},
                    layers:[
                        {cn:"LeoStripeA2",dimX:3000,dimY:2000,mul:1,scale:1,alpha:1},
                        {cn:"LeoStripeB2",dimX:3000,dimY:2000,mul:1,scale:1,alpha:1}
                    ],
                    baseMap:{
                        enabled:false
                    }
                },
               
   

            Jungle:{
                    name:"Jungle",
                    thumbMC:"ThumbJungle",
                    titleMC:"TitleJungle2",
                    clearAtStart:false,
                    drawScale:1,
                    drawScaleMobile:1,
                    filter:{
                        type:"ColorAdjust",
                        delay:1,
                        params:{
                            brightness:0,
                            contrast:0,
                            hue:-3,
                            hueAni:{enabled:false},
                            saturation:0
                        }
                    },
                    blur:{enabled:false,val:2},
                    glitchEffect:false,
                    shiftEffect:{enabled:false,x:0,y:0},
                    layers:[
                        {cn:"Jungle2A",dimX:3000,dimY:2000,mul:1,scale:1,alpha:1},
                        //{cn:"MapWavesWhite",dimX:3000,dimY:2000,mul:0.5,scale:1,alpha:0.5},
                        {cn:"Jungle2B",dimX:3000,dimY:2000,mul:-1,scale:1,alpha:1}
					],
                    buildOrder:[1,0],
					baseMap:{
                        enabled:true,
                        cn:"StarsAdditive"
                    }
				},
				 Okama:{
                    name:"Jungle",
                    thumbMC:"ThumbJungle",
                    titleMC:"TitleJungle2",
                    clearAtStart:false,
                    drawScale:1,
                    drawScaleMobile:1,
                    filter:{
                        type:"ColorAdjust",
                        delay:1,
                        params:{
                            brightness:0,
                            contrast:0,
                            hue:-3,
                            hueAni:{enabled:false},
                            saturation:0
                        }
                    },
                    blur:{enabled:false,val:2},
                    glitchEffect:false,
                    shiftEffect:{enabled:false,x:0,y:0},
                    layers:[
                        {cn:"OkamaA",dimX:3000,dimY:2000,mul:1,scale:1,alpha:1},
                        //{cn:"MapWavesWhite",dimX:3000,dimY:2000,mul:0.5,scale:1,alpha:0.5},
                        {cn:"OkamaB",dimX:3000,dimY:2000,mul:-1,scale:1,alpha:1}
					],
                    buildOrder:[1,0],
					baseMap:{
                        enabled:true,
                        cn:"StarsAdditive"
                    }
				},
            Rhombus:{
                    name:"Rhombus",
                    thumbMC:"ThumbRhombus",
                    titleMC:"TitleRhombus",
                    clearAtStart:false,
                    drawScale:1,
                    drawScaleMobile:1,
                    filter:{
                        type:"ColorAdjust",
                        delay:2,
                        params:{
                            brightness:-2,
                            contrast:0,
                            hue:0,
                            hueAni:{enabled:false},
                            saturation:-10
                        }
                    },
                    blur:{enabled:false,val:2},
                    glitchEffect:false,
                    shiftEffect:{enabled:false,x:0,y:0},
                    layers:[
                        {cn:"RhombusA",dimX:3000,dimY:2000,mul:1,scale:1,alpha:1},
                        {cn:"RhombusB",dimX:3000,dimY:2000,mul:1,scale:1,alpha:1}
                    ],
                    baseMap:{
                        enabled:false
                    }
                },

            Doughnuts:{
                    name:"Doughnuts",
                    thumbMC:"ThumbDoughnuts",
                    titleMC:"TitleDoughnuts",
                    clearAtStart:false,
                    drawScale:1,
                    drawScaleMobile:1,
                    filter:{
                        type:"ColorAdjust",
                        delay:2,
                        params:{
                            brightness:0,
                            contrast:0,
                            hue:10,
                            hueAni:{enabled:false},
                            saturation:-6
                        }
                    },
                    blur:{enabled:false,val:2},
                    glitchEffect:false,
                    shiftEffect:{enabled:false,x:0,y:0},
                    layers:[
                        {cn:"DoughnutsA",dimX:3000,dimY:2000,mul:1,scale:1,alpha:1},
                        {cn:"DoughnutsB",dimX:3000,dimY:2000,mul:1,scale:1,alpha:1}
                    ],
                    baseMap:{
                        enabled:true,
                        cn:"StarsAdditive"
                    }
                },

            Sakura:{
                    name:"Sakura",
                    thumbMC:"ThumbSakura",
                    titleMC:"TitleSakura",
                    clearAtStart:false,
                    drawScale:1,
                    drawScaleMobile:1,
                    filter:{
                        type:"ColorAdjust",
                        delay:2,
                        params:{
                            brightness:0,
                            contrast:0,
                            hue:-180,
                            hueAni:{enabled:false},
                            saturation:0
                        }
                    },
                    blur:{enabled:false,val:2},
                    glitchEffect:false,
                    shiftEffect:{enabled:false,x:0,y:0},
                    layers:[
                        {cn:"MapSakuraA",dimX:3000,dimY:2000,mul:1,scale:1,alpha:1},
                        {cn:"MapSakuraB",dimX:3000,dimY:2000,mul:1,scale:1,alpha:1}
                    ],
                    baseMap:{
                        enabled:false
                    }
                },
                 
               
            AllStars:{
                    name:"AllStars",
                    thumbMC:"ThumbAllStars",
                    titleMC:"TitleAllStars",
                    clearAtStart:true,
                    drawScale:1,
                    drawScaleMobile:1,
                    filter:{
                        type:"ColorAdjust",
                        delay:1,
                        params:{
                            brightness:0,
                            contrast:0,
                            hue:1,
                            hueAni:{
                                enabled:true,
                                v0:1,
                                v1:30,
                                alpha:0,
                                speed:0.05
                            },
                            saturation:0
                        }
                    },
                    blur:{enabled:true,val:1},
                    glitchEffect:false,
                    shiftEffect:{
                        enabled:true,
                        alpha:0,
                        radius:3,
                        speed:0.001
                    
                    },
                    layers:[
                       // {cn:"MapWavesGray",dimX:3000,dimY:2000,mul:1,scale:1,alpha:1},
                        {cn:"MapStarsA",dimX:3000,dimY:2000,mul:1,scale:1,alpha:1},
                        {cn:"MapStarsB",dimX:3000,dimY:2000,mul:-1,scale:1,alpha:1}
                    ],
                    baseMap:{
                        enabled:false,
                        cn:"StarsAdditive"
                    }
                },

            Translucent:{
                    name:"Translucent",
                    thumbMC:"ThumbTranslucent",
                    titleMC:"TitleTranslucent",
                    clearAtStart:true,
                    drawScale:1,
                    drawScaleMobile:0.7,
                    filter:{
                        type:"ColorAdjust",
                        delay:2,
                        params:{
                            brightness:-10,
                            contrast:0,
                            hue:0,
                            hueAni:{enabled:false},
                            saturation:-3
                        }
                    },
                    blur:{enabled:false,val:2},
                    glitchEffect:false,
                    shiftEffect:{enabled:false,x:0,y:0},
                    layers:[
                        {cn:"TranslucentA",dimX:3000,dimY:2000,mul:1,scale:1,alpha:1},
                        {cn:"TranslucentB",dimX:3000,dimY:2000,mul:1,scale:1,alpha:1}
                    ],
                    baseMap:{
                        enabled:false
                    }
                },

            TranslucentInv:{
                    name:"Translucent Inv",
                    thumbMC:"ThumbTranslucentInv",
                    titleMC:"TitleTranslucentInv",
                    clearAtStart:false,
                    drawScale:1,
                    drawScaleMobile:0.7,
                    filter:{
                        type:"ColorAdjust",
                        delay:2,
                        params:{
                            brightness:-2,
                            contrast:0,
                            hue:0,
                            hueAni:{enabled:false},
                            saturation:-3
                        }
                    },
                    blur:{enabled:false,val:2},
                    glitchEffect:false,
                    shiftEffect:{enabled:false,x:0,y:0},
                    layers:[
                        {cn:"TranslucentInvA",dimX:3000,dimY:2000,mul:1,scale:1,alpha:1},
                        {cn:"TranslucentInvB",dimX:3000,dimY:2000,mul:1,scale:1,alpha:1}
                    ],
                    baseMap:{
                        enabled:false
                    }
                },
            
                /*
                {
                    name:"OldDMT",
                    thumbMC:"ThumbDMT",
                    titleMC:"TitleDMT",
                    clearAtStart:false,
                    filter:{
                        type:"ColorAdjust",
                        delay:2,
                        params:{
                            brightness:0,
                            contrast:0,
                            hue:-10,
                            hueAni:{enabled:false},
                            saturation:0
                        }
                    },
                    glitchEffect:true,
                    layers:[
                        {cn:"Map2NoB",dimX:3000,dimY:2000,mul:1,scale:1,alpha:1},
                        {cn:"Map1NoB",dimX:3000,dimY:2000,mul:-1,scale:1,alpha:1}
                    ],
                    baseMap:{
                        enabled:false
                    }
                },*/
            RetroGIF1:{
                    name:"Retro GIF 1",
                    thumbMC:"ThumbRetroGIF1",
                    titleMC:"TitleGIF1",
                    clearAtStart:false,
                    drawScale:1,
                    drawScaleMobile:1,
                    filter:{
                        type:"ColorAdjust",
                        delay:2,
                        params:{
                            brightness:0,
                            contrast:0,
                            hue:0,
                            hue_inc:0,
                            saturation:-10,
                            hueAni:{
                                enabled:false
                            }
                        }
                    },
                    blur:{enabled:false,val:2},
                    glitchEffect:true,
                    shiftEffect:{enabled:false,x:0,y:0},
                    layers:[
                        {cn:"MapEmpty",dimX:3000,dimY:2000,mul:-0.2,scale:1,alpha:1},
                        {cn:"MapGIF1",dimX:3000,dimY:2000,mul:1,scale:1,alpha:1}
                    ],
                    baseMap:{
                        enabled:false
                    }
                },
            RetroGIF2:{
                    name:"Retro GIF 2",
                    thumbMC:"ThumbRetroGIF2",
                    titleMC:"TitleGIF2",
                    clearAtStart:false,
                    drawScale:1,
                    drawScaleMobile:1,
                    filter:{
                        type:"ColorAdjust",
                        delay:2,
                        params:{
                            brightness:0,
                            contrast:0,
                            hue:0,
                            hue_inc:1,
                            saturation:-7,
                            hueAni:{
                                enabled:false
                            }
                        }
                    },
                    blur:{enabled:false,val:2},
                    glitchEffect:true,
                    shiftEffect:{enabled:false,x:0,y:0},
                    layers:[
                        {cn:"MapEmpty",dimX:512,dimY:512,mul:-0.2,scale:1,alpha:1},
                        {cn:"MapGIF2",dimX:3000,dimY:2000,mul:1,scale:1,alpha:1}
                    ],
                    baseMap:{
                        enabled:false
                    }
                },
                
  /*  {
                    name:"geom",
                    titleMC:"TitleAbstractive",
                    bmpFilter:false,
                    glitchEffect:false,
                    layers:[
                        {cn:"Map1Back",dimX:3000,dimY:2000,mul:1,scale:1,alpha:1},
                        {cn:"Map1NoB",dimX:3000,dimY:2000,mul:1,scale:1,alpha:1}
                        
                        ]
                },
                {
                    name:"diamonds",
                    titleMC:"TitleDiamonds",
                    bmpFilter:false,
                    glitchEffect:false,
                    layers:[
                        {cn:"Map2Back",dimX:3000,dimY:2000,mul:1,scale:1,alpha:1},
                        {cn:"Map2NoB",dimX:3000,dimY:2000,mul:1,scale:1,alpha:1}
                        ]
                },
                {
                    name:"csuka",
                    titleMC:"TitleCsuka",
                    bmpFilter:false,
                    glitchEffect:false,
                    layers:[
                        {cn:"CsikiCsuka",dimX:1024,dimY:1024,mul:1,scale:1,alpha:1},
                        {cn:"MapGIF1Few",dimX:1000,dimY:1000,mul:1,scale:1,alpha:1}
                        ]
                },*/
                Test:{
                    name:"Test",
                    thumbMC:"ThumbA",
                    titleMC:"TitleA",
                    clearAtStart:false,
                    drawScale:1,
                    drawScaleMobile:1,
                    filter:{
                        type:"ColorAdjust",
                        delay:2,
                        params:{
                            brightness:0,
                            contrast:0,
                            hue:0,
                            hue_inc:1,
                            saturation:-7,
                            hueAni:{
                                enabled:false
                            }
                        }
                    },
                    blur:{enabled:false,val:2},
                    glitchEffect:true,
                    shiftEffect:{enabled:false,x:0,y:0},
                    layers:[
                        //{cn:"MapEmpty",dimX:512,dimY:512,mul:-0.2,scale:1,alpha:1},
                        {cn:"AreasTest",dimX:3000,dimY:2000,mul:1,scale:1,alpha:1}
                    ],
                    baseMap:{
                        enabled:false
                    }
                }
			};
            
		public static var mapsApp=[
			maps.Okama,
            maps.Jungle,
            maps.LeoStripes,
			maps.CarnivalGems,
            maps.Rhombus,
            maps.Doughnuts,
            maps.Sakura,
            maps.AllStars,
            // maps.Translucent,
            // maps.TranslucentInv,
            maps.RetroGIF1,
            maps.RetroGIF2
        ];

        public static var mapsTropic=[
            maps.CarnivalGems,
            maps.Cameleons,
            maps.Jungle,
            maps.AllStars
        ];

        public static var mapsTest=[
            maps.Test
        ];

        public static var mapsAfro=[
            maps.Afro2,
            maps.Afro3,
            maps.Afro1,
            //maps.LeoStripes,
            maps.Translucent
        ];
    }
}