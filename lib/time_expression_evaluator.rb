require "set"

class TimeExpressionEvaluator
  ALLOWED_TIME_VALUES = {
    minute: 0..59,
    hour: 0..23,
    day_of_month: 1..31,
    month: 1..12,
    day_of_week: 0..6,
  }

  def initialize(time_expressions)
    validate_time_expressions(time_expressions)
    @time_expressions = time_expressions
  end

  def calculate_time_fields
    {
      minute: evaluate_time_expression(time_expressions[0], :minute),
      hour: evaluate_time_expression(time_expressions[1], :hour),
      day_of_month: evaluate_time_expression(time_expressions[2], :day_of_month),
      month: evaluate_time_expression(time_expressions[3], :month),
      day_of_week: evaluate_time_expression(time_expressions[4], :day_of_week),
    }
  end

  private

  attr_accessor :time_expressions

  def evaluate_time_expression(time_expression, time_category)
    time_field = Set.new

    range = ALLOWED_TIME_VALUES[time_category]
    time_expression = normalize_time_expression(time_expression)
    sub_expressions = time_expression.split(",")

    sub_expressions.each do |expression|
      time_field.merge(evaluate_expression(expression, range))
    end

    if (time_field.min < range.first) || (time_field.max > range.last)
      raise_range_error(time_category)
    end

    time_field.to_a
  end

  def evaluate_expression(expression, range)
    if expression.match(/\*/)
      handle_asterisk_expression(expression, range)
    else
      if expression.match(/\//)
        handle_stepped_expression(expression, range)
      elsif expression.match(/-/)
        handle_range_expression(expression, 1)
      else
        [expression.to_i]
      end
    end
  end

  def handle_asterisk_expression(expression, range)
    step = expression.length == 1 ? 1 : expression[2..-1].to_i
    range_with_step_values(range.first, range.last, step)
  end

  def handle_stepped_expression(expression, range)
    value, step = expression.split("/")

    if value.match(/-/)
      handle_range_expression(value, step)
    else
      range_with_step_values(value.to_i, range.last, step.to_i)
    end
  end

  def handle_range_expression(expression, step)
    first, last = expression.split("-")
    range_with_step_values(first.to_i, last.to_i, step.to_i)
  end

  def range_with_step_values(first, last, step)
    (first..last).step(step).to_a
  end

  def validate_time_expressions(time_expressions)
    time_expressions.each do |time_expression|
      raise_invalid_time_expression(time_expression) if time_expression.match(/[^\,?\d\*\/-]+/)
    end
  end

  def normalize_time_expression(time_expression)
    time_expression.gsub("?", "*").gsub(/\*{2,}/, "*").
                    gsub(/\/{2,}/, "/").gsub(/\-{2,}/, "-").
                    gsub(/\,{2,}/, ",")
  end

  def raise_invalid_time_expression(time_expression)
    raise ArgumentError, "Invalid time expression #{time_expression}"
  end

  def raise_range_error(time_category)
    error_msg = "Time field #{time_category} has values " \
                "out of #{ALLOWED_TIME_VALUES[time_category]} range"
    raise ArgumentError, error_msg
  end
end
