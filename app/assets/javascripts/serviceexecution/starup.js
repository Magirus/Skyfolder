$(document).ready(function(){
    $(function() {
		$( "#how_to_use_tabs" ).tabs();
        setCookie("enc", false);
	});

    $("h1").addClass("li_hovered",4000).removeClass("li_hovered",4000);


});

function loading(){
    var flag = false;
    $(".loading_div a:first-child").each(function(){
        var text = $(this).text();
        if ($(this).parent().prev().css('width') == "150px"){
            if ($("#encrypt_enabled .enabler").is(':checked')){
                $(this).text('Шифрування');
                flag = true;
            }
            else {
                $(this).text('Зачекайте');
                flag = true;
            }
        }
        else {
            $(this).text('Завантаження');
            flag = true;
        }
        var dots = $(this).next();
        if (dots.text().length != 3){
            $(dots).text($(dots).text().concat('.'));
        }
        else {
            $(dots).text("");
        }
    });
    if (flag){
        setTimeout(loading, 1000);
    }
};

function Download(el){
    var container = $(el).parent().parent();
    $(container).effect('pulsate',"normal");

    $(container).find(".downloading_div").css("display","block");
    setTimeout(function(){$(container).find(".downloading_div").css("display","none");}, 5000);
}

function Encryption(){
    if ($("#encrypt_enabled .enabler").is(':checked')){
        $("#encrypt_warning").show('fold', 250);
    }
    else{
        $("#encrypt_warning").hide();
    }

    setCookie("enc", $("#encrypt_enabled .enabler").is(':checked'));
};

function setCookie(c_name,value,exdays)
{
       var exdate=new Date();
       exdate.setDate(exdate.getDate() + exdays);
       var c_value=escape(value) + ((exdays==null) ? "" : "; expires="+exdate.toUTCString());
       document.cookie=c_name + "=" + c_value;
};


