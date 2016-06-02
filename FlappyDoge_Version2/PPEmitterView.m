//
// PPEmitterView.h
// Created by Particle Playground on 5/16/14
//

#import "PPEmitterView.h"

@implementation PPEmitterView

-(id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	
	if (self) {
		self.backgroundColor = [UIColor clearColor];
	}
	
	return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	
	if (self) {
		self.backgroundColor = [UIColor clearColor];
	}
	
	return self;
}

+ (Class) layerClass {
    //configure the UIView to have emitter layer
    return [CAEmitterLayer class];
}

-(void)awakeFromNib {
    CAEmitterLayer *emitterLayer = (CAEmitterLayer*)self.layer;

	emitterLayer.name = @"emitterLayer";
	emitterLayer.emitterPosition = CGPointMake(150, 400);
	emitterLayer.emitterZPosition = 0;

	emitterLayer.emitterSize = CGSizeMake(10.00, 10.00);
	emitterLayer.emitterDepth = 0.00;

	emitterLayer.emitterShape = kCAEmitterLayerRectangle;

	emitterLayer.emitterMode = kCAEmitterLayerPoints;

	emitterLayer.renderMode = kCAEmitterLayerAdditive;

	emitterLayer.seed = 3578721279;



	
	// Create the emitter Cell
	CAEmitterCell *emitterCell = [CAEmitterCell emitterCell];
	
	emitterCell.name = @"underneath_add_cell";
	emitterCell.enabled = YES;

	emitterCell.contents = (id)[[UIImage imageNamed:@"Particles_fire.png"] CGImage];
	emitterCell.contentsRect = CGRectMake(0.00, 0.00, 1.00, 1.00);

	emitterCell.magnificationFilter = kCAFilterLinear;
	emitterCell.minificationFilter = kCAFilterLinear;
	emitterCell.minificationFilterBias = 0.00;

	emitterCell.scale = 3.50;
	emitterCell.scaleRange = 0.00;
	emitterCell.scaleSpeed = 0.30;

	emitterCell.color = [[UIColor colorWithRed:0.50 green:0.50 blue:0.00 alpha:1.00] CGColor];
	emitterCell.redRange = 0.00;
	emitterCell.greenRange = 0.00;
	emitterCell.blueRange = 0.00;
	emitterCell.alphaRange = 0.00;

	emitterCell.redSpeed = 0.00;
	emitterCell.greenSpeed = 0.00;
	emitterCell.blueSpeed = 0.00;
	emitterCell.alphaSpeed = 0.00;

	emitterCell.lifetime = 2.16;
	emitterCell.lifetimeRange = 0.00;
	emitterCell.birthRate = 62;
	emitterCell.velocity = 0.00;
	emitterCell.velocityRange = 500.00;
	emitterCell.xAcceleration = 0.00;
	emitterCell.yAcceleration = 0.00;
	emitterCell.zAcceleration = 0.00;

	// these values are in radians, in the UI they are in degrees
	emitterCell.spin = 0.000;
	emitterCell.spinRange = 0.000;
	emitterCell.emissionLatitude = 0.000;
	emitterCell.emissionLongitude = 0.000;
	emitterCell.emissionRange = 0.000;


	
	emitterLayer.emitterCells = @[emitterCell];
}

@end
