# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $(document).on "keypress", "input:not(.allow_submit)", (event) -> event.which != 13

  $("select[name^=filter]").change ->
    filter_status=$("#filter_status").val()
    filter_friend=$("#filter_friend").val()
    window.location="contract_list?status_filter_selected="+filter_status+"&friend_filter_selected="+filter_friend
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
      $("#refundButton").val("返済する")
    else if balance < inputPrice
      $("#refundButton").prop("disabled", true)
      $("#refundButton").val("返済する")
    else
      $("#refundButton").prop("disabled", false)
      $("#refundButton").val("部分返済する")

  $("#loaning_price").on 'input', ->
    console.log($(this).val())
    inputPrice = Number($(this).val())
    if inputPrice <= 0
      $("#makingButton").prop("disabled", true)
    else
      $("#makingButton").prop("disabled", false)

  $("#contract_friend_id").change ->
      friend_id=$(this).val()
      if friend_id is ""
        create_friend($(this))
