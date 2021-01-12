//
//  BuyAlert.swift
//  NightGuards
//
//  Created by shiMac on 1/11/21.
//

import SwiftUI

struct BuyAlert {
    let purchaser = Purchaser()
    
    func alert(heroName: String) -> Alert {
        let alert = Alert(title: Text("Purchase \(heroName) for $0.99?"), primaryButton: .default(Text("Buy")), secondaryButton: .cancel(Text("Exit")))
        return alert
    }
}
