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
end
