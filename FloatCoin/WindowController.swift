//
//  WindowController.swift
//  FloatCoin
//
//  Created by Kaunteya Suryawanshi on 01/01/18.
//  Copyright © 2018 Kaunteya Suryawanshi. All rights reserved.
//

import AppKit

class WindowController: NSWindowController {

    override func awakeFromNib() {
        Log.info("awakeFromNib")
        initialiseWindow()
    }

    func initialiseWindow() {
        window!.isMovableByWindowBackground = true
        window!.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(CGWindowLevelKey.popUpMenuWindow)))
        window!.makeMain()
        window!.hidesOnDeactivate = !UserDefaults.floatOnTop
        window!.delegate = self
        window?.backgroundColor = .clear
    }

    func toggleAppWindow() {
        (window!.isVisible ? hide : show)()
    }

    func show() {
        Log.info("Show")
        window!.makeKeyAndOrderFront(self)
        window!.makeMain()
        NSApp.activate(ignoringOtherApps: true)
        (window!.contentViewController as! MainViewController).ratesController.startTimer()
    }

    private func hide() {
        Log.info("Hide")
        window!.orderOut(self)
        (window!.contentViewController as! MainViewController).ratesController.stopTimer()
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == UserDefaults.keyFloatOnTop {
            Log.info("\(keyPath!) CHANGED \(UserDefaults.floatOnTop)")
            self.window!.hidesOnDeactivate = !UserDefaults.floatOnTop
        }
    }
}

extension WindowController: NSWindowDelegate {
    func windowDidBecomeKey(_ notification: Notification) {
//        Log.info("windowDidBecomeKey")
    }

    func windowDidResignKey(_ notification: Notification) {
//        Log.info("windowDidResignKey")
    }

    func windowDidBecomeMain(_ notification: Notification) {
//        Log.info("windowDidBecomeMain")

        UserDefaults.standard.addObserver(self, forKeyPath: UserDefaults.keyFloatOnTop, options: .new, context: nil)
    }

    func windowDidResignMain(_ notification: Notification) {
//        Log.info("windowDidResignMain")
        UserDefaults.standard.removeObserver(self, forKeyPath: UserDefaults.keyFloatOnTop)

        /// If window is not pinned(hides on deactivate) it does not close(just hides)
        /// Hence close is expicitly called
        if UserDefaults.floatOnTop == false {
            (window?.contentViewController as! MainViewController).ratesController.stopTimer()
            window?.close()
        }
    }

    func windowWillClose(_ notification: Notification) {
//        Log.info("windowDidResignMain")
    }
}

class Window: NSWindow {
    override var canBecomeMain: Bool {
        return true
    }
}
