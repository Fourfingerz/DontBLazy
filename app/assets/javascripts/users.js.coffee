# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$('#hidden_phone_number').val('<%= @user.phone_number %>')
$('#send-pin').hide()
$('#verify-pin').fadeToggle()
$('#pin').focus()