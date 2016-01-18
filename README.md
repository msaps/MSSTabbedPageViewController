# MSSTabbedPageViewController
[![Build Status](https://travis-ci.org/MerrickSapsford/MSSTabbedPageViewController.svg?branch=master)](https://travis-ci.org/MerrickSapsford/MSSTabbedPageViewController)

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

// array of NSString's for titles in tab bar
- (NSArray *)tabTitlesForTabBarView:(MSSTabBarView *)tabBarView;
```

There are also some optional `MSSTabbedPageViewControllerDataSource` methods:

```
// default page index to display
- (NSInteger)defaultPageIndexForPageViewController:(MSSPageViewController *)pageViewController;
```
The `MSSTabbedPageViewControllerDelegate` provides the following optional methods:

```
// The desired tab bar height in the tabbed page view controller
- (CGFloat)tabbedPageViewControllerHeightForTabBar:(MSSTabbedPageViewController *)tabbedPageViewController;
```

Child view controllers can have access to numerous components of the parent controller by implementing the `MSSTabbedPageChildViewController` protocol:

```
// Parent page view controller
@property (nonatomic, weak) MSSPageViewController *pageViewController;

// Parent tab bar view
@property (nonatomic, weak) MSSTabBarView *tabBarView;

// The required inset for the child view controller to display correctly in the parent
@property (nonatomic, assign) UIEdgeInsets requiredContentInset;
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

## Requirements
Supports iOS 8 and iOS 9.

## Author
Merrick Sapsford

Mail: [merrick@merricksapsford.co.uk](mailto:merrick@merricksapsford.co.uk)
