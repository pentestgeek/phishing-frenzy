$( document ).ready(function() {
  // enable dataTable on campaign#list
  $('#campaigns').dataTable({
    "aoColumnDefs": [ { 'bSortable': false, "aTargets": [ 0, 5 ] } ],
    "iDisplayLength": 25
  });

  // prefill SMTP settings on pre-populate dropdown change
  $('#smtpPreFill').change(function () {
    var myValue = $(this).val();
    switch (myValue) {
      case 'google':
        $('#campaign_email_settings_attributes_smtp_server').val('smtp.gmail.com');
        $('#campaign_email_settings_attributes_smtp_server_out').val('smtp.gmail.com');
        $('#campaign_email_settings_attributes_authentication').val('plain');
        $('#campaign_email_settings_attributes_domain').val('gmail.com');
        $('#campaign_email_settings_attributes_enable_starttls_auto').prop('checked', true);
        $('#campaign_email_settings_attributes_openssl_verify_mode').val('VERIFY_NONE');
        $('#campaign_email_settings_attributes_smtp_port').val('587');
        break;
      case 'outlook':
        $('#campaign_email_settings_attributes_smtp_server').val('smtp.outlook.com');
        $('#campaign_email_settings_attributes_smtp_server_out').val('smtp.outlook.com');
        $('#campaign_email_settings_attributes_smtp_port').val('25');
        break;
      case 'godaddy':
        $('#campaign_email_settings_attributes_smtp_server').val('smtp.secureserver.net');
        $('#campaign_email_settings_attributes_smtp_server_out').val('smtpout.secureserver.net');
        $('#campaign_email_settings_attributes_smtp_port').val('3535');
        break;
      case 'sendgrid':
        $('#campaign_email_settings_attributes_smtp_server').val('smtp.sendgrid.net');
        $('#campaign_email_settings_attributes_smtp_server_out').val('smtp.sendgrid.net');
        $('#campaign_email_settings_attributes_smtp_port').val('25');
        break;
    }
  });

  // if use_beef checked function
  function is_stuff_checked() {
    if ($("#campaign_campaign_settings_attributes_use_beef").is(':checked')) {
      // enable beef_url form
      $("#beef-url").show( 1500 );
    }
    else {
      // disable beef_url form
      $("#beef-url").hide( 1000 );
    }

    if ($("#campaign_campaign_settings_attributes_ssl").is(':checked')) {
      // display ssl form
      $("[id=ssl-row]").show( 1500 );
    }
    else {
      // hide ssl form
      $("[id=ssl-row]").hide( 1000 );
    }
  }

  // enable checkbox stuff on page load
  is_stuff_checked();

  // click event handler to for checked stuff
  $( "#campaign_campaign_settings_attributes_use_beef" ).on( "click", is_stuff_checked);
  $( "#campaign_campaign_settings_attributes_ssl" ).on( "click", is_stuff_checked);
});