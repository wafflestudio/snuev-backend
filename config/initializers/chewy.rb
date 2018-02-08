Chewy.logger = Logger.new(STDOUT) unless Rails.env.test?

Chewy.root_strategy = :atomic

Chewy.use_after_commit_callbacks = !Rails.env.test?
