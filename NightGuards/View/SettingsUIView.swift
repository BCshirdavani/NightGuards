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
                        Text("dfs sdaf asdf asdf sadf sadf sadf sadf asdf asdf asdf sad sdaf sdaf asdf sdaf sdaf asdf asdf asdf asdf asdf asdf sadf asdf asdf asdf sadf asdf asdf asdf asdf asdf sadf asdf asdf asdf asdf asdf asdf asdf asdf dfs sdaf asdf asdf sadf sadf sadf sadf asdf asdf asdf sad sdaf sdaf asdf sdaf sdaf asdf asdf asdf asdf asdf asdf sadf asdf asdf asdf sadf asdf asdf asdf asdf asdf sadf asdf asdf asdf asdf asdf asdf asdf asdf  dfs sdaf asdf asdf sadf sadf sadf sadf asdf asdf asdf sad sdaf sdaf asdf sdaf sdaf asdf asdf asdf asdf asdf asdf sadf asdf asdf asdf sadf asdf asdf asdf asdf asdf sadf asdf asdf asdf asdf asdf asdf asdf asdf  dfs sdaf asdf asdf sadf sadf sadf sadf asdf asdf asdf sad sdaf sdaf asdf sdaf sdaf asdf asdf asdf asdf asdf asdf sadf asdf asdf asdf sadf asdf asdf asdf asdf asdf sadf asdf asdf asdf asdf asdf asdf asdf asdf  dfs sdaf asdf asdf sadf sadf sadf sadf asdf asdf asdf sad sdaf sdaf asdf sdaf sdaf asdf asdf asdf asdf asdf asdf sadf asdf asdf asdf sadf asdf asdf asdf asdf asdf sadf asdf asdf asdf asdf asdf asdf asdf asdf  dfs sdaf asdf asdf sadf sadf sadf sadf asdf asdf asdf sad sdaf sdaf asdf sdaf sdaf asdf asdf asdf asdf asdf asdf sadf asdf asdf asdf sadf asdf asdf asdf asdf asdf sadf asdf asdf asdf asdf asdf asdf asdf asdf  dfs sdaf asdf asdf sadf sadf sadf sadf asdf asdf asdf sad sdaf sdaf asdf sdaf sdaf asdf asdf asdf asdf asdf asdf sadf asdf asdf asdf sadf asdf asdf asdf asdf asdf sadf asdf asdf asdf asdf asdf asdf asdf asdf  dfs sdaf asdf asdf sadf sadf sadf sadf asdf asdf asdf sad sdaf sdaf asdf sdaf sdaf asdf asdf asdf asdf asdf asdf sadf asdf asdf asdf sadf asdf asdf asdf asdf asdf sadf asdf asdf asdf asdf asdf asdf asdf asdf  dfs sdaf asdf asdf sadf sadf sadf sadf asdf asdf asdf sad sdaf sdaf asdf sdaf sdaf asdf asdf asdf asdf asdf asdf sadf asdf asdf asdf sadf asdf asdf asdf asdf asdf sadf asdf asdf asdf asdf asdf asdf asdf asdf  ")
                    }
                    Button(action: {showCreditsModal = false}){
                        Text("Close").padding(10)
                    }.buttonStyle(PlainButtonStyle())
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .background(Color.red)
                    .accentColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    .padding(5)
                }
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
