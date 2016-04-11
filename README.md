# MSSTabbedPageViewController
[![Build Status](https://travis-ci.org/MerrickSapsford/MSSTabbedPageViewController.svg?branch=master)](https://travis-ci.org/MerrickSapsford/MSSTabbedPageViewController)
[![CocoaPods](https://img.shields.io/cocoapods/v/MSSTabbedPageViewController.svg)]()

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

To use the tabbed page view controller, simply create a `UIViewController` that is a subclass of `MSSTabbedPageViewController`. Then implement the following data source methods:

```
// array of view controllers to display in page view controller
- (NSArray *)viewControllersForPageViewController:(MSSPageViewController *)pageViewController;

// array of strings for titles in tab bar
- (NSArray *)tabTitlesForTabBarView:(MSSTabBarView *)tabBarView;
```

If you are using a `UINavigationController` (As shown in Example project) you can embed the tab bar in the navigation bar. Simply set the `UINavigationBar` class in the navigation controller to `MSSTabNavigationBar` and the navigation bar will attach to the view controller.

Otherwise you must attach a `MSSTabBarView` via the `tabBarView` property on `MSSTabbedPageViewController`, and setting the `dataSource` and `delegate` of the `MSSTabBarView` to the view controller. 

There are also some optional `MSSTabbedPageViewControllerDataSource` methods:

```
// default page index to display
- (NSInteger)defaultPageIndexForPageViewController:(MSSPageViewController *)pageViewController;
```

Child view controllers can have access to components of the parent controller by implementing the `MSSTabbedPageChildViewController` protocol:

```
// Parent page view controller
@property (nonatomic, weak) MSSPageViewController *pageViewController;

// Parent tab bar view
@property (nonatomic, weak) MSSTabBarView *tabBarView;
```

### Page View Controller Enhancements

MSSPageViewController is a UIViewController wrapper for UIPageViewController that provides a simpler data source and enhanced delegation methods. The data source methods are encapsulated in the `MSSTabbedPageViewControllerDataSource` as seen above. 

The delegate methods that `MSSPageViewControllerDelegate` provides are listed below:

```
- (void)pageViewController:(MSSPageViewController *)pageViewController
     didScrollToPageOffset:(CGFloat)pageOffset
                 direction:(MSSPageViewControllerScrollDirection)scrollDirection;
```
Called when the page view controller is scrolled by the user to a specific offset, similar to `scrollViewDidScroll`. The pageOffset maintains the current page position and a scroll direction is provided. 

```
- (void)pageViewController:(MSSPageViewController *)pageViewController
           didScrollToPage:(NSInteger)page;
```
Called when the page view controller completes a full scroll to a new page. 

## Appearance
`MSSTabBarView` has numerous properties for adjusting its appearance:

- `sizingStyle` - Whether the tab bar should size to fit or equally distribute its tabs.
- `tabStyle` - The style to use for tabs, either `MSSTabStyleText` for text or `MSSTabStyleImage` for images.
- `tabIndicatorColor` - The color of the selection indicator. Also attached to the `tintColor` of the tab bar.
- `tabTextColor` - The text colour for the tabs.

## Requirements
Supports iOS 8 and iOS 9.

## Author
Merrick Sapsford

Mail: [merrick@sapsford.tech](mailto:merrick@sapsford.tech)
