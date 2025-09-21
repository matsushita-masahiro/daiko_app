# 管理者ダッシュボード機能 - 設計書

## 概要

Basic認証を使用した管理者機能を実装し、お問い合わせの管理と回答機能を提供します。

## アーキテクチャ

### 認証フロー

```
[/admin/*] → [Basic認証] → [管理者機能]
     ↓           ↓            ↓
  認証要求    ユーザー名/PW   ダッシュボード
```

### 管理者機能フロー

```
[Dashboard] → [Inquiries Index] → [Answer New]
     ↓              ↓                ↓
  統計表示      お問い合わせ一覧    回答作成
```

## コンポーネント設計

### 1. Basic認証の実装

#### ApplicationController の拡張

```ruby
class ApplicationController < ActionController::Base
  protected

  def authenticate_admin
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV['ADMIN_USERNAME'] && password == ENV['ADMIN_PASSWORD']
    end
  end
end
```

#### Admin::BaseController の作成

```ruby
class Admin::BaseController < ApplicationController
  before_action :authenticate_admin
  layout 'admin'
end
```

### 2. コントローラー設計

#### Admin::DashboardController

- `index`: ダッシュボード表示
- 統計情報の取得と表示

#### Admin::InquiriesController

- `index`: お問い合わせ一覧表示
- `show`: お問い合わせ詳細表示

#### Admin::AnswersController

- `new`: 回答作成画面表示
- `create`: 回答保存とメール送信

### 3. ルーティング設計

```ruby
namespace :admin do
  root 'dashboard#index'
  resources :inquiries, only: [:index, :show] do
    resources :answers, only: [:new, :create]
  end
end
```

### 4. ビュー設計

#### レイアウト構造

```
app/views/layouts/admin.html.erb
├── app/views/admin/dashboard/index.html.erb
├── app/views/admin/inquiries/index.html.erb
├── app/views/admin/inquiries/show.html.erb
└── app/views/admin/answers/new.html.erb
```

#### 管理者レイアウト

- 管理者専用のヘッダー
- ナビゲーションメニュー
- 管理者用のスタイル

## データモデル

### 既存モデルの活用

- `Inquiry`: 既存のお問い合わせモデル
- `Answer`: 既存の回答モデル

### 統計情報の取得

```ruby
# ダッシュボード用の統計
total_inquiries = Inquiry.count
unanswered_inquiries = Inquiry.left_joins(:answers).where(answers: { id: nil }).count
answered_inquiries = total_inquiries - unanswered_inquiries
```

## インターフェース設計

### ダッシュボード画面

```
┌─────────────────────────────────┐
│ 管理者ダッシュボード             │
├─────────────────────────────────┤
│ 統計情報                        │
│ ・総お問い合わせ数: XX件        │
│ ・未回答: XX件                  │
│ ・回答済み: XX件                │
├─────────────────────────────────┤
│ メニュー                        │
│ [お問い合わせ管理]              │
└─────────────────────────────────┘
```

### お問い合わせ一覧画面

```
┌─────────────────────────────────┐
│ お問い合わせ一覧                │
├─────────────────────────────────┤
│ 日時    │ 名前  │ 区分 │ 状況   │
├─────────┼───────┼──────┼────────┤
│ 2025/01 │ 山田  │ 依頼 │ 未回答 │
│ 2025/01 │ 田中  │ 質問 │ 回答済 │
└─────────────────────────────────┘
```

### 回答作成画面

```
┌─────────────────────────────────┐
│ お問い合わせ回答                │
├─────────────────────────────────┤
│ [お問い合わせ内容表示]          │
├─────────────────────────────────┤
│ 回答内容:                       │
│ ┌─────────────────────────────┐ │
│ │                             │ │
│ │                             │ │
│ └─────────────────────────────┘ │
│ [送信]                          │
└─────────────────────────────────┘
```

## セキュリティ設計

### Basic認証の設定

- 環境変数での認証情報管理
- `ADMIN_USERNAME` と `ADMIN_PASSWORD`
- 本番環境では強力なパスワードを設定

### アクセス制御

- 全ての管理者機能に認証を要求
- セッション管理の適切な実装
- CSRF保護の継続

## スタイル設計

### 管理者専用CSS

```scss
// app/assets/stylesheets/admin.scss
.admin-layout {
  background: #f5f5f5;
  
  .admin-header {
    background: #343a40;
    color: white;
    padding: 1rem;
  }
  
  .admin-nav {
    background: #495057;
    padding: 0.5rem;
  }
  
  .admin-content {
    padding: 2rem;
  }
}
```

## エラーハンドリング

### 認証エラー

- Basic認証失敗時の適切な応答
- 認証情報不正時のログ記録

### データエラー

- お問い合わせが存在しない場合の処理
- 回答保存失敗時の処理
- メール送信失敗時の処理

## テスト戦略

### 認証テスト

- Basic認証の成功/失敗ケース
- 認証なしでのアクセス拒否

### 機能テスト

- ダッシュボードの表示
- お問い合わせ一覧の表示
- 回答機能の動作

### 統合テスト

- 管理者フローの一連動作
- メール送信の確認