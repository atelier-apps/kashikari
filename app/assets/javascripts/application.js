// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require_tree .

function hoge(select){
  swal({
    title: "友達の新規作成",
    text: "新しい友達の名前を入力します",
    content: "input",
    button: "追加"
  }).then(function(value){
    if(value==null||value==false||value===""){
      swal({
        text: "キャンセルしました",
        icon: "warning",
        buttons: false,
        timer: 2500
      });
      select.val(1);
    }else{
      $.ajax({
        url: '/hoge',
        type: 'GET',
        dataType: 'json',
        async: false,
        data: {
          name: value,
          user_id: 1
        }
      }).done(function(data){
        console.log(data);
        if(data!=null){
          swal({
            text: value+"を追加しました",
            icon: "success",
            buttons: false,
            timer: 2500
          });
          select.html(data.html)
          select.val(data.friend_id)
        }else{
          select.val(1)
        }
      }).fail(function(data){
        select.val(1)
      });
    }

  });

}
