//
//  MainMyView.m
//  VocabularyHelp
//
//  Created by xu zhuoran on 6/18/14.
//  Copyright (c) 2014 xu zhuoran. All rights reserved.
//

#import "MainMyView.h"
#import "VocabularyData.h"
@interface MainMyView ()
@property (weak, nonatomic) IBOutlet UIButton *ButtonN2;
@property (weak, nonatomic) IBOutlet UIButton *ButtonN3;
@property (weak, nonatomic) IBOutlet UIButton *ButtonN4;
@property (weak, nonatomic) IBOutlet UIButton *ButtonN5;
@property (weak, nonatomic) IBOutlet UIButton *ButtonN1;

@end

@implementation MainMyView

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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    VocabularyData *data=[VocabularyData getSharedInstance];
    NSString *xmlpath=NULL;
    [data Clear];
    if ([sender isEqual:_ButtonN2])
    {
        xmlpath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"N2Record.xml"];
    }
    if ([sender isEqual:_ButtonN3])
    {
        xmlpath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"N3Record.xml"];
    }
    if ([sender isEqual:_ButtonN4])
    {
        xmlpath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"N4Record.xml"];
    }
    if ([sender isEqual:_ButtonN5])
    {
        xmlpath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"N5Record.xml"];
    }
    if ([sender isEqual:_ButtonN1])
    {
        xmlpath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"N1Record.xml"];
    }
    //load
    if(![data LoadPath:xmlpath])
    {
        [data Clear];
    }
}
- (IBAction)COOK:(id)sender
{
    UIAlertView* finalCheck = [[UIAlertView alloc]
                               initWithTitle:@"COOK"
                               message:@"Sure to reset all records?"
                               delegate:self
                               cancelButtonTitle:@"OK"
                               otherButtonTitles:@"Cancel",nil];
    [finalCheck show];
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)//ok
    {
        for (int i=1; i<=5; i++)
        {
            NSFileManager *manager = [NSFileManager defaultManager];
            NSString *name=[@"N" stringByAppendingString:[NSString stringWithFormat:@"%d",i]];
            NSString *topath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[name stringByAppendingString:@"Record.xml"]];
            if ([manager fileExistsAtPath:topath])
            {
                [manager removeItemAtPath:topath error:nil];
            }
            NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[name stringByAppendingString:@".txt"]];
            if (![manager fileExistsAtPath:path])
            {
                path=[[NSBundle mainBundle] pathForResource:name ofType:@"txt" ];
            }
            if (![manager fileExistsAtPath:path])
            {
                continue;
            }
            VocabularyData *data=[VocabularyData getSharedInstance];
            [data Clear];
            [data ConvertPath:path Name:name ToPath:topath];
            [data Clear];
        }
    }
    else if(buttonIndex == 1)//cacel
    {
        return;
    }
}

- (IBAction)unwindToMain:(UIStoryboardSegue *)segue
{
}

@end
