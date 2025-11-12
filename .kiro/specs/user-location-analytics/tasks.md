# 実装計画

- [x] 1. データベースとモデルのセットアップ
  - UserLocationモデルとテーブルを作成し、位置情報データを保存できるようにする
  - マイグレーションファイルを作成してuser_locationsテーブルを定義する
  - UserLocationモデルにバリデーション、スコープ、ビジネスロジックを実装する
  - _要件: 2.1, 2.2, 2.3, 2.4_

- [x] 1.1 マイグレーションファイルの作成
  - user_locationsテーブルのマイグレーションを生成する
  - latitude, longitude, ip_address, user_agent, referer, visited_at, anonymized_atカラムを定義する
  - visited_at, latitude/longitude, ip_addressにインデックスを追加する
  - _要件: 2.1, 2.2, 2.3, 2.4, 7.5_

- [x] 1.2 UserLocationモデルの実装
  - UserLocationモデルファイルを作成する
  - バリデーション（latitude, longitude, ip_address, visited_atの必須チェック）を追加する
  - スコープ（today, this_week, this_month, within_service_area, outside_service_area）を実装する
  - record_locationクラスメソッドを実装する
  - within_service_area?インスタンスメソッドを実装する
  - _要件: 2.1, 2.2, 2.3, 2.4, 3.2_

- [x] 1.3 匿名化処理の実装
  - anonymize_old_recordsクラスメソッドを実装する（30日以上前のレコードのIPアドレスを匿名化）
  - _要件: 5.4_

- [x] 2. UserLocationsコントローラーの実装
  - フロントエンドからの位置情報データを受信し、データベースに保存する
  - UserLocationsControllerを作成する
  - createアクションを実装してPOSTリクエストを処理する
  - ルーティングを追加する
  - _要件: 1.3, 2.5_

- [x] 2.1 UserLocationsControllerの作成
  - app/controllers/user_locations_controller.rbを作成する
  - createアクションを実装する（latitude, longitudeパラメータを受け取る）
  - UserLocation.record_locationを呼び出してデータを保存する
  - 成功時にHTTP 201、失敗時にHTTP 422を返す
  - _要件: 1.3, 2.5_

- [x] 2.2 ルーティングの追加
  - config/routes.rbにPOST /user_locationルートを追加する
  - _要件: 1.3_

- [x] 3. JavaScriptの改善
  - 既存のuser_location.jsを改善し、要件に沿った動作を実装する
  - セッションキャッシュ機能を追加する
  - タイムアウト処理を追加する
  - エラーハンドリングを改善する
  - _要件: 1.1, 1.2, 1.3, 1.4, 1.5, 7.1, 7.2, 7.3, 7.4_

- [x] 3.1 user_location.jsの改善
  - セッションストレージで位置情報をキャッシュする機能を追加する
  - 10秒のタイムアウトを設定する
  - エラーハンドリングを改善する（許可拒否、タイムアウト、ネットワークエラー）
  - プライバシー通知を表示する機能を追加する（オプション）
  - _要件: 1.1, 1.2, 1.3, 1.4, 5.2, 7.1, 7.2, 7.3, 7.4_

- [x] 3.2 application.jsへのインポート確認
  - app/javascript/application.jsにuser_location.jsがインポートされていることを確認する
  - _要件: 1.1_

- [x] 4. 管理者ダッシュボードの拡張
  - 既存のAdmin::DashboardControllerに位置情報分析を追加する
  - ダッシュボードビューに位置情報統計を表示する
  - _要件: 3.1, 3.2, 3.3, 3.4_

- [x] 4.1 Admin::DashboardControllerの拡張
  - app/controllers/admin/dashboard_controller.rbのindexアクションに位置情報統計を追加する
  - 総位置情報レコード数を取得する
  - サービスエリア内/外の件数と割合を計算する
  - 今日、今週、今月の位置情報件数を取得する
  - 最近の位置情報レコード（10件）を取得する
  - _要件: 3.1, 3.2, 3.3, 3.4_

- [x] 4.2 ダッシュボードビューの更新
  - app/views/admin/dashboard/index.html.erbに位置情報統計セクションを追加する
  - 総レコード数、サービスエリア内/外の割合を表示する
  - 時系列データ（今日、今週、今月）を表示する
  - 最近の位置情報レコードをテーブルで表示する
  - _要件: 3.1, 3.2, 3.3, 3.4_

- [ ] 5. 時系列分析機能の実装
  - 日付別、時間帯別の分析データを提供する
  - Admin::DashboardControllerに時系列データの集計ロジックを追加する
  - ダッシュボードビューにチャートを表示する
  - _要件: 4.1, 4.2, 4.3, 4.4_

- [ ] 5.1 時系列データの集計
  - Admin::DashboardControllerに日別の訪問者数を集計するロジックを追加する
  - 時間帯別（0-23時）の訪問者数を集計するロジックを追加する
  - _要件: 4.1, 4.4_

- [ ] 5.2 チャート表示の実装
  - Chart.jsまたはChartkickを使用してチャートを表示する
  - 日別訪問者数の折れ線グラフを追加する
  - 時間帯別訪問者数の棒グラフを追加する
  - _要件: 4.2_

- [ ] 6. CSVエクスポート機能の実装
  - 管理者が位置情報データをCSV形式でエクスポートできるようにする
  - Admin::LocationAnalyticsControllerを作成する
  - exportアクションを実装する
  - ダッシュボードにエクスポートボタンを追加する
  - _要件: 6.1, 6.2, 6.3, 6.4, 6.5_

- [ ] 6.1 Admin::LocationAnalyticsControllerの作成
  - app/controllers/admin/location_analytics_controller.rbを作成する
  - Admin::BaseControllerを継承する
  - exportアクションを実装する（CSV形式でデータを出力）
  - 日付範囲フィルタリング機能を追加する
  - 最大10,000レコードに制限する
  - _要件: 6.1, 6.2, 6.3, 6.4, 6.5_

- [ ] 6.2 ルーティングの追加
  - config/routes.rbにGET /admin/location_analytics/exportルートを追加する
  - _要件: 6.1_

- [ ] 6.3 ダッシュボードにエクスポートボタンを追加
  - app/views/admin/dashboard/index.html.erbにCSVエクスポートボタンを追加する
  - 日付範囲フィルタリングフォームを追加する（オプション）
  - _要件: 6.1, 6.4_

- [ ] 7. バックグラウンドジョブの設定
  - 30日以上前のIPアドレスを匿名化する定期ジョブを設定する
  - AnonymizeOldLocationsJobを作成する
  - whenever gemまたはcronで定期実行を設定する
  - _要件: 5.4_

- [ ] 7.1 AnonymizeOldLocationsJobの作成
  - app/jobs/anonymize_old_locations_job.rbを作成する
  - UserLocation.anonymize_old_recordsを呼び出す
  - _要件: 5.4_

- [ ] 7.2 定期実行の設定
  - config/schedule.rbを作成する（wheneverを使用する場合）
  - 毎日深夜に実行するように設定する
  - _要件: 5.4_

- [x] 8. スタイリングの追加
  - 位置情報分析セクションのCSSスタイルを追加する
  - 統計カード、テーブル、チャートのスタイリングを実装する
  - _要件: 3.1, 3.2, 3.3, 3.4_

- [x] 8.1 管理者ダッシュボードのスタイリング
  - app/assets/stylesheets/admin.scssに位置情報分析セクションのスタイルを追加する
  - 統計カードのレイアウトを実装する
  - テーブルのスタイリングを追加する
  - レスポンシブデザインを考慮する
  - _要件: 3.1, 3.2, 3.3, 3.4_

- [x] 9. マイグレーションの実行とテスト
  - データベースマイグレーションを実行する
  - 動作確認を行う
  - _要件: すべて_

- [x] 9.1 マイグレーションの実行
  - rails db:migrateを実行する
  - マイグレーションが正常に完了することを確認する
  - _要件: 2.1_

- [x] 9.2 動作確認
  - ブラウザでサイトにアクセスし、位置情報が取得されることを確認する
  - 管理者ダッシュボードで統計が表示されることを確認する
  - CSVエクスポートが動作することを確認する
  - _要件: すべて_
