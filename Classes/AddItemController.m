//
//  AddItemController.m
//  SaleChecker
//
//  Created by Nathan Vander Wilt on 5/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AddItemController.h"

#import "Product.h"


@implementation AddItemController

@synthesize product;


- (void)viewDidLoad {
    self.title = @"New Item";
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
    [self.product addItem:self.item];
	[self.navigationController dismissModalViewControllerAnimated:YES];
}

@end
