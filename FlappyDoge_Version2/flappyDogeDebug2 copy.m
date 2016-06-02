//  flappyDogeDebug2.m
//  FlappyDoge_Version2
//
//  Created by Rijul Gupta on 2/11/14.
//  Copyright (c) 2014 Rijul Gupta. All rights reserved.
//

#import "flappyDogeDebug2.h"
#import <float.h>
#import <SpriteKit/SpriteKit.h>
#import <GameKit/GameKit.h>
//#import "GameCenterFiles.h"
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

@property (nonatomic) SKLabelNode *myLabel;

@property (nonatomic) SKSpriteNode *startAgainButton;
@property (nonatomic) SKSpriteNode *leaderboardButton;


@property (nonatomic) SKSpriteNode *ESPNgameCenter;

@property (nonatomic) SKSpriteNode *medal;


@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;



@end

static const uint32_t floorCategory     =  0x1 << 0;
static const uint32_t pipeCategory        =  0x1 << 1;
static const uint32_t dogeCategory        =  0x1 << 5;

@implementation flappyDogeDebug2
NSArray * _dogeFrames;
BOOL inJump;
int score = 0;
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
     [self generatePipes:5];

}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
       // self.presentedViewController.canDisplayBannerAds = YES;
        if(IsIphone5)
        {
            //your stuff
            self.background = [SKSpriteNode spriteNodeWithImageNamed:@"backgroundForFive"];
            
            self.background.size = CGSizeMake(344, 568 + 6);
            self.background.position = CGPointMake(172, (568 + 6)/2);
            NSLog(@"Using the 5");
            

        }
        else
        {
            //your stuff
            self.background = [SKSpriteNode spriteNodeWithImageNamed:@"background.gif"];
            
            self.background.size = CGSizeMake(344, 486);
            self.background.position = CGPointMake(172, 243);
            NSLog(@"Using the 3.5 inch");
        }

    

        gameHasStarted = false;
        endGame = false;
        postEndGame = false;
        score = 43;
       // score = 0;
        //set background scene

        self.background.zPosition = 0;
        [self addChild:self.background];
        
        

    
        //set floor variable
        self.floor = [SKSpriteNode spriteNodeWithImageNamed:@"floorLong.png"];
        self.floor.size = CGSizeMake(340, 12);
        self.floor.position = CGPointMake(170, 51);
        self.floor.zPosition = 2;
        [self addChild:self.floor];
        _floor.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_floor.size]; // 1
        _floor.physicsBody.dynamic = NO;
        _floor.physicsBody.categoryBitMask = floorCategory; // 3
        _floor.physicsBody.contactTestBitMask = dogeCategory; // 4
        _floor.physicsBody.collisionBitMask = dogeCategory;
        
        self.floor2 = [SKSpriteNode spriteNodeWithImageNamed:@"floorLong.png"];
        self.floor2.size = CGSizeMake(340, 12);
        self.floor2.position = CGPointMake(510, 51);
        self.floor2.zPosition = 2;
        [self addChild:self.floor2];
        _floor2.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_floor2.size]; // 1
        _floor2.physicsBody.dynamic = NO;
        _floor2.physicsBody.categoryBitMask = floorCategory; // 3
        _floor2.physicsBody.contactTestBitMask = dogeCategory; // 4
        _floor2.physicsBody.collisionBitMask = dogeCategory;
        
        
        self.bottomColor = [SKSpriteNode spriteNodeWithImageNamed:@"bottomColor"];
        self.bottomColor.size = CGSizeMake(340, 46);
        self.bottomColor.position = CGPointMake(170, 23);
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
        self.doge.size = CGSizeMake(36, 25);
        _doge.position = CGPointMake(100, 300);
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
        

        _topPipe.position = CGPointMake(500, 0);
        _topPipe2.position = CGPointMake(1000, 0);

        
        //DOGE VELOCITY
        
     
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        
        
        
        self.physicsWorld.contactDelegate = self;
        
       // [self generatePipes:5];
        [self generateFloor2];
        
        self.myLabel = [SKLabelNode labelNodeWithFontNamed:@"04b_19"];
        
        _myLabel.fontSize = 34;
        [self addChild:_myLabel];
        _myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                        CGRectGetMidY(self.frame) + 150);
        _myLabel.zPosition = 12;
        

        largerLabel = [SKLabelNode labelNodeWithFontNamed:@"04b_19"];

        largerLabel.fontColor = [UIColor blackColor];
        largerLabel.fontSize = 34;
        largerLabel.position = CGPointMake(_myLabel.position.x + 3,
                                        _myLabel.position.y - 3);
        
        
        [self addChild:largerLabel];
        
        largerLabel.zPosition = 11;
        
        _scoreBoard = [SKSpriteNode spriteNodeWithImageNamed:@"scoreBoard"];
        _scoreBoard.size = CGSizeMake(280, 140);
        _scoreBoard.position = CGPointMake(CGRectGetMidX(self.frame), -300);
        _scoreBoard.zPosition = 11;

        
        
        bestScoreShadow = [SKLabelNode  labelNodeWithFontNamed:@"04b_19"];
        bestScoreShadow.fontColor = [UIColor blackColor];
        bestScoreShadow.fontSize = 28;
        bestScoreShadow.position = CGPointMake(CGRectGetMidX(self.frame) + 90 + 3, -500 - 50 - 3);
        bestScoreShadow.zPosition = 11;

        bestScore = [SKLabelNode labelNodeWithFontNamed:@"04b_19"];
        bestScore.fontColor = [UIColor whiteColor];
        bestScore.fontSize = 28;
        bestScore.position = CGPointMake(CGRectGetMidX(self.frame) + 90, -500 - 50);
        bestScore.zPosition = 12;
 
        
        _gameOverText = [SKSpriteNode spriteNodeWithImageNamed:@"loseText"];
        _gameOverText.size = CGSizeMake(240, 53);
        _gameOverText.position = CGPointMake(CGRectGetMidX(self.frame), 600);
        _gameOverText.zPosition = 12;

        //Set up animation of doge
        
        //  SKAction * rotate = [SKAction rotateToAngle:(M_PI_2)*(60./360.) duration:.01];
        // [_doge runAction:rotate];
    
    
    self.startAgainButton = [SKSpriteNode spriteNodeWithImageNamed:@"playAgainButton"];
    
    self.startAgainButton.size = CGSizeMake(130, 70);
    self.startAgainButton.position = CGPointMake(20 + 130/2, -300);
    self.startAgainButton.zPosition = 12;
    
        
        self.leaderboardButton = [SKSpriteNode spriteNodeWithImageNamed:@"leadboardImage"];
        
        self.leaderboardButton.size = CGSizeMake(130, 70);
        self.leaderboardButton.position = CGPointMake(20 + 20 + 130/2 + 130, -300);
        self.leaderboardButton.zPosition = 12;
    
    self.beginImage = [SKSpriteNode spriteNodeWithImageNamed:@"beginImage"];
    self.beginImage.size = CGSizeMake(170, 123);
    self.beginImage.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    self.beginImage.zPosition = 6;
    
    [self addChild:_beginImage];

        self.medal = [SKSpriteNode spriteNodeWithImageNamed:@"medalBronzeDoge"];
        
        self.medal.size = CGSizeMake(56, 56);
        self.medal.position = CGPointMake(80, 240);
        self.medal.zPosition = 20;
        
        
        self.ESPNgameCenter = [SKSpriteNode spriteNodeWithImageNamed:@"playAgainButton"];
        
        self.ESPNgameCenter.size = CGSizeMake(30, 30);
        self.ESPNgameCenter.position = CGPointMake(20 + 130/2, 400);
        self.ESPNgameCenter.zPosition = 12;
      //  [self addChild:_medal];


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
    SKAction * actionMoveUp = [SKAction moveTo:CGPointMake(_doge.position.x, _doge.position.y+60) duration:duration];
        
        
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
        
        CGPoint location = [touch locationInView:nil];

        int yHeight = 480 - location.y;
        
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
            if(abs(location.x - _startAgainButton.position.x) < 100 && abs(yHeight - _startAgainButton.position.y) < 50){
                [self restartGame];
            }
            if(abs(location.x - _leaderboardButton.position.x) < 100 && abs(yHeight - _leaderboardButton.position.y) < 50){
             //   [self restartGame];
                /*
                    GKLeaderboardViewController *leaderboardViewController = [[GKLeaderboardViewController alloc] init];
                    if (leaderboardViewController != NULL)
                    {
                        id appDelegate = [[UIApplication sharedApplication] delegate];

                        leaderboardViewController.category = self.currentLeaderBoard;
                        leaderboardViewController.timeScope = GKLeaderboardTimeScopeWeek;
                      //  leaderboardViewController.leaderboardDelegate = appDelegate.GameCenterFiles;
                        leaderboardViewController.leaderboardDelegate =
                      //  [self presentViewController: leaderboardViewController animated: YES completion:nil];
                       [appDelegate.GameCenterFiles presentModalViewController:leaderboardViewController animated:YES];

                    }
                */
                /*
                GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
                if (leaderboardController != NULL)
                {
                        leaderboardController.category = self.currentLeaderBoard;
                    leaderboardController.timeScope = GKLeaderboardTimeScopeAllTime;
                    leaderboardController.leaderboardDelegate = self;
                
                UIViewController *vc = self.view.window.rootViewController;
                [vc presentViewController: leaderboardController animated: YES completion:nil];
                }
                 */
                GKGameCenterViewController* gameCenterController = [[GKGameCenterViewController alloc] init];
                gameCenterController.viewState = GKGameCenterViewControllerStateLeaderboards;
                gameCenterController.gameCenterDelegate = self;
                UIViewController *vc = self.view.window.rootViewController;
                [vc presentViewController:gameCenterController animated:YES completion:nil];
               // [leaderboardController release];
            }

            if(abs(location.x - _ESPNgameCenter.position.x) < 100 && abs(yHeight - _ESPNgameCenter.position.y) < 50){
                //   [self restartGame];
                NSLog(@"leaderboard YO!");
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
    
    self.gameCenterManager = [[GameCenterFiles alloc] init] ;
    [self.gameCenterManager resetAchievements];
    
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
            self.topPipe.size = CGSizeMake(65, 350);
            self.topPipe.position = CGPointMake(400, topPipeXValue);
            self.topPipe.zPosition = 1;
            [self addChild:self.topPipe];
            _topPipe.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_topPipe.size]; // 1
            _topPipe.physicsBody.categoryBitMask = pipeCategory; // 3
            _topPipe.physicsBody.contactTestBitMask = dogeCategory; // 4
            _topPipe.physicsBody.collisionBitMask = 0;
            
            //the bottomPipe height is 100px below that of the end of the top pipe
            //y max = 265 y min = -35 y = pipeHeight - 350
            self.bottomPipe = [SKSpriteNode spriteNodeWithImageNamed:@"bottomPipe.png"];
            self.bottomPipe.size = CGSizeMake(65, 350);
            self.bottomPipe.position = CGPointMake(400, topPipeXValue - 460);
            [self addChild:self.bottomPipe];
            _bottomPipe.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_bottomPipe.size]; // 1
            
            _bottomPipe.physicsBody.categoryBitMask = pipeCategory; // 3
            _bottomPipe.physicsBody.contactTestBitMask = dogeCategory; // 4
            _bottomPipe.physicsBody.collisionBitMask = 0;
            
            
            SKAction * actionMoveTop = [SKAction moveTo:CGPointMake(-50, _topPipe.position.y) duration:pipeSpeed];
            SKAction * actionMoveBottom = [SKAction moveTo:CGPointMake(-50, _bottomPipe.position.y) duration:pipeSpeed];
            
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
        self.topPipe2.size = CGSizeMake(65, 350);
        self.topPipe2.position = CGPointMake(400, topPipeXValue);
        self.topPipe2.zPosition = 1;
        [self addChild:self.topPipe2];
        _topPipe2.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_topPipe2.size]; // 1
        _topPipe2.physicsBody.categoryBitMask = pipeCategory; // 3
        _topPipe2.physicsBody.contactTestBitMask = dogeCategory; // 4
        _topPipe2.physicsBody.collisionBitMask = 0;
        
        //the bottomPipe2 height is 100px below that of the end of the top Pipe2
        //y max = 265 y min = -35 y = Pipe2Height - 350
        self.bottomPipe2 = [SKSpriteNode spriteNodeWithImageNamed:@"bottomPipe.png"];
        self.bottomPipe2.size = CGSizeMake(65, 350);
        self.bottomPipe2.position = CGPointMake(400, topPipeXValue - 460);
        [self addChild:self.bottomPipe2];
        _bottomPipe2.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_bottomPipe2.size]; // 1
        
        _bottomPipe2.physicsBody.categoryBitMask = pipeCategory; // 3
        _bottomPipe2.physicsBody.contactTestBitMask = dogeCategory; // 4
        _bottomPipe2.physicsBody.collisionBitMask = 0;
        
        
        SKAction * actionMoveTop = [SKAction moveTo:CGPointMake(-50, _topPipe2.position.y) duration:pipeSpeed];
        SKAction * actionMoveBottom = [SKAction moveTo:CGPointMake(-50, _bottomPipe2.position.y) duration:pipeSpeed];
        
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

    
}

-(void)generateFloor{
    
    if(endGame == FALSE)
    {
    double duration = 1.813;
    SKAction * reset = [SKAction moveTo:CGPointMake(510, _floor.position.y) duration:.001];
    SKAction * actionMove = [SKAction moveTo:CGPointMake(170, _floor.position.y) duration:duration];
    SKAction * actionMove2 = [SKAction moveTo:CGPointMake(-170, _floor2.position.y) duration:duration];
    
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
    
    SKAction * reset = [SKAction moveTo:CGPointMake(510, _floor2.position.y) duration:.001 ];
    SKAction * actionMove = [SKAction moveTo:CGPointMake(-170, _floor.position.y) duration:duration];
    SKAction * actionMove2 = [SKAction moveTo:CGPointMake(170, _floor2.position.y) duration:duration];
    
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
        flashScreen = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(340, 568)];
    }
    else{
        flashScreen = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(340, 480)];
    }
    flashScreen.position = CGPointMake(170, flashScreen.size.height/2);
    
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
    
    postEndGame = true;
    double speed = 0.7;
    int yHeight = 250;
    [self addChild:_scoreBoard];
    [self addChild:bestScore];
    [self addChild:bestScoreShadow];
    [self addChild:_gameOverText];
    
    _myLabel.fontSize = 28;
    _myLabel.position = CGPointMake(CGRectGetMidX(self.frame) + 90, -500 + 10);
    
    largerLabel.fontSize = 28;
    largerLabel.position = CGPointMake(CGRectGetMidX(self.frame) + 90 + 3, -500 + 10 - 3);
    
    [self addChild:_myLabel];
    [self addChild:largerLabel];
    
    _myLabel.text = [NSString stringWithFormat:@"0"];
    largerLabel.text = [NSString stringWithFormat:@"0"];

    NSInteger lastHighScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"high_score"];

    bestScore.text = [NSString stringWithFormat:@"%d", lastHighScore];
    bestScoreShadow.text = [NSString stringWithFormat:@"%d", lastHighScore];

    
    [_scoreBoard runAction:[SKAction moveTo:CGPointMake(_scoreBoard.position.x, yHeight) duration:speed]];
    

    [_startAgainButton runAction:[SKAction moveTo:CGPointMake(_startAgainButton.position.x, 51 + 40) duration:0.1]];
    [_leaderboardButton runAction:[SKAction moveTo:CGPointMake(_leaderboardButton.position.x, 51 + 40) duration:0.1]];
    [bestScore runAction:[SKAction moveTo:CGPointMake(_scoreBoard.position.x + 90, yHeight - 50) duration:speed]];
    [bestScoreShadow runAction:[SKAction moveTo:CGPointMake(_scoreBoard.position.x + 90 + 3, yHeight - 50 - 3) duration:speed]];
    [_myLabel runAction:[SKAction moveTo:CGPointMake(_scoreBoard.position.x + 90, yHeight + 5) duration:speed]];
    [largerLabel runAction:[SKAction moveTo:CGPointMake(_scoreBoard.position.x + 90 + 3, yHeight + 5 - 3) duration:speed]];
    [_gameOverText runAction:[SKAction moveTo:CGPointMake(_gameOverText.position.x, 370) duration:speed]];

    
    dispatch_time_t popTime2 = dispatch_time(DISPATCH_TIME_NOW, speed * NSEC_PER_SEC);
    dispatch_after(popTime2, dispatch_get_main_queue(), ^(void){
        //code to be executed on the main queue after delay
       [self addScore:0];
    });
    
}

-(void)addScore:(int)previousInt{

    

    int bronzeMedal = 40;
    int silverMedal = 75;
    int goldMedal = 100;

    if(endGame == true){
        
        if(previousInt == bronzeMedal){
            
            self.medal = [SKSpriteNode spriteNodeWithImageNamed:@"medalBronzeDoge"];
            
            self.medal.size = CGSizeMake(56, 56);
            self.medal.position = CGPointMake(80, 240);
            self.medal.zPosition = 20;
            
            [self addChild:_medal];

        }
        if(previousInt == silverMedal){
          //  [_medal removeFromParent];
          //  self.medal.zPosition = 20;
           // [self addChild:_medal];
            [_medal removeFromParent];
            self.medal = [SKSpriteNode spriteNodeWithImageNamed:@"medalSilverDoge"];
            
            self.medal.size = CGSizeMake(56, 56);
            self.medal.position = CGPointMake(80, 240);
            self.medal.zPosition = 20;
            
            [self addChild:_medal];

        }
        if(previousInt == goldMedal){
            [_medal removeFromParent];
            self.medal = [SKSpriteNode spriteNodeWithImageNamed:@"medalGoldDoge"];
            
            self.medal.size = CGSizeMake(56, 56);
            self.medal.position = CGPointMake(80, 240);
            self.medal.zPosition = 20;
            
            [self addChild:_medal];

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
                    
                    self.medal.size = CGSizeMake(56, 56);
                    self.medal.position = CGPointMake(80, 240);
                    self.medal.zPosition = 20;
                    
                    [self addChild:_medal];
                    
                }
                if(previousInt >= silverMedal && previousInt < goldMedal){
                    //  [_medal removeFromParent];
                    //  self.medal.zPosition = 20;
                    // [self addChild:_medal];
                    [_medal removeFromParent];
                    self.medal = [SKSpriteNode spriteNodeWithImageNamed:@"medalSilverDoge"];
                    
                    self.medal.size = CGSizeMake(56, 56);
                    self.medal.position = CGPointMake(80, 240);
                    self.medal.zPosition = 20;
                    
                    [self addChild:_medal];
                    
                }
                if(previousInt >= goldMedal){
                    [_medal removeFromParent];
                    self.medal = [SKSpriteNode spriteNodeWithImageNamed:@"medalGoldDoge"];
                    
                    self.medal.size = CGSizeMake(56, 56);
                    self.medal.position = CGPointMake(80, 240);
                    self.medal.zPosition = 20;
                    
                    [self addChild:_medal];
                    
                }
                
                NSInteger lastHighScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"high_score"];
                if(lastHighScore < score){
                    
                    
                    
                    SKSpriteNode *newHighScore = [SKSpriteNode spriteNodeWithImageNamed:@"newHighScore"];
                    newHighScore.size = CGSizeMake(30, 13);
                    newHighScore.position = CGPointMake(_myLabel.position.x - 40, _myLabel.position.y - 15);
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



@end