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
				ARDisplayView().edgesIgnoringSafeArea(.all)
				VStack {
					Spacer()
					HStack {
						Spacer()
						NavigationLink(destination: HeroUIView()) {
							ZStack {
								Circle()
									.frame(width: 60, height: 60, alignment: .center)
									.padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, 15)
									.foregroundColor(.black)
								Text("Hero").foregroundColor(.white)
							}


						}
					}
				}
			}.navigationBarTitle(Text("Night Guards"), displayMode: .inline)
			.navigationBarItems(trailing: NavigationLink(
									destination: SettingsUIView(),
									label: {
										Image(systemName: "gear")
											.foregroundColor(.black)
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
