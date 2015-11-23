# model: name of the Class to create the model from or the actual model instance to be used.
# attribute: name of the column we're checking for changes
# method: name of the method that should cause the change
# arguments: an array of arguments that the method should get called with
# options: additional arguments:
#   :current_val => indicates what the value should be upon creation
#   :desired_val => indicates what the attribute should change to
#   :factory_hash => indicates factory overrides for the model creation process
RSpec.shared_context 'attribute_changed' do |model, attribute, method, params, options|

  options ||= {}

  has_current_val = options.has_key?(:current_val)
  has_desired_val = options.has_key?(:desired_val)

  current_val_str = has_current_val ? " from #{options[:current_val].inspect}" : ""
  desired_val_str = has_desired_val ? " to #{options[:desired_val].inspect}" : ""

  it "should change #{attribute} attribute#{current_val_str}#{desired_val_str}" do
    instance = setup_instance(model, options)

    initial_val = instance.class.find(instance.id).send(attribute)
    expect(initial_val).to eq(options[:current_val]) if has_current_val

    instance.send(method, *params)

    final_val = instance.class.find(instance.id).send(attribute)
    expect(final_val).to eq(options[:desired_val]) if has_desired_val

    expect(final_val).to_not eq(initial_val)
  end
end

def setup_instance (model, options)
  if model.instance_of?(String) || model.instance_of?(Symbol)
    instance = create(model, options[:factory_hash])
  else
    instance = model
  end

  return instance
end
