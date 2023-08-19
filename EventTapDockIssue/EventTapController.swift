import CoreGraphics
import SwiftUI


struct EventTapController {

    private static var timer: Timer?

    static var eventTap: CFMachPort!
    private var eventTapCallback: CGEventTapCallBack = { proxy, type, event, _ in
        if type == .tapDisabledByTimeout {
            CGEvent.tapEnable(tap: eventTap, enable: true)
        }
        
        if type == .mouseMoved {
            print("mouse moved")

            return Unmanaged.passUnretained(event)
        }

        return nil
    }
        
    init() {
        Self.eventTap = setUpEventTap()
    }
        
    
    private func setUpEventTap() -> CFMachPort {
        let eventMask = (1 << CGEventType.mouseMoved.rawValue)
        guard let eventTap = CGEvent.tapCreate(tap: .cgAnnotatedSessionEventTap, place: .tailAppendEventTap, options: .defaultTap, eventsOfInterest: CGEventMask(eventMask), callback: eventTapCallback, userInfo: nil) else { fatalError("big issue: can't create event tap") }
        
        let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        
        return eventTap
    }
}
