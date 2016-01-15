# MSSTabbedPageViewController

MSSTabbedPageViewController is a UIViewController that provides a simple to implement page view controller with scrolling tab bar. It also includes a UIPageViewController wrapper that provides improved data source and delegation methods.

<div style="width:100%;">
<img src="Example/MSSTabbedPageViewController.gif" align="center" height="30%" width="30%" style="margin-left:20px;">
</div>

<p><p>

## Installation
MSSTabbedPageViewController is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

    pod "MSSTabbedPageViewController"

## Usage
To run the example project, clone the repo. Use `pod install` in your project.

To use the tabbed page view controller, simply create a UIViewController that is a subclass of MSSTabbedPageViewController. Then implement the following data source methods:

```
// array of view controllers to display in page view controller
- (NSArray *)viewControllersForPageViewController:(MSSPageViewController *)pageViewController;

// array of NSString's for titles in tab bar
- (NSArray *)tabTitlesForTabBarView:(MSSTabBarView *)tabBarView;
```

There are also some optional data source methods:

```
// default page index to display
- (NSInteger)defaultPageIndexForPageViewController:(MSSPageViewController *)pageViewController;
```

MSSPageViewController is a UIViewController wrapper for UIPageViewController that provides s simpler data source and enhanced delegation methods. The data source methods are encapsulated in the MSSTabbedPageViewControllerDataSource as seen above. The delegate methods that MSSPageViewController provides are listed below:

```

## Requirements
Supports iOS 8 and iOS 9.

## Author
Merrick Sapsford

Mail: [merrick@merricksapsford.co.uk](mailto://merrick@merricksapsford.co.uk)
