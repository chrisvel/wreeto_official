module ButtonsHelper

  def back_button
    link_to 'BACK',
      :back,
      class: "btn btn-sm btn-light",
      data: { turbolinks: false }
  end

  def add_note_button
    link_to 'ADD NEW NOTE',
    new_inventory_note_path,
    class: "btn btn-sm btn-purple",
    data: { turbolinks: false }
  end

  def add_idea_button
    link_to 'ADD NEW IDEA',
    new_inventory_idea_path,
    class: "btn btn-sm btn-purple",
    data: { turbolinks: false }
  end

  def add_thought_button
    link_to 'ADD NEW THOUGHT',
    new_inventory_thought_path,
    class: "btn btn-sm btn-purple",
    data: { turbolinks: false }
  end

  def add_asset_button
    link_to 'ADD NEW ASSET',
    new_inventory_asset_path,
    class: "btn btn-sm btn-purple",
    data: { turbolinks: false }
  end

  def add_task_button
    link_to 'ADD NEW TASK',
    new_task_path,
    class: "btn btn-sm btn-purple",
    data: { turbolinks: false }
  end

  def add_category_button
    link_to 'ADD NEW CATEGORY',
    new_category_path,
    class: "btn btn-sm btn-purple",
    data: { turbolinks: false }
  end
end
