(function ($) {
    // SETS UP RIGHT/LEFT ARROW PAGINGATION
    // Key 39 is the right arrow
    // Key 37 is the left arrow
    $('body').keyup(function (event) 
    {
        if (event.keyCode == 39) 
        {
            window.open('next.xqy','_self'); 
        }
        else if (event.keyCode == 37) 
        {
            window.open('prev.xqy','_self');
        }
    });    		
})(jQuery);