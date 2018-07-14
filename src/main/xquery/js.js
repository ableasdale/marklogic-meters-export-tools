(function ($) {
    console.log("ready");
    // SETS UP RIGHT/LEFT ARROW PAGINGATION
    // Key 39 is the right arrow
    // Key 37 is the left arrow
    $('body').keyup(function (event) 
    {
        if (event.keyCode == 39) 
        {
            console.log("right");
            window.open('next-page-url','_self'); 
        }
        else if (event.keyCode == 37) 
        {
            console.log("left");
            window.open('previous-page-url','_self');
        }
    });    		
})(jQuery);