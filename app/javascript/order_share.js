//document.addEventListener('DOMContentLoaded', function() {
//  console.log('order_share.js が読み込まれました');
//  
//  const shareButtons = document.querySelectorAll('.share-btn');
//  console.log('共有ボタンの数:', shareButtons.length);
//
//  shareButtons.forEach(button => {
//    button.addEventListener('click', function() {
//        //動作確認
//      console.log('共有ボタンがクリックされました！');
//
//      //id, token取得
//      const orderId = this.dataset.orderId;
//      const shareToken = this.dataset.shareToken;
//      console.log('Order ID:', orderId);
//      console.log('Share Token:', shareToken);
//
//      // urlの生成
//      const shareUrl = generateShareUrl(shareToken);
//      console.log('生成されたURL:', shareUrl);
//
//      //storename, menuname取得
//      const storeName = this.dataset.storeName;
//      const menuName = this.dataset.menuName;
//      const orderStatus = this.dataset.orderStatus === 'true';
//      console.log('StoreName:', storeName);
//      console.log('MenuName:', menuName);
//      console.log('OrderStatus:', orderStatus);
//
//      const shareData = {
//        store_name: storeName,
//        menu_name: menuName,
//        shareUrl: shareUrl,
//        orderStatus: orderStatus
//      }
//
//     //shareToX(shareUrl, orderId)
//     shareToX(shareData);
//    });
//  });
//});
document.addEventListener('click', function(event) {
    // 1. クリックされた要素から、最も近い '.share-btn' の親要素を探す
    const button = event.target.closest('.share-btn');
    
    // 2. 共有ボタンがクリックされた場合のみ処理を実行
    if (button) {
        event.preventDefault(); // リンク要素の場合のデフォルト動作を防ぐ（今回はボタンなので必須ではないが安全のため）
        
        // 動作確認
        console.log('共有ボタンがクリックされました！ (イベント委譲)');

        // id, token取得（button 変数を使う）
        const orderId = button.dataset.orderId;
        const shareToken = button.dataset.shareToken;
        console.log('Order ID:', orderId);
        console.log('Share Token:', shareToken);

        // urlの生成
        const shareUrl = generateShareUrl(shareToken);
        console.log('生成されたURL:', shareUrl);

        // storename, menuname取得
        const storeName = button.dataset.storeName;
        const menuName = button.dataset.menuName;
        const orderStatus = button.dataset.orderStatus === 'true';
        console.log('StoreName:', storeName);
        console.log('MenuName:', menuName);
        console.log('OrderStatus:', orderStatus);

        const shareData = {
          store_name: storeName,
          menu_name: menuName,
          shareUrl: shareUrl,
          orderStatus: orderStatus
        };

        // shareToX 関数を呼び出す
        shareToX(shareData);
    }
});

function generateShareUrl(shareToken) {
    // 既存ページを取得
    const baseUrl = window.location.origin;

    // url生成
    const shareUrl = `${baseUrl}/orders/share/${shareToken}`;
    return shareUrl;
}

function shareToX(shareData) {
    try {
        const shareText = generateShareText(shareData);
        console.log('TEXT:', shareText);
        
        // textinfo
        const encodeUrl = encodeURIComponent(shareData.shareUrl);
        const hashTags = encodeURIComponent('注文履歴アプリOrder?');
        
        const encodeText = encodeURIComponent(shareText);

        const xShareUrl = `https://x.com/intent/post?text=${encodeText}&url=${encodeUrl}&hashtags=${hashTags}`;
        console.log('x共有URL:', xShareUrl);

        //xを開く
        window.open(xShareUrl, '_blank');

        
    } catch (error) {
        console.error('共有エラー:', error);
        alert('失敗');
    }
}

function generateShareText(shareData) {
  const { store_name, menu_name, orderStatus } = shareData;

  if (orderStatus) {
    return `${store_name}の${menu_name}を注文しました`;
  } else {
    return `${store_name}の${menu_name}を気になるメニューとして登録しました`;
  }
}