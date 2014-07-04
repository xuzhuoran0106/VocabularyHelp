//
//  InsertNewVocMyTableViewController.m
//  VocabularyHelp
//
//  Created by xu zhuoran on 7/1/14.
//  Copyright (c) 2014 xu zhuoran. All rights reserved.
//

#import "InsertNewVocMyTableViewController.h"
//#import "MainMyTableViewController.h"
#import "ManageMyTableViewController.h"

@interface InsertNewVocMyTableViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *returnButton;

@end

@implementation InsertNewVocMyTableViewController
{
    NSMutableArray *_objects;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
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
    
    if (!_objects)
    {
        _objects = [[NSMutableArray alloc] init];
    }
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *dirpath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSArray * dir = [manager contentsOfDirectoryAtPath:dirpath error:nil];
    for (NSString* one in dir)
    {
        if([one hasSuffix:@".txt"])
        {
            NSString* name=[one substringToIndex:[one length]-4];
            [_objects addObject:name];
        }
    }
    for (NSString* one in _objects)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [_objects count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSString *str = _objects[indexPath.row];
    cell.textLabel.text = str;
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    //if ([[segue identifier] isEqualToString:@"addNewSet"])
    {
        NSString *name=@"";
        if ([sender isEqual:_returnButton])
        {
            name=@"";
        }
        else
        {
            UITableViewCell *cell = sender;
            name = cell.textLabel.text;
        }
        ManageMyTableViewController* ctr=[segue destinationViewController];
        [ctr nameOfNewSet:name];
        
        
    }
}

@end
