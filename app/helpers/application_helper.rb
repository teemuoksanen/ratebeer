module ApplicationHelper
  def edit_and_destroy_buttons(item)
    return unless current_user

    edit = link_to('Edit', url_for([:edit, item]), class: "btn btn-primary")
    del = button_to('Destroy', item, method: :delete,
                                     form: { data: { turbo_confirm: "Are you sure ?" } },
                                     class: "btn btn-danger")
    raw("<p>#{edit} #{del}</p>")
  end

  def round(number)
    number.round(1).to_f
  end
end
