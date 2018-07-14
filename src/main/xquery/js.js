(function ($) {
    // SETS UP RIGHT/LEFT ARROW PAGINGATION
    // Key 39 is the right arrow
    // Key 37 is the left arrow
    $('body').keyup(function (event) 
    {
        if (event.keyCode == 39) 
        {
            // a.next-link
            //$('a.next-link').attr('href')
            window.open($('a.next-link').attr('href'),'_self'); 
        }
        else if (event.keyCode == 37) 
        {   // a.prev-link
            window.open($('a.prev-link').attr('href'),'_self');
        }
    });    		
})(jQuery);