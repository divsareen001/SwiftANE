/**
 * Created by User on 04/07/2017.
 */
package com.tuarua {
import flash.events.EventDispatcher;
import flash.events.StatusEvent;
import flash.external.ExtensionContext;
import flash.system.Capabilities;

public class CommonDependencies extends EventDispatcher {
    private static const NAME:String = "CommonDependencies";
    private var ctx:ExtensionContext;
    public function CommonDependencies() {
        initiate();
    }
    private function initiate():void {
        if (Capabilities.os.indexOf("Mac OS") == -1) return;
        trace("[" + NAME + "] Initalizing ANE...");
        try {
            ctx = ExtensionContext.createExtensionContext("com.tuarua."+NAME, null);
            ctx.addEventListener(StatusEvent.STATUS, gotEvent);
            ctx.call("initFreSwift");
        } catch (e:Error) {
            trace("[" + NAME + "] ANE Not loaded properly.  Future calls will fail.");
        }
    }
    private function gotEvent(event:StatusEvent):void {
        var pObj:Object;
        switch (event.level) {
            case "TRACE":
                trace(event.code);
                break;
        }
    }
    public function dispose():void {
        if (Capabilities.os.indexOf("Mac OS") == -1) return;
        if (!ctx) {
            trace("[" + NAME + "] Error. ANE Already in a disposed or failed state...");
            return;
        }

        trace("[" + NAME + "] Unloading ANE...");
        ctx.removeEventListener(StatusEvent.STATUS, gotEvent);
        ctx.dispose();
        ctx = null;
    }
}
}
