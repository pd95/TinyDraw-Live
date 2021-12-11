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
    var undoManager: UndoManager?

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
        addStrokeWithUndo(currentStroke)
//        oldStrokes.append(currentStroke)
//        newStroke()
    }

    func newStroke() {
        currentStroke = Stroke(color: foregroundColor, width: lineWidth, spacing: lineSpacing, blur: blurAmount)
    }

    func undo() {
        objectWillChange.send()
        undoManager?.undo()
    }

    func redo() {
        objectWillChange.send()
        undoManager?.redo()
    }

    private func addStrokeWithUndo(_ stroke: Stroke) {
        undoManager?.registerUndo(withTarget: self, handler: { drawing in
            drawing.removeStrokeWithUndo(stroke)
        })

        oldStrokes.append(stroke)
        newStroke()
    }

    private func removeStrokeWithUndo(_ stroke: Stroke) {
        undoManager?.registerUndo(withTarget: self, handler: { drawing in
            drawing.addStrokeWithUndo(stroke)
        })

        oldStrokes.removeLast()
    }
}
