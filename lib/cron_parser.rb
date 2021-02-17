require_relative "time_expression_evaluator"

class CronParser
  def initialize(cron_expression)
    cron_expression_fields = extract_expression_fields(cron_expression)
    @time_fields = TimeExpressionEvaluator.new(cron_expression_fields.take(5)).calculate_time_fields
    @command = cron_expression_fields.drop(5)
  end

  def parse
    formatted_cron_expression = ""
    self.time_fields.each do |key, value|
      formatted_cron_expression << key.to_s.ljust(15) + value.join(" ") + "\n"
    end
    formatted_cron_expression << "command".ljust(15) + self.command.join(" ")
    formatted_cron_expression
  end

  private

  attr_accessor :time_fields, :command

  def extract_expression_fields(cron_expression)
    raise_invalid_argument_error unless cron_expression.respond_to?(:split)

    cron_expression_fields = cron_expression.split(/\s+/)

    raise_invalid_argument_error if cron_expression_fields.length < 6

    cron_expression_fields
  end

  def raise_invalid_argument_error
    raise ArgumentError, 'Invalid cron expression'
  end
end
