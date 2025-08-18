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

     shareToX(shareUrl, orderId)
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

function shareToX(shareUrl, orderId) {
    try {
        // textinfo
        // 動的にしたい。ex, XXのYYを注文しました。XXのYYを気になるメニューに追加しました。
        const shareText = encodeURIComponent('前にもこれ食べたな, 注文時の悩みを記録で解決');
        const encodeUrl = encodeURIComponent(shareUrl);
        const hashTags = encodeURIComponent('注文履歴アプリOrder?');

        const xShareUrl = `https://x.com/intent/post?text=${shareText}&url=${encodeUrl}&hashtags=${hashTags}`;
        console.log('x共有URL:', xShareUrl);

        //xを開く
        window.open(xShareUrl, '_blank', 'width=550,height=420');

        
    } catch (error) {
        console.error('共有エラー:', error);
        alert('失敗');
    }
}