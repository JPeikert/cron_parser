require "time_expression_evaluator"


describe TimeExpressionEvaluator do
  describe "#new" do
    it "raises error when not given valid time expressions" do
      time_expressions = ["1", "1", "1", "1", "1.24"]
      expect { TimeExpressionEvaluator.new(time_expressions) }.
        to raise_error(ArgumentError, "Invalid time expression 1.24")
    end
  end

  describe "#calculate_time_fields" do
    it "returns hash of correct time fields" do
      time_expressions = ["1,2,3-10/3,15/10", "*/5", "1", "5/4", "*"]
      expected_result = {
        minute: [1, 2, 3, 6, 9, 15, 25, 35, 45, 55],
        hour: [0, 5, 10, 15, 20],
        day_of_month: [1],
        month: [5, 9],
        day_of_week: [0, 1, 2, 3, 4, 5, 6],
      }

      expect(TimeExpressionEvaluator.new(time_expressions).calculate_time_fields).
        to eq expected_result
    end

    it "raises error when time field has out of range value" do
      time_expressions = ["1-70", "1", "1", "1", "1"]

      expect { TimeExpressionEvaluator.new(time_expressions).calculate_time_fields }.
        to raise_error(ArgumentError, "Time field minute has values out of 0..59 range")
    end
  end
end
