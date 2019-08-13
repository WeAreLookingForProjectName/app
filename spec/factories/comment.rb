FactoryBot.define do
  factory :comment do
    user
    post
    sub { post.sub }
    text { "Text" }

    trait :moderated do
      approved_at { Time.current }
      deleted_at { Time.current }
    end

    trait :not_moderated do
      approved_at { nil }
      deleted_at { nil }
    end
    
    factory :comment_with_reports do
      transient do
        reports_count { 2 }
      end

      after(:create) do |comment, evaluator|
        create_list(:report, evaluator.reports_count, reportable: comment)
      end
    end
  end
end