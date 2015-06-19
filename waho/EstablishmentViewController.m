//
//  EstablishmentViewController.m
//  waho
//
//  Created by José Luiz Correia Neto on 12/06/15.
//  Copyright (c) 2015 Miguel Araújo. All rights reserved.
//

#import "EstablishmentViewController.h"

@interface EstablishmentViewController ()

@end

@implementation EstablishmentViewController
@synthesize storyView, localView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)segmentValeuChanged:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
            //story
        case 0:
            self.storyView.hidden = NO;
            self.localView.hidden = YES;
            break;
            //local
        case 1:
            self.storyView.hidden = YES;
            self.localView.hidden = NO;
            break;
            
        default:
            break;
    }
}


@end
