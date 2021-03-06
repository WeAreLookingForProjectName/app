class RuleSerializer < ApplicationSerializer
  def attributes
    {
      id: model.id,
      community: community,
      title: model.title,
      description: model.title,
      created_at: model.created_at,
      updated_at: model.updated_at
    }
  end

  private

  def community
    model.association(:community).loaded? && model.community.present? ? CommunitySerializer.serialize(model.community) : nil
  end
end
