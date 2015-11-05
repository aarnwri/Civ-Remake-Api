require 'rails_helper'

RSpec.describe Tokenable do

  class DummyClass
    include Tokenable
  end

  before(:each) { @dummy_class = DummyClass.new }

  context 'class methods' do
    context 'generate_token' do
      it 'should exist' do
        expect { DummyClass.generate_token }.to_not raise_error
      end

      it 'should call SecureRandom.urlsafe_base64(32)' do
        expect(SecureRandom).to receive(:urlsafe_base64).with(32)
        DummyClass.generate_token
      end
    end
  end

  context 'methods' do
    context 'set_token (column_name)' do
      it 'should be able to take a string or symbol as column_name'

      it 'should call the class method generate_token'

      it 'should ensure that the token is unique'

      it 'should raise an error if there is no setter method for column_name'

      it 'should call the appropriate setter using the column_name'

      it 'should not call save upon setting the token'
    end

    context 'nullify_token (column_name)' do
      it 'should be able to take a string or symbol as column_name'

      it 'should raise an error if there is no setter method for column_name'

      it 'should call the appropriate setter using the column_name'

      it 'should set the token to nil'

      it 'should not call save upon setting the token'
    end
  end

end
