module ApplicationHelper
  def bootstrap_class_for(flash_type)
    { success: 'alert-success', error: 'alert-danger', alert: 'alert-warning',
      notice: 'alert-info' }[flash_type.to_sym] || "alert-#{flash_type}"
  end

  def flash_messages(_opts = {})
    flash.each do |msg_type, message|
      concat(content_tag(:div, message, class: class_string(msg_type)) do
        concat content_tag(:button, 'x', class: 'close',
                                         data: { dismiss: 'alert' })
        concat message
      end)
    end
    nil
  end

  def class_string(msg_type)
    "alert #{bootstrap_class_for(msg_type)} fade in"
  end

  def format_date_if_present(datetime)
    return '' unless datetime.present?
    l datetime, format: :default
  end

  def bottom_closed_on_focus_popover(title, text)
    { href: '#', 'data-trigger' => 'focus', 'data-placement' => 'bottom' }.
      merge(title: title, 'data-content' => text)
  end

  def sortable(col, title = nil)
    title ||= col.titleize
    css_class = col == sort_column ? "sortable sortable_#{sort_direction}" : nil
    direction = if col == sort_column && sort_direction == 'asc'
                  'desc'
                else
                  'asc'
                end
    link_to title, { sort: col, direction: direction }, class: css_class
  end
end
