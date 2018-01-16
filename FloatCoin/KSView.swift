//
//  KSView.swift
//  FloatCoin
//
//  Created by Kaunteya Suryawanshi on 03/01/18.
//  Copyright © 2018 Kaunteya Suryawanshi. All rights reserved.
//

import Foundation
import Cocoa

@IBDesignable
public class KSView: NSView {

    @IBInspectable public var backgroundColor: NSColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0) {
        didSet {
            self.layer!.backgroundColor = backgroundColor.cgColor
        }
    }

    @IBInspectable public var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer?.cornerRadius = cornerRadius
        }
    }

    @IBInspectable public var borderWidth: CGFloat = 0 {
        didSet {
            self.layer?.borderWidth = borderWidth
        }
    }

    @IBInspectable public var borderColor: NSColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) {
        didSet {
            self.layer?.borderColor = borderColor.cgColor
        }
    }

    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.wantsLayer = true
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        self.wantsLayer = true
        //        TODO: All subview will be drawn in parent views layer
        //        self.canDrawSubviewsIntoLayer = true
    }
}
