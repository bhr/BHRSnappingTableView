//
//  BHRSnappingTableViewController.m
//  BHRSnappingTableView
//
//  Created by Benedikt Hirmer on 5/15/14.
//  Copyright (c) 2014 HIRMER.me. All rights reserved.
//

#import "BHRSnappingTableViewController.h"
#import "BHRSnappingTableView.h"

@interface BHRSnappingTableViewController () <UIScrollViewDelegate, UITableViewDelegate>

@property (nonatomic, strong) BHRSnappingTableView *tableView;

@property (nonatomic, assign) CGPoint previousContentOffset;
@property (nonatomic, assign) CGPoint lastScrollContentOffset;

@end

@implementation BHRSnappingTableViewController

#pragma mark - UIViewController overrides

- (void)viewDidLayoutSubviews
{
	[super viewDidLayoutSubviews];

	[self.tableView setContentOffset:CGPointMake(0.0f,
												 CGRectGetHeight(self.tableView.tableHeaderView.bounds))];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	self.previousContentOffset = scrollView.contentOffset;
	NSLog(@"scrollViewWillBeginDragging %f", scrollView.contentOffset.y);
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//	NSLog(@"scrollViewDidScroll %f", scrollView.contentOffset.y);
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
					 withVelocity:(CGPoint)velocity
			  targetContentOffset:(inout CGPoint *)targetContentOffset
{
	NSLog(@"scrollViewWillEndDragging %f", scrollView.contentOffset.y);
	CGPoint newOffset = *targetContentOffset;
	CGFloat tableViewHeaderViewHeight = CGRectGetHeight(self.tableView.tableHeaderView.bounds);
	CGFloat treshold = 5.0f;

	//snap back if we didn't move above the treshold
	if (self.previousContentOffset.y < treshold &&
		newOffset.y < treshold)
	{
		newOffset.y = 0.0f;
	}
	//snap to hide header view if we are in treshold range of table view content
	else if (self.previousContentOffset.y == tableViewHeaderViewHeight &&
			 newOffset.y > tableViewHeaderViewHeight - treshold &&
			 newOffset.y < tableViewHeaderViewHeight)
	{
		newOffset.y = tableViewHeaderViewHeight;
	}
	//snap to header if we didn't show it
	else if (self.previousContentOffset.y > 0 &&
			 self.previousContentOffset.y <= tableViewHeaderViewHeight &&
			 newOffset.y < tableViewHeaderViewHeight)
	{
		newOffset.y = 0.0f;
	}
	//snap to table view content if we come from header
	else if (self.previousContentOffset.y < tableViewHeaderViewHeight &&
			 newOffset.y < tableViewHeaderViewHeight)
	{
		newOffset.y = tableViewHeaderViewHeight;
	}
	//we come from anywhere down at table and flip up -> snap to table view content
	else if (self.previousContentOffset.y > tableViewHeaderViewHeight &&
			 newOffset.y < tableViewHeaderViewHeight)
	{
		newOffset.y = tableViewHeaderViewHeight;
	}

	*targetContentOffset = newOffset;
}


- (BHRSnappingTableView *)tableView
{
	if (!_tableView)
	{
		_tableView = [[BHRSnappingTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
		_tableView.translatesAutoresizingMaskIntoConstraints = NO;
		_tableView.delegate = self;

		[self.view addSubview:_tableView];
		[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|"
																		  options:0
																		  metrics:nil
																			views:NSDictionaryOfVariableBindings(_tableView)]];
		[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tableView]|"
																		  options:0
																		  metrics:nil
																			views:NSDictionaryOfVariableBindings(_tableView)]];
	}

	return _tableView;
}

@end
