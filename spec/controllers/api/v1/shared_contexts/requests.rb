RSpec.shared_context 'expect_valid_json' do |validation_hash|
  it "should return valid json" do
    validate_json_with_hash(validation_hash)
  end
end

RSpec.shared_context 'expect_json_error_message' do |message|
  it(json_em_test_str(message)) { expect_json_error_message(message) }
end

RSpec.shared_context 'expect_status_code' do |code|
  it(status_test_str(code)) { expect_status(code) }
end

RSpec.shared_context 'expect_same_db_count' do |*models|
  models.each do |model|
    klass = model.to_s.camelize.constantize

    it "should not create or delete a #{klass} object" do
      expect(klass.all.count).to eq(eval("@#{model.to_s}_count"))
    end
  end
end

RSpec.shared_context 'expect_plus_one_db_count' do |*models|
  models.each do |model|
    klass = model.to_s.camelize.constantize

    it "should not create or delete a #{klass} object" do
      expect(klass.all.count).to eq(eval("@#{model.to_s}_count") + 1)
    end
  end
end

RSpec.shared_context 'expect_minus_one_db_count' do |*models|
  models.each do |model|
    klass = model.to_s.camelize.constantize

    it "should not create or delete a #{klass} object" do
      expect(klass.all.count).to eq(eval("@#{model.to_s}_count") - 1)
    end
  end
end

RSpec.shared_context 'expect_same_db_attrs' do |model|
  it 'should not update the db object' do
    db_attrs = model.to_s.camelize.constantize.find(self.send(model).id).attributes
    created_attrs = self.send(model).attributes

    expect(db_attrs).to eq(created_attrs)
  end
end
