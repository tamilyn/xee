#import "XeeMultiImage.h"
#import "XeeBitmapImage.h"
#import "CSFilterHandle.h"

#define XeePhotoshopBitmapMode 0
#define XeePhotoshopGreyscaleMode 1
#define XeePhotoshopIndexedMode 2
#define XeePhotoshopRGBMode 3
#define XeePhotoshopCMYKMode 4
#define XeePhotoshopMultichannelMode 7
#define XeePhotoshopDuotoneMode 8
#define XeePhotoshopLabMode 9



@interface XeePhotoshopImage:XeeMultiImage
{
	int bitdepth,mode,channels;

	SEL loadersel;
	int loaderframe;
}

-(CSHandle *)handleForNumberOfChannels:(int)requiredchannels alpha:(BOOL)alpha;

-(id)init;
-(void)dealloc;
-(SEL)initLoader;

-(int)bitDepth;
-(int)mode;

@end



@interface XeePackbitsHandle:CSFilterHandle
{
	int rows,bytesperrow;
	off_t totalsize,*offsets;

	int spanleft;
	uint8 spanbyte;
	BOOL literal;
}

-(id)initWithHandle:(CSHandle *)handle rows:(int)numrows bytesPerRow:(int)bpr channel:(int)channel of:(int)numchannels previousSize:(off_t)prevsize;
-(void)dealloc;

-(uint8)produceByteAtOffset:(off_t)pos;

-(off_t)totalSize;

@end

@interface XeeDeltaHandle:CSFilterHandle
{
	int cols,depth;
	uint16 curr;
}

-(id)initWithHandle:(CSHandle *)handle depth:(int)bitdepth columns:(int)columns;
-(uint8)produceByteAtOffset:(off_t)pos;

@end
