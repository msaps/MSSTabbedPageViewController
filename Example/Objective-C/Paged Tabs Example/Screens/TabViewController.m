//
//  TabViewController.m
//  TabbedPageViewController
//
//  Created by Merrick Sapsford on 24/12/2015.
//  Copyright © 2015 Merrick Sapsford. All rights reserved.
//

#import "TabViewController.h"
#import "ChildViewController.h"

@implementation TabViewController

#pragma mark - Init

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _style = [TabControllerStyle styleWithName:@"Default"
                                          tabStyle:MSSTabStyleText
                                       sizingStyle:MSSTabSizingStyleSizeToFit
                                      numberOfTabs:6];
    }
    return self;
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.navigationController.viewControllers.firstObject == self) { // only show styles option if initial screen
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Styles"
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:@selector(showStylesScreen:)];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tabBarView setTransitionStyle:self.style.transitionStyle];
    self.tabBarView.tabStyle = self.style.tabStyle;
    self.tabBarView.sizingStyle = self.style.sizingStyle;
    
    self.tabBarView.tabAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:16.0f weight:UIFontWeightThin],
                                      NSForegroundColorAttributeName : [UIColor blackColor],
                                      MSSTabTransitionAlphaEffectEnabled : @(NO)};
    self.tabBarView.selectedTabAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:16.0f weight:UIFontWeightMedium],
                                              NSForegroundColorAttributeName : self.view.tintColor};
    self.tabBarView.indicatorAttributes = @{};
}

#pragma mark - Interaction

- (void)showStylesScreen:(id)sender {
    [self performSegueWithIdentifier:@"showStylesSegue" sender:self];
}

#pragma mark - MSSPageViewControllerDataSource

- (NSArray *)viewControllersForPageViewController:(MSSPageViewController *)pageViewController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    NSMutableArray *viewControllers = [NSMutableArray new];
    
    for (NSInteger i = 0; i < self.style.numberOfTabs; i++) {
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"viewController1"];
        [viewControllers addObject:viewController];
    }
    return viewControllers;
}

#pragma mark - MSSTabBarViewDataSource

- (void)tabBarView:(MSSTabBarView *)tabBarView populateTab:(MSSTabBarCollectionViewCell *)tab atIndex:(NSInteger)index {
    NSString *imageName = [NSString stringWithFormat:@"tab%i.png", (int)(index + 1)];
    NSString *pageName = [NSString stringWithFormat:@"Page %i", (int)(index + 1)];
    
    tab.image = [UIImage imageNamed:imageName];
    tab.title = pageName;
}

@end
