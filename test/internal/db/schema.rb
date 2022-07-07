ActiveRecord::Schema.define do
  create_table :users do |t|
    t.string :name
  end

  create_table :customer_fakes do |t|
    t.string :name
  end

  create_table :accounts do |t|
    t.string :name
  end
end
