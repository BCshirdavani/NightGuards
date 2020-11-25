//
//  HeroUIView.swift
//  NightGuards
//
//  Created by shy macbook on 11/25/20.
//

import SwiftUI

struct HeroUIView: View {
    var body: some View {
        Text("Choose Guardian Here")
		.navigationBarTitle(Text("Guards"), displayMode: .inline)
    }
}

struct HeroUIView_Previews: PreviewProvider {
    static var previews: some View {
        HeroUIView()
    }
}
