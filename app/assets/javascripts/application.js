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
//= require lib/sweetalert2.min
//= require rails-ujs
//= require activestorage
//= require_tree .
window.onbeforeunload = function() {
    // IE用。ここは空でOKです
};
window.onunload = function() {
    // IE以外用。ここは空でOKです
};
window.addEventListener("pageshow", function(event){
  if (event.persisted) {
    // ここにキャッシュ有効時の処理を書く
    $("#loading_spenner").css('visibility','visible');
    window.location.reload();
  }
});

function parse_amount(amount){
  return String(amount).replace( /(\d)(?=(\d\d\d)+(?!\d))/g, '$1,')+"円";
}

function create_friend(select){
  swal({
    text: "新しい友達の名前",
    showCloseButton: true,
    input: 'text',
    confirmButtonText: '保存',
  }).then(function(data){
    if(data.dismiss!=null){
      swal({
        text: "キャンセルしました",
        type: "warning",
        showConfirmButton: false,
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
          name: data.value,
          user_id: 1
        }
      }).done(function(data2){
        if(data2!=null){
          swal({
            text: data.value+"を追加しました",
            type: "success",
            showConfirmButton: false,
            timer: 2500
          });
          select.html(data2.html)
          select.val(data2.friend_id)
        }else{
          swal({
            text: "すでに存在する名前です",
            type: "error",
            timer: 2500
          });
          select.val(1)
        }
      }).fail(function(data){
        swal({
          text: "失敗しました",
          type: "error",
          showConfirmButton: false,
          timer: 2500
        });
        select.val(1)
      });
    }

  });

}

function edit_friend(friend_id, previous_name){
  swal({
    text: "友達の名前を変更",
    showCloseButton: true,
    input: 'text',
    inputAttributes: {
      placeholder: previous_name
    },
    confirmButtonText: '保存',
  }).then(function(data){
    if(data.dismiss!=null||data.value==""||data.value==null){
      swal({
        text: "キャンセルしました",
        type: "warning",
        showConfirmButton: false,
        timer: 2500
      });
    }else{
      $.ajax({
        url: '/editFriend',
        type: 'POST',
        dataType: 'json',
        async: false,
        data: {
          frined_id: friend_id,
          name: data.value,
          user_id: 1
        }
      }).done(function(data2){
        if(data2!=null){
          swal({
            text: data.value+"に変更しました",
            type: 'success',
            showConfirmButton: false,
            timer: 2500
          }).then((value) => {
            location.reload();
          });

        }else{
          swal({
            text: "すでに存在する名前です",
            type: "error",
            timer: 2500
          });
        }
      }).fail(function(data){
        swal({
          text: "失敗しました",
          type: "error",
          showConfirmButton: false,
          timer: 2500
        });
      });
    }

  });

}

function delete_contract(contract_id){

  swal({
    text: "本当に削除しますか",
    type: "question",
    showConfirmButton: true,
    showCancelButton: true,
    focusConfirm: true,
    focusCancel: true,
  }).then(function(data){

    if(data.dismiss==null){
      $.ajax({
        url: '/deleteContract',
        type: 'POST',
        dataType: 'json',
        async: false,
        data: {
          contract_id: contract_id
        }
      }).done(function(data2){
        swal({
          text: "削除しました",
          type: "success",
          showConfirmButton: false,
          timer: 2500
        }).then((data3) => {
          location.reload()
        });
      }).fail(function(data2){
        swal({
          text: "失敗しました",
          type: "error",
          showConfirmButton: false,
          timer: 2500
        });
      });
    }else{
      swal({
        text: "キャンセルしました",
        type: "warning",
        showConfirmButton: false,
        timer: 2500
      });
    }
  });
}

function option(contract_id){
  swal({
    showCloseButton: true,
    showConfirmButton: false,
    focusClose: false,
    html: $("#option").get(0)
    });
}

//画面横向き防止
$(window).on('load orientationchange resize', function(){
    if (Math.abs(window.orientation) === 90) {
        // 横向きになったときの処理
        $("#restrict_reverse").css('visibility','visible');

    } else {
        // 縦向きになったときの処理
        $("#restrict_reverse").css('visibility','hidden');
    }
});
