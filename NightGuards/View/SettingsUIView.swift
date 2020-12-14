//
//  SettingsUIView.swift
//  NightGuards
//
//  Created by shy macbook on 11/18/20.
//

import SwiftUI

struct SettingsUIView: View {
	@State private var isOnSetting1 = false

	var body: some View {
		List{
			Toggle(isOn: $isOnSetting1) {
				Text("setting 1")
			}
			.padding(.vertical, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
			HStack {
				Text("restore purchases?")
				Spacer()
				Section {
					Button(action: {print("resrore pressed")}) {
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
			Button(action: {print("test pressed")}) {
				Text("test")
			}
			.padding(.vertical, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
		}
		.navigationBarTitle(Text("Settings"), displayMode: .inline)
	}
}

struct SettingsUIView_Previews: PreviewProvider {
	static var previews: some View {
		SettingsUIView()
	}
}
