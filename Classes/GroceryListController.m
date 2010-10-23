//
//  GroceryListController.m
//  SaleChecker
//
//  Created by Nathan Vander Wilt on 4/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GroceryListController.h"

#import "SaleCheckerAppDelegate.h"
#import "AddProductController.h"
#import "Product.h"


@implementation GroceryListController

- (void)viewWillAppear:(BOOL)animated {
	// call super to clear selection
	[super viewWillAppear:animated];
    [(UITableView*)self.view reloadData];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table data source

- (NSArray*)products {
	SaleCheckerAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
	return [appDelegate products];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
	(void)tableView;
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
	(void)tableView;
	(void)section;
    return [self.products count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    static NSString* const cellIdentifier = @"Grocery";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:cellIdentifier] autorelease];
    }
	Product* product = [self.products objectAtIndex:indexPath.row];
	cell.text = product.name ?: @"(no name)";
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
	(void)tableView;
	ProductController* productController = [[ProductController alloc]
											initWithStyle:UITableViewStyleGrouped];
	Product* product = [self.products objectAtIndex:indexPath.row];
	[product hydrate];
	productController.product = product;
	[self.navigationController pushViewController:productController animated:YES];
	[productController release];
}

- (IBAction)addItem {
	Product* newProduct = [Product new];
	AddProductController* productController = [[AddProductController alloc]
											   initWithStyle:UITableViewStyleGrouped];
	productController.product = newProduct;
	[newProduct release];
	[productController setEditing:YES animated:NO];
	
	UINavigationController* modalNavController = [[UINavigationController alloc]
												  initWithRootViewController:productController];
	[productController release];
	[self.navigationController presentModalViewController:modalNavController animated:YES];
	[modalNavController release];
}

@end

