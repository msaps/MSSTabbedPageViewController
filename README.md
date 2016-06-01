# MSSTabbedPageViewController
[![Build Status](https://travis-ci.org/MerrickSapsford/MSSTabbedPageViewController.svg?branch=develop)](https://travis-ci.org/MerrickSapsford/MSSTabbedPageViewController)
[![CocoaPods](https://img.shields.io/cocoapods/v/MSSTabbedPageViewController.svg)]()

MSSTabbedPageViewController is a UIViewController that provides a simple to implement page view controller with scrolling tab bar. It also includes a UIPageViewController wrapper that provides improved data source and delegation methods.

<div style="width:100%;">
<img src="MSSTabbedPageViewController.gif" align="center" height="30%" width="30%" style="margin-left:20px;">
</div>

<p><p>

## Example
To run the example project, clone the repo and build the project. Examples are available for both Objective-C and Swift projects.

## Installation
MSSTabbedPageViewController is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

    pod "MSSTabbedPageViewController"

And run `pod install`.

## Usage

To use the tabbed page view controller, simply create a `UIViewController` that is a subclass of `MSSTabbedPageViewController`. Then implement the following data source method:

```
// array of view controllers to display in page view controller
- (NSArray *)viewControllersForPageViewController:(MSSPageViewController *)pageViewController;
```

If you are using a `UINavigationController` (As shown in Example project) you can embed the tab bar in the navigation bar. Simply set the `UINavigationBar` class in the navigation controller to `MSSTabNavigationBar` and the navigation bar will attach to the view controller.

To manually attach a tab bar view to the `MSSTabbedPageViewController`:

- Set the `tabBarView` property of the `MSSTabbedPageViewController` to an `MSSTabBarView` instance (Note: `tabBarView` is weak and an `IBOutlet`).
- Set the `dataSource` and `delegate` properties of the `MSSTabBarView` instance to the `MSSTabbedPageViewController` (Both are `IBOutlet`able).

To customise the content of the tabs in the tab bar override the following:

```
- (void)tabBarView:(MSSTabBarView *)tabBarView
       populateTab:(MSSTabBarCollectionViewCell *)tab
           atIndex:(NSInteger)index;
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
`MSSTabBarView` provides properties for appearance customisation, including:

- `sizingStyle` - Whether the tab bar should size to fit or equally distribute its tabs.
- `tabStyle` - The style to use for tabs, either `MSSTabStyleText` for text or `MSSTabStyleImage` for images.
- `indicatorAttributes` - Appearance attributes for tab indicator.
- `tabAttributes` - Appearance attributes for tabs.
- `selectedTabAttributes` - Appearance attributes for the selected tab.
- `selectionIndicatorTransitionStyle` - The transition style for the selection indicator.
 - `MSSTabTransitionStyleProgressive` to progressively transition between tabs.
 - `MSSTabTransitionStyleSnap` to snap between tabs during transitioning.
 - use `setTransitionStyle:` to set both the `selectionIndicatorTransitionStyle` and `tabTransitionStyle`.
- `tabTransitionStyle` - The transition style to use for the tabs.

## Requirements
Supports iOS 8 and iOS 9.

## Author
Merrick Sapsford

Mail: [merrick@sapsford.tech](mailto:merrick@sapsford.tech)
