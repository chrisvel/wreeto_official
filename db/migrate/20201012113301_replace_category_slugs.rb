class ReplaceCategorySlugs < ActiveRecord::Migration[5.2]
  def change
    Category.where(deletable: true).each{|category| category.send(:set_slug); category.save!}
  end
end
