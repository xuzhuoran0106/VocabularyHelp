//
//  WatchingListTableViewController.m
//  VocabularyHelp
//
//  Created by xu zhuoran on 7/4/14.
//  Copyright (c) 2014 xu zhuoran. All rights reserved.
//

#import "WatchingListTableViewController.h"
#import "VocabularyData.h"
#import "OneWord.h"

@interface WatchingListTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *LabelKanji;
@property (weak, nonatomic) IBOutlet UILabel *LabelKatakana;
@property (weak, nonatomic) IBOutlet UILabel *LabelMeaning;
@property (weak, nonatomic) IBOutlet UILabel *LabelComment;
@property (weak, nonatomic) IBOutlet UIButton *ButtonInsert;

@property (weak, nonatomic) IBOutlet UILabel *LabelSelectedKanji;
@property (weak, nonatomic) IBOutlet UILabel *LabelSelectedKatakana;
@property (weak, nonatomic) IBOutlet UILabel *LabelSelectedMeaning;
@property (weak, nonatomic) IBOutlet UILabel *LabelSelectedComment;

@end

@implementation WatchingListTableViewController
{
     NSMutableArray *_objects;
    int _CurrentIndex;
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
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self reload];
}
-(void)reload
{
    while([_objects count]!=0)
    {
        NSString *tmp=_objects[0];
        [_objects removeObjectAtIndex:0];
        [self.tableView beginUpdates];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }
    VocabularyData *data=[VocabularyData getSharedInstance];
    int index = data.currentIndex;
    _CurrentIndex=index;
    
    _LabelSelectedKanji.text=@"";
    _LabelSelectedKatakana.text=@"";
    _LabelSelectedComment.text=@"";
    _LabelSelectedMeaning.text=@"";
    
    if (index<0)
    {
        _LabelKanji.text=@"";
        _LabelKatakana.text=@"";
        _LabelComment.text=@"";
        _LabelMeaning.text=@"";
        _ButtonInsert.enabled=false;
        
        return;
    }
    
    for (NSNumber*one in data.watchingList)
    {
        NSString* name=[self GetNameAtIndex:[one intValue]];
        [_objects addObject:one];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[_objects indexOfObject:one] inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    OneWord *one=data.data[index];
    
    if ([one.first length]==0)
    {
        _LabelKanji.text=one.second;
    }
    else
    {
        _LabelKanji.text=one.first;
    }
    _LabelKatakana.text=@"";
    if (!([one.first length]==0))
    {
        _LabelKatakana.text=one.second;
    }
    _LabelComment.text=one.comment;
    _LabelMeaning.text=one.meaning;
}
- (IBAction)InsertButton:(id)sender
{
    if (_CurrentIndex<0)
    {
        return;
    }
    VocabularyData *data=[VocabularyData getSharedInstance];
    if ([data AddToWatchingList:_CurrentIndex])
    {
        NSString* name =  [self GetNameAtIndex:_CurrentIndex];
        [_objects addObject:[NSNumber numberWithInt:_CurrentIndex]];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[_objects indexOfObject:[NSNumber numberWithInt:_CurrentIndex]] inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    if (tableView==self.tableView)
    {
        VocabularyData *data=[VocabularyData getSharedInstance];
        int index = [_objects[indexPath.row] intValue];
        OneWord * one = data.data[index];
        
        if ([one.first length]==0)
        {
            _LabelSelectedKanji.text=one.second;
        }
        else
        {
            _LabelSelectedKanji.text=one.first;
        }
        _LabelKatakana.text=@"";
        if (!([one.first length]==0))
        {
            _LabelSelectedKatakana.text=one.second;
        }
        _LabelSelectedComment.text=one.comment;
        _LabelSelectedMeaning.text=one.meaning;
    }
}
- (NSString*)GetNameAtIndex:(int)index
{
    VocabularyData *data=[VocabularyData getSharedInstance];
    OneWord * one = data.data[index];
    NSString *str=NULL;
    if ([one.first length]==0)
    {
        str=one.second;
    }
    else
    {
        str=one.first;
    }
    return str;
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
    
    NSNumber *one = _objects[indexPath.row];
    cell.textLabel.text = [self GetNameAtIndex:[one intValue]];
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
        NSNumber* index = _objects[indexPath.row];
        VocabularyData *data=[VocabularyData getSharedInstance];
        [data.watchingList removeObject:index];
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // register for keyboard notifications
    //[self reload];
    
}
@end
