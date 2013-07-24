$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'
require 'bundler'

is_test = ARGV.join(' ') =~ /spec/
if is_test
  require 'guard/motion'
  Bundler.require :default, :spec
else
  Bundler.require
end

Motion::Project::App.setup do |app|
  app.name = 'MotionDataWrapperTest'
  app.version = "0.99.0"

  # Devices
  app.deployment_target = "6.0"

  app.detect_dependencies = true

  if is_test
    app.redgreen_style = :full
  end
end
