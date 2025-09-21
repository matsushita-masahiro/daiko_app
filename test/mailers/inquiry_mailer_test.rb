require "test_helper"

class InquiryMailerTest < ActionMailer::TestCase
  test "inquiry_received" do
    mail = InquiryMailer.inquiry_received
    assert_equal "Inquiry received", mail.subject
    assert_equal [ "to@example.org" ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "answer_sent" do
    mail = InquiryMailer.answer_sent
    assert_equal "Answer sent", mail.subject
    assert_equal [ "to@example.org" ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match "Hi", mail.body.encoded
  end
end
