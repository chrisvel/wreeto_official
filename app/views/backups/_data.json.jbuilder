json.user do
  json.merge! user.attributes
  json.notes user.notes do |note|
    json.merge! note.attributes
    json.attachments note.attachments do |att|
      json.merge! att.attributes
      json.blob att.blob.attributes  
    end
    json.taggings note.taggings do |tagging|
      json.merge! tagging.attributes 
    end
  end
  json.categories user.categories do |category|
    json.merge! category.attributes 
  end
  json.tags user.tags do |tag|
    json.merge! tag.attributes 
  end
  json.backups user.backups do |backup|
    json.merge! backup.attributes 
  end
end

# json.active_storage_attachments do 
#   json.merge! user.attributes
# end 


