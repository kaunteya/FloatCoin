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
        log.info("awakeFromNib")
        initialiseWindow()
    }

    func initialiseWindow() {
        window!.isMovableByWindowBackground = true
        window!.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(CGWindowLevelKey.floatingWindow)))
        window!.makeMain()
        window!.hidesOnDeactivate = !UserDefaults.floatOnTop
        window!.delegate = self
    }

    func toggleAppWindow() {
        (window!.isVisible ? hide : show)()
    }

    func show() {
        log.info("Show")
        window!.makeKeyAndOrderFront(self)
        window!.makeMain()
        NSApp.activate(ignoringOtherApps: true)
        (window!.contentViewController as! MainViewController).ratesController.startTimer()
    }

    private func hide() {
        log.info("Hide")
        window!.orderOut(self)
        (window!.contentViewController as! MainViewController).ratesController.stopTimer()
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == UserDefaults.keyFloatOnTop {
            log.info("\(keyPath!) CHANGED \(UserDefaults.floatOnTop)")
            self.window!.hidesOnDeactivate = !UserDefaults.floatOnTop
        }
    }
}

extension WindowController: NSWindowDelegate {
    func windowDidBecomeKey(_ notification: Notification) {
        log.info("windowDidBecomeKey")
    }

    func windowDidResignKey(_ notification: Notification) {
        log.info("windowDidResignKey")
    }

    func windowDidBecomeMain(_ notification: Notification) {
        log.info("windowDidBecomeMain")

        UserDefaults.standard.addObserver(self, forKeyPath: UserDefaults.keyFloatOnTop, options: .new, context: nil)
    }

    func windowDidResignMain(_ notification: Notification) {
        log.info("windowDidResignMain")
        UserDefaults.standard.removeObserver(self, forKeyPath: UserDefaults.keyFloatOnTop)

        /// If window is not pinned(hides on deactivate) it does not close(just hides)
        /// Hence close is expicitly called
        if UserDefaults.floatOnTop == false {
            (window?.contentViewController as! MainViewController).ratesController.stopTimer()
            window?.close()
        }
    }

    func windowWillClose(_ notification: Notification) {
        log.info("windowDidResignMain")
    }
}

class Window: NSWindow {
    override var canBecomeMain: Bool {
        return true
    }
}
