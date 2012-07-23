//
//  NavViewController.m
//  Spritemation
//
//  Created by Craig Hinrichs on 7/15/12.
//
//

#import "NavViewController.h"
#import "cocos2d.h"
#import <DropboxSDK/DropboxSDK.h>
#import "ImageSelectTableViewController.h"

@interface NavViewController ()

@end

@implementation NavViewController
@synthesize cont;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIBarButtonItem *addImages = [[UIBarButtonItem alloc] initWithTitle:@"Add Image" style:UIBarButtonItemStylePlain target:self action:@selector(addImage:)];
    [CCDirector sharedDirector].navigationItem.leftBarButtonItem = addImages;
    
    
    UIBarButtonItem *settings = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self  action:@selector(settings:)];
    [CCDirector sharedDirector].navigationItem.rightBarButtonItem = settings;
}

- (void) addImage:(id) sender {
    if (![[DBSession sharedSession] isLinked]) {
        NSLog(@"Nope not linked");
		[[DBSession sharedSession] linkFromController:self];
    } else {
        //TestViewController *test = [[TestViewController alloc] initWithNibName:nil bundle:nil];
        
        if(cont == nil) {
            ImageSelectTableViewController *test = [[ImageSelectTableViewController alloc] initWithStyle:UITableViewStylePlain];
            cont = [[UIPopoverController alloc] initWithContentViewController:test];
        }
        [cont presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

- (void) settings:(id) sender {
    [[DBSession sharedSession] unlinkAll];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
