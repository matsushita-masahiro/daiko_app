# 設計ドキュメント

## 概要

神戸運転代行ヒロクルのウェブサイトに訪問者の位置情報を収集・分析する機能を追加します。既存のPageViewモデルとAdmin::DashboardControllerを拡張し、位置情報データの収集、保存、可視化を実装します。

## アーキテクチャ

### システム構成

```
[ブラウザ] 
  ↓ (Geolocation API)
[user_location.js] 
  ↓ (AJAX POST)
[UserLocationsController#create]
  ↓
[UserLocation Model]
  ↓
[PostgreSQL/SQLite Database]
  ↑
[Admin::LocationAnalyticsController]
  ↓
[Admin Dashboard View]
```

### レイヤー構造

1. **プレゼンテーション層**
   - JavaScript (user_location.js): ブラウザの位置情報API呼び出し
   - Views: 管理者ダッシュボードでの分析表示

2. **アプリケーション層**
   - UserLocationsController: 位置情報データの受信とバリデーション
   - Admin::LocationAnalyticsController: 分析データの集計と提供

3. **ドメイン層**
   - UserLocation Model: 位置情報データのビジネスロジック
   - LocationAnalyzer Service: 位置情報の分析ロジック

4. **データ層**
   - user_locations テーブル: 位置情報データの永続化

## コンポーネントとインターフェース

### 1. UserLocation Model

**責務**: 位置情報データの管理と分析用クエリの提供

**属性**:
- `latitude` (decimal): 緯度
- `longitude` (decimal): 経度
- `ip_address` (string): IPアドレス
- `user_agent` (text): ユーザーエージェント
- `referer` (string): 参照元URL
- `visited_at` (datetime): 訪問日時
- `anonymized_at` (datetime): 匿名化日時
- `created_at` (datetime): 作成日時
- `updated_at` (datetime): 更新日時

**メソッド**:
- `self.record_location(request, latitude, longitude)`: 位置情報の記録
- `self.within_service_area`: サービスエリア内の位置情報を取得
- `self.outside_service_area`: サービスエリア外の位置情報を取得
- `self.today`: 今日の位置情報を取得
- `self.this_week`: 今週の位置情報を取得
- `self.this_month`: 今月の位置情報を取得
- `self.anonymize_old_records`: 30日以上前のIPアドレスを匿名化
- `within_service_area?`: サービスエリア内かどうかを判定
- `approximate_address`: 概算住所を取得（逆ジオコーディング）

### 2. UserLocationsController

**責務**: フロントエンドからの位置情報データの受信

**アクション**:
- `create`: 位置情報データの保存

**リクエスト形式**:
```json
{
  "latitude": 34.6901,
  "longitude": 135.1955
}
```

**レスポンス**:
- 成功: HTTP 201 Created
- 失敗: HTTP 422 Unprocessable Entity

### 3. Admin::LocationAnalyticsController

**責務**: 管理者向けの位置情報分析データの提供

**アクション**:
- `index`: 位置情報分析ダッシュボード
- `export`: CSV形式でのデータエクスポート

**提供データ**:
- 総位置情報レコード数
- サービスエリア内/外の割合
- 時系列データ（日別、週別、月別）
- 最近の位置情報レコード
- 時間帯別アクセス統計

### 4. LocationAnalyzer Service

**責務**: 位置情報の分析ロジック

**メソッド**:
- `service_area_stats`: サービスエリア統計の計算
- `time_series_data(start_date, end_date)`: 時系列データの生成
- `hourly_breakdown`: 時間帯別の内訳
- `recent_locations(limit)`: 最近の位置情報取得

### 5. JavaScript (user_location.js)

**責務**: ブラウザでの位置情報取得とサーバーへの送信

**機能**:
- ページ読み込み後に位置情報を非同期取得
- セッションストレージでキャッシュ（重複リクエスト防止）
- 10秒のタイムアウト設定
- エラーハンドリング

## データモデル

### user_locations テーブル

```ruby
create_table :user_locations do |t|
  t.decimal :latitude, precision: 10, scale: 6, null: false
  t.decimal :longitude, precision: 10, scale: 6, null: false
  t.string :ip_address, null: false
  t.text :user_agent
  t.string :referer
  t.datetime :visited_at, null: false
  t.datetime :anonymized_at
  t.timestamps
end

add_index :user_locations, :visited_at
add_index :user_locations, [:latitude, :longitude]
add_index :user_locations, :ip_address
```

### サービスエリアの定義

神戸市全域、芦屋市、西宮市、尼崎市を含む矩形エリア:
- 北緯: 34.6°〜34.8°
- 東経: 135.0°〜135.5°

より正確な判定が必要な場合は、ポリゴンベースの判定を実装。

## エラーハンドリング

### クライアントサイド
- 位置情報APIが利用不可: コンソールに警告を出力、処理を継続
- ユーザーが許可を拒否: ログに記録、処理を継続
- タイムアウト: 10秒後に処理を中断
- ネットワークエラー: サイレントに失敗（ユーザー体験に影響なし）

### サーバーサイド
- 無効な座標: HTTP 422エラーを返す
- データベースエラー: ログに記録、HTTP 500エラーを返す
- CSRF検証失敗: HTTP 403エラーを返す

## テスト戦略

### 単体テスト (RSpec)

1. **UserLocation Model**
   - バリデーションのテスト
   - スコープのテスト
   - サービスエリア判定のテスト
   - 匿名化処理のテスト

2. **UserLocationsController**
   - 正常な位置情報の保存
   - 無効なデータの拒否
   - CSRF保護の確認

3. **Admin::LocationAnalyticsController**
   - 認証が必要なことの確認
   - 統計データの正確性
   - CSVエクスポートの動作

4. **LocationAnalyzer Service**
   - 統計計算の正確性
   - エッジケースの処理

### 統合テスト (System Tests)

1. 位置情報の取得から保存までのフロー
2. 管理者ダッシュボードでの表示
3. CSVエクスポート機能

### JavaScriptテスト

1. 位置情報APIの呼び出し
2. セッションキャッシュの動作
3. エラーハンドリング

## セキュリティ考慮事項

1. **CSRF保護**: すべてのPOSTリクエストにCSRFトークンを含める
2. **レート制限**: 同一IPからの過度なリクエストを制限
3. **データ匿名化**: 30日後にIPアドレスを自動匿名化
4. **アクセス制御**: 管理者のみが分析データにアクセス可能
5. **プライバシー通知**: 位置情報取得前にユーザーに通知

## パフォーマンス最適化

1. **データベースインデックス**: visited_at、latitude、longitude、ip_addressにインデックス
2. **非同期処理**: 位置情報取得はページ読み込み後に非同期実行
3. **キャッシュ**: セッションストレージで位置情報をキャッシュ
4. **バッチ処理**: 匿名化処理は定期的なバッチジョブで実行
5. **クエリ最適化**: 集計クエリにはデータベースの集約関数を使用

## デプロイメント考慮事項

1. **マイグレーション**: user_locationsテーブルの作成
2. **環境変数**: サービスエリアの座標範囲を設定可能に
3. **バックグラウンドジョブ**: 匿名化処理用のcronジョブ設定
4. **モニタリング**: 位置情報取得の成功率を監視

## 今後の拡張性

1. **地図表示**: Google Maps APIまたはLeaflet.jsでの可視化
2. **ヒートマップ**: 訪問者密度の可視化
3. **詳細な住所情報**: 逆ジオコーディングAPIの統合
4. **リアルタイム分析**: WebSocketでのリアルタイム更新
5. **機械学習**: 訪問パターンの予測分析
