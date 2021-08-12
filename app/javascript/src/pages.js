var ready = function(){
  !function(){const e=document.documentElement;if(e.classList.remove("no-js"),e.classList.add("js"),document.body.classList.contains("has-animations")){const e=window.sr=ScrollReveal();e.reveal(".hero-title, .hero-paragraph, .hero-cta",{duration:1e3,distance:"40px",easing:"cubic-bezier(0.5, -0.01, 0, 1.005)",origin:"bottom",interval:150}),e.reveal(".feature, .pricing-table",{duration:600,distance:"40px",easing:"cubic-bezier(0.5, -0.01, 0, 1.005)",interval:100,origin:"bottom",viewFactor:.5}),e.reveal(".feature-extended-image",{duration:600,scale:.9,easing:"cubic-bezier(0.5, -0.01, 0, 1.005)",viewFactor:.5})}}();
};

$(document).ready(ready);
$(document).on('page:load', ready);
