//
//  ContentView.swift
//  NightGuards
//
//  Created by shy macbook on 11/18/20.
//

import SwiftUI
import RealityKit

struct ContentView : View {
	var body: some View {
		NavigationView {
            
			ZStack {
				ARDisplayView().edgesIgnoringSafeArea(.bottom)
			}.navigationBarTitle(Text("Night Guards"), displayMode: .inline)
			.navigationBarItems(trailing: NavigationLink(
									destination: SettingsUIView(),
									label: {
										Image(systemName: "gear")
											.font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
									}))
		}
	}
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
#endif
