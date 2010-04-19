var myNicEditor;
var original_text_values = new Array();
var skip_validation = false;

var change_select_cambios = false

var custom_x_mouse;
var custom_y_mouse;

$(document).ready(
    function()
    {

        //Si no tenemos un formulario con class "main" oculto el botón guardar de la barra del administrador
        if ($("form.main").length==0 && $(".editable").length==0 && $(".texto_editable").length==0) {
            $("#menu_admin .save-icon").hide();
        }

        // --------------------- Cargar editor ---------------------------- //
        // Comprueba que tenga permisos de edición
        if ($("#myNicPanel").length>0) {
            myNicEditor = new nicEditor({
                fullPanel : true,
                onSave : function(content, id, instance) {

                }
            });

            myNicEditor.setPanel('myNicPanel');
            $(".texto_editable").each(function() {
                myNicEditor.addInstance($(this).attr("id"));
//                original_text_values[$(this).attr("id")] = $(this).html();
            });
            $(".editable").each(function() {
                myNicEditor.addInstance($(this).attr("id"));
 //               original_text_values[$(this).attr("id")] = $(this).html();
            });
        }
        else {
            skip_validation = true;
        }



        $(".input_year").each(function() {
            datePickerController.addEvent(this, "change", updateDatePreviews);
        });


        /*******************         Editores        ***********************/
        $(".texto_editable").focus(function() {
            if (jQuery.trim($(this).html())=="Inserte su texto..."){
                $(this).html("")
            }
            nicEditor_actual_selected = obtener_nicedit_instance($(this).attr("id"));
            nicEditor_actual_selected_id = $(this).attr("id");
        });
        $(".texto_editable").blur(function() {
            if (jQuery.trim($(this).html())==""){
                $(this).html("Inserte su texto...")
            }
        });
        var initial_texto = "";
        $(".editable").focus(function() {
            if(/- -(.*?)- -/.test(jQuery.trim($(this).html()))){
                initial_texto = $(this).html();
                $(this).html("");
            }
            nicEditor_actual_selected = obtener_nicedit_instance($(this).attr("id"));
            nicEditor_actual_selected_id = $(this).attr("id");
            //Si es editor de fichero abro la ventana emergente
	    if ($(this).hasClass("file_editable")) {
            //$(".file_editable").focus(function() {
                editar_file($(this));
            }
	    //);
        });
        $(".editable").blur(function() {
            if (jQuery.trim($(this).html())==""){
                $(this).html(initial_texto);
            }
        });

        /* Ocultamos las capas de la galería y gmaps si no tienen contenido */
        $(".gmap").each(function() {
           if ($(this).html()=="") {
               $(this).hide();
           }
        });
        $(".galeria").each(function() {
           if ($(this).html()=="") {
               $(this).hide();
           }
        });

        $(".texto_editable").each(function() {
            original_text_values[$(this).attr("id")] = $(this).html();
        });
        $(".editable").each(function() {
            original_text_values[$(this).attr("id")] = $(this).html();
        });

    });

window.onbeforeunload = function (evt) {
    if (!skip_validation){
        var cambios = false;
            $(".editable").each(function(){
               if (original_text_values[$(this).attr("id")] != $(this).html()) cambios = true;
            });
            $(".texto_editable").each(function(){
               if (original_text_values[$(this).attr("id")] != $(this).html()) {
                   cambios = true;
               }
            });
		if(cambios || change_select_cambios){
                    var message = '¡¡ Se han realizado cambios que NO han sido guardados !!';
                    if (typeof evt == 'undefined') {//IE
                            evt = window.event;
                    }
                    if (evt) {
                            evt.returnValue = message;
                    }
                    return message;
            }
    }
}

function justify(align) {
    insert_block_style("div","text-align: " + align + ";");
}

function insert_temp_tag() {
    if (navigator.appName=="Netscape") {
        insert_temp_tag_noie();
    }
    else {
        insert_temp_tag_ie();
    }
}

function insert_temp_tag_noie() {
    var aux_src="tmp_nic_55512345";
    var contenido = nicEditor_actual_selected.getContent().replace(/\r/g, '').replace(/\n/g, '');
    if (contenido=="") {
        contenido = "<!--aux_content-->";
        nicEditor_actual_selected.setContent(contenido);
        contenido = nicEditor_actual_selected.getContent().replace(/\r/g, '').replace(/\n/g, '');
        if (contenido=="") { //Si explorer...
            contenido = "@aux_content@"
            nicEditor_actual_selected.setContent(contenido);
        }
    }
    else {
        var range = nicEditor_actual_selected.getRng();
        range.surroundContents(document.createElement(aux_src));
        contenido = nicEditor_actual_selected.getContent().replace(/\r/g, '').replace(/\n/g, '');
        contenido = contenido.replace("<" + aux_src + "></" + aux_src + ">","<!--aux_content-->");
        contenido = contenido.replace("<" + aux_src + ">","<!--aux_block_start-->");
        contenido = contenido.replace("</" + aux_src + ">","<!--aux_block_end-->");
        nicEditor_actual_selected.setContent(contenido);
    }
}


function insert_temp_tag_ie() {
    var encontrado=false;
    var contenido = "";
    aux_src="tmp_nic_55512345";
    nicEditor_actual_selected.ne.nicCommand("fontname",aux_src);
    $(nicEditor_actual_selected.e).find("span").each(function() {
       if ($(this).attr("style")=="font-family: " + aux_src + ";") {
           $(this).prepend("@aux@").append("@aux@");
           encontrado = true;
       }
    });
    if (!encontrado) {
        $(nicEditor_actual_selected.e).find("font[face="+aux_src+"]").each(function() {
           $(this).prepend("@aux@").append("@aux@");
           encontrado = true;
        });
    }
    if (!encontrado) {
        $(nicEditor_actual_selected.e).find("a,p,div,h1,h2,h3").each(function() {
           if ($(this).attr("style")=="font-family: " + aux_src + ";") {
               $(this).prepend("@aux@").append("@aux@");
               encontrado = true;
           }
        });
    }
    if (!encontrado) {
        $(nicEditor_actual_selected.e).find("img").each(function() {
           if ($(this).attr("style")=="font-family: " + aux_src + ";") {
               $(this).after("@aux@").before("@aux@");
               encontrado = true;
           }
        });
    }
    contenido = nicEditor_actual_selected.getContent().replace(/\r/g, '').replace(/\n/g, '');
    rea = new RegExp("<span ([^>]*?)>@aux@","ig");
    reb = new RegExp("@aux@</span>","ig");
    re1 = new RegExp("<([^>]*?)>@aux@","ig");
    re2 = new RegExp("@aux@</([^>]*?)>","ig");
    re3 = new RegExp("@aux@<([^>]*?)>@aux@","ig");
    re4 = new RegExp("<img ([^>]*?)" + aux_src + "([^>]*?)>","ig");

    if (contenido.match(rea) && contenido.match(reb)) {
        m = contenido.match(rea);
        contenido = contenido.replace(m[0],"<!--aux_block_start-->" + m[0].replace(/<span ([^>]*?)>@aux@/g,""));
        m = contenido.match(reb);
        contenido = contenido.replace(m[0],m[0].replace(/@aux@<\/span>/g,"") + "<!--aux_block_end-->");
    }
    else 
    if (contenido.match(re1) && contenido.match(re2)) {
        m = contenido.match(re1);
        contenido = contenido.replace(m[0],"<!--aux_block_start-->" + m[0].replace("@aux@",""));
//        contenido = contenido.replace(m[0],"<!--aux_block_start-->" + m[0].replace(/<([^>]*?)>@aux@/g,""));
        m = contenido.match(re2);
        contenido = contenido.replace(m[0],m[0].replace("@aux@","") + "<!--aux_block_end-->");
//        contenido = contenido.replace(m[0],m[0].replace(/@aux@<\/([^>]*?)>/g,"") + "<!--aux_block_end-->");
    }
    else {
        if (contenido.match(re3)) {
            m = contenido.match(re3);
            contenido = contenido.replace(m[0],"<!--aux_block_start-->" + m[0].replace("@aux@","") + "<!--aux_block_end-->");
        } else {
            nicEditor_actual_selected.ne.insertImage(aux_src,"","");
            contenido = nicEditor_actual_selected.getContent().replace(/\r/g, '').replace(/\n/g, '');
            contenido = contenido.replace(re4,"<!--aux_content-->");
        }
    }
    contenido = contenido.replace("font-family: " + aux_src + ";","");
    contenido = contenido.replace("<FONT face=" + aux_src + ">","");
    contenido = contenido.replace("</FONT>","");
    contenido = contenido.replace(/@aux@/g,"");
    nicEditor_actual_selected.setContent(contenido);
}


function replace_image_temp_tag(texto) {
    var contenido = "";
    contenido = nicEditor_actual_selected.getContent().replace(/\r/g, '').replace(/\n/g, '');
    re0 = new RegExp("@aux_content@","i");
    re1 = new RegExp("<!--aux_content-->","i");
    if (contenido.match(re0)){
        contenido = contenido.replace(re0,texto);
    }
    else
    if (contenido.match(re1)){
        contenido = contenido.replace(re1,texto);
    }
    else {
        re2 = new RegExp("<!--aux_block_start-->(.*?)<!--aux_block_end-->");
        if (contenido.match(re2)) {
            contenido = contenido.replace(re2,texto);
        }
    }
    nicEditor_actual_selected.setContent(contenido);
}

function replace_anchor_temp_tag(destino,nombre,title,evento) {
    var contenido = "";
    contenido = nicEditor_actual_selected.getContent().replace(/\r/g, '').replace(/\n/g, '');
    re1 = new RegExp("<!--aux_content-->","i");
    re0 = new RegExp("@aux_content@","i");
    if (contenido.match(re0)){
        if (evento) {
            contenido = contenido.replace(re0,"<a href=\"" + destino + "\" title=\"" + title + "\" rel=\"external\">" + nombre + "</a>");
        } else {
            contenido = contenido.replace(re0,"<a href=\"" + destino + "\" title=\"" + title + "\">" + nombre + "</a>");
        }
    }
    else
    if (contenido.match(re1)){
        if (evento) {
            contenido = contenido.replace(re1,"<a href=\"" + destino + "\" title=\"" + title + "\" rel=\"external\">" + nombre + "</a>");
        } else {
            contenido = contenido.replace(re1,"<a href=\"" + destino + "\" title=\"" + title + "\">" + nombre + "</a>");
        }
    }
    else {
        re2 = new RegExp("<!--aux_block_start-->","i");
        re3 = new RegExp("<!--aux_block_end-->","i");
        if (contenido.match(re2) && contenido.match(re3)) {
            if (evento) {
                contenido = contenido.replace(re2,"<a href=\"" + destino + "\" title=\"" + title + "\" rel=\"external\">");
            } else {
                contenido = contenido.replace(re2,"<a href=\"" + destino + "\" title=\"" + title + "\">");
            }
            contenido = contenido.replace(re3,"</a>");
        }
    }
    nicEditor_actual_selected.setContent(contenido);
}

function replace_anchor_temp_tag_document(destino,nombre,title,evento) {
    var contenido = "";
    contenido = nicEditor_actual_selected.getContent().replace(/\r/g, '').replace(/\n/g, '');
//    re1 = new RegExp("(.*?)<!--aux_block_end-->","i");
//    if (contenido.match(re1)){
        if (evento) {
            contenido = "<a href=\"" + destino + "\" title=\"" + title + "\" rel=\"external\">" + nombre + "</a>";
//            contenido = contenido.replace(re1,"<a href=\"" + destino + "\" title=\"" + title + "\" rel=\"external\">" + nombre + "</a>");
        } else {
            //contenido = contenido.replace(re1,"<a href=\"" + destino + "\" title=\"" + title + "\">" + nombre + "</a>");
            contenido = "<a href=\"" + destino + "\" title=\"" + title + "\">" + nombre + "</a>";
        }
//    }
    nicEditor_actual_selected.setContent(contenido);
}

function remove_temp_tag() {
    var contenido = "";
    if (nicEditor_actual_selected != undefined) {
        aux_src="tmp_nic_55512345";
        contenido = nicEditor_actual_selected.getContent().replace(/\r/g, '').replace(/\n/g, '');
        re1 = new RegExp("@aux_content@","i");
        re2 = new RegExp("@aux_block_start@","i");
        re3 = new RegExp("@aux_block_end@","i");
        re4 = new RegExp("<!--aux_content-->","i");
        re5 = new RegExp("<!--aux_block_start-->","i");
        re6 = new RegExp("<!--aux_block_end-->","i");
        contenido = contenido.replace(re1,"");
        contenido = contenido.replace(re2,"");
        contenido = contenido.replace(re3,"");
        contenido = contenido.replace(re4,"");
        contenido = contenido.replace(re5,"");
        contenido = contenido.replace(re6,"");
        nicEditor_actual_selected.setContent(contenido);
    }
}

function insert_content(texto){
    var contenido = "";
    aux_src="tmp_nic_123654789";
    nicEditor_actual_selected.ne.insertImage(aux_src,"","");
    contenido = nicEditor_actual_selected.getContent().replace(/\r/g, '').replace(/\n/g, '');
    re = new RegExp("<img ([^>]*?)" + aux_src + "([^>]*?)>","i");
    contenido = contenido.replace(re,texto);
    nicEditor_actual_selected.setContent(contenido);
}

function insert_block(pre,post){
    var contenido = "";
    aux_src="tmp_nic_123654789";
    nicEditor_actual_selected.ne.nicCommand("createlink",aux_src);
    $("a[href='" + aux_src + "']").prepend("@aux@").append("@aux@");
    contenido = nicEditor_actual_selected.getContent().replace(/\r/g, '').replace(/\n/g, '');
    re1 = new RegExp("<a ([^>]*?)" + aux_src + "([^>]*?)>@aux@","i");
    re2 = new RegExp("@aux@</a>","i");
    contenido = contenido.replace(re1,pre);
    contenido = contenido.replace(re2,post);
    contenido = contenido.replace(/@aux@/g,"");
    nicEditor_actual_selected.setContent(contenido);
}

function insert_block_style(elemento,atributos) {
        var range = nicEditor_actual_selected.getRng();
        if (range.toString().length==0) {
            var id=nicEditor_actual_selected.e.getAttribute("id");
            range.setStart(document.getElementById(id),0);
            range.setEnd(document.getElementById(id),1);
        }
        var ele = document.createElement(elemento);
        ele.setAttribute("style", atributos);
        range.surroundContents(ele);
}

function updateDatePreviews(e) {
    $('#' + $(this).attr("id") + '_preview' ).html($('#' + $(this).attr("id")).attr("value"));
    $('#' + $(this).attr("id") + '-mm_preview' ).html($('#' + $(this).attr("id") + '-mm').attr("value"));
    $('#' + $(this).attr("id") + '-dd_preview' ).html($('#' + $(this).attr("id") + '-dd').attr("value"));
}

function sanitize_string(s) {
    var tags = [
        ["'","&#39;"]
    ];
    for(i=0;i<tags.length;i++) {
        s = s.replace(new RegExp(tags[i][0],"g"),tags[i][1]);
    }
    return s;
}

function save_action(){
    //Se guarda la posicion de gmaps, si existe
    save_gmaps_position();
    skip_validation = true;
    if ($("form.main").length==0) {
        $(".og_aux_form").attr("action", window.location.href);
        $(".og_aux_form").addClass("main");
        //$("body").append("<form class='main' method='post' action='" + window.location.href + "'></form>")
    }
    $(".editable").each(function() {
        if (ends_with($(this).html().toLowerCase(),"<br>")){
            $(this).html($(this).html().substring(0,$(this).html().length-4));
        }
        if ($(this).html().indexOf("- - ")!=0 && $(this).html().indexOf("--/--")!=0){
            $("form.main:first").append("<input type='hidden' name='" + $(this).attr("id") + "' value='" + sanitize_string($(this).html()) + "' />");
        }
    });
    $(".texto_editable").each(function() {
        if (ends_with($(this).html(),"<br>")){
            $(this).html($(this).html().substring(0,$(this).html().length-4));
        }
        if (original_text_values[$(this).attr("id")] != $(this).html()) {
            $("form.main:first").append("<input type='hidden' name='" + $(this).attr("id") + "' value='" + sanitize_string($(this).html()) + "' />");
        }
    });
    $("form.main:first").submit();
    return false;
}

function delete_gmap(id) {
    if ($("#" + id).length>0){
        $("#" + id).hide();
        $("#" + id).html("");
    }
    else {
        if (window.parent.$)
        {
            $ = window.parent.$;
        }
    if ($("#" + id).length>0){
        $("#" + id).hide();
        $("#" + id).html("");
    }
    }
}

//Guarda la posición actual de todos los mapas en bbdd
function save_gmaps_position() {
    var id=0;
    $(".gmap").each(function() {
       if ($(this).html()!="") {
           id = $(this).attr("id");
           map = window[$($(this).children()[0]).attr("id")];
           try {
                lat = map.getCenter().lat();
                $.post(private_url + "/gmaps/update/", { id: id, lat: map.getCenter().lat(), lon: map.getCenter().lng(), zoom: map.getZoom() } );
           }
           catch (error) {

           }
       }
    });


    //Puede haber mapas en un iframe
    $("iframe").each(function() {
       map = this.contentWindow[$($(this).contents().find("div")[0]).attr("id")];
       $.post(private_url + "/gmaps/update/", { id: id, lat: map.getCenter().lat(), lon: map.getCenter().lng(), zoom: map.getZoom() } );
    });
}

function ends_with(string, pattern) {
    var d = string.length - pattern.length;
    return d >= 0 && string.lastIndexOf(pattern) === d;
}

var simpleTreeCollection;
function load_simple_tree() {
    simpleTreeCollection = $('.simpleTree').simpleTree({
        autoclose: true,
        afterClick:function(node){
            if (node.attr("class").indexOf('doc')!=-1 && node.attr('galeria_multimedia')!=1) {
                clean_imgarea();
                // Hacemos un preview del elemento pinchado
                $.ajax({
                    async:true,
                    dataType:'script',
                    url: private_url + "/folders/click_object/" + node.attr('id')
                    })
            } else if (node.attr("class").indexOf('doc')!=-1) {
                // Hacemos un preview del elemento pinchado
                $.ajax({
                    async:true,
                    dataType:'script',
                    url: private_url + "/galeriamultimedias/click_object/" + node.attr('id')
                    })
            }
            else {
                //Actualizamos la carpeta en la que nos encontramos. Para ello actualizamos el campo folder_id
                $(".hidden_folder_id").attr("value",node.attr('id'));
//                if (node.attr('id') != "Folder_0") {
                    // Hacemos un preview del elemento pinchado
                    if (node.attr('galeria_multimedia')!=1) {
                        $.ajax({
                            async:true,
                            dataType:'script',
                            url: private_url + "/folders/click/" + node.attr('id').replace("Folder_","") + "?type=" + $("#" + node.attr('id') + " > span").attr("type")
                            })
                    } else {
                        $.ajax({
                            async:true,
                            dataType:'script',
                            url: private_url + "/galeriamultimedias/click_folder/" + node.attr('id') + "?type=" + $("#" + node.attr('id') + " > span").attr("type")
                            })
                    }
//                }
//                else {
//                    $("#preview").html("");
//                }
            }
        },
        afterAjax:function() {
            setContextMenu();
        },
        afterDblClick:function(node){
        //alert("text-"+$('span:first',node).text());
        },
        afterMove:function(destination, source, pos){
            $.ajax({
                async:true,
                dataType:'script',
                url:private_url + "/folders/move_object?source=" + source.attr('id') + "&destination=" + destination.attr('id') + "&pos=" + pos
                })
        //alert("destination-"+destination.attr('id')+" source-"+source.attr('id')+" pos-"+pos);
        },
        afterContextMenu:function(node) {

        //			$.ajax({async:true, dataType:'script', url:"/folders/delete/" + node.attr('id')})
        },
        animate:true
    //,docToFolderConvert:true
    });
    $("#image_submit,#flashobject_submit,#document_submit,#video_submit").click(
        function() {
            if (!simpleTreeCollection.get(0).selected()) {
                jAlert("<div class='errorExplanation'><p>" + t("tree.select_goal") + "</p></div>",t("main.error"));
                return false;
            }
            else {
                return true;
            }
        }
        );
    $("#folder_submit").click(
        function() {
            if (!simpleTreeCollection.get(0).selected()) {
                jAlert("<div class='errorExplanation'><p>" + t("tree.select_goal") + "</p></div>",t("main.error"));
                return false;
            }
            else {
                return true;
            }
        }
        );
        $("#TB_toggle_new").click(function() {
            if ($("#tree").css("height") == "463px") {
				$("#tree").animate({ height: "296px" },500);
            }
            else {
				$("#tree").animate({ height: "463px" },500);
            }
        });
    setContextMenu();

}

function clean_imgarea() {
    $(".imgareaselect-selection").hide();
    $(".imgareaselect-border1").hide();
    $(".imgareaselect-border2").hide();
    $(".imgareaselect-outer").hide();
}

function setContextMenu() {
    $(".simpleTree span[type=folder]").contextMenu({
        menu: 'folder_menu'
    },
    function(action, el, pos) {
        var aux=action.split("#");
        switch (aux[aux.length-1]) {
            case "add":
                insert_gallery($(el).parent().attr('id'),$(nicEditor_actual_selected.e).next(".galeria").attr("id"));
                break;
            case "delete":
                $.ajax({
                    async:true,
                    dataType:'script',
                    url:private_url + "/folders/delete/" + $(el).parent().attr('id')
                    })
                break;
            case "paste":
                if ((simpleTreeCollection.object_copy != '') && (simpleTreeCollection.object_copy_type != '')) {
                    destino = $(el).parent().attr("id");
                    $.ajax({
                        async:true,
                        dataType:'script',
                        url:private_url + "/folders/clone/" + simpleTreeCollection.object_copy + "?destino=" + destino + "?type=" + simpleTreeCollection.object_type
                        });
                }
                break;
        }
    });
    $(".simpleTree span[type=Image]").contextMenu({
        menu: 'image_menu'
    },
    function(action, el, pos) {
        var aux=action.split("#");
        switch (aux[aux.length-1]) {
            case "delete":
                if ($(el).attr("otype")=="folder") {
                    delete_selected_folder(t('folder.confirm'));
                }
                else {
                    if (confirm(t('image.confirm'))) {
                        $.ajax({
                            async:true,
                            dataType:'script',
                            url:private_url + "/images/delete/" + $(el).attr('oid')
                            })
                    }
                }
                break;
            case "add":
                insert_image($(el).attr('filename'),$(el).attr('oid'));
                break;
            case "copy":
                simpleTreeCollection.object_copy = $(el).attr('oid');
                simpleTreeCollection.object_type = "images";
                break;
            case "clone":
                destino = $(el).parent().parent().parent().attr("id");
                $.ajax({
                    async:true,
                    dataType:'script',
                    url:private_url + "/images/clone/" + $(el).attr('oid') + "?destino=" + destino
                    });
                break;
            case "paste":
                if (simpleTreeCollection.object_copy != '') {
                    if ($(el).attr("otype")=="folder") {
                        destino = "Folder_" + $(el).attr("oid");
                    }
                    else {
                        destino = $(el).parent().parent().parent().attr("id");
                    }
                    $.ajax({
                        async:true,
                        dataType:'script',
                        url:private_url + "/images/clone/" + simpleTreeCollection.object_copy + "?destino=" + destino
                        });
                }
                break;
        }
    });
    $(".simpleTree span[type=Document]").contextMenu({
        menu: 'document_menu'
    },
    function(action, el, pos) {
        var aux=action.split("#");
        switch (aux[aux.length-1]) {
            case "delete":
                if ($(el).attr("otype")=="folder") {
                    delete_selected_folder(t('folder.confirm'));
                }
                else {
                    if (confirm(t('document.confirm'))) {
                        $.ajax({
                            async:true,
                            dataType:'script',
                            url:private_url + "/folders/delete_node/" + $(el).attr('oid') + "?type=Document"
                            })
                    }
                }
                break;
            case "add":
                insert_document($(el).attr('title'),$(el).attr('oid'));
                break;
            case "copy":
                simpleTreeCollection.object_copy = $(el).attr('oid');
                simpleTreeCollection.object_type = "documents";
                break;
            case "clone":
                destino = $(el).parent().parent().parent().attr("id");
                $.ajax({
                    async:true,
                    dataType:'script',
                    url:private_url + "/documents/clone/" + $(el).attr('oid') + "?destino=" + destino
                    });
                break;
            case "paste":
                if (simpleTreeCollection.object_copy != '') {
                    if ($(el).attr("otype")=="folder") {
                        destino = "Folder_" + $(el).attr("oid");
                    }
                    else {
                        destino = $(el).parent().parent().parent().attr("id");
                    }
                    $.ajax({
                        async:true,
                        dataType:'script',
                        url:private_url + "/documents/clone/" + simpleTreeCollection.object_copy + "?destino=" + destino
                        });
                }
                break;
        }
    });
}

//function set_images_tree() {
//    $("#simpleTree.doc-last").each(function() {
//       image =  $(this).find("span").attr("filename");
//       $(this).css();
//    });
//}

function add_object_to_tree(id,destination,node) {
    simpleTreeCollection.get(0).addTypedNode(id,destination,node);
    setContextMenu();
}

function show_preview_image(id) {
    clean_imgarea();
    $.ajax({
        async:true,
        dataType:'script',
        url:private_url + "/folders/click_object/Image_"+id
        });
}

function show_preview_flash(id) {
    $.ajax({
        async:true,
        dataType:'script',
        url:private_url + "/folders/click_object/Flashobject_"+id
        });
}

function load_preview_flash(file) {
    swfobject.embedSWF(file, "flash_preview", "244", "161", "8.0.0");
    activar_botones_proporcional();
}

function load_flash(file,id,width,height) {
    var flashvars = {};
    var params = {
        wmode: "transparent"
    };
    var attributes = {
        wmode: "transparent"
    };
    swfobject.embedSWF(file, id, width, height, "8.0.0","",flashvars,params,attributes);
}

function show_preview_video(id) {
    $.ajax({
        async:true,
        dataType:'script',
        url:private_url + "/folders/click_object/Video_"+id
        });
}

function add_folder_to_tree(id,destination,node) {
    simpleTreeCollection.get(0).addFolder(id,destination,node);
    setContextMenu();
}

function delete_node_from_tree(id) {
    clean_imgarea();
    $("#preview").html("");
    simpleTreeCollection.get(0).delNodeById(id);
}

function delete_folder_from_tree(id) {
    simpleTreeCollection.get(0).delNodeById(id);
}

function delete_selected_folder(m) {
    if(confirm(m)) {
        $.ajax({
            async:true,
            dataType:'script',
            url: private_url + "/folders/delete/Folder_" + $("#preview_folder").attr("oid")
            });
    }
}

function reload_tree(html) {
    clean_imgarea();
    $("#simpleTree").html(html);
    load_simple_tree();
}

function set_imgarea() {
    $("img#preview_image").imgAreaSelect({
        parent: $("#TB_window"),
        onSelectChange: select_image_tree_change
    });
}


function select_image_tree_change(img,selection) {
    $("#preview_image").attr("x1sel",selection.x1);
    $("#preview_image").attr("x2sel",selection.x2);
    $("#preview_image").attr("y1sel",selection.y1);
    $("#preview_image").attr("y2sel",selection.y2);
}

function rotate_image(angle) {
    clean_imgarea();
    id = $("#preview_image").attr("oid");
    $.ajax({
        async:true,
        dataType:'script',
        url:private_url + "/images/rotate/" + id + "?angle=" + angle
    })
}

function save_image() {
    x1sel = parseInt($("#preview_image").attr("x1sel"));
    x2sel = parseInt($("#preview_image").attr("x2sel"));
    y1sel = parseInt($("#preview_image").attr("y1sel"));
    y2sel = parseInt($("#preview_image").attr("y2sel"));
    id = $("#preview_image").attr("oid");
    if (x1sel!=x2sel) {
        pre_imagen = new Image();
        pre_imagen.src = $("#preview_image").attr("src");
        orig_width = pre_imagen.width;
        orig_height = pre_imagen.height;
        rel_width = parseInt($("#preview_image").attr("width"));
        rel_height = parseInt($("#preview_image").attr("height"));
        x1 = Math.round(x1sel*orig_width/rel_width);
        x2 = Math.round(x2sel*orig_width/rel_width);
        y1 = Math.round(y1sel*orig_height/rel_height);
        y2 = Math.round(y2sel*orig_height/rel_height);
        $.ajax({
            async:true,
            dataType:'script',
            url:private_url + "/images/crop/" + id + "?x=" + x1 + "&y=" + y1 + "&width=" + (x2-x1) + "&height=" + (y2-y1)
            })
    }
    $.ajax({
        async:true,
        dataType:'script',
        url:private_url + "/images/update_object/" + id + "?type=image&title=" + $("#preview_image_title").val() + "&name=" + $("#preview_image_name").val()
        })
}

function save_folder() {
    id = $("#preview_folder").attr("oid");
    $.ajax({
        async:true,
        dataType:'script',
        url:private_url + "/folders/update/" + id + "?name=" + $("#folder_new_name").val() + "&role=" + $("#folder_role").val() + "&recursive=" + $("#folder_recursive").is(":checked")
        })
}

function save_document() {
    id = $("#preview_document").attr("oid");
    $.ajax({async:true, dataType:'script', url:private_url + "/documents/update_object/" + id + "?type=document&title=" + $("#preview_document_title").val() + "&name=" + $("#preview_document_name").val()})
}

function save_flash() {
    id = $("#preview_flash_title").attr("oid");
    $.ajax({async:true, dataType:'script', url:private_url + "/flashobjects/update_object/" + id + "?type=flashobject&title=" + $("#preview_flash_title").val()})
}

function save_video() {
    id = $("#preview_video").attr("oid");
    $.ajax({async:true, dataType:'script', url:private_url + "/videos/update_object/" + id + "?type=video&title=" + $("#preview_video_title").val()})
}

function image_cropped(id) {
    clean_imgarea();
    $("img[oid=" + id + "]").each(function() {
        $(this).attr("src",$(this).attr("src").split("?")[0] + "?" + Math.round(Math.random()*1000000000));
    });
    set_imgarea();
}

function object_title_modified(id,title) {
    $("span[oid=" + id + "].obj_title").text(title);
}

function folder_name_modified(id,name) {
    $("span[oid=" + id + "][otype=folder]").text(name);
}

function image_rotated(id) {
    clean_imgarea();
    $("img[oid=" + id + "]").each(function() {
        $(this).attr("src",$(this).attr("src").split("?")[0] + "?" + Math.round(Math.random()*1000000000));
    });
    set_imgarea();
}

function insert_video(video,thumb,video_id) {
    html = "<a class=\"videoplayer\" href=\"" + video + "\" id=\"video_" + video_id + "\">";
    html = html + "<img src=\"" + thumb + "\"/></a>";
    replace_image_temp_tag(html);
    flowplayer("a.videoplayer", "/swf/flowplayer.swf",{ key: flowplayer_key });
    tb_remove();
  	jMessage("<p>" + t("video.added") + "</p>", t("main.alert"));
}

function activar_botones_preview_image() {
    $(".select_align").click(function() {
        s=$(this).hasClass("sel");
        $(".select_align").each(function() {
            $(this).removeClass("sel");
        });
        if (s) {
            $(this).removeClass("sel");
            $("#select_align_id").attr("value","");
        }
        else {
            $(this).addClass("sel");
            $("#select_align_id").attr("value",$(this).attr("oid"));
        }
    });
    activar_botones_proporcional();

}

function activar_botones_proporcional() {
    $(".select_proporcional").click(function() {
       $(this).toggleClass("sel");
    });

    $("#preview_image_width").change(function() {
        if ($(".select_proporcional").hasClass("sel")) {
            $("#preview_image_height").val(Math.round(parseInt($("#preview_image_original_height").val())*parseInt($("#preview_image_width").val())/parseInt($("#preview_image_original_width").val())));
        }
    });

    $("#preview_image_height").change(function() {
        if ($(".select_proporcional").hasClass("sel")) {
            $("#preview_image_width").val(Math.round(parseInt($("#preview_image_original_width").val())*parseInt($("#preview_image_height").val())/parseInt($("#preview_image_original_height").val())));
        }
    });
}

function activar_botones_link_type() {
    $(".link_type").click(function() {
        $(".link_type").each(function() {
            $(this).removeClass("sel");
        });
        $(this).addClass("sel");
    });
}

function activar_botones_mapaweb() {
    $(".mapaweb_item").click(function() {
        $("#local_page").text($(this).text());
        $("#local").attr("value",$(this).attr("link"));
        $.alerts._hide();
    });
}

function insert_videos(folder_id) {
    html = "<a class=\"videoplayer_playlist\" id=\"videos_" + folder_id + "\"></a>";
    //html = html + "<img src=\"" + thumb + "\"/></a>";
    replace_image_temp_tag(html);
    $.ajax({
        async:true,
        dataType:'script',
        url: "/videos/load_playlist/" + folder_id + "?start=1"
    });
    tb_remove();
}


function insert_image(imagen,imagen_id,title) {
    var clase;
    //Si tenemos especificado un destino, lo enviamos ahí. Si no, al editor
    if ($("#destino").length>0) {
        var destino = $("#destino").attr("value");
        $("#" + destino).attr("src",imagen);

        //Si estoy en un editor de imagen vorago, relleno el hidden
        if ($("#" + destino).parents(".edicion_imagen").length>0) {
            $("#" + destino).parents(".edicion_imagen").find("input").attr("value",imagen_id);

        }

        //Cerramos la ventana del thickbox
        tb_remove();
    }
    else {
        align = $("#select_align_id").val();
        if (align=='') {
            align = "nicedit_sin-alinear";
        }
        desc = $("#preview_image_name").val();
        if (desc == "") {
            desc = $("#preview_image_title").val();            
        }
        clase = align;
        if ($("#select_displayable").is(":checked")) {
            clase = clase + " magnify";
        }

        texto = "<img src=\"" + imagen + "\" alt=\"" + ($("#preview_image_name").val() || $("#preview_image_title").val()) + "\" class=\"" + clase + "\""
        texto = texto + " style=\"width: " + $("#preview_image_width").val() + "px; height: " + $("#preview_image_height").val() + "px;\"/>";
        replace_image_temp_tag(texto);
        tb_remove();
    }
  	jMessage("<p>" + t("image.added") + "</p>", t("main.alert"));
}

function insert_document(documento,documento_id,title) {
    if ($("#destino").length>0) {
        replace_anchor_temp_tag_document("/documents/download/" + documento_id,documento,title);
    }
    else {
        replace_anchor_temp_tag("/documents/download/" + documento_id,documento,title);
    }
    tb_remove();
  	jMessage("<p>" + t("document.added") + "</p>", t("main.alert"));
}

function insert_link(form) {
    var txt="";
    var alt="";
    var title="";
    var ok=true;
    var nueva_ventana=false;
    switch (form.find(".sel input").attr("id")) {
        case "web":
            txt=form.find(".sel input").val();
            alt=txt;
            if ((txt.split("://").length<2) && (txt[0]!="/"))  {
                txt = "http://" + txt;
            }
            title = t("link_window.follow_link") + alt;
            nueva_ventana=$("#nueva_ventana").attr("checked");
            break;
        case "local":
            txt=form.find(".sel input").val();
            alt=form.find(".sel span").text();
            title = t("link_window.follow_link") + alt;
            nueva_ventana=$("#nueva_ventana").attr("checked");
            break;
        case "mail":
            txt="mailto:" + form.find(".sel input").val();
            alt=form.find(".sel input").val();
            ok = validate_email(alt);
            title = t("link_window.send_mail") + alt;
            break;
    }
    if (ok) {
        replace_anchor_temp_tag(txt,alt,title,nueva_ventana);
        tb_remove();
    }
}

function insert_table(f) {
    rows = parseInt($("#form_tabla").find("#filas").val());
    cols = parseInt($("#form_tabla").find("#columnas").val());
    headers_filas = $("#form_tabla").find("#cabeceras_filas").attr("checked");
    headers_columnas = $("#form_tabla").find("#cabeceras_columnas").attr("checked");

	if(isNaN(cols) || isNaN(rows) || (rows==0) || (cols==0)){
        jAlert("<p>" + t("table.invalid_values") + "</p>",t("main.error"));
        return false
    }
    var tabla = "<table>";
    for(var i=0;i<rows;i++) {
       if (i==0) {
           if (headers_filas) {
                tabla += "<thead>";
           } else {
               tabla += "<tbody>";
           }
       }
       else if ((i==1) && headers_filas) {
           tabla += "<tbody>";
       }
       tabla += "<tr>";
       for(var j=0;j<cols;j++)
           if (i==0 && headers_filas)
               tabla += "<th>" + t("table.default_text") + "</th>";
           else {
               if (j==0 && headers_columnas) {
                    tabla += "<th>" + t("table.default_text") + "</th>";
               } else {
                    tabla += "<td>" + t("table.default_text") + "</td>";
               }
           }
       tabla += "</tr>";
       if ((i==0) && headers_filas) tabla += "</thead>";
    }
    tabla += "</tbody></table>";
    replace_image_temp_tag(tabla);
    tb_remove();
}

function insert_flashobject(flash,flash_id) {
    id_capa = "flash_replace_" + flash_id;
    texto = "<div class=\"flash_container\" id=\"flash_" + flash_id + "\"><div id=\"" + id_capa + "\"></div></div>";
    replace_image_temp_tag(texto);
    tb_remove();
    load_flash(flash,id_capa,$("#preview_image_width").val(),$("#preview_image_height").val());
  	jMessage("<p>" + t("flash.added") + "</p>", t("main.alert"));
}

function obtener_nicedit_instance(id){
    var B=nicEditors.editors[0].nicInstances;
    for(var A=0;A<B.length;A++){
        if(B[A].e.id==id){
            return B[A];
        }
    }
}

function insert_gallery(id,div) {
    var tipo = $("#galeriatipo_id").val();
    $.ajax({
        async:true,
        dataType:'script',
        url:private_url + "/galerias/create/" + id + "?div=" + div + "&tipo=" + tipo
        });
	jMessage(t("galeria.aniadida"), t("main.alert"));		
}

function insert_multimedia_gallery(id,div) {
    objs = [];
                $("#multimedias_folder li").each(function(){
                        objs = objs.concat($(this).attr("oid"));
                })
    $.ajax({
        async:true,
        dataType:'script',
        url:private_url + "/galeriamultimedias/create/" + id + "?div=" + div + "&orden=" + objs.join("o")
        });
	jMessage(t("galeria.aniadida"), t("main.alert"));
}

function crop_preview(objeto) {
    pre_imagen = new Image();
    pre_imagen.src = $(objeto).attr("src");
    orig_width = $(objeto).width;
    orig_height = $(objeto).height;
    width = $(objeto).parents(".edicion_imagen:first").width();
    height = $(objeto).parents(".edicion_imagen:first").height();
    factor_width = 1;
    if (orig_width!=0) {
        factor_width = width / orig_width;
    }
    factor_height = 0;
    if (orig_height!=0) {
        factor_height = height / orig_height;
    }
    factor = 0;
    sobrante_width = 0;
    sobrante_height = 0;
    if (factor_width > factor_height) {
        factor = factor_width;
        sobrante_width = 0;
        sobrante_height = (orig_height * factor) - height;
    } else {
        factor = factor_height;
        sobrante_width = (orig_width * factor) - width;
        sobrante_height = 0;
    }
    final_width = orig_width * factor;
    final_height = orig_height * factor;
    $(objeto).width(final_width);
    $(objeto).height(final_height);
    $(objeto).css("margin-left", -1 * sobrante_width/2);
    $(objeto).css("margin-top", -1 * sobrante_height/2);
}

function editar_imagen(id,objeto,width,height) {
    tb_show("Imágenes","/folders/index?height=500&width=650&type=image&destino=" + id,false);
    return false;
}

function quitar_imagen(id_imagen,url) {
    $("#" + id_imagen + "_preview").attr("src",url);
    $("#" + id_imagen).attr("value",'0');
}

function editar_file(elto) {
    var contenido = "";
    contenido = nicEditor_actual_selected.getContent().replace(/\r/g, '').replace(/\n/g, '');
    contenido = "<!--aux_block_start-->" + contenido + "<!--aux_block_end-->";
    nicEditor_actual_selected.setContent(contenido);
    tb_show("Documentos","/documents/index?height=500&width=650&type=documents&destino=file",false);
    return false;
}

function setpopup() {
    $('.bubbleInfo').each(function () {
        // options
        var distance = 10;
        var time = 250;
        var hideDelay = 500;

        var hideDelayTimer = null;

        // tracker
        var beingShown = false;
        var shown = false;

        var trigger = $('.trigger', this);
        var popup = $('.popup', this).css('opacity', 0);

        // set the mouseover and mouseout on both element
        $([trigger.get(0), popup.get(0)]).mouseover(function (e) {
            // stops the hide event if we move from the trigger to the popup element
            if (hideDelayTimer) clearTimeout(hideDelayTimer);

            // don't trigger the animation again if we're being shown, or already visible
            if (beingShown || shown) {
                return;
            } else {
                beingShown = true;
                // Detect mouse position
                var d = {}, x, y;
                if( self.innerHeight ) {
                    d.pageYOffset = self.pageYOffset;
                    d.pageXOffset = self.pageXOffset;
                    d.innerHeight = self.innerHeight;
                    d.innerWidth = self.innerWidth;
                } else if( document.documentElement &&
                    document.documentElement.clientHeight ) {
                    d.pageYOffset = document.documentElement.scrollTop;
                    d.pageXOffset = document.documentElement.scrollLeft;
                    d.innerHeight = document.documentElement.clientHeight;
                    d.innerWidth = document.documentElement.clientWidth;
                } else if( document.body ) {
                    d.pageYOffset = document.body.scrollTop;
                    d.pageXOffset = document.body.scrollLeft;
                    d.innerHeight = document.body.clientHeight;
                    d.innerWidth = document.body.clientWidth;
                }
                (e.pageX) ? x = e.pageX : x = e.clientX + d.scrollLeft;
                (e.pageY) ? y = e.pageY : x = e.clientY + d.scrollTop;
                if ($("#TB_window").length>0) {
                    x -=  $("#TB_window").position().left + parseInt($("#TB_window").css("margin-left").replace("px",""));
                    y -=  $("#TB_window").position().top + parseInt($("#TB_window").css("margin-top").replace("px",""));
                }

                // reset position of popup box
                popup.css({
                    top: y,
                    left: x,
                    display: 'block' // brings the popup back in to view
                })

                // (we're using chaining on the popup) now animate it's opacity and position
                .animate({
                    top: '+=' + distance + 'px',
                    opacity: 1
                }, time, 'swing', function() {
                    // once the animation is complete, set the tracker variables
                    beingShown = false;
                    shown = true;
                });
            }
        }).mouseout(function () {
            // reset the timer if we get fired again - avoids double animations
            if (hideDelayTimer) clearTimeout(hideDelayTimer);

            // store the timer so that it can be cleared in the mouseover if required
            hideDelayTimer = setTimeout(function () {
                hideDelayTimer = null;
                popup.animate({
                    top: '-=' + distance + 'px',
                    opacity: 0
                }, time, 'swing', function () {
                    // once the animate is complete, set the tracker variables
                    shown = false;
                    // hide the popup entirely after the effect (opacity alone doesn't do the job)
                    popup.css('display', 'none');
                });
            }, hideDelay);
        });
    });
}


function t(key) {
    return eval("og_cms_locales." + key);
}
