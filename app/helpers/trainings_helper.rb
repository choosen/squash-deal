module TrainingsHelper
  def formatted_ut_accepted_at(users_training)
    return '' unless users_training.accepted_at
    l users_training.accepted_at, format: :short
  end

  def format_picker_date(training)
    l training.date || DateTime.current, format: :datetimepicker
  end
end
