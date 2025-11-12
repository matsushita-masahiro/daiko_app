// app/javascript/user_location.js
document.addEventListener("turbo:load", () => {
  // セッションストレージで位置情報が既に送信済みかチェック
  const locationSent = sessionStorage.getItem('location_sent');
  
  if (locationSent) {
    console.log('位置情報は既に送信済みです');
    return;
  }

  if (!navigator.geolocation) {
    console.warn("このブラウザでは位置情報APIがサポートされていません。");
    return;
  }

  // 10秒のタイムアウトを設定
  const timeoutId = setTimeout(() => {
    console.warn("位置情報の取得がタイムアウトしました");
  }, 10000);

  const options = {
    enableHighAccuracy: false,
    timeout: 10000,
    maximumAge: 0
  };

  navigator.geolocation.getCurrentPosition(
    (position) => {
      clearTimeout(timeoutId);
      
      const csrfToken = document.querySelector("[name='csrf-token']");
      if (!csrfToken) {
        console.error("CSRFトークンが見つかりません");
        return;
      }

      fetch("/user_location", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": csrfToken.content
        },
        body: JSON.stringify({
          latitude: position.coords.latitude,
          longitude: position.coords.longitude
        })
      })
      .then(response => {
        if (response.ok) {
          // 送信成功をセッションストレージに記録
          sessionStorage.setItem('location_sent', 'true');
          console.log('位置情報を送信しました');
        } else {
          console.warn('位置情報の送信に失敗しました:', response.status);
        }
      })
      .catch(error => {
        console.error('位置情報の送信中にエラーが発生しました:', error);
      });
    },
    (error) => {
      clearTimeout(timeoutId);
      
      switch(error.code) {
        case error.PERMISSION_DENIED:
          console.log("ユーザーが位置情報の取得を拒否しました");
          break;
        case error.POSITION_UNAVAILABLE:
          console.warn("位置情報が利用できません");
          break;
        case error.TIMEOUT:
          console.warn("位置情報の取得がタイムアウトしました");
          break;
        default:
          console.warn("位置情報の取得に失敗しました:", error.message);
      }
    },
    options
  );
});
