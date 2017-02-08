# Let create training in the past
class CreateWithoutValidation
  def initialize
    @strategy = FactoryGirl.strategy_by_name(:build).new
  end

  delegate :association, to: :@strategy

  def result(evaluation)
    object = @strategy.result(evaluation)
    object.save!(validate: false)
    object
  end
end

FactoryGirl.register_strategy(:create_without_validate, CreateWithoutValidation)
