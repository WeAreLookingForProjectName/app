FactoryBot.define do
  factory :community do
    sequence(:url) { |i| "community#{i}" }
    sequence(:title) { |i| "Community #{i}" }
    sequence(:description) { |i| "Description #{i}" }

    trait :default do
      url { "all" }
    end

    factory :default_community, traits: [:default]

    factory :community_with_moderators do
      transient do
        moderators_count { 2 }
        moderator_user { create(:user) }
      end

      after(:create) do |community, evaluator|
        create_list(:moderator, evaluator.moderators_count, community: community, user: evaluator.moderator_user)
      end
    end

    factory :community_with_followers do
      transient do
        followers_count { 2 }
        user { create(:user) }
      end

      after(:create) do |community, evaluator|
        create_list(:community_follow, evaluator.followers_count, followable: community, user: evaluator.user)
      end
    end

    factory :community_with_users_mutes do
      transient do
        mutes_count { 2 }
        user { create(:user) }
      end

      after(:create) do |community, evaluator|
        create_list(:user_in_community_mute, evaluator.mutes_count, source: community, target: evaluator.user)
      end
    end

    factory :community_with_users_bans do
      transient do
        bans_count { 2 }
        user { create(:user) }
      end

      after(:create) do |community, evaluator|
        create_list(:user_in_community_ban, evaluator.bans_count, source: community, target: evaluator.user)
      end
    end

    factory :community_with_user_moderator do
      transient do
        user { create(:user) }
      end

      after(:create) do |community, evaluator|
        create(:moderator, community: community, user: evaluator.user)
      end
    end

    factory :community_with_user_follower do
      transient do
        user { create(:user) }
      end

      after(:create) do |community, evaluator|
        create(:community_follow, followable: community, user: evaluator.user)
      end
    end

    factory :community_with_banned_user do
      transient do
        user { create(:user) }
      end

      after(:create) do |community, evaluator|
        create(:ban, source: community, target: evaluator.user)
      end
    end

    factory :community_with_muted_user do
      transient do
        user { create(:user) }
      end

      after(:create) do |community, evaluator|
        create(:mute, source: community, target: evaluator.user)
      end
    end
  end
end
