# db/migrate/006_make_order_required.rb
class MakeOrderRequired < ActiveRecord::Migration[6.1]
  def change
    change_column :questions, :order, :integer, null: false
  end
end
