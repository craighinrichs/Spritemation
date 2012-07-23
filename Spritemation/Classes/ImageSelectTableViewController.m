//
//  ImageSelectTableViewController.m
//  Spritemation
//
//  Created by Craig Hinrichs on 7/19/12.
//
//

#import "ImageSelectTableViewController.h"
#import "cocos2d.h"
#import "AnimationBoardScene.h"

@interface ImageSelectTableViewController () <DBRestClientDelegate>
@property (nonatomic, readonly) DBRestClient* restClient;
@end

@implementation ImageSelectTableViewController
    
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
        NSString *searchDirectory = @"/";
        [self.restClient loadMetadata:searchDirectory withHash:photosHash];
        _images = [[NSMutableArray array] retain];
        NSLog(@"Found %i photos",1);
        
        AnimationBoardScene *scene = (AnimationBoardScene *)[[CCDirector sharedDirector] runningScene];
        self.bdelegate = [scene getDelegate];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_images count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"imagecell"] autorelease];
        cell.imageView.image = [_images objectAtIndex:indexPath.row];
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
        addButton.tag = indexPath.row;
        [addButton addTarget:self action:@selector(addImageToScene:) forControlEvents:UIControlEventTouchDown];
        addButton.frame = CGRectMake(cell.frame.size.width * 0.8,cell.center.y,80,80);
        [cell addSubview:addButton];
    }
    // Configure the cell...
    if(cell.imageView.image) {
        
    } else {
        
    }
    return cell;
}

- (void) addImageToScene:(UIButton *) sender {
    int row = sender.tag;
    NSString *path = [photoPaths objectAtIndex:row];
    NSLog(@"%@",path);
    [self.bdelegate addSpriteToScene:[self photoPath:path]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200.0f;
}

#pragma mark - Dropbox Rest Client

- (DBRestClient*)restClient {
    if (restClient == nil) {
        restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
    }
    return restClient;
}

- (void)restClient:(DBRestClient*)client loadedMetadata:(DBMetadata*)metadata {
   // NSLog(@"Tried");
    [photosHash release];
    photosHash = [metadata.hash retain];
    
    NSArray* validExtensions = [NSArray arrayWithObjects:@"png", @"jpg", nil];
    NSMutableArray* newPhotoPaths = [NSMutableArray new];
    for (DBMetadata* child in metadata.contents) {
        NSString* extension = [[child.path pathExtension] lowercaseString];
        if (!child.isDirectory && [validExtensions indexOfObject:extension] != NSNotFound) {
            [newPhotoPaths addObject:child.path];
        }
    }
    [photoPaths release];
    photoPaths = newPhotoPaths;
    
    //NSLog(@"Paths %i",[photoPaths count]);
    
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
    //imageView.image = [UIImage imageWithContentsOfFile:destPath];
    //NSLog(@"Tried to load a thumbnail");
    [_images addObject:[UIImage imageWithContentsOfFile:destPath]];
    [self.tableView reloadData];
}

- (void)restClient:(DBRestClient*)client loadThumbnailFailedWithError:(NSError*)error {
    //[self setWorking:NO];
    //[self displayError];
}

- (void)loadRandomPhoto {
    if ([photoPaths count] == 0) {
        
        NSString *msg = nil;
        if ([DBSession sharedSession].root == kDBRootDropbox) {
            msg = @"Put .png photos in your Photos folder to use DBRoulette!";
        } else {
            msg = @"Put .png photos in your app's App folder to use DBRoulette!";
        }
        
        [[[[UIAlertView alloc] 
           initWithTitle:@"No Photos!" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]
          autorelease]
         show];
        
        //[self setWorking:NO];
    } else {        
        for(NSString *photPath in photoPaths) {
            [self.restClient loadThumbnail:photPath ofSize:@"iphone_bestfit" intoPath:[self photoPath:photPath]];
        }
        
    }
}

- (NSString*)photoPath:(NSString *)path {
    return [NSTemporaryDirectory() stringByAppendingPathComponent:path];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
