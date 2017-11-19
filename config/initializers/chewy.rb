Chewy.logger = Logger.new(STDOUT)

Chewy.root_strategy = :atomic

Chewy.use_after_commit_callbacks = !Rails.env.test?
