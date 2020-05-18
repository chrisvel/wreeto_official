module FormsHelper
  def blank_slate(entity)
    content_tag :div,
    "<i class=\"fa fas fa-sticky-note fa-5x \"></i><br><br> \
    No <div class=\"emphatext\">#{entity.to_s.pluralize}</div> have been created yet :( \
    <br> Why don't you create your <strong>#{add_item_link(entity, 'first one')}</strong>?".html_safe,
    class: "text-center blank-slate card shadow-sm bordered bg-white"
  end

  def no_results_slate
    content_tag :div,
    "<i class=\"fa fas fa-sticky-note fa-5x \"></i><br><br> \
    No <div class=\"emphatext\">notes</div> have been found with your search terms :( \
    <br> Why don't you create <strong>#{add_item_link(:notes, 'one')}</strong> instead?".html_safe,
    class: "text-center blank-slate card shadow-sm bordered bg-white"
  end

  def add_item_link(entity, text)
    case entity
    when :notes
      link_to text,
      new_inventory_note_path,
      class: 'link-purple',
      data: { turbolinks: false }
    when :ideas
      link_to text,
      new_inventory_idea_path,
      class: 'link-purple',
      data: { turbolinks: false }
    when :thoughts
      link_to text,
      new_inventory_thought_path,
      class: 'link-purple',
      data: { turbolinks: false }
    else
      entity
    end
  end
end
