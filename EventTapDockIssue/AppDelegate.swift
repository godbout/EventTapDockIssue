import AppKit
import SwiftUI


class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        guard AXIsProcessTrusted() else {
            let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeRetainedValue() as NSString: true]
            
            AXIsProcessTrustedWithOptions(options)

            return
        }
        
        _  = EventTapController()
        CGEvent.tapEnable(tap: EventTapController.eventTap, enable: true)
    }

}
