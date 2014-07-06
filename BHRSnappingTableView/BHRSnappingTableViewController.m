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

@property (nonatomic, assign) CGPoint previousTargetContentOffset;
@property (nonatomic, assign) BOOL alreadyAppeared;

@end

@implementation BHRSnappingTableViewController

#pragma mark - UIViewController overrides

- (void) loadView
{
	BHRSnappingTableView* snappingTableView = [[BHRSnappingTableView alloc]initWithFrame:CGRectZero
																				   style:UITableViewStylePlain];

	snappingTableView.delegate = self;

	self.view = snappingTableView;
	self.tableView = snappingTableView;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	if (!self.alreadyAppeared)
	{
		self.alreadyAppeared = YES;
		self.resetContentOffset = YES;
	}
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	self.resetContentOffset = YES;
}

- (void)viewDidLayoutSubviews
{
	[super viewDidLayoutSubviews];

	CGFloat tableViewHeaderHeight = CGRectGetHeight(self.tableView.tableHeaderView.bounds);
	if (self.resetContentOffset &&
		self.tableView.contentOffset.y < tableViewHeaderHeight)
	{
		CGPoint defaultContentOffset = CGPointMake(0.0f,
												   tableViewHeaderHeight);
		self.previousTargetContentOffset = defaultContentOffset;
		[self.tableView setContentOffset:defaultContentOffset
								animated:NO];
		self.resetContentOffset = NO;
	}
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[super willRotateToInterfaceOrientation:toInterfaceOrientation
								   duration:duration];

	self.resetContentOffset = YES;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
					 withVelocity:(CGPoint)velocity
			  targetContentOffset:(inout CGPoint *)targetContentOffset
{
	CGPoint newOffset = *targetContentOffset;
	CGFloat tableViewHeaderViewHeight = CGRectGetHeight(self.tableView.tableHeaderView.bounds);
	CGFloat treshold = 5.0f;

	//snap back if we didn't move above the treshold
	if (self.previousTargetContentOffset.y < treshold &&
		newOffset.y < treshold)
	{
		newOffset.y = 0.0f;
	}
	//snap to hide header view if we are in treshold range of table view content
	else if (self.previousTargetContentOffset.y == tableViewHeaderViewHeight &&
			 newOffset.y > tableViewHeaderViewHeight - treshold &&
			 newOffset.y < tableViewHeaderViewHeight)
	{
		newOffset.y = tableViewHeaderViewHeight;
	}
	//snap to header if we didn't show it
	else if (self.previousTargetContentOffset.y > 0 &&
			 self.previousTargetContentOffset.y <= tableViewHeaderViewHeight &&
			 newOffset.y < tableViewHeaderViewHeight)
	{
		newOffset.y = 0.0f;
	}
	//snap to table view content if we come from header
	else if (self.previousTargetContentOffset.y < tableViewHeaderViewHeight &&
			 newOffset.y < tableViewHeaderViewHeight)
	{
		newOffset.y = tableViewHeaderViewHeight;
	}

//	//we come from anywhere down at table and flip up -> snap to table view content
//	else if (self.targetContentOffset.y > tableViewHeaderViewHeight &&
//			 newOffset.y < tableViewHeaderViewHeight)
//	{
//		newOffset.y = tableViewHeaderViewHeight;
//	}

	self.previousTargetContentOffset = newOffset;

	*targetContentOffset = newOffset;
}

@end
