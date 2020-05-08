json.array! @notes do |note| 
    json.title note.title
    json.guid note.guid
    json.category do 
        json.id note.category.id
        json.title note.category.title
    end
end
