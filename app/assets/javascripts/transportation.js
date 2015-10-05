function showPopup() {
  if ($(".rate-popup").css("display") === "none") {
    $(".rate-popup").show();
  } else {
    $(".rate-popup").hide();
  }
}



$(document).on('click', '.close-popup', function(e) {
  showPopup();
  return false;
});

function ExtraPayVisible(){
  if ($("#transportation_complex_direction").is(':checked')){
        $(".extra_fields").show();
      }
      else
      {
        $(".extra_fields").hide();
      }
}

function GetStartSum()
{
  $.ajax(
    {
      type: "GET",
      url:  "/transportations/get_start_sum",
      data: {
        "storage" : $("#transportation_city_id").val(),
        "area" : $("#transportation_area_id").val(),
        "carcase" : $("#transportation_carcase").val(),
        "weight": $("#transportation_weight").val()},
      dataType: "text",
      error:  function(XMLHttpRequest, textStatus, errorThrown)
      {
        alert("Ошибка получения суммы тарифа!!!");
      },
      success:  function(result)
      {
        //alert (result);
        $("#transportation_start_sum").val(result);
      }
    }
  );
}

function TriggerForStartSum(){
  $("#transportation_city_id").change(GetStartSum);
  $("#transportation_carcase").change(GetStartSum);
}

function GetClientCities()
{
  //If client change - try to get its cities
  $("#transportation_client_id").change(
    function(){
      $.ajax(
        {
          type: "GET",
          url:  "/transportations/get_storage",
          data: {"client" : $(this).val()},
          dataType: "text",
          error:  function(XMLHttpRequest, textStatus, errorThrown)
          {
            alert("Ошибка получения списка городов!!!");
          },
          success:  function(result)
          {
            //alert (result);
            $("#transportation_city_id").html(result);
          }
        }
      );
    }
  );
}


(function($) {
  $(document).ready(function() {
    //$(".extra_fields").hide(); //transportation_storage_id
    ExtraPayVisible();
    $("#transportation_complex_direction").click(function(){
      ExtraPayVisible();
    })
  });
})(jQuery);

(function($){
  $(document).ready(function(){
      TriggerForStartSum();
      GetClientCities();
      }
    );
  }
)(jQuery);

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


(function($) {
  $(document).ready(function() {
    $(".oper_column").on("ajax:success", function(e, data, status, xhr){
      $(".do_rate_form").html(data);
      showPopup();
      showRecaptcha();

    }
      ).bind("ajax:error", function(){ alert("Error!!")});

  }
  );
}) (jQuery);

(function($) {
  $(document).ready(function() {
    $(".history").on("ajax:success", function(e, data, status, xhr){
      $(".do_rate_form").html(data);
      showPopup();


    }
      ).bind("ajax:error", function(){ alert("Error!!")});

  }
  );
}) (jQuery);