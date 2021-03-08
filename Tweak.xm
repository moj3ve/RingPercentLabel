@interface BCUIChargeRing : UIView
	@property(nonatomic, assign, readwrite) NSInteger *percentCharge;
	@property(nonatomic, retain) UILabel *ringPercentLabel;
@end

%hook UIImageView

	-(void)setFrame:(CGRect)arg1
	{
		//Hacky but works! Also it's safe since we validate the superview
		if ([self.superview class] == objc_getClass("BCUIChargeRing"))
		{
			arg1.origin.y = 20;
			//Attempt to fix the huge bluetooth icon
			arg1.origin.x = 12;
			arg1.size.width = 36;
			arg1.size.height = 36;
		}

		%orig;
	}

%end

%hook BCUIChargeRing
	%property (nonatomic, retain) UILabel *ringPercentLabel;

	-(void)setGlyph:(id)arg1
	{
		%orig;

		if(!self.ringPercentLabel){

			self.ringPercentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
			[self addSubview:self.ringPercentLabel];

			//Add constraints to the label
			self.ringPercentLabel.translatesAutoresizingMaskIntoConstraints = NO;
			[self.ringPercentLabel.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
			[self.ringPercentLabel.topAnchor constraintEqualToAnchor:self.topAnchor constant:7].active = YES;
			[self.ringPercentLabel.widthAnchor constraintEqualToConstant:40].active = YES;
			[self.ringPercentLabel.heightAnchor constraintEqualToConstant:20].active = YES;
			[self.ringPercentLabel setFont:[UIFont boldSystemFontOfSize:12]];
			self.ringPercentLabel.text = [NSString stringWithFormat:@"%ld", (long)self.percentCharge];
			[self.ringPercentLabel sizeToFit];
			self.ringPercentLabel.textAlignment = NSTextAlignmentCenter;
		}
	}

	-(void)setPercentCharge:(int)arg1
	{
		%orig;
		self.ringPercentLabel.text = [NSString stringWithFormat:@"%d", arg1];
	}
%end
