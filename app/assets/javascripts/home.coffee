# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $(document).on "keypress", "input:not(.allow_submit)", (event) -> event.which != 13

  $("select[name^=filter]").change ->
    filter_note=$("#filter_note").val()
    filter_friend=$("#filter_friend").val()
    window.location="contract_list?note_filter_selected="+filter_note+"&friend_filter_selected="+filter_friend
    return

  $("#payment_amount").on 'input', ->
    console.log($("#contractBalance").attr("data-balance") )
    console.log($(this).val())
    balance = Number($("#contractBalance").attr("data-balance"))
    inputPrice = Number($(this).val())
    if balance == inputPrice
      $("#refundButton").prop("disabled", false)
      $("#refundButton").val("返済する")
    else if inputPrice <= 0
      $("#refundButton").prop("disabled", true)
      $("#refundButton").val("1円以上を入力してください")
    else if balance < inputPrice
      $("#refundButton").prop("disabled", true)
      $("#refundButton").val("返済金額を超えています")
    else
      $("#refundButton").prop("disabled", false)
      $("#refundButton").val("部分返済する")

  $("#contract_friend_id").change ->
      friend_id=$(this).val()
      if friend_id is ""
        create_friend($(this))

  $("img").click ->
    if $(this).attr("name") isnt "PAID"
      $(this).attr('src','/assets/icon_paid-3ac411dfa518fce3e303a57d905e7bdaf9a334bb3cea9d6551a27e433bb48707.png');
      $(this).addClass('animation-check');
