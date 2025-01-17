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
@synthesize viewPrincipal, storyView, localView, lblFavoritado, lblName, txtStory, lblQuote, place, favoritedPlaces, visitedPlaces, imgPerson, btFavoritar, btVisitei, scrollView, pictures;

- (void)changeFavButtonToSaved:(BOOL)reverse {
    if ( reverse ) {
        UIImage *bandeiraSalva = [UIImage imageNamed:@"bandeira_nao_salvo"];
        [btFavoritar setBackgroundImage:bandeiraSalva forState:UIControlStateNormal];
    } else {
        UIImage *bandeiraSalva = [UIImage imageNamed:@"bandeira_salvar"];
        [btFavoritar setBackgroundImage:bandeiraSalva forState:UIControlStateNormal];
    }
}

- (void)showEstablishmentData:(PFObject *) thisPlace {
    lblName.text = thisPlace[@"name"];
    lblQuote.text = thisPlace[@"quote"];
    txtStory.text = thisPlace[@"about"];
    NSArray *features = thisPlace[@"features"];
    int qtdFeatures = [features count];
    for(int i = 0; i < [features count]; i++){
        UILabel *label =  [[UILabel alloc] initWithFrame: CGRectMake(58, 775+(25*i), 259, 21) ];
        label.text = features[i];
        label.font = [UIFont fontWithName:@"Avenir" size:15];
        [scrollView addSubview:label];
    }
    
    UIButton *goToGoogleMaps = [UIButton buttonWithType:UIButtonTypeCustom];
    [[goToGoogleMaps imageView] setContentMode: UIViewContentModeScaleAspectFill];
    [goToGoogleMaps addTarget:self
               action:@selector(openMaps)
     forControlEvents:UIControlEventTouchUpInside];
    [goToGoogleMaps setImage:[UIImage imageNamed:@"btOpenGoogleMaps"] forState:UIControlStateNormal];
    goToGoogleMaps.frame = CGRectMake(45, 775+(25*(qtdFeatures+1)), 283, 34);
    [scrollView addSubview:goToGoogleMaps];
    
    /* Images appearing in the view */
    PFFile *imageFile = thisPlace[@"picture1"];
    imgPerson.file = imageFile;
    
    [imgPerson loadInBackground:^(UIImage *image, NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    PFFile *imageFile2 = thisPlace[@"picture2"];
    PFFile *imageFile3 = thisPlace[@"picture3"];
    pictures = @[imageFile2, imageFile3];
}

- (void)openMaps{
    PFGeoPoint * point;
    point = place[@"location"];
    double lat = point.latitude;
    double lon = point.longitude;
    NSString *urlInit = @"comgooglemaps://?daddr=";
    NSString *urlEnd = @"&directionsmode=transit";
    NSString *comma = @",";
    NSString *latString = [NSString stringWithFormat:@"%f", lat];
    NSString *lonString = [NSString stringWithFormat:@"%f", lon];
    if ([[UIApplication sharedApplication] canOpenURL:
         [NSURL URLWithString:@"comgooglemaps://"]]) {
        [[UIApplication sharedApplication] openURL:
         [NSURL URLWithString: [NSString stringWithFormat:@"%@%@%@%@%@", urlInit, latString, comma, lonString, urlEnd]]];
    } else {
        NSLog(@"Can't use comgooglemaps://");
        NSString *urlInit = @"http://maps.apple.com/?daddr=";
        NSString *comma = @",";
        [[UIApplication sharedApplication] openURL:
         [NSURL URLWithString: [NSString stringWithFormat:@"%@%@%@%@", urlInit, latString, comma,lonString]]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES]; // loading animation
    
    [self showEstablishmentData:place];
    
    //create carousel
    //_carousel = [[iCarousel alloc] initWithFrame:self.view.bounds];
    //_carousel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _carousel.type = iCarouselTypeLinear;
    _carousel.delegate = self;
    _carousel.dataSource = self;
    //_carousel.viewpointOffset = CGSizeMake(0.0f, 100.0f);
    //add carousel to view
    //[scrollView addSubview:_carousel];
    
    
    if([favoritedPlaces containsObject:place]){
        [self changeFavButtonToSaved:NO];
    }else{
        UIImage *bandeiraSalva = [UIImage imageNamed:@"bandeira_nao_salvo"];
        [btFavoritar setBackgroundImage:bandeiraSalva forState:UIControlStateNormal];
    }
    
    if([visitedPlaces containsObject:place]){
        [btVisitei setEnabled:NO];
    }
}

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    return 2;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (view == nil){
        view = [[PFImageView alloc] initWithFrame:CGRectMake(0, 0, 330.0, 200.0)];
        ((PFImageView *)view).file = pictures[index];
        [((PFImageView *)view) loadInBackground];
        view.userInteractionEnabled = YES;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button addTarget:self action:@selector(singleTapping:) forControlEvents:UIControlEventAllEvents];
        button.frame = CGRectMake(0.0, 0.0,330.0, 200.0);
        [view addSubview:button];
    }
    else
    {
        view = [[PFImageView alloc] initWithFrame:CGRectMake(0, 0, 330.0, 200.0)];
        ((PFImageView *)view).file = pictures[index];
        [((PFImageView *)view) loadInBackground];
        view.userInteractionEnabled = YES;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button addTarget:self action:@selector(singleTapping:) forControlEvents:UIControlEventAllEvents];
        button.frame = CGRectMake(0.0, 0.0, 330.0, 200.0);
        [view addSubview:button];
    }
    
    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    //label.text = [pictures[index] stringValue];

    return view;
}

-(void)singleTapping:(UIGestureRecognizer *)recognizer
{
    NSLog(@"image click");
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    if (option == iCarouselOptionSpacing)
    {
        return value * 1.1;
    }
    return value;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    
    //free up memory by releasing subviews
    self.carousel = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    CGFloat height = self.view.frame.size.height;
    NSLog(@"tamanho da tela %f",height);
    //5s
    if([[UIScreen mainScreen] bounds].size.height == 568.00){
        self.constraintTxtStoryWidth.constant = 300;
    }
    //4s
    if([[UIScreen mainScreen] bounds].size.height == 480.00){
        self.constraintTxtStoryWidth.constant = 260;
    }
    //6s
    if([[UIScreen mainScreen] bounds].size.height == 736.00){
        self.imgFaixaCurvada.image = [UIImage imageNamed:@"faixa curvada 6plus"];
        self.constraintFaixaLabelSpace.constant = 12;

    }
}

- (void)dealloc
{
    //it's a good idea to set these to nil here to avoid
    //sending messages to a deallocated viewcontroller
    //this is true even if your project is using ARC, unless
    //you are targeting iOS 5 as a minimum deployment target
    _carousel.delegate = nil;
    _carousel.dataSource = nil;
}


- (void) likePlace:(PFObject *)object{
    if([favoritedPlaces containsObject:place]){
        PFQuery *query = [PFQuery queryWithClassName:@"Place"];
        NSLog(@"%@" , place.objectId);
        [query whereKey:@"objectId" equalTo:place.objectId];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                // The find succeeded.
                // Do something with the found objects
                for (int i = 0; i <objects.count; i++) {
                    NSLog(@"ok , ne") ;
                    PFObject *event = [objects objectAtIndex:i];    // note using 'objects', not 'eventObjects'
                    [event removeObject:[[PFUser currentUser] objectId] forKey:@"favorites"];
                }
                [PFObject saveAll:objects];
                [favoritedPlaces removeObject:place] ;
                [self changeFavButtonToSaved:YES];
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    } else {
        [object addUniqueObject:[[PFUser currentUser] objectId] forKey:@"favorites"];
        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                NSLog(@"local favoritado!");
                [favoritedPlaces addObject:place];
                [self favoritedSuccess];
            } else {
                [self favoritedFail];
                NSLog(@"Error: %@", error);
            }
        }];
        
        /* Add this place to global favoritedPlaces array */
        NSMutableArray* favoritePlacesUpdated = [[PlacesFromParse sharedPlacesFromParse]favoritedPlaces];
        [favoritePlacesUpdated addObject:place];
        [[PlacesFromParse sharedPlacesFromParse]setFavoritedPlaces:favoritePlacesUpdated];
    }
}

- (IBAction)favoritarNovo:(UIButton *)sender {
    NSLog(@"hahaha");
    //[PFUser logOut];
    PFUser *userF = [PFUser currentUser];
    //[PFUser logOut];
    if (userF) {
        [self likePlace:place];
    } else {
        // show the signup or login page
        PFLogInViewController *logInViewController = [[MyLoginViewController alloc] init];
        [logInViewController setDelegate:self];
         [logInViewController setFields: PFLogInFieldsUsernameAndPassword | PFLogInFieldsPasswordForgotten | PFLogInFieldsSignUpButton | PFLogInFieldsFacebook | PFLogInFieldsDismissButton];
        [self presentViewController:logInViewController animated:YES completion:NULL];
    }
}

- (void) favoritedSuccess{
    [self changeFavButtonToSaved:NO];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sucesso!" message:@"Local favoritado com sucesso" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

- (void) favoritedFail{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ooooops!" message:@"Erro ao tentar favoritar local" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

- (IBAction)visitarNovo:(UIButton *)sender {
    PFUser *userF = [PFUser currentUser];
    if (userF) {
        //[self changeFavButtonToSaved];
        [self visitPlace:place];
    } else {
        // show the signup or login page
        PFLogInViewController *logInViewController = [[MyLoginViewController alloc] init];
        [logInViewController setDelegate:self];        
        [logInViewController setFacebookPermissions:[NSArray arrayWithObjects:@"friends_about_me", nil]];
        [logInViewController setFields: PFLogInFieldsTwitter | PFLogInFieldsFacebook | PFLogInFieldsDismissButton];
        [self presentViewController:logInViewController animated:YES completion:NULL];
    }
    
}

- (void) visitPlace:(PFObject *)object{
    [object addUniqueObject:[[PFUser currentUser] objectId] forKey:@"visited"];
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"local visitado!");
            [self visitedSuccess];
        } else {
            [self visitedFail];
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void) visitedSuccess{
    [btVisitei setEnabled:NO];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sucesso!" message:@"Local visitado!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

- (void) visitedFail{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ooooops!" message:@"Erro ao tentar visitar local" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}


- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    NSLog(@"logou eh tetraaa");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    // Check if both fields are completed
    if (username && password && username.length != 0 && password.length != 0) {
        return YES; // Begin login process
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                message:@"Make sure you fill out all of the information!"
                               delegate:nil
                      cancelButtonTitle:@"ok"
                      otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}


- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    [[[UIAlertView alloc] initWithTitle:@"Error"
                                message:@"Wrong username or password!"
                               delegate:nil
                      cancelButtonTitle:@"ok"
                      otherButtonTitles:nil] show];
    NSLog(@"Failed to log in...");
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    [signUpController setDelegate:self];
    // loop through all of the submitted data
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || field.length == 0) { // check completion
            informationComplete = NO;
            break;
        }
    }
    
    // Display an alert if a field wasn't completed
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                    message:@"Make sure you fill out all of the information!"
                                   delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil] show];
    }
    
    return informationComplete;
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self dismissModalViewControllerAnimated:YES];
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"User dismissed the signUpViewController");
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
