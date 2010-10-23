//
//  ItemController.m
//  SaleChecker
//
//  Created by Nathan Vander Wilt on 4/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ItemController.h"

#import "Item.h"
#import "PricePoint.h"

@implementation ItemController

@synthesize item;

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
	(void)tableView;
	return 2;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
	(void)tableView;
	NSInteger numberOfRows = 0;
	if (section == 0) {
		numberOfRows = 2;
	}
	else if (section == 1) {
		numberOfRows = [self.item.priceHistory count];
	}
	return numberOfRows;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
	(void)indexPath;
	static NSString* const nameCellIdentifier = @"Name";
	static NSString* const priceCellIdentifier = @"Price";
	
	UITableViewCell* cell = nil;
	if (indexPath.section == 0) {
		cell = [tableView dequeueReusableCellWithIdentifier:nameCellIdentifier];
		if (!cell) {
			cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero
										   reuseIdentifier:nameCellIdentifier] autorelease];
		}
		cell.text = self.item.detailedName;
	}
	else if (indexPath.section == 1) {
		cell = [tableView dequeueReusableCellWithIdentifier:priceCellIdentifier];
		if (!cell) {
			cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero
										   reuseIdentifier:priceCellIdentifier] autorelease];
		}
		PricePoint* price = [self.item.priceHistory objectAtIndex:indexPath.row];
		cell.text = [price description];
	}
	
	return cell;
}

@end

