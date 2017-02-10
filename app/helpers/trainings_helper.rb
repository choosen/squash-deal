module TrainingsHelper
  def format_picker_date(training)
    l training.date || DateTime.current, format: :datetimepicker
  end
end
