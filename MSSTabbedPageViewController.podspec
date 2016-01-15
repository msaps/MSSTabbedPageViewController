Pod::Spec.new do |s|

  s.name         = "MSSTabbedPageViewController"
  s.version      = "0.1.1"
  s.summary      = "A custom container UIViewController which provides a simple to implement page view controller with scrolling tab bar"

  s.description  = <<-DESC
  					MSSTabbedPageViewController is a UIViewController that provides a simple to implement page view controller with scrolling tab bar. It also includes a UIPageViewController wrapper that provides improved data source and delegation methods.
                   DESC

  s.homepage     = "https://github.com/MerrickSapsford/MSSTabbedPageViewController"
  s.screenshots  = "https://raw.githubusercontent.com/MerrickSapsford/MSSTabbedPageViewController/develop/Example/MSSTabbedPageViewController.gif"
  s.license      = "MIT"
  s.author       = { "Merrick Sapsford" => "merrick@merricksapsford.co.uk" }
  s.social_media_url   = "http://twitter.com/MSapsfordDev"

  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/MerrickSapsford/MSSTabbedPageViewController.git", :tag => s.version.to_s }
  s.requires_arc = true
  s.source_files  = "MSSTabbedPageViewController/Classes", "MSSTabbedPageViewController/**/*.{h,m}"
  s.frameworks = 'UIKit'

end
