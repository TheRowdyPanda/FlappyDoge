//  flappyDogeDebug2.m
//  FlappyDoge_Version2
//
//  Created by Rijul Gupta on 2/11/14.
//  Copyright (c) 2014 Rijul Gupta. All rights reserved.
//

#import "flappyDogeDebug2.h"
#import <float.h>
#import <SpriteKit/SpriteKit.h>
#define   IsIphone5     ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#import <iAd/iAd.h>

@interface flappyDogeDebug2 () <SKPhysicsContactDelegate>
@property (nonatomic) SKSpriteNode * floor;
@property (nonatomic) SKSpriteNode * floor2;
@property (nonatomic) SKSpriteNode *background;
@property (nonatomic) SKSpriteNode *bottomColor;
@property (nonatomic) SKSpriteNode *doge;
@property (nonatomic) SKSpriteNode *topPipe;
@property (nonatomic) SKSpriteNode *topPipe2;
@property (nonatomic) SKSpriteNode *bottomPipe;
@property (nonatomic) SKSpriteNode *bottomPipe2;
@property (nonatomic) SKSpriteNode *scoreBoard;
@property (nonatomic) SKSpriteNode *gameOverText;
@property (nonatomic) SKSpriteNode *beginImage;

@property (nonatomic) SKSpriteNode *titleImage;


@property (nonatomic) SKLabelNode *myLabel;

@property (nonatomic) SKSpriteNode *startAgainButton;
@property (nonatomic) SKSpriteNode *leaderboardButton;



@property (nonatomic) SKSpriteNode *medal;


@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;

@property int screenChanger;


@end

static const uint32_t floorCategory     =  0x1 << 0;
static const uint32_t pipeCategory        =  0x1 << 1;
static const uint32_t dogeCategory        =  0x1 << 5;

@implementation flappyDogeDebug2
@synthesize currentLeaderBoard;
NSArray * _dogeFrames;
BOOL inJump;
int score = 0;
int scoreToSend = 0;
bool endGame = FALSE;
bool gameHasStarted = FALSE;
bool postEndGame = false;
SKLabelNode *largerLabel;
SKLabelNode *bestScore;
SKLabelNode *bestScoreShadow;

//I can't fucking use dogJumpDuration. Why? Obviously because
/*
 duplicate symbol _dogJumpDuration in:
 /Users/rijulgupta/Library/Developer/Xcode/DerivedData/FlappyDoge_Version2-clpooshgdciuzlcxjphemgainzmi/Build/Intermediates/FlappyDoge_Version2.build/Debug-iphonesimulator/FlappyDoge_Version2.build/Objects-normal/i386/MyScene.o
 /Users/rijulgupta/Library/Developer/Xcode/DerivedData/FlappyDoge_Version2-clpooshgdciuzlcxjphemgainzmi/Build/Intermediates/FlappyDoge_Version2.build/Debug-iphonesimulator/FlappyDoge_Version2.build/Objects-normal/i386/flappyDogeDebug2.o
 ld: 1 duplicate symbol for architecture i386
 clang: error: linker command failed with exit code 1 (use -v to see invocation)
 
 
 This is the only variable that caused the error
 
 Solution:
    The variable name was used in another scene. Use @property
 */

/*NOTES
 What if you don't die when you hit a pipe, your score just resets.... You try and get it as high as you can.
 
 Maybe you could get pushed back. When you hit the left wall - you die.
 */
double dogJumpDuration_debug = 0.25;

//GAME CENTER GAME CENTER GAME CENTER


//@implementation ViewController


/*thorwing into initWithsize
- (void)viewDidLoad
{
    currentLeaderBoard=@"GHS";
    [[GameCenterFiles sharedInstance] authenticateLocalUser];
    
    [super viewDidLoad];
}
*/

/*restartGame
- (IBAction)resetButtonPressed:(id)sender {
    self.gameCenterManager = [[GameCenterFiles alloc] init] ;
    [self.gameCenterManager resetAchievements];
}
 
 */
/*

- (IBAction)gameOverButtonPressed:(id)sender {
    
    self.gameCenterManager = [[GameCenterFiles alloc] init] ;
    
    [self.gameCenterManager setDelegate:self];
    
    [self.gameCenterManager reportScore: score forCategory: self.currentLeaderBoard];
    NSString* identifier = NULL;
    int percentComplete;
    if(score>= achievementLevel1){
        identifier=@"Level1";
        percentComplete=100;
    }
    if(identifier!= NULL)
        
    {
        [self.gameCenterManager submitAchievement: identifier percentComplete: percentComplete];
    }
}


- (IBAction)showGameCenterButtonPressed:(id)sender {
    {
        
        GKLeaderboardViewController *leaderboardViewController = [[GKLeaderboardViewController alloc] init];
        if (leaderboardViewController != NULL)
        {
            leaderboardViewController.category = self.currentLeaderBoard;
            leaderboardViewController.timeScope = GKLeaderboardTimeScopeWeek;
            leaderboardViewController.leaderboardDelegate = self;
            [self presentViewController: leaderboardViewController animated: YES completion:nil];
        }
    }
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
    NSLog(@"in leaderboardControllerDidFinish");
    [self dismissViewControllerAnimated: YES completion:nil];
}



@end


//GAME CENTER GAME CENTER GAME CENTER
*/


-(void)beginGame{
    
    [_beginImage removeFromParent];
    [_titleImage removeFromParent];
    
     [self generatePipes:5];

}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
       // self.presentedViewController.canDisplayBannerAds = YES;
        
       // int xMul =(self.size.width/320);
       // int yMul = self.size.height/
        _screenChanger = 480;
        if(IsIphone5)
        {
            //your stuff
            self.background = [SKSpriteNode spriteNodeWithImageNamed:@"backgroundForFive"];
            
            self.background.size = CGSizeMake(344, 568 + 6);
            self.background.position = CGPointMake(172, (568 + 6)/2);
            NSLog(@"Using the 5");
            _screenChanger = 568;
            

        }
        else
        {
            //your stuff
            self.background = [SKSpriteNode spriteNodeWithImageNamed:@"background.gif"];
            
            self.background.size = CGSizeMake(344*(self.size.width/320), 486*(self.size.height/_screenChanger));
            self.background.position = CGPointMake(172*(self.size.width/320), 243*(self.size.height/_screenChanger));
            NSLog(@"Using the 3.5 inch");
            _screenChanger = 480;
        }


    

        gameHasStarted = false;
        endGame = false;
        postEndGame = false;
        //score = 43;
        score = 0;
        //set background scene

        self.background.zPosition = 0;
        [self addChild:self.background];
        
        

    
        //set floor variable
        self.floor = [SKSpriteNode spriteNodeWithImageNamed:@"floorLong.png"];
        self.floor.size = CGSizeMake(340*(self.size.width/320), 12*(self.size.height/_screenChanger));
        self.floor.position = CGPointMake(170*(self.size.width/320), 51*(self.size.height/_screenChanger));
        self.floor.zPosition = 2;
        [self addChild:self.floor];
        _floor.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_floor.size]; // 1
        _floor.physicsBody.dynamic = NO;
        _floor.physicsBody.categoryBitMask = floorCategory; // 3
        _floor.physicsBody.contactTestBitMask = dogeCategory; // 4
        _floor.physicsBody.collisionBitMask = dogeCategory;
        
        self.floor2 = [SKSpriteNode spriteNodeWithImageNamed:@"floorLong.png"];
        self.floor2.size = CGSizeMake(340*(self.size.width/320), 12*(self.size.height/_screenChanger));
        self.floor2.position = CGPointMake(510*(self.size.width/320), 51*(self.size.height/_screenChanger));
        self.floor2.zPosition = 2;
        [self addChild:self.floor2];
        _floor2.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_floor2.size]; // 1
        _floor2.physicsBody.dynamic = NO;
        _floor2.physicsBody.categoryBitMask = floorCategory; // 3
        _floor2.physicsBody.contactTestBitMask = dogeCategory; // 4
        _floor2.physicsBody.collisionBitMask = dogeCategory;
        
        
        self.bottomColor = [SKSpriteNode spriteNodeWithImageNamed:@"bottomColor"];
        self.bottomColor.size = CGSizeMake(340*(self.size.width/320), 46*(self.size.height/_screenChanger));
        self.bottomColor.position = CGPointMake(170*(self.size.width/320), 23*(self.size.height/_screenChanger));
        self.bottomColor.zPosition = 2;
        [self addChild:self.bottomColor];
        
        NSMutableArray *walkFrames = [NSMutableArray array];
        SKTextureAtlas *dogeAnimatedAtlas = [SKTextureAtlas atlasNamed:@"DogeImages"];
        
        int numImages = dogeAnimatedAtlas.textureNames.count;
        for (int i=1; i <= numImages; i++) {
            NSString *textureName = [NSString stringWithFormat:@"dogeFlap%d", i];
            SKTexture *temp = [dogeAnimatedAtlas textureNamed:textureName];
            [walkFrames addObject:temp];
        }
        _dogeFrames = walkFrames;
        
        SKTexture *temp = _dogeFrames[0];
        _doge = [SKSpriteNode spriteNodeWithTexture:temp];
        self.doge.size = CGSizeMake(36*(self.size.width/320), 25*(self.size.height/_screenChanger));
        _doge.position = CGPointMake(100*(self.size.width/320), 300*(self.size.height/_screenChanger));
        [self addChild:_doge];
        
        [self flappingDoge];
        //set doge
        _doge.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_doge.size]; // 1
        _doge.physicsBody.dynamic = YES; // 2
        _doge.physicsBody.categoryBitMask = dogeCategory; // 3
        _doge.physicsBody.contactTestBitMask = pipeCategory; // 4
        _doge.physicsBody.collisionBitMask = pipeCategory;
        _doge.physicsBody.collisionBitMask = floorCategory;
        _doge.physicsBody.velocity = CGVectorMake(0, 0);
        _doge.physicsBody.linearDamping = 1;
        _doge.zPosition = 8;
        
        // _doge.physicsBody.usesPreciseCollisionDetection = YES;
        

        _topPipe.position = CGPointMake(500*(self.size.width/320), 0*(self.size.height/_screenChanger));
        _topPipe2.position = CGPointMake(1000*(self.size.width/320), 0*(self.size.height/_screenChanger));

        
        //DOGE VELOCITY
        
     
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        
        
        
        self.physicsWorld.contactDelegate = self;
        
       // [self generatePipes:5];
        [self generateFloor2];
        
        self.myLabel = [SKLabelNode labelNodeWithFontNamed:@"04b_19"];
        
        _myLabel.fontSize = 34*(self.size.height/_screenChanger);
        [self addChild:_myLabel];
        _myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                        CGRectGetMidY(self.frame) + 150*(self.size.height/_screenChanger));
        _myLabel.zPosition = 12;
        

        largerLabel = [SKLabelNode labelNodeWithFontNamed:@"04b_19"];

        largerLabel.fontColor = [UIColor blackColor];
        largerLabel.fontSize = 34*(self.size.height/_screenChanger);
        largerLabel.position = CGPointMake(_myLabel.position.x + 3,
                                        _myLabel.position.y - 3);
        
        
        [self addChild:largerLabel];
        
        largerLabel.zPosition = 11;
        
        _scoreBoard = [SKSpriteNode spriteNodeWithImageNamed:@"scoreBoard"];
        _scoreBoard.size = CGSizeMake(280*(self.size.width/320), 140*(self.size.height/_screenChanger));
        _scoreBoard.position = CGPointMake(CGRectGetMidX(self.frame), -300*(self.size.height/_screenChanger));
        _scoreBoard.zPosition = 11;

        
        
        bestScoreShadow = [SKLabelNode  labelNodeWithFontNamed:@"04b_19"];
        bestScoreShadow.fontColor = [UIColor blackColor];
        bestScoreShadow.fontSize = 28*(self.size.height/_screenChanger);
        bestScoreShadow.position = CGPointMake(CGRectGetMidX(self.frame) + (90 + 3)*(self.size.width/320), (-500 - 50 - 3)*(self.size.height/_screenChanger));
        bestScoreShadow.zPosition = 11;

        bestScore = [SKLabelNode labelNodeWithFontNamed:@"04b_19"];
        bestScore.fontColor = [UIColor whiteColor];
        bestScore.fontSize = 28*(self.size.height/_screenChanger);
        bestScore.position = CGPointMake(CGRectGetMidX(self.frame) + (90)*(self.size.width/320), (-500 - 50)*(self.size.height/_screenChanger));
        bestScore.zPosition = 12;
 
        
        _gameOverText = [SKSpriteNode spriteNodeWithImageNamed:@"loseText"];
        _gameOverText.size = CGSizeMake(240*(self.size.width/320), 53*(self.size.height/_screenChanger));
        _gameOverText.position = CGPointMake(CGRectGetMidX(self.frame), 600*(self.size.height/_screenChanger));
        _gameOverText.zPosition = 12;

        //Set up animation of doge
        
        //  SKAction * rotate = [SKAction rotateToAngle:(M_PI_2)*(60./360.) duration:.01];
        // [_doge runAction:rotate];
    
    
    self.startAgainButton = [SKSpriteNode spriteNodeWithImageNamed:@"playAgainButton"];
    
    self.startAgainButton.size = CGSizeMake(130*(self.size.width/320), 70*(self.size.height/_screenChanger));
        self.startAgainButton.name = @"startAgainButtonNode";
    self.startAgainButton.position = CGPointMake((20 + 130/2)*(self.size.width/320), -300*(self.size.height/_screenChanger));
    self.startAgainButton.zPosition = 12;
    
        
        self.leaderboardButton = [SKSpriteNode spriteNodeWithImageNamed:@"leadboardImage"];
        
        self.leaderboardButton.size = CGSizeMake(130*(self.size.width/320), 70*(self.size.height/_screenChanger));
        self.leaderboardButton.name = @"leaderboardButtonNode";
        self.leaderboardButton.position = CGPointMake((20 + 20 + 130/2 + 130)*(self.size.width/320), -300*(self.size.height/_screenChanger));
        self.leaderboardButton.zPosition = 12;
    
    self.beginImage = [SKSpriteNode spriteNodeWithImageNamed:@"beginImage"];
    self.beginImage.size = CGSizeMake(170*(self.size.width/320), 123*(self.size.height/_screenChanger));
    self.beginImage.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    self.beginImage.zPosition = 6;
    
    [self addChild:_beginImage];

        
      //  self.titleImage = [SKSpriteNode spriteNodeWithImageNamed:@"flappyShibeTitleImage"];
          self.titleImage = [SKSpriteNode spriteNodeWithImageNamed:@"titleImage"];

        self.titleImage.size = CGSizeMake(235*(self.size.width/320), 60*(self.size.height/_screenChanger));
        self.titleImage.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 150*(self.size.height/_screenChanger));
        self.titleImage.zPosition = 6;
        
        [self addChild:_titleImage];

        
        
        self.medal = [SKSpriteNode spriteNodeWithImageNamed:@"medalBronzeDoge"];
        
        self.medal.size = CGSizeMake(56*(self.size.width/320), 56*(self.size.height/_screenChanger));
        self.medal.position = CGPointMake(80*(self.size.width/320), 240*(self.size.height/_screenChanger));
        self.medal.zPosition = 20;
        
        

      //  [self addChild:_medal];

        
        
        adMobinterstitial_ = [[GADInterstitial alloc] init];
        
        adMobinterstitial_.adUnitID = @"ca-app-pub-4658531991803126/1478669697";
        [adMobinterstitial_ setDelegate:self];
        
        

    }
    return self;

}

-(void)flappingDoge{
    //This is our general runAction method to make our bear walk.
    [_doge runAction:[SKAction repeatActionForever:
                      [SKAction animateWithTextures:_dogeFrames
                                       timePerFrame:0.1f
                                             resize:NO
                                            restore:YES]] withKey:@""];
    
    
    return;
}

-(void)dogeJump{
    
    //DOGE JUMP HEIGHT
   // inJump = NO;
    if(endGame == false){
        [self runAction:[SKAction playSoundFileNamed:@"rope_swinging_swish_2.mp3" waitForCompletion:NO]];

    int dogeFallSpeed = -150;
    
    _doge.physicsBody.velocity = CGVectorMake(0, 0);
    double duration = dogJumpDuration_debug;
    

    [_doge removeAllActions];
    [self flappingDoge];
    SKAction * actionMoveUp = [SKAction moveTo:CGPointMake(_doge.position.x, _doge.position.y+40*(self.size.height/_screenChanger)) duration:duration];
        
        
    SKAction *rotate = [SKAction rotateToAngle:((M_PI_2)*(150/360.)) duration:(duration*1)];
    SKAction *groupAction = [SKAction group:@[actionMoveUp, rotate]];

    SKAction * actionMoveDown = [SKAction moveTo:CGPointMake(_doge.position.x, _doge.position.y) duration:duration*1];
    //SKAction *rotateSlightly = [SKAction rotateToAngle:((M_PI_2)*(0/360.)) duration:(duration)];

    SKAction *groupAction2 = actionMoveDown;// [SKAction group:@[actionMoveDown, rotateSlightly]];

    SKAction *setVelocity = [SKAction moveTo:CGPointMake(_doge.position.x, dogeFallSpeed) duration:1];
    double durationDown = .2;
    SKAction * rotateDown = [SKAction rotateToAngle:(M_PI_2)*(-360/360.) duration:durationDown];
    SKAction *groupAction3 = [SKAction group:@[setVelocity, rotateDown]];


    
    [_doge runAction:[SKAction sequence:@[groupAction, groupAction2, groupAction3]]];
    
    
    
    //#NSTimer, #Method with Delay, #Timerfix
    
   // [self jumpFinished:inJump];

    }
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        
        CGPoint location = [touch locationInNode:self];

        int yHeight = 480*(self.size.height/_screenChanger) - location.y;
        SKSpriteNode *node = (SKSpriteNode *)[self nodeAtPoint:location];
        
        if([node.name isEqualToString:@"fbNode"]){
            [self facebook];
            [self runAction:[SKAction playSoundFileNamed:@"clickButton.wav" waitForCompletion:NO]];

        }
        if([node.name isEqualToString:@"twNode"]){
            [self twitter];
            [self runAction:[SKAction playSoundFileNamed:@"clickButton.wav" waitForCompletion:NO]];

        }
        if([node.name isEqualToString:@"rpNode"]){
            [self rpButton];
            [self runAction:[SKAction playSoundFileNamed:@"clickButton.wav" waitForCompletion:NO]];

        }
        if([node.name isEqualToString:@"revmobNode"]){
          [self revmob];
            [self runAction:[SKAction playSoundFileNamed:@"clickButton.wav" waitForCompletion:NO]];

        }
        
        if(IsIphone5){
            yHeight = yHeight + 88;
        }
            [self dogeJump];
        
        if(gameHasStarted == false){
            [self beginGame];
            gameHasStarted = true;
        }
        if(postEndGame == true){
            [self addScore:score];
          //  }
            if([node.name isEqualToString:@"startAgainButtonNode"]){
                


                [self restartGame];
            }
        if([node.name isEqualToString:@"leaderboardButtonNode"]){

            NSLog(@"SLKDJFLSKFJLSKF");
//            
//         
//            GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
//                [localPlayer authenticateWithCompletionHandler:^(NSError *error) {
//                    if (localPlayer.isAuthenticated)
//                    {
//                        
//                            GKScore* score2= [[GKScore alloc] initWithLeaderboardIdentifier:self.currentLeaderBoard];
//                            score2.value = scoreToSend;
//                            [GKScore reportScores:@[score2] withCompletionHandler:^(NSError *error) {
//                                if (error) {
//                                    // handle error
//                                }
//                            }];
//                        
//
//                        GKGameCenterViewController* gameCenterController = [[GKGameCenterViewController alloc] init];
//                        gameCenterController.viewState = GKGameCenterViewControllerStateLeaderboards;
//                        gameCenterController.gameCenterDelegate = self;
//                        
//            
//                        UIViewController *vc = self.view.window.rootViewController;
//                        [vc presentViewController:gameCenterController animated:YES completion:nil];
//                        // Player was successfully authenticated.
//                        // Perform additional tasks for the authenticated player.
//                    }
//                }];
//      
//              
               // [leaderboardController release];
            
            
            GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
            
            
            [localPlayer authenticateWithCompletionHandler:^(NSError *error) {
                if (localPlayer.isAuthenticated)
                {
                    
                    currentLeaderBoard = @"highScore";
                    GKScore* score2= [[GKScore alloc] initWithLeaderboardIdentifier:self.currentLeaderBoard];
                    score2.value = scoreToSend;
                    [GKScore reportScores:@[score2] withCompletionHandler:^(NSError *error) {
                        if (error) {
                            // handle error
                        }
                    }];
                    
                    
                    GKGameCenterViewController* gameCenterController = [[GKGameCenterViewController alloc] init];
                    gameCenterController.viewState = GKGameCenterViewControllerStateLeaderboards;
                    gameCenterController.gameCenterDelegate = self;
                    
                    
                    UIViewController *vc = self.view.window.rootViewController;
                    [vc presentViewController:gameCenterController animated:YES completion:nil];
                    // Player was successfully authenticated.
                    // Perform additional tasks for the authenticated player.
                }
            }];
            
            
            }




        }

    }
    //  _doge.physicsBody.velocity = CGVectorMake(0, -400);
    
}

-(void)restartGame{
    
    /*
    @property (nonatomic) SKSpriteNode *background;
    @property (nonatomic) SKSpriteNode *bottomColor;
    @property (nonatomic) SKSpriteNode *doge;
    @property (nonatomic) SKSpriteNode *topPipe;
    @property (nonatomic) SKSpriteNode *topPipe2;
    @property (nonatomic) SKSpriteNode *bottomPipe;
    @property (nonatomic) SKSpriteNode *bottomPipe2;
    @property (nonatomic) SKSpriteNode *scoreBoard;
    @property (nonatomic) SKSpriteNode *gameOverText;
    @property (nonatomic) SKSpriteNode *beginImage;
    
    */

    [_floor removeFromParent];
    [_floor2 removeFromParent];
    //[_background removeFromParent];
   // [_bottomColor removeFromParent];
  //  [_doge removeFromParent];
    //[_topPipe removeFromParent];
    //[_topPipe2 removeFromParent];
   // [_bottomPipe removeFromParent];
 //   [_bottomPipe2 removeFromParent];
 //   [_scoreBoard removeFromParent];
    [_myLabel removeFromParent];
    [largerLabel removeFromParent];
    [_startAgainButton removeFromParent];
    [_leaderboardButton removeFromParent];
    SKScene *restartScene = [[flappyDogeDebug2 alloc] initWithSize:self.size];
    SKTransition *transition = [SKTransition doorsOpenHorizontalWithDuration:0.5];
    [self.view presentScene:restartScene transition:transition];
    
    }
-(void)generatePipes:(int)previousPipeHeight{
    //130px between pipes
    //190 px per second
    if(endGame == FALSE)
    {
    double pipeSpeed = 2.7;
        double delayInSeconds = (190/450.)*pipeSpeed;
    //set top pipe sprite
    //maximum height is 40px below top screen which is y = 615
    //min height is 140px above bottom screen which is 340px below top screen  which is y = 315
    
    //scratch those - min height should be determined by the minimum height the bottom one can be which is -50
    int pipeHeight = arc4random()%22;
    
    int topPipeXValue = pipeHeight*10+ 400;
    
            self.topPipe = [SKSpriteNode spriteNodeWithImageNamed:@"topPipe.png"];
            self.topPipe.size = CGSizeMake(65*(self.size.width/320), 350*(self.size.height/_screenChanger));
            self.topPipe.position = CGPointMake(400*(self.size.width/320), topPipeXValue*(self.size.height/_screenChanger));
            self.topPipe.zPosition = 1;
            [self addChild:self.topPipe];
            _topPipe.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_topPipe.size]; // 1
            _topPipe.physicsBody.categoryBitMask = pipeCategory; // 3
            _topPipe.physicsBody.contactTestBitMask = dogeCategory; // 4
            _topPipe.physicsBody.collisionBitMask = 0;
            
            //the bottomPipe height is 100px below that of the end of the top pipe
            //y max = 265 y min = -35 y = pipeHeight - 350
            self.bottomPipe = [SKSpriteNode spriteNodeWithImageNamed:@"bottomPipe.png"];
            self.bottomPipe.size = CGSizeMake(65*(self.size.width/320), 350*(self.size.height/_screenChanger));
        if(score < 10){
            self.bottomPipe.position = CGPointMake(400*(self.size.width/320), (topPipeXValue - 480)*(self.size.height/_screenChanger));
        }
        else if(score >= 10 && score < 20){
            self.bottomPipe.position = CGPointMake(400*(self.size.width/320), (topPipeXValue - 475)*(self.size.height/_screenChanger));
        }
        else if(score >= 20 && score < 30){
            self.bottomPipe.position = CGPointMake(400*(self.size.width/320), (topPipeXValue - 470)*(self.size.height/_screenChanger));
        }
        else if(score >= 30 && score < 40){
            self.bottomPipe.position = CGPointMake(400*(self.size.width/320), (topPipeXValue - 465)*(self.size.height/_screenChanger));
        }
        else if(score >= 40 && score < 50){
            self.bottomPipe.position = CGPointMake(400*(self.size.width/320), (topPipeXValue - 460)*(self.size.height/_screenChanger));
        }
        else if(score >= 50){
            self.bottomPipe.position = CGPointMake(400*(self.size.width/320), (topPipeXValue - 450)*(self.size.height/_screenChanger));
        }
            [self addChild:self.bottomPipe];
            _bottomPipe.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_bottomPipe.size]; // 1
            
            _bottomPipe.physicsBody.categoryBitMask = pipeCategory; // 3
            _bottomPipe.physicsBody.contactTestBitMask = dogeCategory; // 4
            _bottomPipe.physicsBody.collisionBitMask = 0;
            
            
            SKAction * actionMoveTop = [SKAction moveTo:CGPointMake(-50*(self.size.width/320), _topPipe.position.y) duration:pipeSpeed];
            SKAction * actionMoveBottom = [SKAction moveTo:CGPointMake(-50*(self.size.width/320), _bottomPipe.position.y) duration:pipeSpeed];
            
           // SKAction * actionMoveDone = [SKAction removeFromParent];
            
            SKAction * actionMoveDone = [SKAction removeFromParent];
            
            [_topPipe runAction:[SKAction sequence:@[actionMoveTop, actionMoveDone]]];
            [_bottomPipe runAction:[SKAction sequence:@[actionMoveBottom, actionMoveDone]]];
            
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                //code to be executed on the main queue after delay
             
                if(endGame == false){
                    [self generatePipes2:previousPipeHeight];

                }

            });
        }
        
    
        // [self performSelectorOnMainThread:@selector(newPipeNeeded:) withObject:previousPipeHeight waitUntilDone:YES];
        /*
         SEL sel = @selector(newPipeNeeded:);
         
         NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:sel];
         NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
         invocation.selector = sel;
         // note that the first argument has index 2!
         [invocation setArgument:&previousPipeHeight atIndex:2];
         */
        // with delay
    //  [self performSelector:@selector(newPipeNeeded:) withObject:previousPipeHeight afterDelay:0.1];
    
    //[self generatePipes:(int*) previousPipeHeight];
    
    /*
     [NSTimer scheduledTimerWithTimeInterval:1
     target:self
     selector:@selector(newPipeNeeded:)
     userInfo:@"previousPipeHeight"
     repeats:NO];
     
     
     */
    //[self generatePipes:previousPipeHeight withDelay:1.0];
    
    
    //#NSTimer, #Method with Delay, #Timerfix
    
    double delayInSeconds2 = 1.55;
    dispatch_time_t popTime2 = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds2 * NSEC_PER_SEC);
    dispatch_after(popTime2, dispatch_get_main_queue(), ^(void){
        //code to be executed on the main queue after delay
        if(endGame == false){

        [self updateScore];
        }
    });
    
   // [self updateScore];
    // [self generatePipes:previousPipeHeight2 withDelay:1.0];
    
    

}

    


-(void)generatePipes2:(int)previousPipeHeight{
    if(endGame == FALSE)
    {
        double pipeSpeed = 2.7;
        double delayInSeconds = (190/450.)*pipeSpeed;
        //set top pipe sprite
        //maximum height is 40px below top screen which is y = 615
        //min height is 140px above bottom screen which is 340px below top screen  which is y = 315
        
        //scratch those - min height should be determined by the minimum height the bottom one can be which is -50
        int pipeHeight = arc4random()%22;
        int topPipeXValue = pipeHeight*10+ 400;
        
        

        
    
        self.topPipe2 = [SKSpriteNode spriteNodeWithImageNamed:@"topPipe.png"];
        self.topPipe2.size = CGSizeMake(65*(self.size.width/320), 350*(self.size.height/_screenChanger));
        self.topPipe2.position = CGPointMake(400*(self.size.width/320), topPipeXValue*(self.size.height/_screenChanger));
        self.topPipe2.zPosition = 1;
        [self addChild:self.topPipe2];
        _topPipe2.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_topPipe2.size]; // 1
        _topPipe2.physicsBody.categoryBitMask = pipeCategory; // 3
        _topPipe2.physicsBody.contactTestBitMask = dogeCategory; // 4
        _topPipe2.physicsBody.collisionBitMask = 0;
        
        //the bottomPipe2 height is 100px below that of the end of the top Pipe2
        //y max = 265 y min = -35 y = Pipe2Height - 350
        self.bottomPipe2 = [SKSpriteNode spriteNodeWithImageNamed:@"bottomPipe.png"];
        self.bottomPipe2.size = CGSizeMake(65*(self.size.width/320), 350*(self.size.height/_screenChanger));
        if(score < 10){
            self.bottomPipe2.position = CGPointMake(400*(self.size.width/320), (topPipeXValue - 480)*(self.size.height/_screenChanger));
        }
        else if(score >= 10 && score < 20){
            self.bottomPipe2.position = CGPointMake(400*(self.size.width/320), (topPipeXValue - 475)*(self.size.height/_screenChanger));
        }
        else if(score >= 20 && score < 30){
            self.bottomPipe2.position = CGPointMake(400*(self.size.width/320), (topPipeXValue - 470)*(self.size.height/_screenChanger));
        }
        else if(score >= 30 && score < 40){
            self.bottomPipe2.position = CGPointMake(400*(self.size.width/320), (topPipeXValue - 465)*(self.size.height/_screenChanger));
        }
        else if(score >= 40 && score < 50){
            self.bottomPipe2.position = CGPointMake(400*(self.size.width/320), (topPipeXValue - 460)*(self.size.height/_screenChanger));
        }
        else if(score >= 50){
            self.bottomPipe2.position = CGPointMake(400*(self.size.width/320), (topPipeXValue - 450)*(self.size.height/_screenChanger));
        }
        
        [self addChild:self.bottomPipe2];
        _bottomPipe2.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_bottomPipe2.size]; // 1
        
        _bottomPipe2.physicsBody.categoryBitMask = pipeCategory; // 3
        _bottomPipe2.physicsBody.contactTestBitMask = dogeCategory; // 4
        _bottomPipe2.physicsBody.collisionBitMask = 0;
        
        
        SKAction * actionMoveTop = [SKAction moveTo:CGPointMake(-50*(self.size.width/320), _topPipe2.position.y) duration:pipeSpeed];
        SKAction * actionMoveBottom = [SKAction moveTo:CGPointMake(-50*(self.size.width/320), _bottomPipe2.position.y) duration:pipeSpeed];
        
        SKAction * actionMoveDone = [SKAction removeFromParent];
        
        [_topPipe2 runAction:[SKAction sequence:@[actionMoveTop, actionMoveDone]]];
        [_bottomPipe2 runAction:[SKAction sequence:@[actionMoveBottom, actionMoveDone]]];
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            //code to be executed on the main queue after delay
            
            if(endGame == false){
                [self generatePipes:previousPipeHeight];
            }
            
            
            
        }
                       );
    
        double delayInSeconds2 = 1.55;
        dispatch_time_t popTime2 = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds2 * NSEC_PER_SEC);
        dispatch_after(popTime2, dispatch_get_main_queue(), ^(void){
            //code to be executed on the main queue after delay
            if(endGame == false){
                
                [self updateScore];
            }
        });
        
    }

}
-(void)updateScore{

    [_myLabel removeFromParent];
    [largerLabel removeFromParent];

    score = score + 1;
    _myLabel.text = [NSString stringWithFormat:@"%d", score];

    largerLabel.text = [NSString stringWithFormat:@"%d", score];
    [self addChild:_myLabel];
    [self addChild:largerLabel];
    [self runAction:[SKAction playSoundFileNamed:@"addPoint.wav" waitForCompletion:NO]];

    

    
}

-(void)generateFloor{
    
    if(endGame == FALSE)
    {
    double duration = 1.813;
    SKAction * reset = [SKAction moveTo:CGPointMake(510*(self.size.width/320), _floor.position.y) duration:.001];
    SKAction * actionMove = [SKAction moveTo:CGPointMake(170*(self.size.width/320), _floor.position.y) duration:duration];
    SKAction * actionMove2 = [SKAction moveTo:CGPointMake(-170*(self.size.width/320), _floor2.position.y) duration:duration];
    
    // SKAction * actionMoveDone = [SKAction removeFromParent];
    
    [_floor runAction:[SKAction sequence:@[reset, actionMove]]];
    [_floor2 runAction:actionMove2];
    
    
    [NSTimer scheduledTimerWithTimeInterval:duration + 0.001
                                     target:self
                                   selector:@selector(generateFloor2)
                                   userInfo:nil
                                    repeats:NO];
    }
}

-(void)generateFloor2{
    
    if(endGame == FALSE)
    {
    double duration = 1.813;
    
    SKAction * reset = [SKAction moveTo:CGPointMake(510*(self.size.width/320), _floor2.position.y) duration:.001 ];
    SKAction * actionMove = [SKAction moveTo:CGPointMake(-170*(self.size.width/320), _floor.position.y) duration:duration];
    SKAction * actionMove2 = [SKAction moveTo:CGPointMake(170*(self.size.width/320), _floor2.position.y) duration:duration];
    
    // SKAction * actionMoveDone = [SKAction removeFromParent];
    
    [_floor runAction:actionMove];
    [_floor2 runAction:[SKAction sequence:@[reset, actionMove2]]];
    
    
    
    [NSTimer scheduledTimerWithTimeInterval:duration + 0.001
                                     target:self
                                   selector:@selector(generateFloor)
                                   userInfo:nil
                                    repeats:NO];
    
    }
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    // 1
    SKPhysicsBody *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    // 2
    if ((firstBody.categoryBitMask & floorCategory) != 0 &&
        (secondBody.categoryBitMask & dogeCategory) != 0)
    {
        [_doge removeAllActions];
    }
    if ((firstBody.categoryBitMask & pipeCategory) != 0 &&
        (secondBody.categoryBitMask & dogeCategory) != 0)
    {
        [self shakeEmUp];
        [self endGame];

    }
    
}

-(void)endGame{
    [self runAction:[SKAction playSoundFileNamed:@"deathSound.wav" waitForCompletion:NO]];


    scoreToSend = score;

    double flashScreenTime = 1.00;

    endGame = TRUE;
    [_topPipe removeAllActions];
    [_topPipe2 removeAllActions];

    [_bottomPipe removeAllActions];
    [_bottomPipe2 removeAllActions];

    [_floor removeAllActions];
    [_floor2 removeAllActions];

    SKSpriteNode * flashScreen;
    if(IsIphone5){
        flashScreen = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(340*(self.size.width/320), 568*(self.size.height/_screenChanger))];
    }
    else{
        flashScreen = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(340*(self.size.width/320), 480*(self.size.height/_screenChanger))];
    }
    flashScreen.position = CGPointMake(170*(self.size.width/320), flashScreen.size.height/2);
    
    [flashScreen runAction:[SKAction sequence:@[[SKAction fadeAlphaTo:0.0 duration:1], [SKAction removeFromParent]]]];

    flashScreen.zPosition = 10;
    [self addChild:flashScreen];
    
    [_myLabel runAction:[SKAction removeFromParent]];
    [largerLabel runAction:[SKAction removeFromParent]];

    _doge.physicsBody.contactTestBitMask = floorCategory;
    _topPipe.physicsBody.categoryBitMask = 0;
    _topPipe2.physicsBody.categoryBitMask = 0;
    _bottomPipe.physicsBody.categoryBitMask = 0;
    _bottomPipe2.physicsBody.categoryBitMask = 0;

    //[_doge runAction:[SKAction sequence:@[pushUp, backDown, allTheWayDown]]];;
    
 //   [_doge runAction:[SKAction moveTo:CGPointMake(_doge.position.x, 60) duration:.3]];

    dispatch_time_t popTime2 = dispatch_time(DISPATCH_TIME_NOW, flashScreenTime * NSEC_PER_SEC);
    dispatch_after(popTime2, dispatch_get_main_queue(), ^(void){
        //code to be executed on the main queue after delay
            [self postEndGame];
    });
    
    
    
}


//This method is fucking sick. Use this all the time.
-(void)shakeEmUp{
    
    int times = 4;
    CGPoint initialPoint = self.position;
    NSInteger amplitudeX = 4;
    NSInteger amplitudeY = 4;
    NSMutableArray * randomActions = [NSMutableArray array];
    for (int i=0; i<times; i++) {
        NSInteger randX = self.position.x+arc4random() % amplitudeX - amplitudeX/2;
        NSInteger randY = self.position.y+arc4random() % amplitudeY - amplitudeY/2;
        SKAction *action = [SKAction moveTo:CGPointMake(randX, randY) duration:0.01];
        [randomActions addObject:action];
    }
    
    SKAction *rep = [SKAction sequence:randomActions];
    
    [self runAction:rep completion:^{
        self.position = initialPoint;
    }];
    

}

-(void)postEndGame{
    
    
//    *********▄**************▄****
//    ********▌@█***********▄#@▌***
//    ********▌@@█********▄#@@@▐***
//    *******▐▄#@@####▄▄▄#@@@@@▐***
//    *****▄▄#@*@@@@@@@@@█@@▄█@▐***
//    ***▄#@@@***@@@***@@@#██#@▌***
//    **▐@@@▄▄@@@@***@@@@@@@#▄@@▌**
//    **▌**▌█#@@@@@▄#█▄@@@@@@@█@▐**
//    *▐***@@@@@@@@▌██#@@***@@@#▄▌*
//    *▌*@▄██▄@@@@@@@@@******@@@@▌*
//    #@#▐▄█▄█▌▄*#@@**********@@@▐*
//    ▐@@▐#▐#@*▄▄@▄@@@@@@*@*@*@@@@▌
//    ▐@@@##▄▄@@@▄@@@@@@@@*@*@*@@▐*
//    *▌@@@@@@###@@@@@@*@*@*@*@@@▌*
//    *▐@@@@@@@@@@@@@@*@*@*@@▄@@▐**
//    **#▄@@@@@@@@@@@*@*@*@▄@@@@▌**
//    ****#▄@@@@@@@@@@▄▄▄#@@@@▄#***
//    ******#▄▄▄▄▄▄###@@@@@▄▄#*****
//    *********@@@@@@@@@@##********
//    
    int spaceAdjuster  = 0;
    if(IsIphone5){
        
    }
    else{
         spaceAdjuster  = 75;

    }
    postEndGame = true;
    double speed = 0.7;
    int yHeight = 250;
    [self addChild:_scoreBoard];
    [self addChild:bestScore];
    [self addChild:bestScoreShadow];
    [self addChild:_gameOverText];
    
    _myLabel.fontSize = 28*(self.size.height/_screenChanger);
    _myLabel.position = CGPointMake(CGRectGetMidX(self.frame) + 90*(self.size.width/320), (-500 + 10)*(self.size.height/_screenChanger));
    
    largerLabel.fontSize = 28*(self.size.height/_screenChanger);
    largerLabel.position = CGPointMake(CGRectGetMidX(self.frame) + (90 + 3)*(self.size.width/320), (-500 + 10 - 3)*(self.size.height/_screenChanger));
    
    [self addChild:_myLabel];
    [self addChild:largerLabel];
    
    _myLabel.text = [NSString stringWithFormat:@"0"];
    largerLabel.text = [NSString stringWithFormat:@"0"];

    NSInteger lastHighScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"high_score"];

    bestScore.text = [NSString stringWithFormat:@"%d", lastHighScore];
    bestScoreShadow.text = [NSString stringWithFormat:@"%d", lastHighScore];

    
    [_scoreBoard runAction:[SKAction moveTo:CGPointMake(_scoreBoard.position.x, yHeight*(self.size.height/_screenChanger)) duration:speed]];
    

    [_startAgainButton runAction:[SKAction moveTo:CGPointMake(_startAgainButton.position.x, (51 + 40)*(self.size.height/_screenChanger)) duration:0.1]];
    [_leaderboardButton runAction:[SKAction moveTo:CGPointMake(_leaderboardButton.position.x, (51 + 40)*(self.size.height/_screenChanger)) duration:0.1]];
    [bestScore runAction:[SKAction moveTo:CGPointMake(_scoreBoard.position.x + 90*(self.size.width/320), (yHeight - 50)*(self.size.height/_screenChanger)) duration:speed]];
    [bestScoreShadow runAction:[SKAction moveTo:CGPointMake(_scoreBoard.position.x + (90 + 3)*(self.size.width/320), (yHeight - 50 - 3)*(self.size.height/_screenChanger)) duration:speed]];
    [_myLabel runAction:[SKAction moveTo:CGPointMake(_scoreBoard.position.x + 90*(self.size.width/320), (yHeight + 5)*(self.size.height/_screenChanger)) duration:speed]];
    [largerLabel runAction:[SKAction moveTo:CGPointMake(_scoreBoard.position.x + (90 + 3)*(self.size.width/320), (yHeight + 5 - 3)*(self.size.height/_screenChanger)) duration:speed]];
    [_gameOverText runAction:[SKAction moveTo:CGPointMake(_gameOverText.position.x, 370*(self.size.height/_screenChanger)) duration:speed]];

    
    int squareSize = 50;
    int spaceSize = (self.size.width - squareSize*4)/5;
    
    SKSpriteNode *fb = [SKSpriteNode spriteNodeWithImageNamed:@"facebook_128"];
    fb.size = CGSizeMake(50*(self.size.height/_screenChanger), 50*(self.size.height/_screenChanger));
    fb.position = CGPointMake(self.size.width*1/4 - 40*(self.size.width/320), self.size.height + (80 + spaceAdjuster)*(self.size.height/_screenChanger));
    [self addChild:fb];
    fb.name = @"fbNode";
    fb.zPosition = 100;
    [fb runAction:[SKAction moveByX:0 y:-200*(self.size.height/_screenChanger) duration:0.5]];
    
    
    SKSpriteNode *tw = [SKSpriteNode spriteNodeWithImageNamed:@"twitter_128"];
    tw.size = CGSizeMake(50*(self.size.height/_screenChanger), 50*(self.size.height/_screenChanger));
    tw.position = CGPointMake(self.size.width*2/4- 40*(self.size.width/320), self.size.height + (80 + spaceAdjuster)*(self.size.height/_screenChanger));
    [self addChild:tw];
    tw.name = @"twNode";
    tw.zPosition = 100;
    [tw runAction:[SKAction moveByX:0 y:-200*(self.size.height/_screenChanger) duration:0.5]];
    
    SKSpriteNode *rp = [SKSpriteNode spriteNodeWithImageNamed:@"squarePandaButton_small"];
    rp.size = CGSizeMake(50*(self.size.height/_screenChanger), 50*(self.size.height/_screenChanger));
    
    rp.position = CGPointMake(self.size.width*3/4- 40*(self.size.width/320), self.size.height + (80 + spaceAdjuster)*(self.size.height/_screenChanger));
    [self addChild:rp];
    rp.name = @"rpNode";
    rp.zPosition = 100;
    [rp runAction:[SKAction moveByX:0 y:-200*(self.size.height/_screenChanger) duration:0.5]];
    
    SKSpriteNode *revmob = [SKSpriteNode spriteNodeWithImageNamed:@"revmob"];
    revmob.size = CGSizeMake(50*(self.size.height/_screenChanger), 50*(self.size.height/_screenChanger));
    revmob.position = CGPointMake(self.size.width*4/4 - 40*(self.size.width/320), self.size.height + (80 + spaceAdjuster)*(self.size.height/_screenChanger));
    [self addChild:revmob];
    revmob.name = @"revmobNode";
    revmob.zPosition = 100;
    [revmob runAction:[SKAction moveByX:0 y:-200*(self.size.height/_screenChanger) duration:0.5]];
    
    
    dispatch_time_t popTime2 = dispatch_time(DISPATCH_TIME_NOW, speed * NSEC_PER_SEC);
    dispatch_after(popTime2, dispatch_get_main_queue(), ^(void){
        //code to be executed on the main queue after delay
       [self addScore:0];
    });
    
}

-(void)addScore:(int)previousInt{

    if(previousInt < score){
        [self runAction:[SKAction playSoundFileNamed:@"addTotalPoints.wav" waitForCompletion:NO]];
    }

    int bronzeMedal = 40;
    int silverMedal = 75;
    int goldMedal = 100;

    if(endGame == true){
        
        if(previousInt == bronzeMedal){
            
            self.medal = [SKSpriteNode spriteNodeWithImageNamed:@"medalBronzeDoge"];
            
            self.medal.size = CGSizeMake(56*(self.size.height/_screenChanger), 56*(self.size.height/_screenChanger));
            self.medal.position = CGPointMake(80*(self.size.width/320), 240*(self.size.height/_screenChanger));
            self.medal.zPosition = 20;
            
            [self addChild:_medal];
            [self runAction:[SKAction playSoundFileNamed:@"getMedal.wav" waitForCompletion:NO]];


        }
        if(previousInt == silverMedal){
          //  [_medal removeFromParent];
          //  self.medal.zPosition = 20;
           // [self addChild:_medal];
            [_medal removeFromParent];
            self.medal = [SKSpriteNode spriteNodeWithImageNamed:@"medalSilverDoge"];
            
            self.medal.size = CGSizeMake(56*(self.size.height/_screenChanger), 56*(self.size.height/_screenChanger));
            self.medal.position = CGPointMake(80*(self.size.width/320), 240*(self.size.height/_screenChanger));
            self.medal.zPosition = 20;
            
            [self addChild:_medal];
            [self runAction:[SKAction playSoundFileNamed:@"getMedal.wav" waitForCompletion:NO]];


        }
        if(previousInt == goldMedal){
            [_medal removeFromParent];
            self.medal = [SKSpriteNode spriteNodeWithImageNamed:@"medalGoldDoge"];
            
            self.medal.size = CGSizeMake(56*(self.size.height/_screenChanger), 56*(self.size.height/_screenChanger));
            self.medal.position = CGPointMake(80*(self.size.width/320), 240*(self.size.height/_screenChanger));
            self.medal.zPosition = 20;
            
            [self addChild:_medal];
            [self runAction:[SKAction playSoundFileNamed:@"getMedal.wav" waitForCompletion:NO]];


        }
        
        if(score >= 0){
            if(previousInt < score){
                
                
                dispatch_time_t popTime2 = dispatch_time(DISPATCH_TIME_NOW, 0.05 * NSEC_PER_SEC);
                dispatch_after(popTime2, dispatch_get_main_queue(), ^(void){
                    //code to be executed on the main queue after delay
                    
                    [self addScore:previousInt + 1];
                });
            }
            
            _myLabel.text = [NSString stringWithFormat:@"%d", previousInt];
            largerLabel.text = [NSString stringWithFormat:@"%d", previousInt];
            if(previousInt == score)
            {
                if(previousInt >= bronzeMedal && previousInt < silverMedal){
                    
                    self.medal = [SKSpriteNode spriteNodeWithImageNamed:@"medalBronzeDoge"];
                    
                    self.medal.size = CGSizeMake(56*(self.size.height/_screenChanger), 56*(self.size.height/_screenChanger));
                    self.medal.position = CGPointMake(80*(self.size.width/320), 240*(self.size.height/_screenChanger));
                    self.medal.zPosition = 20;
                    
                    [self addChild:_medal];
                    
                }
                if(previousInt >= silverMedal && previousInt < goldMedal){
                    //  [_medal removeFromParent];
                    //  self.medal.zPosition = 20;
                    // [self addChild:_medal];
                    [_medal removeFromParent];
                    self.medal = [SKSpriteNode spriteNodeWithImageNamed:@"medalSilverDoge"];
                    
                    self.medal.size = CGSizeMake(56*(self.size.height/_screenChanger), 56*(self.size.height/_screenChanger));
                    self.medal.position = CGPointMake(80*(self.size.width/320), 240*(self.size.height/_screenChanger));
                    self.medal.zPosition = 20;
                    
                    [self addChild:_medal];
                    
                }
                if(previousInt >= goldMedal){
                    [_medal removeFromParent];
                    self.medal = [SKSpriteNode spriteNodeWithImageNamed:@"medalGoldDoge"];
                    
                    self.medal.size = CGSizeMake(56*(self.size.height/_screenChanger), 56*(self.size.height/_screenChanger));
                    self.medal.position = CGPointMake(80*(self.size.width/320), 240*(self.size.height/_screenChanger));
                    self.medal.zPosition = 20;
                    
                    [self addChild:_medal];
                    
                }
                
                NSInteger lastHighScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"high_score"];
              //  int lastHighScore2 = lastHighScore;
                if(lastHighScore < score){
                    
                    
                    
                    SKSpriteNode *newHighScore = [SKSpriteNode spriteNodeWithImageNamed:@"newHighScore"];
                    newHighScore.size = CGSizeMake(30*(self.size.width/320), 13*(self.size.height/_screenChanger));
                    newHighScore.position = CGPointMake(_myLabel.position.x - 40*(self.size.width/320), _myLabel.position.y - 15*(self.size.height/_screenChanger));
                    newHighScore.zPosition = 20;
                    [self addChild:newHighScore];
                    
                    bestScore.text = [NSString stringWithFormat:@"%d", score];
                    bestScoreShadow.text = [NSString stringWithFormat:@"%d", score];
                    
                    
                    [[NSUserDefaults standardUserDefaults] setInteger:score forKey:@"high_score"];
                }
                else{
                    bestScore.text = [NSString stringWithFormat:@"%d", lastHighScore];
                    bestScoreShadow.text = [NSString stringWithFormat:@"%d", lastHighScore];
                    
                }
                
                [self addChild:_startAgainButton];
                [self addChild:_leaderboardButton];
                _myLabel.text = [NSString stringWithFormat:@"%d", previousInt];
                largerLabel.text = [NSString stringWithFormat:@"%d", previousInt];
                score = -1;
                NSLog(@"restartButtonCalled");
            }
            
            
            
        }
    }
    
    
    
    
    
    
}







-(void)revmob{
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"There IS NO internet connection");
        SKView * skView = (SKView *)self.view;
        //  skView.showsFPS = YES;
        //  skView.showsNodeCount = YES;
        
        // Create and configure the scene.
        //   SKScene * scene = [MyScene sceneWithSize:skView.bounds.size];
        // SKScene * scene = [MyScene2 sceneWithSize:skView.bounds.size];
        //SKScene * scene = [MyScene sceneWithSize:skView.bounds.size];
        
        
        
     //   scene.scaleMode = SKSceneScaleModeAspectFill;
    //    [skView presentScene:scene];
   
    } else {
        NSLog(@"There IS internet connection");
        
        
        RevMobFullscreen *ad = [[RevMobAds session] fullscreen]; // you must retain this object
        [ad loadWithSuccessHandler:^(RevMobFullscreen *fs) {
            [fs showAd];
            NSLog(@"Ad loaded");
         //   [self doVolumeFadeOut:_themePlayer];
            
        } andLoadFailHandler:^(RevMobFullscreen *fs, NSError *error) {
            NSLog(@"Ad error: %@",error);
            [adMobinterstitial_ loadRequest:request];
            
        } onClickHandler:^{
            NSLog(@"Ad clicked");
        } onCloseHandler:^{
            NSLog(@"Ad closed");
            /*
            
            SKView * skView = (SKView *)self.view;
            //  skView.showsFPS = YES;
            //  skView.showsNodeCount = YES;
            
            // Create and configure the scene.
            //   SKScene * scene = [MyScene sceneWithSize:skView.bounds.size];
            // SKScene * scene = [MyScene2 sceneWithSize:skView.bounds.size];
            SKScene * scene = [MyScene sceneWithSize:skView.bounds.size];
            
            
            
            scene.scaleMode = SKSceneScaleModeAspectFill;
            [skView presentScene:scene];
            */
          //  [self restartGame];
        }];
        
        
        //    [[RevMobAds session] showFullscreen];
        
        
    }
    
}


//Google admob


- (void)interstitialDidReceiveAd:(GADInterstitial *)ad{
    
    
    
    [adMobinterstitial_ presentFromRootViewController:self.view.window.rootViewController];
    
    
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)ad{
    
    // SKView * skView = (SKView *)self.view;
    // skView.showsFPS = YES;
    // skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    /*
     SKScene * scene = [choosePlayer sceneWithSize:skView.bounds.size];      scene.scaleMode = SKSceneScaleModeAspectFill;
     [skView presentScene:scene];
     */
    

    
}


-(void)interstitialWillPresentScreen:(GADInterstitial *)ad{
    

}
-(void)interstitialWillDismissScreen:(GADInterstitial *)ad{
    
}

-(void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error{
    
  //  [self interstitialDidDismissScreen:ad];
}




-(void)facebook{
    
    
    // Check if the Facebook app is installed and we can present the share dialog
    FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
    params.picture = [NSURL URLWithString:@"http://www.imgur.com/7mPSzdL.png"];
    params.link = [NSURL URLWithString:@"www.appstore.com/flappydogeflappyflyer"];
    params.caption = @"From Rowdy Panda Games";
        NSString *descriptString = [NSString stringWithFormat:@"Wow. Such Flappy. %d Much Score. Wow.", [_myLabel.text intValue]];
    params.linkDescription = descriptString;
    params.name = @"Flappy Doge";
    
    NSURL *appUrl = [NSURL URLWithString:@"http://www.appstore.com/flappydogeflappyflyer"];
    NSURL *picUrl = [NSURL URLWithString:@"http://www.imgur.com/7mPSzdL.png"];
    // If the Facebook app is installed and we can present the share dialog
    if ([FBDialogs canPresentShareDialogWithParams:params]) {
        // Present share dialog
        
    //    NSURL *url = [NSURL URLWithString:@"http://www.google.com"];
        /*
        [FBDialogs presentShareDialogWithLink:appUrl
                                      handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                          if(error) {
                                              // An error occurred, we need to handle the error
                                              // See: https://developers.facebook.com/docs/ios/errors
                                              NSLog(@"Error publishing story: %@", error.description);
                                          } else {
                                              // Success
                                              NSLog(@"result %@", results);
                                          }
                                      }];
         */
        NSDictionary *clientState = [NSDictionary dictionary];
        [FBDialogs presentShareDialogWithLink:appUrl name:params.name caption:params.caption description:descriptString picture:picUrl clientState:clientState handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
            if(error) {
                // An error occurred, we need to handle the error
                // See: https://developers.facebook.com/docs/ios/errors
                NSLog(@"Error publishing story: %@", error.description);
            } else {
                // Success
                NSLog(@"result %@", results);
            }
        }];
        
        
        
    } else {
        
        // Present the feed dialog
        
        // Put together the dialog parameters
        NSString *descriptString = [NSString stringWithFormat:@"Wow. Such Flappy. %d Much Score. Wow.", [_myLabel.text intValue]];
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"Flappy Doge", @"name",
                                       @"From Rowdy Panda Games", @"caption",
                                       descriptString, @"description",
                                       @"http://www.appstore.com/flappydogeflappyflyer", @"link",
                                       @"http://imgur.com/7mPSzdL", @"picture",
                                       nil];
        
        // Show the feed dialog
        [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                               parameters:params
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      if (error) {
                                                          // An error occurred, we need to handle the error
                                                          // See: https://developers.facebook.com/docs/ios/errors
                                                          NSLog(@"Error publishing story: %@", error.description);
                                                      } else {
                                                          if (result == FBWebDialogResultDialogNotCompleted) {
                                                              // User cancelled.
                                                              NSLog(@"User cancelled.");
                                                          } else {
                                                              // Handle the publish feed callback
                                                              NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                              
                                                              if (![urlParams valueForKey:@"post_id"]) {
                                                                  // User cancelled.
                                                                  NSLog(@"User cancelled.");
                                                                  
                                                              } else {
                                                                  // User clicked the Share button
                                                                  NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                                  NSLog(@"result %@", result);
                                                              }
                                                          }
                                                      }
                                                  }];
        
        
    }

    
}

// A function for parsing URL parameters returned by the Feed Dialog.
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}




-(void)twitter{
    
    //  Create an instance of the Tweet Sheet
    SLComposeViewController *tweetSheet = [SLComposeViewController
                                           composeViewControllerForServiceType:
                                           SLServiceTypeTwitter];
    
    // Sets the completion handler.  Note that we don't know which thread the
    // block will be called on, so we need to ensure that any required UI
    // updates occur on the main queue
    tweetSheet.completionHandler = ^(SLComposeViewControllerResult result) {
        switch(result) {
                //  This means the user cancelled without sending the Tweet
            case SLComposeViewControllerResultCancelled:
                break;
                //  This means the user hit 'Send'
            case SLComposeViewControllerResultDone:
                break;
        }
    };
    
    //  Set the initial body of the Tweet
    int score = 10;
    NSString *initialTextString = [NSString stringWithFormat:@"  Wow.     \n\n      Such Flappy.   \n\n      %d    \n  Much Score.\n\n          Wow.\n\n@TheRowdyPanda", [_myLabel.text intValue]];
    [tweetSheet setInitialText:initialTextString];
    
    //  Add an URL to the Tweet.  You can add multiple URLs.
    if (![tweetSheet addURL:[NSURL URLWithString:@"http://www.appstore.com/flappydogeflappyflyer"]]){
        NSLog(@"Unable to add the URL!");
    }
    
    //  Adds an image to the Tweet.  For demo purposes, assume we have an
    //  image named 'larry.png' that we wish to attach
    if (![tweetSheet addImage:[UIImage imageNamed:@"Icon.png"]]) {
        NSLog(@"Unable to add the image!");
    }
    
    
    
    //  Presents the Tweet Sheet to the user
    UIViewController *vc = self.view.window.rootViewController;

    [vc presentViewController:tweetSheet animated:NO completion:^{
        NSLog(@"Tweet sheet has been presented.");
    }];

}

-(void)rpButton{
    
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.appstore.com/crappybirds"]];
        

    
}
-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    /*
     // Handle time delta.
     // If we drop below 60fps, we still want everything to move the same distance.
     CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
     self.lastUpdateTimeInterval = currentTime;
     if (timeSinceLast > 1) { // more than a second since last update
     timeSinceLast = 1.0 / 60.0;
     self.lastUpdateTimeInterval = currentTime;
     }
     
     // [self updateWithTimeSinceLastUpdate:timeSinceLast];
     
     */
}


-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];

}


@end