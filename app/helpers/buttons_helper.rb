module ButtonsHelper
  def back_button
    link_to 'BACK',
      :back,
      class: "btn btn-sm btn-light",
      data: { turbolinks: false }
  end

  def add_note_button
    link_to 'ADD NEW NOTE',
    new_note_path,
    class: "btn btn-sm btn-purple",
    data: { turbolinks: false }
  end

  def add_category_button
    link_to 'ADD NEW CATEGORY',
    new_category_path,
    class: "btn btn-sm btn-purple",
    data: { turbolinks: false }
  end

  def add_tag_button
    link_to 'ADD NEW TAG',
    new_tag_path,
    class: "btn btn-sm btn-purple",
    data: { turbolinks: false }
  end
end
