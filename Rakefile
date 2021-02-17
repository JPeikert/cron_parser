require_relative "lib/cron_parser"

namespace :cron_parser do
  desc "Prints cron expression in a more understandable form"
  task :print do
    ARGV.each { |a| task a.to_sym do ; end }

    cron_expression = ARGV[1]

    puts CronParser.new(cron_expression).parse
  end
end
