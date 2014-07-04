//
//  VocabularyDetailViewController.m
//  VocabularyHelp
//
//  Created by xu zhuoran on 7/4/14.
//  Copyright (c) 2014 xu zhuoran. All rights reserved.
//

#import "VocabularyDetailViewController.h"
#import "VocabularyData.h"

@interface VocabularyDetailViewController ()

@end

@implementation VocabularyDetailViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)ClearButton:(id)sender
{
    VocabularyData *data=[VocabularyData getSharedInstance];
    if([data.path isEqual:@"Not Loaded"])
    {
        return;
    }
    UIAlertView* finalCheck = [[UIAlertView alloc]
                               initWithTitle:@"Clear"
                               message:@"Sure to reset all records to initial?"
                               delegate:self
                               cancelButtonTitle:@"OK"
                               otherButtonTitles:@"Cancel",nil];
    [finalCheck show];
    

}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)//ok
    {
        VocabularyData *data=[VocabularyData getSharedInstance];
        [data ResetToinitial];
        [data SavePath:data.path];
    }
    else if(buttonIndex == 1)//cacel
    {
        return;
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    VocabularyData *data=[VocabularyData getSharedInstance];
    [data Clear];
}


@end
