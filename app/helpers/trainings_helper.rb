module TrainingsHelper
  def formatted_ut_accepted_at(users_training)
    return unless users_training.accepted_at
    l users_training.accepted_at, format: :short
  end
end
