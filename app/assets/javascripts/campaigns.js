$( document ).ready(function() {
  // enable dataTable on campaign#list
  $('#campaigns').dataTable( {
  "sPaginationType": "bootstrap",
  "aoColumnDefs": [ { 'bSortable': false, "aTargets": [ 0, 5 ] } ],
  "iDisplayLength": 25
  });

  // prefill SMTP settings on pre-populate dropdown change
  $('#smtpPreFill').change(function () {
    var myValue = $(this).val();
    switch (myValue) {
      case 'google':
        $('#email_settings_smtp_server').val('smtp.gmail.com');
        $('#email_settings_smtp_server_out').val('smtp.gmail.com');
        $('#email_settings_authentication').val('plain');
        $('#email_settings_domain').val('gmail.com');
        $('#email_settings_enable_starttls_auto').prop('checked', true);
        $('#email_settings_openssl_verify_mode').val('VERIFY_NONE');
        $('#email_settings_smtp_port').val('587');
        break;
      case 'outlook':
        $('#email_settings_smtp_server').val('smtp.outlook.com');
        $('#email_settings_smtp_server_out').val('smtp.outlook.com');
        $('#email_settings_smtp_port').val('25');
        break;
      case 'godaddy':
        $('#email_settings_smtp_server').val('smtp.secureserver.net');
        $('#email_settings_smtp_server_out').val('smtpout.secureserver.net');
        $('#email_settings_smtp_port').val('3535');
        break;
      case 'sendgrid':
        $('#email_settings_email_settings_smtp_server').val('smtp.sendgrid.net');
        $('#email_settings_smtp_server_out').val('smtp.sendgrid.net');
        $('#email_settings_smtp_port').val('25');
        break;
    }
  });

  // if use_beef checked function
  function is_beef_checked() {
    if ($("#campaign_settings_use_beef").is(':checked')) {
      // enable beef_url form
      $("#campaign_settings_beef_url").prop('disabled', false);
    }
    else {
      // disable beef_url form
      $("#campaign_settings_beef_url").prop('disabled', true);
    }
  }

  // enable beef_url if use_beef is checked on page load
  is_beef_checked();

  // click event handler to enable beef_url if use_beef is checked
  $( "#campaign_settings_use_beef" ).on( "click", is_beef_checked);
});