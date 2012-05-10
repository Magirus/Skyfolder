var IE6 = (navigator.userAgent.indexOf("MSIE 6")>=0) ? true : false;
if(IE6){

	$(function(){
		
		$("<div>")
			.css({
				'position': 'absolute',
				'top': '0px',
				'left': '0px',
				backgroundColor: 'black',
				'opacity': '0.75',
				'width': '100%',
				'height': $(window).height(),
				zIndex: 5000
			})
			.appendTo("body");
			
		$("<div><img src='/assets/ie6/no-ie6.png' alt='' style='float: left;'/><p><br /><strong>Даний веб ресурс не можливо переглянути в браузері Internet Explorer 6, який ви на даний момент використовуєте.</strong><br /><br />Якщо ви хочете переглянути дану сторінку будь-ласка встановіть сучасний браузер. Ми рекомендуємо використовувати <a href='https://www.google.com/chrome?hl=ru'>Google Chrome</a></p>")
			.css({
				backgroundColor: 'white',
				'top': '50%',
				'left': '50%',
				marginLeft: -210,
				marginTop: -100,
				width: 410,
				paddingRight: 10,
				height: 200,
				'position': 'absolute',
				zIndex: 6000
			})
			.appendTo("body");
	});		
}