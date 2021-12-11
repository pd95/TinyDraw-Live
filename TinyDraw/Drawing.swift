//
//  Drawing.swift
//  TinyDraw
//
//  Created by Philipp on 11.12.21.
//

import SwiftUI

class Drawing: ObservableObject {
    private var oldStrokes = [Stroke]()
    private var currentStroke = Stroke()

    init() {}

    var strokes: [Stroke] {
        var all = oldStrokes
        all.append(currentStroke)
        return all
    }

    @Published var foregroundColor = Color.black {
        didSet {
            currentStroke.color = foregroundColor
        }
    }

    @Published var lineWidth = 3.0 {
        didSet {
            currentStroke.width = lineWidth
        }
    }

    @Published var lineSpacing = 0.0 {
        didSet {
            currentStroke.spacing = lineSpacing
        }
    }

    @Published var blurAmount = 0.0 {
        didSet {
            currentStroke.blur = blurAmount
        }
    }

    func add(point: CGPoint) {
        objectWillChange.send()
        currentStroke.points.append(point)
    }

    func finishedStroke() {
        objectWillChange.send()
        oldStrokes.append(currentStroke)
        newStroke()
    }

    func newStroke() {
        currentStroke = Stroke(color: foregroundColor, width: lineWidth, spacing: lineSpacing, blur: blurAmount)
    }
}
