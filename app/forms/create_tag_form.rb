# frozen_string_literal: true

class CreateTagForm
  include ActiveModel::Model

  attr_accessor :sub, :title
  attr_reader :tag

  def save
    @tag = Tag.create!(
      sub: sub,
      title: title
    )
  rescue ActiveRecord::RecordInvalid => invalid
    errors.merge!(invalid.record.errors)

    return false
  end
end