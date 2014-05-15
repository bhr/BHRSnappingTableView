//
//  BHRSnappingTableView.m
//  BHRSnappingTableView
//
//  Created by Benedikt Hirmer on 5/15/14.
//  Copyright (c) 2014 HIRMER.me. All rights reserved.
//

#import "BHRSnappingTableView.h"

@implementation BHRSnappingTableView

- (void)setContentSize:(CGSize)contentSize
{
	CGFloat tableViewHeight = CGRectGetHeight(self.bounds);
	CGFloat tableViewHeaderViewHeight = CGRectGetHeight(self.tableHeaderView.bounds);

	CGFloat difference = (tableViewHeight - contentSize.height);
	if (difference > 0)
	{
		contentSize.height += difference + tableViewHeaderViewHeight;
	}

	[super setContentSize:contentSize];
}


@end
