var opacity_1 = 1;
var opacity_2 = 0.5;
var background_color_1 = 'rgba( 100, 100, 100, 0.5)';
var background_color_2 = 'rgba(44, 44, 44, 0.9)';
var font_color_1 = 'rgba( 255, 255, 255, 0.99)';
var font_color_2 = 'rgba( 255, 255, 255, 0.5)';
var time_for_animation_1 = 150;
var time_for_animation_2 = 100;
var not_css3_1 = '#646464';
var not_css3_2 = '#2c2c2c';
var time_for_animation_3 = 250;
$(document).ready(function(){
    $(".menu>ul>li").hover(
     function(){
         if ($.browser.version < 9){
             $(this).addClass("li_hovered").animate({
                 'background-color':not_css3_1
             },time_for_animation_2);
         }
         else {
             $(this).addClass("li_hovered").animate({
                 'background-color':background_color_1
             },time_for_animation_2);
             $(this).children('a').animate({
             'color':font_color_1
             },time_for_animation_2).addClass('box_shadow');
         }

         $(".li_hovered ul").show('clip',time_for_animation_3);
     },
     function(){
         $(".li_hovered ul").hide('clip',time_for_animation_2);
         if ($.browser.version < 9){
             $(this).removeClass("li_hovered").animate({
                 'background-color':not_css3_2
             },time_for_animation_1);
         }
         else{
            $(this).children('a').animate({
             'color':font_color_2
             },time_for_animation_2).removeClass('box_shadow');
            $(this).removeClass("li_hovered").animate({
                 'background-color':background_color_2
             },time_for_animation_1);
         }
     });
 /*$(".menu >ul> li").hover(
     function(){
         $(this).animate({opacity : opacity}, time_for_opacity,
             function(){
                 $(this).addClass("li_hovered").animate({opacity:1}, time_for_opacity);
                 $(".li_hovered ul").show('clip',time_for_animation_1)});
         },
     function(){
         $(this).animate({opacity : opacity}, time_for_opacity,
             function(){
                 $(".li_hovered ul").hide('clip',time_for_animation_2);
                $(this).removeClass("li_hovered").animate({opacity:1}, time_for_opacity);
             });
         });
    */
    $("li ul li").hover(
     function(){
         if ($.browser.version < 9){
            $(this).animate({
                 'background-color':not_css3_1
             },time_for_animation_2);
         }
         else {
             $(this).animate({
                 'background-color':background_color_1
             },time_for_animation_2);
             $(this).children('a').animate({
                 'color':font_color_1
             },time_for_animation_2);
         }
     },
     function(){
         if ($.browser.version < 9){
            $(this).animate({
                 'background-color':not_css3_2
             },time_for_animation_2);
         }
         else {
             $(this).animate({
                 'background-color':background_color_2
             },time_for_animation_1);
             $(this).children('a').animate({
                 'color':font_color_2
             },time_for_animation_2);
         }
     });

    $("#hover_enter").click(function(event){
        $("#enter_form").show(600, 'easeInBack');
        event.preventDefault();
    });

    $("#enter_form .image_close").click(function(){
        $("#enter_form").hide('drop', 300);
    });

});




