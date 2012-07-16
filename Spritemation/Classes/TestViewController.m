//
//  TestViewController.m
//  Spritemation
//
//  Created by Craig Hinrichs on 7/15/12.
//
//

#import "TestViewController.h"

@interface TestViewController () <DBRestClientDelegate>

@property (nonatomic, readonly) DBRestClient* restClient;
@end

@implementation TestViewController
@synthesize imageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!imageView.image) {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        [self.view addSubview:imageView];
        [self didPressRandomPhoto];
    }
}

- (void)didPressRandomPhoto {
    //[self setWorking:YES];
    
    NSString *photosRoot = nil;
    if ([DBSession sharedSession].root == kDBRootDropbox) {
        photosRoot = @"/Photos";
    } else {
        photosRoot = @"/";
    }
    
    [self.restClient loadMetadata:photosRoot withHash:photosHash];
}

- (void)restClient:(DBRestClient*)client loadedMetadata:(DBMetadata*)metadata {
    NSLog(@"Tried");
    [photosHash release];
    photosHash = [metadata.hash retain];
    
    NSArray* validExtensions = [NSArray arrayWithObjects:@"jpg", @"jpeg", nil];
    NSMutableArray* newPhotoPaths = [NSMutableArray new];
    for (DBMetadata* child in metadata.contents) {
        NSString* extension = [[child.path pathExtension] lowercaseString];
        if (!child.isDirectory && [validExtensions indexOfObject:extension] != NSNotFound) {
            [newPhotoPaths addObject:child.path];
        }
    }
    [photoPaths release];
    photoPaths = newPhotoPaths;
    [self loadRandomPhoto];
}

- (void)restClient:(DBRestClient*)client metadataUnchangedAtPath:(NSString*)path {
    [self loadRandomPhoto];
}

- (void)restClient:(DBRestClient*)client loadMetadataFailedWithError:(NSError*)error {
    NSLog(@"restClient:loadMetadataFailedWithError: %@", [error localizedDescription]);
    //[self displayError];
    //[self setWorking:NO];
}

- (void)restClient:(DBRestClient*)client loadedThumbnail:(NSString*)destPath {
    //[self setWorking:NO];
    imageView.image = [UIImage imageWithContentsOfFile:destPath];
}

- (void)restClient:(DBRestClient*)client loadThumbnailFailedWithError:(NSError*)error {
    //[self setWorking:NO];
    //[self displayError];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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

- (void)loadRandomPhoto {
    if ([photoPaths count] == 0) {
        
        NSString *msg = nil;
        if ([DBSession sharedSession].root == kDBRootDropbox) {
            msg = @"Put .jpg photos in your Photos folder to use DBRoulette!";
        } else {
            msg = @"Put .jpg photos in your app's App folder to use DBRoulette!";
        }
        
        [[[[UIAlertView alloc] 
           initWithTitle:@"No Photos!" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]
          autorelease]
         show];
        
        //[self setWorking:NO];
    } else {
        NSString* photoPath;
        if ([photoPaths count] == 1) {
            photoPath = [photoPaths objectAtIndex:0];
            if ([photoPath isEqual:currentPhotoPath]) {
                [[[[UIAlertView alloc]
                   initWithTitle:@"No More Photos" message:@"You only have one photo to display." 
                   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]
                  autorelease]
                 show];
                
                //[self setWorking:NO];
                return;
            }
        } else {
            // Find a random photo that is not the current photo
            do {
                srandom(time(NULL));
                NSInteger index =  random() % [photoPaths count];
                photoPath = [photoPaths objectAtIndex:index];
            } while ([photoPath isEqual:currentPhotoPath]);
        }
        
        [currentPhotoPath release];
        currentPhotoPath = [photoPath retain];
        
        [self.restClient loadThumbnail:currentPhotoPath ofSize:@"iphone_bestfit" intoPath:[self photoPath]];
    }
}

- (DBRestClient*)restClient {
    if (restClient == nil) {
        restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
    }
    return restClient;
}

- (NSString*)photoPath {
    return [NSTemporaryDirectory() stringByAppendingPathComponent:@"photo.jpg"];
}
@end
