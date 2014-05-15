//
//  BHRViewController.m
//  BHRSnappingTableView
//
//  Created by Benedikt Hirmer on 5/15/14.
//  Copyright (c) 2014 HIRMER.me. All rights reserved.
//

#import "BHRViewController.h"

#define kTableViewHeaderHeight 100.0f
#define kLowNumberOfItems 3
#define kHighNumberOfItems 100

@interface BHRViewController () <UITableViewDataSource>

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, assign) NSInteger itemsCount;

@end

@implementation BHRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.itemsCount = kLowNumberOfItems;

	[self _setUpTable];
}

- (void)_setUpTable
{
	self.tableView.dataSource = self;
	self.tableView.tableHeaderView = self.headerView;
}



#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.itemsCount;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];

	if (!cell)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
									  reuseIdentifier:@"CELL"];
	}

	cell.backgroundColor = [UIColor colorWithHue:(CGFloat)indexPath.row/(CGFloat)self.itemsCount
									  saturation:0.7f
									  brightness:0.8f
										   alpha:1.0f];
	cell.textLabel.text = [NSString stringWithFormat:@"%lu", (long)indexPath.row];

	return cell;
}


#pragma mark - Properties

- (UIView *)headerView
{
	if (!_headerView)
	{
		_headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 0.0f, kTableViewHeaderHeight)];
		_headerView.backgroundColor = [UIColor darkGrayColor];

		UIButton *addButton = [UIButton buttonWithType:UIButtonTypeSystem];
		addButton.translatesAutoresizingMaskIntoConstraints = NO;

		[addButton setTitle:NSLocalizedString(@"Update items", nil)
				   forState:UIControlStateNormal];
		[addButton addTarget:self
					  action:@selector(changeNumberOfItems:)
			forControlEvents:UIControlEventTouchUpInside];

				[_headerView addSubview:addButton];
		[_headerView addConstraint:[NSLayoutConstraint constraintWithItem:_headerView
																attribute:NSLayoutAttributeCenterX
																relatedBy:NSLayoutRelationEqual
																   toItem:addButton
																attribute:NSLayoutAttributeCenterX
															   multiplier:1.0f
																 constant:0.0f]];

		[_headerView addConstraint:[NSLayoutConstraint constraintWithItem:_headerView
																attribute:NSLayoutAttributeCenterY
																relatedBy:NSLayoutRelationEqual
																   toItem:addButton
																attribute:NSLayoutAttributeCenterY
															   multiplier:1.0f
																 constant:0.0f]];
	}
	return _headerView;
}

#pragma mark - Actions

- (void)changeNumberOfItems:(id)sender
{
	if (self.itemsCount == kLowNumberOfItems) {
		self.itemsCount = kHighNumberOfItems;
	}
	else {
		self.itemsCount = kLowNumberOfItems;
	}

	[self.tableView reloadData];
}

@end
