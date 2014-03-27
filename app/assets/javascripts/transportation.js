function ExtraPayVisible(){
  if ($("#transportation_complex_direction").is(':checked')){
        $(".extra_fields").show();
      }
      else
      {
        $(".extra_fields").hide();
      }
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