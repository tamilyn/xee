#import "XeeDuckyParser.h"
#import "XeeProperties.h"


@implementation XeeDuckyParser

-(id)initWithBuffer:(uint8 *)duckydata length:(int)len
{
	if(self=[super init])
	{
		props=[[NSMutableArray array] retain];

		int pos=0;
		while(pos<len)
		{
			if(!duckydata[pos]) break; // end marker
			if(len+3<pos) break; // truncated
			int chunktype=XeeLEInt16(duckydata+pos); pos+=2;
			int chunklen=XeeLEInt16(duckydata+pos); pos+=2;
			int next=pos+chunklen;
			if(next>=len) break; // truncated

			switch(chunktype)
			{
				case 1: // quality
					if(len>=4)
					[props addObject:[XeePropertyItem itemWithLabel:
					NSLocalizedString(@"Save For Web JPEG quality",@"Save For Web JPEG quality property title")
					value:[NSString stringWithFormat:@"%d%%",XeeLEInt16(duckydata+pos+2)]]];
				break;
				case 2: // description
					if(len>=4)
					[props addObjectsFromArray:[XeePropertyItem itemsWithLabel:
					NSLocalizedString(@"Description",@"Description property title")
					textValue:[[[NSString alloc] initWithBytes:duckydata+pos+4 length:chunklen-4
					encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF16LE)] autorelease]]];
				break;
				case 3: // copyright
					if(len>=4)
					[props addObjectsFromArray:[XeePropertyItem itemsWithLabel:
					NSLocalizedString(@"Copyright",@"Copyright property title")
					textValue:[[[NSString alloc] initWithBytes:duckydata+pos+4 length:chunklen-4
					encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF16LE)] autorelease]]];
				break;
			}
			pos=next;
		}
	}
	return self;
}

-(void)dealloc
{
	[props release];
	[super dealloc];
}

-(NSArray *)propertyArray { return [[props retain] autorelease]; }

@end