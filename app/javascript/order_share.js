document.addEventListener('DOMContentLoaded', function() {
  console.log('order_share.js が読み込まれました');
  
  const shareButtons = document.querySelectorAll('.share-btn');
  console.log('共有ボタンの数:', shareButtons.length);
  
  shareButtons.forEach(button => {
    button.addEventListener('click', function() {
        //動作確認
      console.log('共有ボタンがクリックされました！');

      //id, token取得
      const orderId = this.dataset.orderId;
      const shareToken = this.dataset.shareToken;
      console.log('Order ID:', orderId);
      console.log('Share Token:', shareToken);

      // urlの生成
      const shareUrl = generateShareUrl(shareToken);
      console.log('生成されたURL:', shareUrl);

      // まずはアラートで確認
      //alert(`注文ID: ${this.dataset.orderId} の共有ボタンがクリックされました！`);
     // alert('共有URL: ${shareUrl}');

     //shareToX(shareUrl, orderId)
     shareToX(shareData);
    });
  });
});

function generateShareUrl(shareToken) {
    // 既存ページを取得
    const baseUrl = window.location.origin;

    // url生成
    const shareUrl = `${baseUrl}/orders/share/${shareToken}`;
    return shareUrl;
}

//function shareToX(shareUrl, orderId) {
function shareToX(shareData) {
    try {
        // textinfo
        const encodeUrl = encodeURIComponent(shareUrl);
        const hashTags = encodeURIComponent('注文履歴アプリOrder?');


        if (shareData.store_name) {
          const text = `${shareData.store_name}の情報をチェック`;
        }

        const xShareUrl = `https://x.com/intent/post?url=${encodeUrl}&hashtags=${hashTags}`;
        console.log('x共有URL:', xShareUrl);

        //xを開く
        window.open(xShareUrl, '_blank', 'width=550,height=420');

        
    } catch (error) {
        console.error('共有エラー:', error);
        alert('失敗');
    }
}

function generateShareText(data) {
  const storeName = shareData.store_name;
  const menuName = shareData.menu_name;

//  if (data.ordered) {
//    text = `${data.store_name}で${data.menu_name}を注文しました`;
//  } else {
    text = `${storeName}で${menuName}を気になるメニューとして登録しました`;
//  }
}