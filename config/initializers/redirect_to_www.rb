# wwwなしのドメインからwwwありのドメインへリダイレクト
require_relative '../../lib/rack/host_redirect'

Rails.application.config.middleware.insert_before 0, Rack::HostRedirect,
  'hirokuru.com' => 'www.hirokuru.com'
