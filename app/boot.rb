Dir[File.join(__dir__, "models", "*.rb")].each { |file| require_relative file }
Dir[File.join(__dir__, "services", "**", "*.rb")].each { |file| require_relative file }
