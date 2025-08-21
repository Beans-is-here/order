document.addEventListener('DOMContentLoaded', function() {
  console.log('order_share.js が読み込まれました');
  
  const shareButtons = document.querySelectorAll('.share-btn');
  console.log('共有ボタンの数:', shareButtons.length);

 // if (!window.shareData) {
 //   console.error('window.shareDataが定義されていません');
 //   return;
 // }

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

      //storename, menuname取得
      const storeName = this.dataset.storeName;
      const menuName = this.dataset.menuName;
      console.log('StoreName:', storeName);
      console.log('MenuName:', menuName);

      const shareData = {
        store_name: storeName,
        menu_name: menuName,
        shareUrl: shareUrl
      }

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
        const shareText = generateShareText(shareData);
        console.log('TEXT:', shareText);
        
        // textinfo
        const encodeUrl = encodeURIComponent(shareData.shareUrl);
        const hashTags = encodeURIComponent('注文履歴アプリOrder?');
        
        const encodeText = encodeURIComponent(shareText);


       // if (shareData.store_name) {
       //   const text = `${shareData.store_name}の情報をチェック`;
       // }

        const xShareUrl = `https://x.com/intent/post?url=${encodeUrl}&hashtags=${hashTags}`;
        console.log('x共有URL:', xShareUrl);

        //xを開く
        window.open(xShareUrl, '_blank', 'width=550,height=420');

        
    } catch (error) {
        console.error('共有エラー:', error);
        alert('失敗');
    }
}

function generateShareText(shareData) {
  const storeName = shareData.store_name;
  const menuName = shareData.menu_name;

//  if (data.ordered) {
//    text = `${data.store_name}で${data.menu_name}を注文しました`;
//  } else {
    return `${storeName}で${menuName}を気になるメニューとして登録しました`;
//  }
}