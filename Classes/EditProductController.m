//
//  EditProductController.m
//  SaleChecker
//
//  Created by Nathan Vander Wilt on 4/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "EditProductController.h"

#import "Product.h"
#import "EditableTextCell.h"


@implementation EditProductController

@synthesize product;

- (void)dealloc {
	self.product = nil;
	[nameCell release];
	[super dealloc];
}

- (void)viewDidLoad {
    // Override the DetailViewController viewDidLoad with different navigation bar items and title
    self.title = @"Edit Product";
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																						   target:self action:@selector(cancel)] autorelease];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
																							target:self action:@selector(save)] autorelease];
}

- (IBAction)save {
	self.product.name = nameCell.textField.text;
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancel {
	[self.navigationController popViewControllerAnimated:YES];
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

- (UITableViewCellAccessoryType)tableView:(UITableView*)tableView
		 accessoryTypeForRowWithIndexPath:(NSIndexPath*)indexPath
{
	(void)tableView;
	(void)indexPath;
    return UITableViewCellAccessoryNone;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
	(void)tableView;
	(void)section;
	return 2;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
	(void)tableView;
	(void)indexPath;
	
	UITableViewCell* cell = nil;
	switch (indexPath.row) {
		case 0:
			if (!nameCell) {
				nameCell = [[EditableTextCell alloc] initWithFrame:CGRectZero reuseIdentifier:nil];
				nameCell.textField.placeholder = @"Name";
			}
			nameCell.textField.text = self.product.name;
			cell = nameCell;
			break;
		case 1:
			if (!quantityCell) {
				quantityCell = [[EditableTextCell alloc] initWithFrame:CGRectZero reuseIdentifier:nil];
				quantityCell.textField.placeholder = @"Amount";
				quantityCell.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
			}
			quantityCell.textField.text = @"3.14";
			cell = quantityCell;
			break;
	}
	return cell;
}

@end

