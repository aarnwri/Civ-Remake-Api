module Tokenable
  extend ActiveSupport::Concern

  module ClassMethods
    def generate_token
      SecureRandom.urlsafe_base64(32)
    end
  end

  def set_token (column_name)
    column_name = column_name.to_s
    token = self.class.generate_token

    until self.class.where({ column_name => token }).count == 0
      token = self.class.generate_token
    end

    self.send("#{column_name}=", token)
  end

  def nullify_token (column_name)
    column_name = column_name.to_s

    self.send("#{column_name}=", nil)
  end
end
