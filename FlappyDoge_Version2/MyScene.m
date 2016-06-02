//
//  MyScene.m
//  FlappyDoge_Version2
//
//  Created by Rijul Gupta on 2/11/14.
//  Copyright (c) 2014 Rijul Gupta. All rights reserved.
//

#import "MyScene.h"


@interface MyScene () <SKPhysicsContactDelegate>
@property (nonatomic) SKSpriteNode * floor;
@property (nonatomic) SKSpriteNode * floor2;
@property (nonatomic) SKSpriteNode *background;
@property (nonatomic) SKSpriteNode *bottomColor;
@property (nonatomic) SKSpriteNode *doge;
@property (nonatomic) SKSpriteNode *topPipe;
@property (nonatomic) SKSpriteNode *bottomPipe;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;



@end

static const uint32_t floorCategory     =  0x1 << 0;
static const uint32_t dogeCategory        =  0x1 << 1;


@implementation MyScene
NSArray * _dogeFrames;
BOOL inJump;
double dogJumpDuration = 0.3;


-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
       
        //set background scene
        self.background = [SKSpriteNode spriteNodeWithImageNamed:@"background.gif"];
        
        self.background.size = CGSizeMake(340*(self.size.width/320), 480);
        self.background.position = CGPointMake(170*(self.size.width/320), 240);
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
        _floor.physicsBody.collisionBitMask = 0;

        self.floor2 = [SKSpriteNode spriteNodeWithImageNamed:@"floorLong.png"];
        self.floor2.size = CGSizeMake(340, 12);
        self.floor2.position = CGPointMake(510, 51);
        self.floor2.zPosition = 2;
        [self addChild:self.floor2];
        _floor2.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_floor2.size]; // 1
        _floor2.physicsBody.dynamic = NO;
        _floor2.physicsBody.categoryBitMask = floorCategory; // 3
        _floor2.physicsBody.contactTestBitMask = dogeCategory; // 4
        _floor2.physicsBody.collisionBitMask = 0;
        

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
        _doge.physicsBody.contactTestBitMask = floorCategory; // 4
        _doge.physicsBody.collisionBitMask = 0;
        _doge.physicsBody.velocity = CGVectorMake(0, 0);

       // _doge.physicsBody.usesPreciseCollisionDetection = YES;

        
        //DOGE VELOCITY
        
        
        self.physicsWorld.gravity = CGVectorMake(0,-0.5);

        
    
        self.physicsWorld.contactDelegate = self;

        [self generatePipes:5];
        [self generateFloor2];
        
        
        //Set up animation of doge

      //  SKAction * rotate = [SKAction rotateToAngle:(M_PI_2)*(60./360.) duration:.01];
       // [_doge runAction:rotate];
        

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
    inJump = NO;

    double duration = dogJumpDuration;
    
    SKAction * remove = [SKAction removeFromParent];
    [_doge runAction:remove];
        SKAction * actionMoveUp = [SKAction moveTo:CGPointMake(_doge.position.x, _doge.position.y+60) duration:duration];
        SKAction * actionMoveDown = [SKAction moveTo:CGPointMake(_doge.position.x, _doge.position.y) duration:duration*1.2];


    
    SKAction *rotate = [SKAction rotateToAngle:((M_PI_2)*(3600./360.)) duration:(duration*1.0)];
    SKAction *groupAction = [SKAction group:@[actionMoveUp, rotate]];
    [_doge runAction:[SKAction sequence:@[groupAction, actionMoveDown]]];

    
   
        //#NSTimer, #Method with Delay, #Timerfix
        double delayInSeconds = duration*2.2;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            //code to be executed on the main queue after delay
            [self jumpFinished];
        });
        
        
}

-(void)jumpFinished{
    inJump = NO;

    double duration = .4;
    SKAction * rotate = [SKAction rotateToAngle:(M_PI_2)*(90/360.) duration:duration];
    [_doge runAction:rotate];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        
        if(inJump == NO){
            [self dogeJump];
        }
        else{
            [self dogeJump];
        }
    }
  //  _doge.physicsBody.velocity = CGVectorMake(0, -400);

}

-(void)generatePipes:(int)previousPipeHeight{
//130px between pipes
    //190 px per second
    
    
    double pipeSpeed = 2.4;
    //set top pipe sprite
    //maximum height is 40px below top screen which is y = 615
    //min height is 140px above bottom screen which is 340px below top screen  which is y = 315
    
    //scratch those - min height should be determined by the minimum height the bottom one can be which is -50
    int pipeHeight = arc4random()%22;
    
    int topPipeXValue = pipeHeight*10+ 400;

    while (abs(pipeHeight -previousPipeHeight) < 6) {
        pipeHeight = arc4random()%22;
        topPipeXValue = pipeHeight*10+ 400;

    }
    
    self.topPipe = [SKSpriteNode spriteNodeWithImageNamed:@"topPipe.png"];
    self.topPipe.size = CGSizeMake(65, 350);
    self.topPipe.position = CGPointMake(400, topPipeXValue);
    self.topPipe.zPosition = 1;
    [self addChild:self.topPipe];
    
    //the bottomPipe height is 100px below that of the end of the top pipe
    //y max = 265 y min = -35 y = pipeHeight - 350
    self.bottomPipe = [SKSpriteNode spriteNodeWithImageNamed:@"bottomPipe.png"];
    self.bottomPipe.size = CGSizeMake(65, 350);
    self.bottomPipe.position = CGPointMake(400, topPipeXValue - 460);
    [self addChild:self.bottomPipe];
    
    SKAction * actionMoveTop = [SKAction moveTo:CGPointMake(-50, _topPipe.position.y) duration:pipeSpeed];
    SKAction * actionMoveBottom = [SKAction moveTo:CGPointMake(-50, _bottomPipe.position.y) duration:pipeSpeed];

    SKAction * actionMoveDone = [SKAction removeFromParent];
    
    [_topPipe runAction:[SKAction sequence:@[actionMoveTop, actionMoveDone]]];
    [_bottomPipe runAction:[SKAction sequence:@[actionMoveBottom, actionMoveDone]]];

    
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
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //code to be executed on the main queue after delay
        [self generatePipes:previousPipeHeight];
    });
    
    
    
    
    
   // [self generatePipes:previousPipeHeight2 withDelay:1.0];

    
}

-(void)newPipeNeeded:(int *)previousPipeHeight{
    
    
    
    int fuck = *previousPipeHeight;
    [self generatePipes:fuck];

}

-(void)generateFloor{
    

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

-(void)generateFloor2{
    
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
- (void)dogHitGround{
    _doge.physicsBody.velocity = CGVectorMake(0, 0);
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
        [self dogHitGround];
        
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