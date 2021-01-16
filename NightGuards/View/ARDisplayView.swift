//
//  ARDisplayView.swift
//  NightGuards
//
//  Created by shy macbook on 11/18/20.
//

import SwiftUI
import RealityKit
import ARKit

struct ARDisplayView: View {
    
	let arViewContainer: ARViewContainer
	@State private var anchorPlaced: Bool = false
    @State private var heroSelected: String = K.DONUT
    @State private var camStringStat: String = ""
    @State private var mapName: String = "alpha"
    @State private var roomIndex: Int = 0
    @State private var showButtons: Bool = true
    private let roomArray = ["alpha", "bravo", "charlie"]
    let heroes: Heroes = Heroes()

	init() {
		self.arViewContainer = ARViewContainer()
	}

    var body: some View {
        ZStack {
            arViewContainer.onTapWithLocation({ (point) in
                setCamStatus()
                print("  - - tapped point: \(point)")
                arViewContainer.detectObjectTap(point: point)
            }).gesture(DragGesture(minimumDistance: 5.0, coordinateSpace: .local).onEnded({ (value) in
                if value.translation.width < -100 {
                    roomIndex -= 1
                    switchRoom()
                }
                else if value.translation.width > 100 {
                    roomIndex += 1
                    switchRoom()
                }
                else if value.translation.height < -100 {
                    withAnimation{
                        showButtons = true
                    }
                }
                else if value.translation.height > 100 {
                    withAnimation{
                        showButtons = false
                    }
                }
            })).onDisappear {
                arViewContainer.saveMap()
            }
            VStack {
                Spacer()
                if showButtons {
                    HStack{
                        ActionButtonView(arDisplayView: self, arViewContainer: arViewContainer, anchorPlaced: $anchorPlaced)
                            .onTapGesture {
                                self.placeHero(position: arViewContainer.arScnView.center, object: heroSelected)
                            }
                        Spacer()
                        ZStack{
                            Image(systemName: "arrow.clockwise.circle.fill")
                                .foregroundColor(.red)
                                .font(.system(size: 60, weight: .medium))
                                .onTapGesture {
                                    resetMap()
                                }
                        }
                        Spacer()
                        NavigationLink(destination: HeroUIView(heroSelected: $heroSelected, anchorPlaced: $anchorPlaced, heroes: heroes, mapName: $mapName)) {
                            ZStack {
                                Image(uiImage: UIImage.init(named: heroSelected)!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 60, height: 60)
                                    .clipShape(Circle())
                                Circle()
                                    .strokeBorder(Color.white, lineWidth: 1)
                                    .frame(width: 60, height: 60, alignment: .center)
                                    .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, 15)
                            }
                        }
                    }.transition(.move(edge: .bottom))
                }
            }
        }
    }
    
    func resetMap() {
        arViewContainer.killAllARAnchors()
        arViewContainer.configAR()
        anchorPlaced = false
    }
    
    func switchRoom(){
        let roomCount = roomArray.count
        var newIndex: Int
        if roomIndex >= 0 {
            newIndex = roomIndex % roomCount
        } else {
            newIndex = (roomIndex % roomCount + roomCount) % roomCount
        }
        mapName = roomArray[newIndex]
    }
    
    func placeHero(position: CGPoint, object: String) {
        if object != "none" {
            arViewContainer.castRaySimple(point: position, object: object)
            if let hero = Heroes.heroDict[object] {
                anchorPlaced = hero.isPlaced()
            }
        }
        arViewContainer.saveMap()
    }

	func buttonText() -> String {
        if Heroes.heroDict[heroSelected] != nil {
            return anchorPlaced ? "move" : "place"
        }
        return "..."
	}
    
    // TODO: figure out how to mutate the @State property to update with tracking status
    func setCamStatus() {
        if let trackState = arViewContainer.arScnView.session.currentFrame?.camera.trackingState {
            switch trackState {
            case .normal:
                camStringStat = "normal"
            case .notAvailable:
                camStringStat = "N/A"
            case .limited(.excessiveMotion):
                camStringStat = "moving"
            case .limited(.initializing):
                camStringStat = "initializing"
            case .limited(.insufficientFeatures):
                camStringStat = "need more features"
            case .limited(.relocalizing):
                camStringStat = "relocating"
            default:
                camStringStat = "?"
            }
        }
    }
}

// MARK: extend view tap to show location as well
public extension View {
  func onTapWithLocation(coordinateSpace: CoordinateSpace = .local, _ tapHandler: @escaping (CGPoint) -> Void) -> some View {
    modifier(TapLocationViewModifier(tapHandler: tapHandler, coordinateSpace: coordinateSpace))
  }
}

fileprivate struct TapLocationViewModifier: ViewModifier {
  let tapHandler: (CGPoint) -> Void
  let coordinateSpace: CoordinateSpace

  func body(content: Content) -> some View {
    content.overlay(
      TapLocationBackground(tapHandler: tapHandler, coordinateSpace: coordinateSpace)
    )
  }
}

fileprivate struct TapLocationBackground: UIViewRepresentable {
  var tapHandler: (CGPoint) -> Void
  let coordinateSpace: CoordinateSpace

  func makeUIView(context: UIViewRepresentableContext<TapLocationBackground>) -> UIView {
    let v = UIView(frame: .zero)
    let gesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.tapped))
    v.addGestureRecognizer(gesture)
    return v
  }

  class Coordinator: NSObject {
    var tapHandler: (CGPoint) -> Void
    let coordinateSpace: CoordinateSpace

    init(handler: @escaping ((CGPoint) -> Void), coordinateSpace: CoordinateSpace) {
      self.tapHandler = handler
      self.coordinateSpace = coordinateSpace
    }

    @objc func tapped(gesture: UITapGestureRecognizer) {
      let point = coordinateSpace == .local
        ? gesture.location(in: gesture.view)
        : gesture.location(in: nil)
      tapHandler(point)
    }
  }

  func makeCoordinator() -> TapLocationBackground.Coordinator {
    Coordinator(handler: tapHandler, coordinateSpace: coordinateSpace)
  }

  func updateUIView(_: UIView, context _: UIViewRepresentableContext<TapLocationBackground>) {
    /* nothing */
  }
}

struct ARDisplayView_Previews: PreviewProvider {
    static var previews: some View {
		ARDisplayView()
    }
}
