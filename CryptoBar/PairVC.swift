//
//  PairVC.swift
//  FloatCoin
//
//  Created by Kaunteya Suryawanshi on 25/12/17.
//  Copyright © 2017 Kaunteya Suryawanshi. All rights reserved.
//

import AppKit

class PairVC: NSViewController {

    var list: [UserExchangePair] = [
        UserExchangePair(exchange: .coinbase, pair: Pair("BTC:USD")),
        UserExchangePair(exchange: .cex, pair: Pair("BTC:USD")),
    ]
    @IBOutlet weak var tableView: NSTableView!
    
    @IBOutlet weak var exchangePopupButton: NSPopUpButton!
    @IBOutlet weak var basePopupButton: NSPopUpButton!
    @IBOutlet weak var fiatPopUpButton: NSPopUpButton!

    var selectedExchange: Exchange {
        return Exchange.all[exchangePopupButton.indexOfSelectedItem]
    }

    var selectedBase: Currency? {
        guard basePopupButton.indexOfSelectedItem >= 0 else { return nil }
        return selectedExchange.type.baseCryptoCurriencies()[basePopupButton.indexOfSelectedItem]
    }

    var selectedFIAT: Currency? {
        guard let selectedBase = selectedBase, fiatPopUpButton.indexOfSelectedItem >= 0 else { return nil }
        return selectedExchange.type.FIATCurriences(crypto: selectedBase)[fiatPopUpButton.indexOfSelectedItem]
    }

    var selectedUserExchangePair: UserExchangePair? {
        guard let selectedBase = selectedBase,
            let selectedFIAT = selectedFIAT else { return nil; }
        return UserExchangePair(
            exchange: selectedExchange,
            pair: Pair(a: selectedBase, b: selectedFIAT)
        )
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        Exchange.all.forEach { (ex) in
            exchangePopupButton.addItem(withTitle: ex.description)
        }
        exchangePopupButton.selectItem(at: 1)
    }

    @IBAction func actionExchangeSelected(_ sender: NSPopUpButton) {
        let baseCurriencies = selectedExchange.type.baseCryptoCurriencies()
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
        let fiatList = selectedExchange.type.FIATCurriences(crypto: selectedBase!)
        fiatList.forEach {
            fiatPopUpButton.addItem(withTitle: $0.stringValue)
        }
    }

    @IBAction func add(_ sender: Any) {
        guard let selectedUserExchangePair = selectedUserExchangePair else { return}
        UserDefaults.add(exchangePair: selectedUserExchangePair)
        tableView.reloadData()
        tableView.scrollRowToVisible(tableView.numberOfRows - 1)
    }
    @IBAction func delete(_ sender: Any) {
        guard let selectedUserExchangePair = selectedUserExchangePair else { return}
        UserDefaults.remove(exchangePair: selectedUserExchangePair)
    }
}

extension PairVC: NSTableViewDataSource, NSTableViewDelegate {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return UserDefaults.userExchangePairList.count
    }
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let current = UserDefaults.userExchangePairList[row]
        let cell = tableView.make(withIdentifier: "cell", owner: nil) as! TableViewPairCell
        cell.textField?.stringValue = current.description
        cell.pairLabel.stringValue = current.pair.joined(":")
        cell.exchangeLabel.stringValue = current.exchange.description
        return cell
    }
}

class TableViewPairCell: NSTableCellView {
    @IBOutlet weak var pairLabel: NSTextField!
    @IBOutlet weak var exchangeLabel: NSTextField!
}
