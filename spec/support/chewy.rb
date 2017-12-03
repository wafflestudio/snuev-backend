RSpec.configure do |config|
  config.before(:suite) do
    Chewy.massacre
    Chewy.strategy(:bypass)
  end
end
