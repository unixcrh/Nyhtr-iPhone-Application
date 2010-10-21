//
//  UIPrefix.h
//  

void AssertMsg(const char* msg, const char* fname, int line);


#if (TARGET_IPHONE_SIMULATOR)

#define	_Assert(x)							assert(x)
#define	_Assert_Return(x)					assert(x)
#define	_Assert_ReturnExp(x, returnExp)		assert(x)

#else

#define	_Assert(x)							if (!(x)) AssertMsg(#x, __FILE__, __LINE__)
#define	_Assert_Return(x)					if (!(x)) { AssertMsg(#x, __FILE__, __LINE__); return; }
#define	_Assert_ReturnExp(x, returnExp)		if (!(x)) { AssertMsg(#x, __FILE__, __LINE__); return returnExp; }

#endif


#define _SetRetained(obj, anotherObj)		if (obj != anotherObj) { _ReleaseObject(obj); if (anotherObj) obj = [anotherObj retain]; }

#define _RetainObject(obj)					if (obj) [obj retain]
#define	_ReleaseObject(obj)					if (obj) { [obj release]; obj = nil; }
#define	_AutoReleaseObject(obj)				if (obj) { [obj autorelease]; obj = nil; }

#define	_NYI(x)								[UIUtils messageAlert:@"Feature not yet implemented!" title:@#x delegate:nil]; return
#define	_NYI_Return(x, returnExp)			[UIUtils messageAlert:@"Feature not yet implemented!" title:@#x delegate:nil]; return returnExp

#define _LocalizedString(key)				[[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:nil]

#define	_LocalizedMessageAlert(_strId)		[UIUtils localizedErrorAlert:_LocalizedString(_strId)]
#define	_LocalizedErrorAlert(_strId)		[UIUtils errorAlert:_LocalizedString(_strId)]



#define	_DictionaryNodeFromXMLNode(key, xmlElement)		[xmlElement stringValueForNode:@key], key

#define _StartDictionary(dict)				NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
#define _KeyBoolValPair(key, boolVal)		[NSNumber numberWithBool:boolVal], key
#define _KeyIntValPair(key, intVal)			[NSString stringWithFormat:@"%d", intVal], key
#define _KeyFloatValPair(key, floatVal)		[NSString stringWithFormat:@"%f", floatVal], key
#define _KeyStrValPair(key, strVal)			(strVal ? strVal : @""), key
#define _EndDictionary()					nil];

#define _SetKeyIntValPair(dict, key, intVal)		[dict setObject:[NSString stringWithFormat:@"%d", intVal] forKey:key]
#define _SetKeyStrValPair(dict, key, strVal)		[dict setObject:(strVal ? strVal : @"") forKey:key]
#define _SetKeyFloatValPair(dict, key, floatVal)	[dict setObject:[NSString stringWithFormat:@"%f", floatVal] forKey:key]
#define _SetKeyBoolValPair(dict, key, boolVal)		[dict setObject:[NSNumber numberWithBool:boolVal] forKey:key]

#define	_BoolValForKey(dict, key)			[[dict objectForKey:key] boolValue]
#define	_IntValForKey(dict, key)			[[dict objectForKey:key] intValue]
#define	_FloatValForKey(dict, key)			[[dict objectForKey:key] floatValue]
#define	_StrValForKey(dict, key)			(([[dict objectForKey:key] length] > 0) ? [dict objectForKey:key] : @"")
#define	_Log(dict, key)						NSLog(@"%@", (NSString*)[dict objectForKey:key])

#define _IsSameString(str1, str2)			[str1 isEqualToString: str2]
#define _ifNil(str)							(([str length] == 0) ? @"" : str)

#define _ReturnIfNotEqual(x, y)				if ((x) != (y)) return NO
#define _ReturnIfNotEqualStr(str1, str2)	if (str1 && !_IsSameString(str1, str2)) return NO
#define _StringFromInt(intVal)				[NSString stringWithFormat:@"%d", intVal]

#define _Encoding(str)						((str == nil) ? @"" : [UIUtils base64StringFromString:str])
#define _Decoding(str)						((str == nil) ? @"" : [UIUtils stringFromBase64String:str])

#define _EncodeImage(img)						((img == nil) ? nil : [UIUtils stringFromImage:img])
#define _DecodeImage(str)						((str == nil) ? nil : [UIUtils imageFromString:str])

typedef enum  tagStatusCode
{
	EStatusCodeInvalid = -1,
	EStatusCodeError = -1,
	EStatusCodeSuccess,
	EStatusRequestSent	= 10001,
	EStatusResponseReceived,
	EStatusResponseDataReceiving,
	EStatusRequestCompleted,
	EStatusRequestFailed,
	
	EStatusRequestQueued,
	EStatusNoTransaction,
	EStatusRequestPending,
	EStatusNoSessionError,
	EStatusXMLParsingError,
	EStatusUserAlreadyExists,
	EStatusURLConnectionError,
	EStatusInvalidRequest,
	EStatusInvalidResponse,
	
	EStatusHTTPSuccess = 200,
	EStatusHTTPInvalidURL = 400,
	EStatusHTTPBadGateway = 502,
	EStatusHTTPServerNotReachable = 504,
	
	EStatusCodeUpdationFailed = 1,
	EStatusCodeDatabaseError = 2,
	EStatusCodeXmlError = 3,
	EStatusCodeUserAlreadyExist = 4,
	EStatusCodeRequestSentSuccessfully,
	
	EStatusCodeCantFindHost = -1003,
	EStatusCodeDomainNotSupportedHere = 531,
	EStatusCodePartialSuccessful = 201,
	EStatusCodeUnknownUser = 531,
	EStatusCodeWrongPassword = 409,
	EStatusCodeMessageNotFound = 426,
	EStatusCodeInvalidURL = 2400,
	EStatusCodeGetResponseSuccessfully = 2200,
	EStatusCodeBadGateway = 2502,
	EStatusCodeUnableToReachServer = 2504,
	EStatusCodeRequestTimedOut = 1001,
	EStatusCodeNoInternetConnection = 1009
} EStatusCode;




