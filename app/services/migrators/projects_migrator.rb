module Migrators 
  class ProjectsMigrator 

    def self.process 
      new.process 
    end 

    def initialize 
    end 

    def process 
      ActiveRecord::Base.transaction do
        User.all.each do |user|
          puts "-- USER: #{user.id} : #{user.email}"
          migrate_projects(user)
          rename_uncategorized(user)
        end
      end
    end 

    private 

    def migrate_projects(user)
      parent = user.categories.find_by(slug: 'projects')
      return true if parent.nil? || parent.subcategories.none?
      
      parent.subcategories.each{|sub| sub.update_column(:type, 'Project')}
    end

    def rename_uncategorized(user)
      uncategorized = user.categories.find_by(slug: 'uncategorized')
      return true if uncategorized.nil?
      uncategorized.update_columns(title: 'Inbox', slug: 'inbox')
    rescue ActiveRecord::RecordNotUnique 
      puts "!! ERROR: Duplicate Inbox"
      true
    end
  end 
end 