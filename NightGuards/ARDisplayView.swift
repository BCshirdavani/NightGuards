//
//  ARDisplayView.swift
//  NightGuards
//
//  Created by shy macbook on 11/18/20.
//

import SwiftUI
import RealityKit

struct ARDisplayView: View {
	var body: some View {
		ARViewContainer()
	}
}

struct ARViewContainer: UIViewRepresentable {

	func makeUIView(context: Context) -> ARView {

		let arView = ARView(frame: .zero)

		// Load the "Box" scene from the "Experience" Reality File
		let boxAnchor = try! Experience.loadBox()

		// Add the box anchor to the scene
		arView.scene.anchors.append(boxAnchor)

		return arView

	}

	func updateUIView(_ uiView: ARView, context: Context) {}

}

struct ARDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        ARDisplayView()
    }
}
