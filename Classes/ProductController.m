//
//  ProductController.m
//  SaleChecker
//
//  Created by Nathan Vander Wilt on 4/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ProductController.h"

#import "SaleCheckerAppDelegate.h";

#import "Product.h"
#import "EditProductController.h"

#import "AddItemController.h"
#import "Item.h"


@interface ProductController () <UIActionSheetDelegate>
@property (nonatomic, readonly) UITableView* tableView;
@end


@implementation ProductController

@synthesize product;

- (UITableView*)tableView {
	return (UITableView*)self.view;
}

- (void)viewDidLoad {
	self.title = @"Product";
    self.navigationItem.rightBarButtonItem = [self editButtonItem];
	self.tableView.allowsSelectionDuringEditing = YES;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.tableView reloadData];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.navigationItem setHidesBackButton:editing animated:animated];
    [self.tableView reloadData];
}

- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView
		   editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath
{
	(void)tableView;
	(void)indexPath;
	return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView*)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath*)indexPath {
	(void)tableView;
	(void)indexPath;
	return NO;
}

enum {
	ProductDetailsProductSection = 0,
	ProductDetailsItemsSection,
	ProductDeleteSection,
};

- (UITableViewCellAccessoryType)tableView:(UITableView*)tableView
		 accessoryTypeForRowWithIndexPath:(NSIndexPath*)indexPath
{
	(void)tableView;
	(void)indexPath;
    return (self.isEditing) ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
	(void)tableView;
    return (self.isEditing) ? 3 : 2;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
	(void)tableView;
	NSInteger numberOfRows = 0;
	switch (section) {
		case ProductDetailsProductSection:
			numberOfRows = 2;
			break;
		case ProductDetailsItemsSection:
			numberOfRows = [self.product.items count];
			// add one for the add item button
			numberOfRows += 1;
			break;
		case ProductDeleteSection:
			numberOfRows = 1;
			break;
	}
	return numberOfRows;
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section {
	(void)tableView;
	
	NSString* title = nil;
	switch (section) {
		case ProductDetailsProductSection:
			title = @"Product";
			break;
		case ProductDetailsItemsSection:
			title = @"Items";
			break;
	}
	return title;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
	static NSString* const productCellIdentifier = @"Name";
	static NSString* const itemsCellIdentifier = @"Item";
	static NSString* const deleteCellIdentifier = @"Delete";
	
	UITableViewCell* cell = nil;
	switch (indexPath.section) {
		case ProductDetailsProductSection:
			cell = [tableView dequeueReusableCellWithIdentifier:productCellIdentifier];
			if (!cell) {
				cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero
											   reuseIdentifier:productCellIdentifier] autorelease];
				cell.hidesAccessoryWhenEditing = NO;
			}
			if (indexPath.row == 0) {
				cell.text = self.product.name;
			}
			else if (indexPath.row == 1) {
				cell.text = [self.product.standardMeasure description] ?: @"[Standard measure info]";
			}
			break;
		case ProductDetailsItemsSection:
			cell = [tableView dequeueReusableCellWithIdentifier:itemsCellIdentifier];
			if (!cell) {
				cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero
											   reuseIdentifier:itemsCellIdentifier] autorelease];
				cell.hidesAccessoryWhenEditing = NO;
			}
			if (indexPath.row < [self.product.items count]) {
				Item* item = [self.product.items objectAtIndex:indexPath.row];
				cell.text = item.detailedName;
			}
			else {
				cell.text = @"Add item";
			}
			break;
		case ProductDeleteSection:
			cell = [tableView dequeueReusableCellWithIdentifier:deleteCellIdentifier];
			if (!cell) {
				cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero
											   reuseIdentifier:deleteCellIdentifier] autorelease];
			}
			cell.text = @"Delete";
			break;
	}
	return cell;
}

- (NSIndexPath*)tableView:(UITableView*)tableView willSelectRowAtIndexPath:(NSIndexPath*)indexPath {
	(void)tableView;
	if (indexPath.section == ProductDetailsItemsSection) {
		return indexPath;
	}
	return (self.isEditing) ? indexPath: nil;
}

- (void)actionSheet:(UIActionSheet*)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (buttonIndex == actionSheet.destructiveButtonIndex) {
		// remove this product
		SaleCheckerAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
		[appDelegate removeProduct:self.product];
		[self.navigationController popViewControllerAnimated:YES];
	}
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
	(void)tableView;
	if (indexPath.section == ProductDeleteSection) {
		UIActionSheet* deleteConfirmation = [[UIActionSheet alloc] initWithTitle:nil
																		delegate:self
															   cancelButtonTitle:@"Cancel"
														  destructiveButtonTitle:@"Delete"
															   otherButtonTitles:nil];
		deleteConfirmation.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
		[deleteConfirmation showInView:self.view];
		[deleteConfirmation release];
	}
	else if (indexPath.section == ProductDetailsProductSection) {
		EditProductController* editController = [[EditProductController alloc] initWithStyle:UITableViewStyleGrouped];
		editController.product = self.product;
		[editController setEditing:YES animated:NO];
		[self.navigationController pushViewController:editController animated:YES];
		[editController release];
	}
	else if (indexPath.section == ProductDetailsItemsSection) {
		if (indexPath.row == [self.product.items count]) {
			Item* newItem = [Item new];
			AddItemController* itemController = [[AddItemController alloc] initWithStyle:UITableViewStyleGrouped];
			itemController.product = self.product;
			itemController.item = newItem;
			[newItem release];
			
			UINavigationController* modalNavController = [[UINavigationController alloc]
														  initWithRootViewController:itemController];
			[itemController release];
			[self.navigationController presentModalViewController:modalNavController animated:YES];
			[modalNavController release];
		}
		else {
			ItemController* itemController = [[ItemController alloc] initWithStyle:UITableViewStyleGrouped];
			itemController.item = [self.product.items objectAtIndex:indexPath.row];
			[self.navigationController pushViewController:itemController animated:YES];
			[itemController release];
		}
	}
}

@end

