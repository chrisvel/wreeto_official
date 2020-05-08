class SquashMigration < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at

      t.string :firstname
      t.string :lastname 

      t.string :users, :provider
      t.string :users, :uid
      t.string :users, :token
      t.integer :users, :expires_at
      t.boolean :users, :expires
      t.string :users, :refresh_token

      t.index :email,                unique: true
      t.index :reset_password_token, unique: true
      # add_index :users, :confirmation_token,   unique: true
      # add_index :users, :unlock_token,         unique: true

      t.timestamps null: false
    end
    
    create_table :active_storage_blobs do |t|
      t.string   :key,        null: false
      t.string   :filename,   null: false
      t.string   :content_type
      t.text     :metadata
      t.bigint   :byte_size,  null: false
      t.string   :checksum,   null: false
      t.datetime :created_at, null: false

      t.index [ :key ], unique: true
    end

    create_table :active_storage_attachments do |t|
      t.string     :name,     null: false
      t.references :record,   null: false, polymorphic: true, index: false
      t.references :blob,     null: false

      t.datetime :created_at, null: false

      t.index [ :record_type, :record_id, :name, :blob_id ], name: "index_active_storage_attachments_uniqueness", unique: true
      t.foreign_key :active_storage_blobs, column: :blob_id
    end

    create_table :categories do |t|
      t.string :title
      t.text :description
      t.references :user, foreign_key: true
      t.references :parent, foreign_key: { to_table: :categories }
      t.boolean :active, null: false, default: true
      t.boolean :deletable, null: false, default: true
      t.string :slug
      
      t.index :slug, unique: true

      t.timestamps
    end

    create_table :inventory_items do |t|
      t.references :user, foreign_key: true
      t.string :title
      t.text :content
      t.references :category, foreign_key: true
      t.boolean :favorite
      t.string :serial_no
      t.string :images
      t.integer :sharestate
      t.string :guid

      t.index :guid, unique: true

      t.timestamps
    end
  
    create_table :inventory_notes do |t|
      t.timestamps
    end
  end
end
