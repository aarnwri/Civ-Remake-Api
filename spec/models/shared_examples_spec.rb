RSpec.shared_context 'include module Tokenable' do
  it { should respond_to(:set_token) }
  it { should respond_to(:nullify_token) }
end

RSpec.shared_examples 'attribute_changed' do |model, attribute, method, params, options|

  has_desired_val = options && options.has_key?(:desired_val)

  if has_desired_val
    desired_val_rep = options[:desired_val] ? options[:desired_val] : options[:desired_val].inspect
  end

  desired_val_string = has_desired_val ? " to #{desired_val_rep}" : ""

  it "should change #{attribute} attribute#{desired_val_string}" do
    instance = create(model)

    initial_val = instance.send(attribute)
    instance.send(method, *params)
    final_val = instance.class.find(instance.id).send(attribute)

    expect(final_val == initial_val).to eq(false)
    expect(final_val == options[:desired_val]).to eq(true) if has_desired_val
  end
end
