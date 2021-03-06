# Swift OSX ANE  

Example Xcode project showing how to programme Air Native Extensions for OSX 10.10+ using Swift.


[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=5UR2T52J633RC)

It is comprised of 2 parts.

1. A dynamic Swift Framework which contains the translation of FlashRuntimeExtensions to Swift.
2. A dynamic Swift Framework which contains the main logic of the ANE.


SwiftOSXANE/SwiftOSXANE.m is the entry point of the ANE. It acts as a thin layered API to your Swift controller.  
Add the methods to expose to AIR here 

````objectivec
static FRENamedFunction extensionFunctions[] =
{
    { (const uint8_t*) "load", (__bridge void *)@"load", &callSwiftFunction }
   ,{ (const uint8_t*) "goBack", (__bridge void *)@"goBack", &callSwiftFunction }
};
`````


SwiftOSXANE/SwiftController.swift  
Add Swift method(s) to the functionsToSet Dictionary in getFunctions()

````swift
func getFunctions() -> Array<String> {
    functionsToSet["load"] = load
    functionsToSet["goBack"] = goBack      
}
`````

Add Swift method(s)

````swift
func load(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
    //your code here
    return nil
}

func goBack(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
    //your code here
    return nil
}
`````

----------

### How to use
######  The methods exposed by FlashRuntimeExtensions.swift are identical in most parts to the [iOS version](https://github.com/tuarua/Swift-IOS-ANE). 

Example - Convert a FREObject into a String, and String into FREObject

````swift
let airString: String = FreObjectSwift(freObject: inFRE0).value as? String
trace("String passed from AIR:", airString)
let swiftString: String = "I am a string from Swift"
do {
    return try FreObjectSwift(string: swiftString).rawValue
} catch {}
`````


Example - Call a method on an FREObject

````swift
if let addition: FreObjectSwift = try person.callMethod(name: "add", args: 100, 31) {
    if let sum: Int = addition.value as? Int {
        trace("addition result:", sum)
    }
}
`````

Example - Reading items in array
````swift
let airArray: FreArraySwift = FreArraySwift.init(freObject: inFRE0)
do {
    if let itemZero: FreObjectSwift = try airArray.getObjectAt(index: 0) {
        if let itemZeroVal: Int = itemZero.value as? Int {
            trace("AIR Array elem at 0 type:", "value:", itemZeroVal)
            let newVal = try FreObjectSwift.init(int: 56)
            try airArray.setObjectAt(index: 0, object: newVal)
            return airArray.rawValue
         }
    }
} catch {}
`````

Example - Convert BitmapData to a CGImage
````swift
let asBitmapData = FreBitmapDataSwift.init(freObject: inFRE0)
defer {
    asBitmapData.releaseData()
}
do {
    if let cgimg = try asBitmapData.getAsImage() {
     //do something with cgimg like applying a filter
    }
} catch {}
`````

Example - Error handling
````swift
do {
    _ = try person.getProperty(name: "doNotExist") //calling a property that doesn't exist
} catch let e as FREError {
    if let aneError = e.getError(#file, #line, #column) {
        return aneError //return the error as an actionscript error
    }
} catch {}
`````
----------

### Prerequisites

You will need

- Xcode 8.3 / AppCode
- IntelliJ IDEA
- AIR 25

