FactoryBot.define do
  factory :mailing_list_name, class: MailingList::Steps::Name do
    first_name { "Test" }
    sequence(:last_name) { |n| "User #{n}" }
    sequence(:email) { |n| "testuser#{n}@testing.education.gov.uk" }
    degree_status_id { GetIntoTeachingApi::Constants::DEGREE_STATUS_OPTIONS["First year"] }
  end
end
