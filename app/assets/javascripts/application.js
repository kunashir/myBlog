// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery/dist/jquery.min
//= require jquery.turbolinks
//= require jquery-ui
//= require jquery_ujs
//= require turbolinks
//= require select2
//= require transportation
//= require jquery-ui/datepicker-ru
//= require bootstrap/dist/js/bootstrap
//= require metisMenu/dist/metisMenu.min
//= require raphael/raphael-min
//= require morrisjs/morris.min
//= require sb-admin-2.js
//= require datatables/media/js/jquery.dataTables.min
//= require datatables-plugins/integration/bootstrap/3/dataTables.bootstrap.min
//= require datetimepicker/jquery.datetimepicker


 $(document).ready(function() {
      $('#dataTables-example').DataTable({
              responsive: true
      });
  });

(function($) {
  $(document).ready(function() {
    $("#transportation_client_id").select2({ width: 'resolve' }); //transportation_storage_id
  });
})(jQuery);

(function($){
  $(document).ready(function() {
    $("#datepicker").change(function(){
      //alert ("ttts");
      $("#link_to_xls").html('<a href="transportations/export?datepicker='+$("#datepicker").val() +'" >Сохранить в xls</a>');
    });
  });
})(jQuery);


function InitDatepeicker () {
  $(".datepicker").datepicker({
      format: 'dd.mm.yy', 
      region: "ru", 
      changeMonth: true,
      changeYear: true,
      yearRange: "-1:+0"
    }
  );

  $(".datetimepicker").datetimepicker({
    lang: "ru",
    i18n:{
      ru:{
        months:['Январь','Февраль','Март','Апрель','Май','Июнь','Июль','Август','Сентябрь','Октябрь','Ноябрь','Декабрь']
      }
    },
    format: 'd.m.Y H:m'
  });
}

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

(function($) {
  $(document).ready(function() {
    InitDatepeicker();
  });
})(jQuery);


(function($) {
  $(document).ready(function() {
    $.ajax(
    {
      type: "GET",
			url:  "/transportations/server_time",
			data: "",
			dataType: "text",
			error: function(XMLHttpRequest, textStatus, errorThrown){
        $("#server_time").html("ОШИБКА: не удалось получить время сервера!");
			},
      success:  function(result){
        $("#server_time").html(result);
        //var temp = $("#server_time").text();
        //alert (temp+"::" + result);
        setInterval(function() {$("#server_time").html( add_sec( $("#server_time").text() ) ); },1000);
      }


    });
  });
})(jQuery);