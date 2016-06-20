Pod::Spec.new do |s|

  s.name         = "MSSTabbedPageViewController"
  s.version      = "0.3.1"
  s.summary      = "A custom container UIViewController which provides a simple to implement page view controller with scrolling tab bar"

  s.description  = <<-DESC
  					MSSTabbedPageViewController is a UIViewController that provides a simple to implement page view controller with scrolling tab bar. Also includes a UIPageViewController wrapper that provides improved data source and delegation methods.
                   DESC

  s.homepage     = "https://github.com/MerrickSapsford/MSSTabbedPageViewController"
  s.screenshots  = "https://raw.githubusercontent.com/MerrickSapsford/MSSTabbedPageViewController/develop/Resource/MSSTabbedPageViewController.gif"
  s.license      = "MIT"
  s.author       = { "Merrick Sapsford" => "merrick@sapsford.tech" }
  s.social_media_url   = "http://twitter.com/MerrickSapsford"

  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/MerrickSapsford/MSSTabbedPageViewController.git", :tag => s.version.to_s }
  s.requires_arc = true
  s.source_files  = "MSSTabbedPageViewController/Classes", "Source/**/*.{h,m}"
  s.resources = ['Source/**/*.{xib}']
  s.frameworks = 'UIKit'

end
