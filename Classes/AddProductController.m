//
//  AddProductController.m
//  SaleChecker
//
//  Created by Nathan Vander Wilt on 4/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AddProductController.h"

#import "SaleCheckerAppDelegate.h"


@implementation AddProductController

- (void)viewDidLoad {
    // Override the DetailViewController viewDidLoad with different navigation bar items and title
    self.title = @"New Product";
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																						   target:self action:@selector(cancel)] autorelease];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
																							target:self action:@selector(save)] autorelease];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	// TODO: disable "Save" button if not finished
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (IBAction)cancel {
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (IBAction)save {
    SaleCheckerAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate addProduct:self.product];
	
	// go to the new product, rather than the list
	ProductController* productController = [[ProductController alloc] initWithNibName:@"ProductDetails" bundle:nil];
	productController.product = self.product;
	UINavigationController* parentNavController = (UINavigationController*)self.navigationController.parentViewController;
	[parentNavController pushViewController:productController animated:NO];
	[productController release];
	
	[self.navigationController dismissModalViewControllerAnimated:YES];
}

@end
