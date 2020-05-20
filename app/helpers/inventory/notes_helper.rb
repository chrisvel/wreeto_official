module Inventory::NotesHelper
  def tag_links(note)
    tags_formatted = note.tags.order(:name).map do |tag| 
      link_to("##{tag.name}", tag_path(tag: tag), class: 'badge badge-dark text-white') 
    end
    tags_formatted.join(" ").html_safe
  end
end
