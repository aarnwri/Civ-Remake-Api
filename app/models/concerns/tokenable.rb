module Tokenable
  extend ActiveSupport::Concern

  module ClassMethods
    def generate_token
      SecureRandom.urlsafe_base64(32)
    end
  end

  def set_token (column_name)
    column_name = column_name.to_s
    ensure_column_setter(column_name)

    token = self.class.generate_token

    until token_unique_to_column?(token, column_name)
      token = self.class.generate_token
    end

    self.send(column_name + "=", token)
  end

  def nullify_token (column_name)
    column_name = column_name.to_s
    ensure_column_setter

    self.send(column_name + "=", nil)
  end

  private

  def ensure_column_setter (column_name)
    unless self.respond_to?(column_name + "=")
      raise "No setter for #{self.class}.#{column_name}... Be sure to use the correct column_name..."
    end
  end

  def token_unique_to_column?(token, column_name)
    query_hash = {}
    query_hash[column_name] = token

    self.class.where(query_hash).count == 0
  end
end
