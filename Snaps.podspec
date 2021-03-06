Pod::Spec.new do |s|
  s.name        = "Snaps"
  s.version     = "1.0.0"
  s.description = <<-DESC
                  Snaps combines [Dials](https://github.com/aleffert/dials) and
                  [SnapKit](https://github.com/SnapKit/SnapKit) to let you make
                  changes to your autolayout constraints at runtime and then
                  send them back to your code with just one button.
                  DESC
  s.summary     = "Snaps lets you make changes to your autolayout constraints at runtime and then send them back to your code."
  s.homepage    = "https://github.com/aleffert/snaps"
  s.license     = { :type => 'MIT', :file => 'LICENSE' }
  s.author      = { "Akiva Leffert" => "aleffert@gmail.com" }
  s.platform    = :ios, '8.0'
  s.source      = { :git => "https://github.com/aleffert/snaps.git", :tag => "release/1.0.0" }
  s.preserve_paths = '*'
  s.compiler_flags = '-ObjC'
  s.dependency 'Dials', '~> 1.0'
  s.dependency 'SnapKit', '~> 0.17'
end
