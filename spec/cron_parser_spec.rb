require "cron_parser"

describe CronParser do
  describe "#new" do
    it "raises error when not given enough fields" do
      expect { CronParser.new("1 1 1 1 1") }.
        to raise_error(ArgumentError, "Invalid cron expression")
    end

    it "raises error when not given enough time fields" do
      expect { CronParser.new("1 1 1 1 /usr/bin/found script.sh") }.
        to raise_error(ArgumentError, "Invalid time expression /usr/bin/found")
    end
  end

  describe "#parse" do
    it "returns formatted cron expression" do
      expected_result = <<~RESULT.chomp
                          minute         1
                          hour           1
                          day_of_month   1
                          month          1
                          day_of_week    1
                          command        /usr/bin/found
                        RESULT

      expect(CronParser.new("1 1 1 1 1 /usr/bin/found").parse).to eq expected_result
    end
  end
end
