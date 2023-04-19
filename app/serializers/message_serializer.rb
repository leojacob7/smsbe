class MessageSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :phone_number
  # has_one :user
end
