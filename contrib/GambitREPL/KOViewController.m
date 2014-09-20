//
//  KOViewController.m
//  KOKeyboard
//
//  Created by Adam Horacek on 03.08.12.
//  Copyright (c) 2012 Adam Horacek, Kuba Brecka
//
//  Website: http://www.becomekodiak.com/
//  github: http://github.com/adamhoracek/KOKeyboard
//	Twitter: http://twitter.com/becomekodiak
//  Mail: adam@becomekodiak.com, kuba@becomekodiak.com
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import "KOViewController.h"
#import "KOKeyboardRow.h"

@interface KOViewController ()

@end

@implementation KOViewController
{
	KOKeyboardRow *kov;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	UITextView *textView = [[UITextView alloc] initWithFrame:self.view.bounds];
	[textView setText:@"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum purus magna, gravida non gravida nec, dapibus at lectus. Aliquam hendrerit lorem sed quam mattis posuere sit amet ac urna. Nam placerat dignissim ligula quis pretium. Vivamus laoreet sem et dolor suscipit mollis. Maecenas feugiat nisi a massa elementum vitae bibendum libero iaculis. Vivamus euismod eros a lectus vestibulum porttitor. Donec elementum arcu sit amet mi auctor molestie. Integer pulvinar orci a neque placerat congue. Integer id ultrices nisi. Nullam sit amet dolor ipsum, eget vehicula mauris. Nulla sollicitudin, orci quis pharetra laoreet, magna turpis cursus lacus, ac malesuada ipsum enim et est. Mauris non mi at leo condimentum malesuada. Donec a facilisis metus. Nullam dictum, ante non ultrices sagittis, mi elit bibendum ligula, in tincidunt mi turpis nec nisl. Nulla molestie viverra ipsum eu consequat. Sed mauris erat, vestibulum vel vulputate at, sagittis at nibh.\n\nMorbi tempus scelerisque lectus sit amet posuere. Morbi dictum ullamcorper scelerisque. Morbi eu condimentum felis. Donec rutrum feugiat dolor et bibendum. Mauris turpis sapien, molestie eu laoreet eget, tincidunt at sem. Sed interdum, erat at pharetra adipiscing, orci sem laoreet odio, sit amet fermentum eros urna egestas urna. Vivamus tortor enim, iaculis tristique pulvinar sed, molestie vel orci. In hac habitasse platea dictumst. Praesent aliquam, mauris sit amet mattis malesuada, mauris purus commodo lorem, quis convallis odio nisl in enim. Sed non turpis a tellus porta porttitor ac sed ligula. Pellentesque porta varius venenatis.\n\nCurabitur rutrum lacinia libero non imperdiet. Nulla consectetur tristique lacus, aliquet sodales neque posuere a. Praesent eu mauris vel enim laoreet pulvinar. Aliquam erat volutpat. Aliquam imperdiet dui sed enim lacinia in tempor tellus scelerisque. Fusce id ligula at lectus viverra interdum at id orci. Sed pharetra libero sem, quis auctor sem. Nam scelerisque egestas dui a accumsan.\n\nProin vel diam elit, sit amet pulvinar metus. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Vestibulum eu sodales ipsum. Proin et lacus sit amet velit scelerisque dignissim. Ut mattis leo vitae enim semper quis interdum nisl aliquet. Suspendisse scelerisque condimentum nulla id placerat. Integer mollis luctus justo tincidunt accumsan. Nam consequat metus et diam facilisis sodales. Aenean molestie nulla in dui dictum luctus. Cras dolor sapien, lobortis ut facilisis nec, iaculis nec massa. Nulla quis mi lacus, hendrerit fermentum nunc. Mauris placerat consectetur porta.\n\nNunc scelerisque congue tortor et ornare. Integer a leo metus, eu dictum enim. Mauris aliquet facilisis auctor. Aenean cursus blandit convallis. Vestibulum id nisi semper sapien interdum congue. Nulla porta egestas viverra. Vivamus dignissim elit vitae sem adipiscing venenatis venenatis tortor placerat. Aliquam erat volutpat. Nulla sodales condimentum quam, ac porta sapien blandit vel. Proin feugiat ultricies enim, nec pellentesque libero condimentum et. Aliquam faucibus luctus est id ornare. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus."];
	[self.view addSubview:textView];
	kov = [[KOKeyboardRow alloc] initWithDelegate:textView];
	kov.keys = @"^$*?+[]\\()◉◉◉◉◉{}.|:◉◉◉◉◉\",_/;2406835179";
	kov.keys = @"^$(?+[])()◉◉◉◉◉{}.|:◉◉◉◉◉\",_/;2406835179";
	kov.keys = @"2406835179abAdefg@ijkl&nopq#st*+(#?/-)'\"";
//kov.keys = @"0123456789ABCDEFGHIJ";
	kov.animation = koTraditinalAnimation; //koNoAnimation koTraditinalAnimation;
	
	NSMutableIndexSet *portraitSet= [NSMutableIndexSet new];
	NSMutableIndexSet *landscapeSet = [NSMutableIndexSet new];

	[portraitSet addIndex:0];
	[portraitSet addIndex:1];
	[portraitSet addIndex:2];
	[portraitSet addIndex:6];
	[portraitSet addIndex:7];

	[landscapeSet addIndex:0];
	[landscapeSet addIndex:1];
	[landscapeSet addIndex:3];
	[landscapeSet addIndex:4];
	[landscapeSet addIndex:5];
	[landscapeSet addIndex:6];
	[landscapeSet addIndex:7];

	kov.portraitSet = portraitSet;
	kov.landscapeSet = landscapeSet; // portraitSet landscapeSet;
	[kov setup];

dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^
    {
		[textView becomeFirstResponder];
    } );

}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
	[super willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];
	
	//NSLog(@"WILL ANIMATE!");
	
	[kov switchToOrientation:interfaceOrientation];

	//UIView *sv = [kov.subviews lastObject];
	//[sv removeFromSuperview];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	[super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
	
	//NSLog(@"DID: %@", NSStringFromCGRect(kov.frame));
}


@end
