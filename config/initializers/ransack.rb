Ransack.configure do |config|
  config.add_predicate 'yaml_array_cont',
    arel_predicate: 'matches',
    formatter: proc { |v| "%- #{v.strip}\n%" },
    validator: proc { |v| v.present? },
    type: :string
end
