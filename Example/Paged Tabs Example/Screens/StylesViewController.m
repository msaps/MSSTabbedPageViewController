//
//  RootViewController.m
//  Paged Tabs Example
//
//  Created by Merrick Sapsford on 11/04/2016.
//  Copyright © 2016 Merrick Sapsford. All rights reserved.
//

#import "StylesViewController.h"
#import "TabViewController.h"

@interface StylesViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSArray *styles;

@end

@implementation StylesViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.styles = @[
                    [TabControllerStyle styleWithName:@"Wrapped Text" tabStyle:MSSTabStyleText sizingStyle:MSSTabSizingStyleSizeToFit numberOfTabs:5],
                    [TabControllerStyle styleWithName:@"Distributed Text" tabStyle:MSSTabStyleText sizingStyle:MSSTabSizingStyleDistributed numberOfTabs:3],
                    [TabControllerStyle styleWithName:@"Wrapped Images" tabStyle:MSSTabStyleImage sizingStyle:MSSTabSizingStyleSizeToFit numberOfTabs:5],
                    [TabControllerStyle styleWithName:@"Distributed Images" tabStyle:MSSTabStyleImage sizingStyle:MSSTabSizingStyleDistributed numberOfTabs:3]
                    ];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    TabViewController *tabViewController = (TabViewController *)segue.destinationViewController;
    TabControllerStyle *style = self.styles[[self.tableView indexPathForSelectedRow].row];
    
    tabViewController.style = style;
    
    [super prepareForSegue:segue sender:sender];
}

#pragma mark - Interaction

- (IBAction)closeButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.styles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    
    TabControllerStyle *style = self.styles[indexPath.row];
    cell.textLabel.text = style.name;
    
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"showTabViewController" sender:self];
}

@end
