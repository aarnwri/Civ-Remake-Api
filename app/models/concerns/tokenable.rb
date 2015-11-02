module Tokenable
  extend ActiveSupport::Concern

  module ClassMethods
    def generate_token
      SecureRandom.urlsafe_base64(32)
    end
  end

  def set_token(column_name)
    unless column_name.match(/token/)
      raise "Method not being called on a token attribute"
    end
    token = self.class.generate_token

    until token_unique_to_column?(token, column_name)
      token = self.class.generate_token
    end

    self.send(column_name + "=", token)
  end

  def nullify_token(column_name)
    unless column_name.match(/token/)
      raise "Method not being called on a token attribute"
    end
    self.send(column_name + "=", nil)
  end

  private

  def token_unique_to_column?(token, column_name)
    query_hash = {}
    query_hash[column_name] = token

    self.class.where(query_hash).count == 0
  end
end
