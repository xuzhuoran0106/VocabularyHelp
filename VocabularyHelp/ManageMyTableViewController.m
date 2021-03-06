//
//  ManageMyTableViewController.m
//  VocabularyHelp
//
//  Created by xu zhuoran on 7/4/14.
//  Copyright (c) 2014 xu zhuoran. All rights reserved.
//

#import "ManageMyTableViewController.h"
#import "InsertNewVocMyTableViewController.h"
#import "VocabularyData.h"

@interface ManageMyTableViewController ()

@end

@implementation ManageMyTableViewController
{
    NSMutableArray *_objects;
    BOOL _messageBoxRes;
    NSString *_addNewName;
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
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    //[self reload];

}
-(void)reload
{
//    while([_objects count]!=0)
//    {
//        NSString *tmp=_objects[0];
//        [_objects removeObjectAtIndex:0];
//        [self.tableView beginUpdates];
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        [self.tableView endUpdates];
//    }
    NSMutableArray *tmpArray = [NSMutableArray array];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *dirpath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSArray * dir = [manager contentsOfDirectoryAtPath:dirpath error:nil];
    for (NSString* one in dir)
    {
        if([one hasSuffix:@"Record.xml"])
        {
            NSString* name=[one substringToIndex:[one length]-10];
            [tmpArray addObject:name];
//            if (![_objects containsObject:name])
//            {
//                [_objects addObject:name];
//                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[_objects indexOfObject:name] inSection:0];
//                //[self.tableView beginUpdates];
//                [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//                //[self.tableView endUpdates];
//            }
        }
    }
    for (NSString*one in tmpArray)
    {
        if (![_objects containsObject:one])
        {
            [_objects addObject:one];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[_objects indexOfObject:one] inSection:0];
            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }
    }
    NSMutableArray *delArray = [NSMutableArray array];
    for (NSString*one in _objects)
    {
        if (![tmpArray containsObject:one])
        {
            [delArray addObject:one];
        }
    }
    for (NSString *one in delArray)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[_objects indexOfObject:one] inSection:0];
        [_objects removeObject:one];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
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



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the row from the data source
        NSString *name = _objects[indexPath.row];
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        NSFileManager *manager = [NSFileManager defaultManager];
        NSString* xmlpath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[name stringByAppendingString:@"Record.xml"]];
        [manager removeItemAtPath:xmlpath error:nil];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        
    }
}


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
    
    
    if ([[segue identifier] isEqualToString:@"todetail"])
    {
        VocabularyData *data=[VocabularyData getSharedInstance];
        NSString *xmlpath=NULL;
        [data Clear];
        
        UITableViewCell *cell = sender;
        NSString * name = cell.textLabel.text;
        xmlpath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[name stringByAppendingString:@"Record.xml"]];
        //load
        if(![data LoadPath:xmlpath])
        {
            [data Clear];
        }
    }
}

- (IBAction)unwindToManageTable:(UIStoryboardSegue *)segue
{
    UIViewController* sourceViewController = segue.sourceViewController;
    
    if ([sourceViewController isKindOfClass:[InsertNewVocMyTableViewController class]])
    {
        NSFileManager *manager = [NSFileManager defaultManager];
        NSString *topath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[_addNewName stringByAppendingString:@"Record.xml"]];
        if ([manager fileExistsAtPath:topath])
        {
            _messageBoxRes = false;
            UIAlertView* finalCheck = [[UIAlertView alloc]
                                       initWithTitle:@"replace"
                                       message:@"replace?"
                                       delegate:self
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:@"Cancel",nil];
            //这个函数是异步的会立马返回，所以处理应该放在回调函数中。
            [finalCheck show];
        }
        else
        {
            [self addNew:_addNewName];
            //[self reload];
        }
    }
}
- (void)addNew:(NSString*)name
{
    if ([name isEqual:@""])
    {
        return;
    }
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    //NSString *name=[@"N" stringByAppendingString:[NSString stringWithFormat:@"%d",i]];
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[name stringByAppendingString:@".txt"]];
    if (![manager fileExistsAtPath:path])
    {
        return;
    }
    
    NSString *topath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[name stringByAppendingString:@"Record.xml"]];
    
    VocabularyData *data=[VocabularyData getSharedInstance];
    [data Clear];
    [data ConvertPath:path Name:name ToPath:topath];
    [data Clear];
}
- (void)nameOfNewSet:(id)newone
{
    _addNewName = newone;
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)//ok
    {
        _messageBoxRes=true;
        [self addNew:_addNewName];
        //[self reload];
    }
    else if(buttonIndex == 1)//cacel
    {
        _messageBoxRes=false;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // register for keyboard notifications
    [self reload];
    
}

@end
