// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
// $("input.date_picker").datepicker();

//(function($) {
  //$("#datepicker").datepicker();
  ////$("#datepicker").datepicker("option", "dateFormat", "yy-mm-dd");
//}
//)(jQuery);

//$(function($) {
    //$( "#datepicker" ).datepicker();
		//$( "#datepicker" ).datepicker("option", "dateFormat", "yy-mm-dd");
	//})(jQuery);;

(function($) {
  $(document).ready(function() {
    $( "#datepicker" ).datepicker({
      dateFormat: 'yy-mm-dd'
    });
  });
})(jQuery);

(function($) 
{
  $(document).ready(
    function() 
    {
        $("#transportation_client_id").change(
         function() 
         {
              
              $("#transportation_storage_id").html("<option>Загрзука...</option>");
              $.ajax(
              {
                type: "GET",
                url:  "/transportations/-1/get_storage",
                data: "client=" + $(this).val(),
                dataType: "text",
                error:  function(XMLHttpRequest, textStatus, errorThrown)
                {
                  alert("Ошибка получения списка складов");
                },
                success:  function(result)
                {
                  //alert (result);
                  $("#transportation_storage_id").html(result);
                }
                  
              });
        });
    });
  })(jQuery);
      
(function($) {
  $(document).ready(function() {
    $("#load_tr").click(
      function()
      {
        $.ajax(
        {
          type: "GET",
          url:  "/transportations/-1/load",
          data: "file=" + $("#user_file").val(),
          dataType: "text",
          error: function(XMLHttpRequest, textStatus, errorThrown)
          {
            $("#show_res").html("ОШИБКА: загрзука завершилась аварийно!")
          },
          success:  function(result)
          {
             //alert (result);
             $("#show_res").html(result);
          }
          
          
        });
  });
});
})(jQuery);    
