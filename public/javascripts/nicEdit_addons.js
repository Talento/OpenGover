var estilos_disponibles = {
                        "Título":"h2",
                        "Subtítulo":"h3",
                        "Destacado 1":"<span class='destacado1'>{{texto}}</span>",
                        "Destacado 2":"<span class='destacado2'>{{texto}}</span>",
                        "Ninguno":"none"
                    };

var nicEditor_actual;
var nicEditor_actual_selected;
var nicEditor_actual_selected_id;
var nicEditor_temp_tag;

var nicHrOptions = {
	buttons : {
		'hr' : {name : 'nicedit.hr', type : 'nicHrButton'}
	}
};

var nicImageOptions = {
	buttons : {
		'image' : {name : 'nicedit.image', type : 'nicImageButton', tags : ['IMG']}
	}
};

var nicVideoOptions = {
	buttons : {
		'video' : {name : 'nicedit.video', type : 'nicVideoButton', tags : ['VID']}
	}
};

var nicFlashOptions = {
	buttons : {
		'flash' : {name : 'nicedit.flash', type : 'nicFlashButton', tags : ['OBJECT']}
	}
};

var nicGalleryOptions = {
	buttons : {
		'gallery' : {name : 'nicedit.gallery', type : 'nicGalleryButton', tags : ['']}
	}
};

var nicGmapOptions = {
	buttons : {
		'gmap' : {name : 'nicedit.gmap', type : 'nicGmapButton', tags : ['']}
	}
};

var nicDocumentOptions = {
	buttons : {
		'document' : {name : 'nicedit.document', type : 'nicDocumentButton', tags : ['A']}
	}
};

var nicHrButton=nicEditorAdvancedButton.extend({
	mouseClick:function(){
            if(!this.isDisabled){
                insert_content("<div class=\"hr\"><hr/></div>");
                return false;
            }
	}
});
nicEditors.registerPlugin(nicPlugin,nicHrOptions);

var nicImageButton=nicEditorAdvancedButton.extend({
	mouseClick:function(){
            if(!this.isDisabled){
                insert_temp_tag();
                tb_show("Imágenes","/folders/index?height=500&width=650&type=image",false);
                return false;
            }
	}
});
nicEditors.registerPlugin(nicPlugin,nicImageOptions);

var nicVideoButton=nicEditorAdvancedButton.extend({
	mouseClick:function(){
		if(!this.isDisabled){
            insert_temp_tag();
            tb_show("Vídeos","/videos/index?height=500&width=650&type=video",false);
            return false;
		}
	}
});
nicEditors.registerPlugin(nicPlugin,nicVideoOptions);

var nicFlashButton=nicEditorAdvancedButton.extend({
	mouseClick:function(){
		if(!this.isDisabled){
            insert_temp_tag();
            tb_show("Flashes","/flashobjects/index?height=500&width=650&type=flashobject",false);
            return false;
		}
	}
});
nicEditors.registerPlugin(nicPlugin,nicFlashOptions);


var nicGalleryButton=nicEditorAdvancedButton.extend({
	mouseClick:function(){
		if(!this.isDisabled){
            nicEditor_actual = this.ne;
            nicEditor_actual_selected = this.ne.selectedInstance;
            nicEditor_actual_selected_id = $(this)[0].ne.selectedInstance.e.id;
//            tb_show("Galerías Multimedia","/galeriamultimedias/index?height=500&width=650&type=gallery",false);
            tb_show("Galerías","/images/index?height=500&width=650&type=gallery",false);
            return false;
		}
	}
});
nicEditors.registerPlugin(nicPlugin,nicGalleryOptions);

var nicGmapButton=nicEditorAdvancedButton.extend({
	mouseClick:function(){
		if(!this.isDisabled){
            if (typeof(gmaps_loaded)=="undefined") {
                $("#" + $(this.ne.selectedInstance.e).next().next(".gmap").attr("id")).html("<iframe class=\"iframe_gmaps\" id=\"iframe_gmaps\" src=\"" + private_url + "/gmaps/gmaps_alone/" + $(this.ne.selectedInstance.e).next().next(".gmap").attr("id") + "\"></iframe>");
                $("#" + $(this.ne.selectedInstance.e).next().next(".gmap").attr("id")).show();
            }
            else {
                add_gmap(this.ne.selectedInstance.e);
            }
            return false;
		}
	}
});
nicEditors.registerPlugin(nicPlugin,nicGmapOptions);

var nicDocumentButton=nicEditorAdvancedButton.extend({
	mouseClick:function(){
		if(!this.isDisabled){
//            nicEditor_actual = this.ne;
//            nicEditor_actual_selected = this.ne.selectedInstance;
//            nicEditor_actual_selected_id = $(this)[0].ne.selectedInstance.e.id;
            insert_temp_tag();
            tb_show("Documentos","/documents/index?height=500&width=650&type=documents",false);
            return false;
		}
	},
	addPane:function(){
		this.im=this.ne.selectedInstance.selElm().parentTag("A");
		this.addForm({
									"":{type:"title",txt:"Add/Edit Document"},
									src:{type:"text",txt:"URL",value:"http://",style:{width:"150px"}},
									alt:{type:"text",txt:"Alt Text",style:{width:"100px"}},
									align:{type:"select",txt:"Align",options:{left:"Left",right:"Right"}}
								},this.im)
	},
	submit:function(B){
		var C=this.inputs.src.value;
		if(C==""||C=="http://"){
			alert("You must enter a Image URL to insert");
			return false
		}
		this.removePane();
		if(!this.im){
			var A="javascript:nicImTemp();";
			this.ne.nicCommand("insertImage",A);
			this.im=this.findElm("IMG","src",A)
		}
		if(this.im){
			this.im.setAttributes({src:this.inputs.src.value,alt:this.inputs.alt.value,align:this.inputs.align.value})
		}
	}
});
nicEditors.registerPlugin(nicPlugin,nicDocumentOptions);

/*******************************************************************************/
/*******                                 Listado de estilos                                       ******/
/*******************************************************************************/



var nicStyleSelectOptions = {
	buttons : {
		'style' : {name : "nicedit.style", type : 'nicEditorStylesSelect'}
	}
};


var nicEditorStyleSelect=bkClass.extend({
	construct:function(D,A,C,B){
		this.options=C.buttons[A];
		this.elm=D;
		this.ne=B;
		this.name=A;
		this.selOptions=new Array();
		this.margin=new bkElement("div").setStyle({"float":"left",margin:"2px 1px 0 1px"}).appendTo(this.elm);
		this.contain=new bkElement("div").setStyle({width:"90px",height:"20px",cursor:"pointer",overflow:"hidden"}).addClass("selectContain").addEvent("click",this.toggle.closure(this)).appendTo(this.margin);
		this.items=new bkElement("div").setStyle({overflow:"hidden",zoom:1,border:"1px solid #ccc",paddingLeft:"3px",backgroundColor:"#fff"}).appendTo(this.contain);
		this.control=new bkElement("div").setStyle({overflow:"hidden","float":"right",height:"18px",width:"16px"}).addClass("selectControl").setStyle(this.ne.getIcon("arrow",C)).appendTo(this.items);
		this.txt=new bkElement("div").setStyle({overflow:"hidden","float":"left",width:"66px",height:"14px",marginTop:"1px",fontFamily:"sans-serif",textAlign:"center",fontSize:"12px"}).addClass("selectTxt").appendTo(this.items);
		if(!window.opera){
			this.contain.onmousedown=this.control.onmousedown=this.txt.onmousedown=bkLib.cancelEvent
		}
		this.margin.noSelect();
		this.ne.addEvent("selected",this.enable.closure(this)).addEvent("blur",this.disable.closure(this));
		this.disable();
		this.init()
	},
	disable:function(){
		this.isDisabled=true;
		this.close();
		this.contain.setStyle({opacity:0.6})
	},
	enable:function(A){
		this.isDisabled=false;
		this.close();
		this.contain.setStyle({opacity:1})
	},
	setDisplay:function(A){
		this.txt.setContent(A)
	},
	toggle:function(){
		if(!this.isDisabled){
			(this.pane)?this.close():this.open()
		}
	},
	open:function(){
		this.pane=new nicEditorPane(this.items,this.ne,{width:"88px",padding:"0px",position:"fixed",borderTop:0,borderLeft:"1px solid #ccc",borderRight:"1px solid #ccc",borderBottom:"0px",backgroundColor:"#fff"});
		for(var C=0;C<this.selOptions.length;C++){
			var B=this.selOptions[C];
			var A=new bkElement("div").setStyle({overflow:"hidden",borderBottom:"1px solid #ccc",width:"88px",textAlign:"left",overflow:"hidden",cursor:"pointer"});
			var D=new bkElement("div").setStyle({padding:"0px 4px"}).setContent(B[1]).appendTo(A).noSelect();
			D.addEvent("click",this.update.closure(this,B[0])).addEvent("mouseover",this.over.closure(this,D)).addEvent("mouseout",this.out.closure(this,D)).setAttributes("id",B[0]);
			this.pane.append(A);
			if(!window.opera){
				D.onmousedown=bkLib.cancelEvent
			}
		}
	},
	close:function(){
		if(this.pane){
			this.pane=this.pane.remove()
		}
	},
	over:function(A){
		A.setStyle({backgroundColor:"#ccc"})
	},
	out:function(A){
		A.setStyle({backgroundColor:"#fff"})
	},
	add:function(B,A){
		this.selOptions.push(new Array(B,A))
	},
	update:function(A){
        if (A=="h1" || A=="h2" || A=="h3" || A=="h4" || A=="h5" || A=="h6" || A=="p" || A=="none") {
            if (A=="none"){
                A="pre"
            }
            this.ne.selectedInstance.nicCommand("formatBlock", "<" + A.toUpperCase() + ">");
            re_ini1 = new RegExp("<pre([^>]*?)>(.*?)</pre>", "ig");
            contenido = this.ne.selectedInstance.getContent().replace(/\r/g, '').replace(/\n/g, '');
            if (contenido.match(re_ini1)){
                    contenido_parrafo = contenido.match(re_ini1).toString();
                    deletable_tags=["h1","h2","h3","h4","h5","h6","div","span","b","i","u","s","ul","ol","li","blockquote","p","sub","sup","hr","pre","font"];
                    for (tag in deletable_tags){
                            ini_tag = "<" + deletable_tags[tag] + "([^>]*?)>";
                            fin_tag = "</" + deletable_tags[tag] + ">";
                            re1 = new RegExp(ini_tag, "igm");
                            re2 = new RegExp(fin_tag, "igm");
                        contenido_parrafo = contenido_parrafo.replace(re1,"");
                        contenido_parrafo = contenido_parrafo.replace(re2,"");
                    }
                    re_final = new RegExp("<pre([^>]*?)>(.*?)</pre>", "ig");
                    contenido = contenido.replace(re_final,contenido_parrafo);
                    this.ne.selectedInstance.setContent(contenido);
            }
        } else {
            trozos = A.split("{{texto}}");
            insert_block(trozos[0],trozos[1]);
        }
		this.close();
	}
});

var nicEditorStylesSelect=nicEditorStyleSelect.extend({
	sel:estilos_disponibles, //{"p":"Hola","h1":"Adios"},
	init:function(){
		this.setDisplay("Estilo...");
		for(itm in this.sel){
			var A=itm;//.toUpperCase();
			this.add(this.sel[itm],"<p style=\"padding: 0px; margin: 0px;\">"+A+"</p>");
		}
	}
});

nicEditors.registerPlugin(nicPlugin,nicStyleSelectOptions);

var nicTableOptions = {
	buttons : {
		'table' : {name : 'nicedit.table', type : 'nicTableButton', tags : ['TABLE']}
		//'unlink' : {name : 'Remove Link',  command : 'unlink', noActive : true}
	}
};

var nicTableButton=nicEditorAdvancedButton.extend({
	mouseClick:function(){
		if(!this.isDisabled){
            insert_temp_tag();
            tb_show("Tablas","/nicedit/table?height=136&width=330",false);
            return false;
		}
	}
});

nicEditors.registerPlugin(nicPlugin,nicTableOptions);

var nicLinkButton=nicEditorAdvancedButton.extend({
	mouseClick:function(){
		if(!this.isDisabled){
            insert_temp_tag();
            tb_show("Enlaces","/nicedit/link?height=189&width=500",false);
            return false;
		}
	}
});

nicEditors.registerPlugin(nicPlugin,nicLinkOptions);

var nicSelectStyleOptions = {
	buttons : {
		'fontStyle' : {name : 'nicedit.table', type : 'nicEditorStyleSelect', command : 'formatBlock'}
	}
};

var nicEditorStyleSelect = nicEditorSelect.extend({
//		sel : {'p' : 'Paragraph', 'pre' : 'Pre', 'h6' : 'Heading&nbsp;6', 'h5' : 'Heading&nbsp;5', 'h4' : 'Heading&nbsp;4', 'h3' : 'Heading&nbsp;3', 'h2' : 'Heading&nbsp;2', 'h1' : 'Heading&nbsp;1'},
		sel : {'h2' : 'T&iacute;tulo', 'h3' : 'Subt&iacute;tulo', 'h4' : 'Subt&iacute;tulo 4'},

	init : function() {
		this.setDisplay('Estilo...');
		for(itm in this.sel) {
			var tag = itm.toUpperCase();
			this.add('<'+tag+'>','<'+itm+' style="padding: 0px; margin: 0px;">'+this.sel[itm]+'</'+tag+'>');
		}
	}
});

//nicEditors.registerPlugin(nicPlugin,nicSelectStyleOptions);


