//
//  HeroCard.swift
//  NightGuards
//
//  Created by shiMac on 1/13/21.
//

import SwiftUI

struct HeroCard: View {
    let cardName: String
    let price: String
    let unlocked: Bool
    let placed: Bool
    let cardBio: Dictionary<String, String> = [K.DONUT: "A classic glazed donut with sprinkles on top",
                                               K.PALADIN: "This paladin fights off evil monsters with his sword and shiled",
                                               K.LUCHA: "Mexico's champion luchador, works night shifts, fighting monsters",
                                               K.NINJA: "The ninja is the master of shadows",
                                               K.TRUMP: "This guy does stuff and things"]
    
    var body: some View {
        
        Section {
            VStack {
                HStack {
                    VStack {
                        Text(cardName)
                            .font(.title)
                        
                        ZStack {
                            Image(uiImage: heroPic())
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                            Circle()
                                .strokeBorder(Color.white, lineWidth: 1)
                                .frame(width: 100, height: 100)
                        }
                    }
                    
                    VStack {
                        Section {
                            Text(cardBio[cardName]!)
                        }.padding(.all, 1)
                        Spacer()
                        Section {
                            HStack {
                                Spacer()
                                ZStack {
                                    Circle().fill(placedColor()).frame(width: 70, height: 30)
                                    if placed {
                                        Text("x")
                                    } else{
                                        Text("_")
                                    }
                                }
                                ZStack {
                                    Capsule(style: .circular).fill(buyBGColor()).frame(width: 70, height: 30)
                                    ZStack {
                                        Text(price).foregroundColor(buyFontColor())
                                    }
                                }
                            }
                        }.padding(.trailing, 1).frame(alignment: .bottom)
                    }
                }
            }
        }.frame(minHeight: 100, idealHeight: 150, maxHeight: 250, alignment: .leading)
    }
    
    func buyBGColor() -> Color {
        if unlocked {
            return Color.gray
        } else {
            return Color.green
        }
    }
    
    func buyFontColor() -> Color {
        if unlocked {
            return Color.white
        } else {
            return Color.black
        }
    }
    
    func placedColor() -> Color {
        if placed {
            return Color.green
        } else {
            return Color.gray
        }
    }
    
    func heroPic() -> UIImage {
        switch cardName {
        case K.PALADIN:
            return UIImage(named: K.PALADIN)!
        case K.DONUT:
            return UIImage(named: K.DONUT)!
        case K.NINJA:
            return UIImage(named: K.NINJA)!
        case K.LUCHA:
            return UIImage(named: K.LUCHA)!
        case K.TRUMP:
            return UIImage(named: K.TRUMP)!
        default:
            return UIImage(named: K.DONUT)!
        }
    }
}

struct HeroCard_Previews: PreviewProvider {
    static var previews: some View {
        HeroCard(cardName: K.NINJA, price: "$0.99", unlocked: false, placed: false)
    }
}
