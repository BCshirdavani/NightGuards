//
//  SettingsUIView.swift
//  NightGuards
//
//  Created by shy macbook on 11/18/20.
//

import SwiftUI

struct SettingsUIView: View {
	@State private var isOnSetting1 = false
    @State private var showCreditsModal = false
    let purchaser = Purchaser()

	var body: some View {
		List{
			HStack {
				Text("restore purchases?")
				Spacer()
				Section {
					Button(action: {purchaser.restore()}) {
						Text("Restore").padding(10)
					}
					.buttonStyle(PlainButtonStyle())
					.cornerRadius(10)
					.foregroundColor(.white)
					.background(Color.green)
					.accentColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
				}
			}
			.padding(.vertical, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
			Text("Credits").onTapGesture(perform: {
				showCreditsModal = true
			}).sheet(isPresented: $showCreditsModal, onDismiss: {showCreditsModal = false}, content: {
				VStack {
					ScrollView {
						Text("Credits for 3D models and Characters:").font(.title)
						Group{
							Group {Text("Lucha").font(.headline)
								Text("From Mixamo.com, character name Ortiz")}
							Group {Text("Donut").font(.headline)
								Text("\"Doughnut\" (https://skfb.ly/6RqTy) by ivan_the_terrible is licensed under Creative Commons Attribution (http://creativecommons.org/licenses/by/4.0/).")}
							Group {Text("Alex").font(.headline)
								Text("\"Minecraft Alex\" (https://skfb.ly/YFzT) by HyperOwl is licensed under Creative Commons Attribution (http://creativecommons.org/licenses/by/4.0/).")}
							Group {Text("Alex").font(.headline)
								Text("\"Minecraft Alex\" (https://skfb.ly/YFzT) by HyperOwl is licensed under Creative Commons Attribution (http://creativecommons.org/licenses/by/4.0/).")}
							Group {Text("Alex").font(.headline)
								Text("\"Minecraft Alex\" (https://skfb.ly/YFzT) by HyperOwl is licensed under Creative Commons Attribution (http://creativecommons.org/licenses/by/4.0/).")}
						}
						Group {
							Group {Text("CREEPER").font(.headline)
								Text("\"Minecraft - Creeper\" (https://skfb.ly/6QTSz) by Vincent Yanez is licensed under Creative Commons Attribution (http://creativecommons.org/licenses/by/4.0/).")}
							Group {Text("ENDERMAN").font(.headline)
								Text("\"Minecraft - Enderman\" (https://skfb.ly/6R7vR) by Vincent Yanez is licensed under Creative Commons Attribution (http://creativecommons.org/licenses/by/4.0/).")}
							Group {Text("Villager").font(.headline)
								Text("\"Minecraft - Villager\" (https://skfb.ly/6QTPw) by Vincent Yanez is licensed under Creative Commons Attribution (http://creativecommons.org/licenses/by/4.0/).")}
							Group {Text("Alex").font(.headline)
								Text("\"Minecraft Alex\" (https://skfb.ly/YFzT) by HyperOwl is licensed under Creative Commons Attribution (http://creativecommons.org/licenses/by/4.0/).")}
							Group {Text("Alex").font(.headline)
								Text("\"Minecraft Alex\" (https://skfb.ly/YFzT) by HyperOwl is licensed under Creative Commons Attribution (http://creativecommons.org/licenses/by/4.0/).")}
						}

					}
					Button(action: {showCreditsModal = false}){
						Text("Close").padding(10)
					}.buttonStyle(PlainButtonStyle())
					.cornerRadius(10)
					.foregroundColor(.white)
					.background(Color.red)
					.accentColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
					.padding(5)
				}.padding(5)
			})
		}
		.navigationBarTitle(Text("Settings"), displayMode: .inline)
	}
}

struct SettingsUIView_Previews: PreviewProvider {
	static var previews: some View {
		SettingsUIView()
	}
}
