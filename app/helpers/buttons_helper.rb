module ButtonsHelper
  def add_note_button
    link_to 'ADD A NEW NOTE',
    new_note_path,
    class: "btn btn-sm btn-purple",
    data: { turbolinks: false }
  end

  def add_category_button
    link_to 'ADD A NEW CATEGORY',
    new_category_path,
    class: "btn btn-sm btn-purple",
    data: { turbolinks: false }
  end

  def create_backup_button
    link_to 'BACKUP NOW',
    start_backups_path,
    class: "btn btn-sm btn-purple",
    data: { turbolinks: false }
    # remote: true
  end

  def add_tag_button
    link_to 'ADD A NEW TAG',
    '#',
    class: "btn btn-sm btn-purple",
    data: { toggle: "modal", target: "#add-tag".html_safe, turbolinks: false }
  end
end