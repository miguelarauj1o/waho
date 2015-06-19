//
//  MapViewController.m
//  waho
//
//  Created by Miguel Araújo on 6/15/15.
//  Copyright (c) 2015 Miguel Araújo. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController
@synthesize mapView, listEstablishmentView;

- (void)viewDidLoad {
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault]; //UIImageNamed:@"transparent.png"
    self.navigationController.navigationBar.shadowImage = [UIImage new];////UIImageNamed:@"transparent.png"
    //self.navigationController.navigationBar.translucent = YES;
    //self.navigationController.view.backgroundColor = [UIColor clearColor];
    
    [super viewDidLoad];

    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)valueChangedMap:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
            //map
        case 0:
            self.mapView.hidden = NO;
            self.listEstablishmentView.hidden = YES;
            break;
            //list establishment
        case 1:
            self.mapView.hidden = YES;
            self.listEstablishmentView.hidden = NO;
            break;
            
        default:
            break;
    }
    
}
@end
