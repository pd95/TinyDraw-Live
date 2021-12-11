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
        currentStroke = Stroke()
    }
}
