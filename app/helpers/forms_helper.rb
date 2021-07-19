module FormsHelper
  def blank_slate(entity)
    if entity == :inbox
      content_tag :div,
      "<i class=\"fa fas fa-inbox fa-5x \"></i><br><br> \
      No <div class=\"emphatext\">inbox items</div> have been created yet :(".html_safe,
      class: "text-center blank-slate"
    else 
      content_tag :div,
      "<i class=\"fa fas fa-sticky-note fa-5x \"></i><br><br> \
      No <div class=\"emphatext\">#{entity.to_s.pluralize}</div> have been created yet :( \
      <br> Why don't you create your <strong>#{add_item_link(entity, 'first one')}</strong>?".html_safe,
      class: "text-center blank-slate"
    end
  end

  def no_results_slate
    content_tag :div,
    "<i class=\"fa fas fa-sticky-note fa-5x \"></i><br><br> \
    No <div class=\"emphatext\">notes</div> have been found with your search terms :( \
    <br> Why don't you create <strong>#{add_item_link(:notes, 'one')}</strong> instead?".html_safe,
    class: "text-center blank-slate"
  end

  def add_item_link(entity, text)
    case entity
    when :notes
      link_to text,
      new_note_path,
      class: 'link-purple',
      data: { turbolinks: false }
    when :tags
      link_to text,
      "#",
      class: 'link-purple',
      data: { toggle: "modal", target: "#add-tag".html_safe, turbolinks: false }
    when :projects
      link_to text,
      new_category_path(params: {parent_slug: 'projects'}),
      class: 'link-purple',
      data: { turbolinks: false }
    when :digital_gardens
      link_to text,
      new_digital_garden_path,
      class: 'link-purple',
      data: { turbolinks: false }
    else
      entity
    end
  end
end
