module NotesHelper
  def note_tag_links(note, type)
    tags_formatted = note.tags.includes(:taggings).map do |tag| 
      if type == :index
        link_to("#{tag.name}", tag_path(tag.name), class: 'badge badge-dark text-light note-badge') 
      elsif type == :show
        link_to("#{tag.name}", tag_path(tag.name), class: 'badge badge-light text-dark note-show-badge') 
      end
    end
    tags_formatted.join(" ").html_safe
  end
end
