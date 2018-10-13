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
//= require lib/jquery.min
//= require lib/sweetalert.min
//= require rails-ujs
//= require activestorage
//= require_tree .

function create_friend(select){
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
        url: '/createFriend',
        type: 'POST',
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

function edit_friend(friend_id, previous_name){
  swal({
    title: "友達の編集",
    text: "友達の名前を編集します",
    content: {
      element: "input",
      attributes: {
        placeholder: "山田太郎",
        value: previous_name
      }
    },
    button: "編集"
  }).then(function(value){
    if(value==null||value==false||value===""){
    }else{
      $.ajax({
        url: '/editFriend',
        type: 'POST',
        dataType: 'json',
        async: false,
        data: {
          frined_id: friend_id,
          name: value,
          user_id: 1
        }
      }).done(function(data){
        if(data!=null){
          swal({
            text: value+"に変更しました",
            icon: "success",
            buttons: false,
            timer: 2500
          }).then((value) => {
            location.reload();
          });

        }
      }).fail(function(data){
        swal({
          text: "失敗しました",
          icon: "error",
          buttons: false,
          timer: 2500
        });
      });
    }

  });

}

//画面横向き防止
$(window).on('load orientationchange resize', function(){
    if (Math.abs(window.orientation) === 90) {
        // 横向きになったときの処理
        $(".restrict-reverse").css('visibility','visible');

    } else {
        // 縦向きになったときの処理
        $(".restrict-reverse").css('visibility','hidden');
    }
});
