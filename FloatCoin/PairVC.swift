//
//  PairVC.swift
//  FloatCoin
//
//  Created by Kaunteya Suryawanshi on 25/12/17.
//  Copyright © 2017 Kaunteya Suryawanshi. All rights reserved.
//

import AppKit

class PairVC: NSViewController {

    @IBOutlet weak var exchangePopupButton: NSPopUpButton!
    @IBOutlet weak var basePopupButton: NSPopUpButton!
    @IBOutlet weak var fiatPopUpButton: NSPopUpButton!

    @IBOutlet weak var infoLabel: NSTextField!
    var selectedExchange: Exchange {
        return Exchange.allCases[exchangePopupButton.indexOfSelectedItem]
    }

    var selectedBase: Currency {
        assert( basePopupButton.indexOfSelectedItem >= 0)
        return selectedExchange.type.baseCurrencies[basePopupButton.indexOfSelectedItem]
    }

    var selectedFIAT: Currency {
        assert(fiatPopUpButton.indexOfSelectedItem >= 0)
        return selectedExchange.type.FIATCurriences(crypto: selectedBase)[fiatPopUpButton.indexOfSelectedItem]
    }

    var selectedPair: Pair {
        return Pair(selectedBase, selectedFIAT)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        Exchange.allCases.forEach { (ex) in
            exchangePopupButton.addItem(withTitle: ex.description)
        }
        actionExchangeSelected(nil)
        infoLabel.isHidden = true
    }

    @IBAction func actionExchangeSelected(_ sender: NSPopUpButton?) {
        let baseCurriencies = selectedExchange.type.baseCurrencies
        basePopupButton.removeAllItems()
        baseCurriencies.forEach {
            basePopupButton.addItem(withTitle: $0.stringValue)
        }
        basePopupButton.selectItem(at: 0)
        let fiatList = selectedExchange.type.FIATCurriences(crypto: baseCurriencies.first!)
        fiatPopUpButton.removeAllItems()
        fiatList.forEach {
            fiatPopUpButton.addItem(withTitle: $0.stringValue)
        }
    }

    @IBAction func actionBaseCurrencySelected(_ sender: NSPopUpButton) {
        fiatPopUpButton.removeAllItems()
        let fiatList = selectedExchange.type.FIATCurriences(crypto: selectedBase)
        fiatList.forEach {
            fiatPopUpButton.addItem(withTitle: $0.stringValue)
        }
    }

    func show(info: String) {
        infoLabel.stringValue = info
        infoLabel.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        infoLabel.isHidden = false
        infoLabel.alignment = .center
    }

    @IBAction func add(_ sender: Any) {
        guard !UserDefaults.has(exchange: selectedExchange, pair: selectedPair) else {
            Log.warning("Already contains \(selectedExchange.description) \(selectedPair.description)");
            show(info: "\(selectedPair.description) already added")
            return
        }

        UserDefaults.add(exchange: selectedExchange, pair: Pair(selectedBase, selectedFIAT))
        self.dismiss(sender)
    }
}
