//
//  MSSTabbedPageViewController.m
//  TabbedPageViewController
//
//  Created by Merrick Sapsford on 24/12/2015.
//  Copyright © 2015 Merrick Sapsford. All rights reserved.
//

#import "MSSPageViewController.h"
#import "UIView+MSSAutoLayout.h"

@interface MSSPageViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIPageViewController *pageViewController;

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, assign) CGFloat previousPagePosition;

@end

@implementation MSSPageViewController

#pragma mark - Lifecycle

- (void)loadView {
    [super loadView];
    
    if (!_pageViewController) {
        self.pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                                  navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                                options:nil];
        self.pageViewController.dataSource = self;
        self.pageViewController.delegate = self;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.pageViewController.parentViewController) {
        [self addChildViewController:self.pageViewController];
        [self.view addExpandingSubview:self.pageViewController.view];
        [self.pageViewController didMoveToParentViewController:self];
    }
    self.scrollView.delegate = self;
    
    [self setUpTabs];
}

#pragma mark - Scroll View delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat pageWidth = scrollView.frame.size.width;
    CGFloat scrollOffset = (scrollView.contentOffset.x - pageWidth);
    
    CGFloat currentXOffset = (self.currentPage * pageWidth) + scrollOffset;
    CGFloat currentPagePosition = currentXOffset / pageWidth;
    
    if (currentPagePosition != self.previousPagePosition) {
        if ([self.delegate respondsToSelector:@selector(pageViewController:didScrollToPageOffset:)]) {
            [self.delegate pageViewController:self didScrollToPageOffset:currentPagePosition];
        }
        
        _previousPagePosition = currentPagePosition;
    }
}

#pragma mark - Page View Controller data source

- (UIViewController *)pageViewController:(MSSPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger index = [self indexOfViewController:viewController];
    
    if (index != (self.viewControllers.count - 1) && index != NSNotFound) {
        index++;
        return [self viewControllerAtIndex:index];
    }
    return nil;
}

- (UIViewController *)pageViewController:(MSSPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger index = [self indexOfViewController:viewController];
    
    if (index != 0 && index != NSNotFound) {
        index--;
        return [self viewControllerAtIndex:index];
    }
    return nil;
}

#pragma mark - Page View Controller delegate

- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers
       transitionCompleted:(BOOL)completed {
    
    if (completed) {
        _currentPage = [self indexOfViewController:self.pageViewController.viewControllers.firstObject];
        
        if ([self.delegate respondsToSelector:@selector(pageViewController:didScrollToPage:)]) {
            [self.delegate pageViewController:self didScrollToPage:self.currentPage];
        }
    }
}

#pragma mark - Internal

- (void)setUpTabs {
    _viewControllers = [self.dataSource viewControllersForPageViewController:self];
    NSInteger defaultIndex = [self.dataSource defaultPageIndexForPageViewController:self];
    
    _currentPage = defaultIndex;
    
    [self.pageViewController setViewControllers:@[[self viewControllerAtIndex:defaultIndex]]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];
}

- (UIViewController *)viewControllerAtIndex:(NSInteger)index {
    if (index < self.viewControllers.count) {
        return self.viewControllers[index];
    }
    return nil;
}

- (NSInteger)indexOfViewController:(UIViewController *)viewController {
    return [self.viewControllers indexOfObject:viewController];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        for (UIView *subview in self.pageViewController.view.subviews) {
            if ([subview isKindOfClass:[UIScrollView class]]) {
                _scrollView = (UIScrollView *)subview;
                break;
            }
        }
    }
    return _scrollView;
}

@end
