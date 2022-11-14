class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      # can we have unique but not index?
      t.string :username, null: false, index: {unique: true}
      t.string :password_digest, null: false
      t.string :session_token, null: false, index: {unique: true}

      t.timestamps
    end
  end
end
