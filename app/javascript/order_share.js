document.addEventListener('DOMContentLoaded', function() {
  console.log('order_share.js が読み込まれました');
  
//  const shareButtons = document.querySelectorAll('.share-btn');
//  console.log('共有ボタンの数:', shareButtons.length);

  shareButtons.forEach(button => {
    button.addEventListener('click', function() {

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
      const orderStatus = this.dataset.orderStatus === 'true';
      console.log('StoreName:', storeName);
      console.log('MenuName:', menuName);
      console.log('OrderStatus:', orderStatus);

      const shareData = {
        store_name: storeName,
        menu_name: menuName,
        shareUrl: shareUrl,
        orderStatus: orderStatus
      }

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
    return `${store_name}で${menu_name}を注文しました`;
  } else {
    return `${store_name}の${menu_name}を気になるメニューとして登録しました`;
  }
}