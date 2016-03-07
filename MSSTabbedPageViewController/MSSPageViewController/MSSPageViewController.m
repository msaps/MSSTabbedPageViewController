//
//  MSSTabbedPageViewController.m
//  TabbedPageViewController
//
//  Created by Merrick Sapsford on 24/12/2015.
//  Copyright © 2015 Merrick Sapsford. All rights reserved.
//

#import "MSSPageViewController.h"

@interface MSSPageViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIPageViewController *pageViewController;

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, assign) CGFloat previousPagePosition;

/// Internal scroll update toggle
@property (nonatomic, assign) BOOL scrollUpdatesEnabled;

@end

@implementation MSSPageViewController

#pragma mark - Init

- (instancetype)init {
    if (self = [super init]) {
        [self baseInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self baseInit];
    }
    return self;
}

- (void)baseInit {
    _notifyOutOfBoundUpdates = YES;
    _showPageIndicator = NO;
    _allowScrollViewUpdates = YES;
    _scrollUpdatesEnabled = YES;
}

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
    [self.pageViewController addToParentViewController:self];
    self.scrollView.delegate = self;
    
    [self setUpTabs];
}

- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    // disable scroll updates during rotation
    self.scrollUpdatesEnabled = NO;
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.scrollUpdatesEnabled = YES;
    }];
}

#pragma mark - Scroll View delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat pageWidth = scrollView.frame.size.width;
    CGFloat scrollOffset = (scrollView.contentOffset.x - pageWidth);
    
    CGFloat currentXOffset = (self.currentPage * pageWidth) + scrollOffset;
    CGFloat currentPagePosition = currentXOffset / pageWidth;
    
    if (currentPagePosition != self.previousPagePosition) {

        // check if position is out of bounds
        BOOL outOfBounds = currentPagePosition < 0.0f || currentPagePosition > ((scrollView.contentSize.width / pageWidth) - 1.0f);
        if (self.notifyOutOfBoundUpdates || (!self.notifyOutOfBoundUpdates && !outOfBounds)) {
            
            // check whether updates are allowed
            if (self.scrollUpdatesEnabled && self.allowScrollViewUpdates) {
                if ([self.delegate respondsToSelector:@selector(pageViewController:didScrollToPageOffset:direction:)]) {
                    
                    MSSPageViewControllerScrollDirection direction =
                        currentPagePosition > _previousPagePosition ?
                        MSSPageViewControllerScrollDirectionForward : MSSPageViewControllerScrollDirectionBackward;
                    
                    [self.delegate pageViewController:self
                                didScrollToPageOffset:currentPagePosition
                                            direction:direction];
                }
            }
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

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    if (self.showPageIndicator) {
        return self.numberOfPages;
    }
    return 0;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    if (self.showPageIndicator) {
        return self.currentPage;
    }
    return 0;
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

#pragma mark - Public

- (void)moveToPageAtIndex:(NSInteger)index {
    [self moveToPageAtIndex:index completion:nil];
}

- (void)moveToPageAtIndex:(NSInteger)index
               completion:(void (^)(UIViewController *, BOOL, BOOL))completion {
    
    if (index != self.currentPage) {
        
        BOOL isForwards = index > self.currentPage;
        NSArray *viewControllers = self.pageViewController.viewControllers;
        UIViewController *viewController = [self viewControllerAtIndex:index];
        
        typeof(self) __weak weakSelf = self;
        [self.pageViewController setViewControllers:@[viewController]
                                          direction:isForwards ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse
                                           animated:YES
                                         completion:^(BOOL finished) {
                                             typeof(weakSelf) __strong strongSelf = weakSelf;
                                             [strongSelf pageViewController:strongSelf.pageViewController
                                                         didFinishAnimating:YES
                                                    previousViewControllers:viewControllers
                                                        transitionCompleted:YES];
                                             
                                             if (completion) {
                                                 completion(viewController, YES, YES);
                                             }
                                         }];
    } else {
        if (completion) {
            completion(nil, NO, NO);
        }
    }
}

- (BOOL)isDragging {
    return self.scrollView.isDragging;
}

- (void)setScrollEnabled:(BOOL)scrollEnabled {
    self.scrollView.scrollEnabled = scrollEnabled;
}

- (BOOL)isScrollEnabled {
    return self.scrollView.scrollEnabled;
}

#pragma mark - Internal

- (void)setUpTabs {
    
    // view controllers
    if ([self.dataSource respondsToSelector:@selector(viewControllersForPageViewController:)]) {
        _viewControllers = [self.dataSource viewControllersForPageViewController:self];
    }
    
    if (self.viewControllers.count > 0) {
        [self setUpViewControllers:self.viewControllers];
        
        NSInteger defaultIndex = 0;
        if ([self.dataSource respondsToSelector:@selector(defaultPageIndexForPageViewController:)]) {
            defaultIndex = [self.dataSource defaultPageIndexForPageViewController:self];
        }
        _numberOfPages = self.viewControllers.count;
        _defaultPageIndex = defaultIndex;
        self.currentPage = defaultIndex;
        
        if ([self.delegate respondsToSelector:@selector(pageViewController:didPrepareViewControllers:)]) {
            [self.delegate pageViewController:self didPrepareViewControllers:self.viewControllers];
        }
        
        // display initial page
        UIViewController *viewController = [self viewControllerAtIndex:defaultIndex];
        if ([self.delegate respondsToSelector:@selector(pageViewController:willDisplayInitialViewController:)]) {
            [self.delegate pageViewController:self willDisplayInitialViewController:viewController];
        }
        [self.pageViewController setViewControllers:@[viewController]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:NO
                                         completion:nil];
    }
}

- (void)setUpViewControllers:(NSArray *)viewControllers {
    for (UIViewController<MSSPageChildViewController> *viewController in viewControllers) {
        if ([viewController respondsToSelector:@selector(pageViewController)]) {
            viewController.pageViewController = self;
        }
    }
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
