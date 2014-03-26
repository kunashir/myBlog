// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require jquery.ui.all
//= require jquery.blockUI.js
//= require select2


//(function($) {
//  $(document).ready(function() {
//      $("#datepicker").click(function() {
//	  $.blockUI({ message: "<H1> Are you shure?</H1>" });
	  //alert ("Buy buy");
	  //setTimeout($.unblockUI(), 10000);
//      });
//  });
//})(jQuery);

(function($) {
  $(document).ready(function() {
    $( "#datepicker" ).datepicker({
      dateFormat: 'yy-mm-dd'
    });
    $("#transportation_client_id").select2(); //transportation_storage_id
    $("#transportation_storage_id").select2();
  });
})(jQuery);

(function($){
  $(document).ready(function() {
    $("#datepicker").change(function(){
      //alert ("ttts");
      $("#link_to_xls").html('<a href="transportations/-1/export?datepicker='+$("#datepicker").val() +'" >Сохранить в xls</a>');
    })
  })
})(jQuery);

(function($)
{
  $(document).ready(
    function()
    {
        $("#transportation_storage_id").change(
         function()
         {

            $.ajax(
             {
              type: "GET",
              url:  "/transportations/-1/get_start_sum",
              data: "storage=" + $(this).val() + ",area=" + $("#transportation_area_id").val() + ",carcase=" + $("#transportation_carcase").val(),
              dataType: "text",
              error:  function(XMLHttpRequest, textStatus, errorThrown)
              {
                alert("Ошибка получения списка складов");
              },
              success:  function(result)
              {
                //alert (result);
                $("#transportation_start_sum").val(result);
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

function add_sec(cur_time)
{
   // alert (cur_time);
   // return cur_time;
    if (cur_time.length == 0)
    {
        return "00:00:00";
     }
    var time = cur_time.split(":");
    var is_change_min = false;
    var is_change_hour = false;
    if (time[2] == "59")
    {
       is_change_min = true;
       time[2] = "00";
    }
    else
    {
       var loc = parseInt(time[2], 10) + 1;
       if (loc < 10)
       {
           time[2] = "0" + loc;
       }
       else
       {
           time[2] = loc;
       }
    }
    if (is_change_min)
    {
         if (time[1] == "59")
        {
             is_change_hour = true;
              time[1] = "00";
        }
         else
        {
            var loc = parseInt(time[1], 10) + 1;
            if (loc < 10)
            {
                time[1] = "0" + loc;
            }
            else
            {
               time[1] = loc;
            }
        }
    }

    if (is_change_hour)
    {
         if (time[0] == "23")
        {
             is_change_hour = true;
              time[0] = "00";
        }
         else
        {
            var loc = parseInt(time[0], 10) + 1;
            if (loc < 10)
            {
                time[0] = "0" + loc;
            }
            else
            {
               time[0] = loc;
            }
        }
    }
    return time[0]+":"+time[1]+":"+time[2];
}

/*(function($) {
  $(document).ready(function() {
   setInterval(function() {$("#server_time").html( add_sec($("#server_time").val()) ); },1000);
  });
})(jQuery);
*/

(function($) {
  $(document).ready(function() {
         $.ajax(
	     {
         	type: "GET",
			url:  "/transportations/-1/server_time",
			data: "",
			dataType: "text",
			error: function(XMLHttpRequest, textStatus, errorThrown)
         		{
			      $("#server_time").html("ОШИБКА: не удалось получить время сервера!");
			},
          		success:  function(result)
			{
			      //alert (result);
			      $("#server_time").html(result);
                  //var temp = $("#server_time").text();
                  //alert (temp+"::" + result);
                  setInterval(function() {$("#server_time").html( add_sec( $("#server_time").text() ) ); },1000);
		        }


        });
});
})(jQuery);


function saveToXls ()
{
  $.ajax(
       {
          type: "POST",
          url:  "/transportations/-1/export?datepicker=" + $("#datepicker").val(),
          data: "",
          dataType: "text",
          error: function(XMLHttpRequest, textStatus, errorThrown)
          {
            alert ("Ошибка формирования файла xls");
          },
          success:  function(result)
          {
            //alert (result);
            //$("#server_time").html(result);
                  //var temp = $("#server_time").text();
                  //alert (temp+"::" + result);
             //     setInterval(function() {$("#server_time").html( add_sec( $("#server_time").text() ) ); },1000);
            }


        });
  return false;
}