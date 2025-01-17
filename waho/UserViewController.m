//
//  UserViewController.m
//  waho
//
//  Created by Déborah Mesquita on 06/08/15.
//  Copyright (c) 2015 Miguel Araújo. All rights reserved.
//

#import "UserViewController.h"

@interface UserViewController ()

@end

@implementation UserViewController

@synthesize lblNome, lblEmail , lblImage, btRecomendarLocal;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PFUser *userF = [PFUser currentUser];
    //[PFUser logOut];
    if (userF) {
        [self hideLoginMessage];
        [self showUserContent];
        if ( userF[@"name"]) {
            lblNome.text = userF[@"name"];
        } else {
            lblNome.text = userF[@"username"];
        }
        
        if ( userF[@"avatar"]) {
            
            //5s
            if([[UIScreen mainScreen] bounds].size.height == 568.00){
                self.constraintImgHeight.constant = 170;
                self.constraintImgWidth.constant = 320;
            }
            //4s
            if([[UIScreen mainScreen] bounds].size.height == 480.00){
                self.constraintImgHeight.constant = 170;
                self.constraintImgWidth.constant = 320;
            }
            
            //Set image from parse
            UIImage *avatar = [[UIImage alloc] initWithData: [[userF objectForKey:@"avatar"] getData]];
            [lblImage setBackgroundImage:avatar forState:UIControlStateNormal];
        }else{
            //5s
            if([[UIScreen mainScreen] bounds].size.height == 568.00){
                self.constraintImgHeight.constant = 170;
                self.constraintImgWidth.constant = 320;
                [lblImage setBackgroundImage:[UIImage imageNamed:@"Frame usuário-câmera 4s"] forState:UIControlStateNormal];
            }
            //4s
            if([[UIScreen mainScreen] bounds].size.height == 480.00){
                self.constraintImgHeight.constant = 170;
                self.constraintImgWidth.constant = 320;
                [lblImage setBackgroundImage:[UIImage imageNamed:@"Frame usuário-câmera 4s"] forState:UIControlStateNormal];
            }
        }
        lblEmail.text = userF[@"email"];
        
    } else {
        [self showLoginMessage];
        [self hideUserContent];
    }
    
    UITabBarController *tabBarController = (UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController ;
    
    [tabBarController setDelegate:self];
    [tabBarController setSelectedIndex:2];

}

-(void)viewDidAppear:(BOOL)animated{
    
}

-(void)showUserContent{
    lblNome.hidden = NO;
    lblImage.hidden = NO;
    lblEmail.hidden = NO;
    btRecomendarLocal.hidden = NO;
}

-(void)hideUserContent{
    lblNome.hidden = YES;
    lblImage.hidden = YES;
    lblEmail.hidden = YES;
    btRecomendarLocal.hidden = YES;
}

-(void)showLoginMessage{
    self.lblLogin.hidden = NO;
    self.btLogin.hidden = NO;
}

-(void)hideLoginMessage{
    self.lblLogin.hidden = YES;
    self.btLogin.hidden = YES;
}
- (IBAction)loginButtonPressed:(id)sender {
    PFLogInViewController *logInViewController = [[MyLoginViewController alloc] init];
    [logInViewController setDelegate:self];
    
    [logInViewController setFields: PFLogInFieldsUsernameAndPassword | PFLogInFieldsPasswordForgotten | PFLogInFieldsSignUpButton | PFLogInFieldsFacebook | PFLogInFieldsDismissButton];
    
    
    PFSignUpViewController *signUpViewController = [[MySignUpViewController alloc] init];
    [signUpViewController setDelegate:self];
    
    // Assign our sign up controller to be displayed from the login controller
    [logInViewController setSignUpController:signUpViewController];
    
    [self presentViewController:logInViewController animated:YES completion:NULL];
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if (tabBarController.selectedIndex == 2){
        PFUser *userF = [PFUser currentUser];
        //[PFUser logOut];
        if (userF) {
            [self hideLoginMessage];
            [self showUserContent];
            if ( userF[@"name"]) {
                lblNome.text = userF[@"name"];
            } else {
                lblNome.text = userF[@"username"];
            }
            lblEmail.text = userF[@"email"];
        } else {
            [self showLoginMessage];
            [self hideUserContent];
        }
    }    
}

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    NSLog(@"logou eh tetraaa1");
    [self _loadData] ;
    
    /* Now that user is logged in, get his favoritedPlaces array */
    [self getFavoritedPlaces];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self viewDidLoad] ;
}

- (void) getFavoritedPlaces {
    if ([PFUser currentUser] != nil) {
        PFQuery *queryUser = [PFQuery queryWithClassName:@"Place"];
        [queryUser whereKey:@"favorites" equalTo:[[PFUser currentUser] objectId]];
        [queryUser findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                [[PlacesFromParse sharedPlacesFromParse]setFavoritedPlaces:objects];
                if([objects count] > 0){
                    NSLog(@"Lista de favoritos encontrada");
                    for (int i = 0; i < [objects count]; i++) {
                        NSLog(objects[i][@"name"]);
                    };
                }else{
                    NSLog(@"Nenhum favorito encontrado ao procurar lista de favoritos");
                }
            } else {
                NSLog(@"Error: %@", error);
            }
        }];
    } else {
        NSLog(@"Usuario nao esta logado");
    }
    
}

- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)logoffClick:(UIButton *)sender {
    [PFUser logOut];
    [self showLoginMessage];
    [self hideUserContent];
    [self logoffMessage];
}

- (IBAction)recomendarLocal:(UIButton *)sender {
    if ([MFMailComposeViewController canSendMail]){
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"dhsm@cin.ufpe.br"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
        [self presentViewController:mc animated:YES completion:NULL];
    }else{
        [self emailFail];
    }
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void) emailFail{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Eitaaa!" message:@"Você precisa estar logado no app de emails do iPhone!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

- (void) logoffMessage{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Logout" message:@"Logout efetuado com sucesso" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_loadData {
    // ...
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            
            NSString *facebookID = userData[@"id"];
            NSString *name = userData[@"name"];
            
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
            UIImage *picture = [UIImage imageWithData: [NSData dataWithContentsOfURL:pictureURL]];
            
            
            NSData *imageData = UIImagePNGRepresentation(picture);
            PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
            [imageFile saveInBackground];
            
            PFUser *user = [PFUser currentUser];
            [user setObject:imageFile forKey:@"avatar"];
            [user setObject:name forKey:@"name"] ;
            [user saveInBackground];
        }
    }];
}

- (IBAction)pickImage:(id)sender {
    UIImagePickerController *pickerLibrary = [[UIImagePickerController alloc] init];
    pickerLibrary.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickerLibrary.delegate = self;
    [self presentModalViewController:pickerLibrary animated:YES];
}


- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    NSData *myImage = UIImageJPEGRepresentation(image, 0.25);
    PFFile *imageFile = [PFFile fileWithName:@"image.png" data:myImage];
    PFUser *user = [PFUser currentUser];
    [user setObject:imageFile forKey:@"avatar"];
    [user saveInBackground];
    [picker dismissViewControllerAnimated:NO completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
