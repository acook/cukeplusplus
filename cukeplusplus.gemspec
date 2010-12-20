# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "cukeplusplus/version"

Gem::Specification.new do |s|
  s.name        = "cukeplusplus"
  s.version     = Cukeplusplus::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Anthony Michael Cook"]
  s.email       = ["anthonymichaelcook@gmail.com"]
  s.homepage    = "http://github.com/acook/cukeplusplus"
  s.summary     = %q{Designed for beauty and simplicity, a Cucumber custom formatter.}
  s.description = %q{This clean and easy to use Cucumber formatter displays scenarios as they are run, displaying failures as they occur.}

  s.add_dependency "cucumber"

  s.post_install_message = <<-EOS

  *****************************************************************
  * To use the cukeplusplus formatter, simple add                 *
  *   --format 'Cukeplusplus::Formatter'                          * 
  * to your cucumber.yml, Rakefile, or command line call          *
  *****************************************************************

  EOS

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
