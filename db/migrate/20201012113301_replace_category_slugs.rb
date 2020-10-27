class ReplaceCategorySlugs < ActiveRecord::Migration[5.2]
  def change
    Category.where(deletable: true).each do |category| 
      category.update_attribute(:slug, category.title.parameterize)
      category.save!
    end
  end
end
