//
//  Drawing.swift
//  TinyDraw
//
//  Created by Philipp on 11.12.21.
//

import SwiftUI
import UniformTypeIdentifiers

class Drawing: ObservableObject, ReferenceFileDocument {
    private var oldStrokes = [Stroke]()
    private var currentStroke = Stroke()
    var undoManager: UndoManager?

    static var readableContentTypes = [UTType(exportedAs: "com.yourcompany.tinydraw")]

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

    init() {}

    // MARK: Loading from and saving to a file

    required init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            oldStrokes = try JSONDecoder().decode([Stroke].self, from: data)

            if let lastStroke = oldStrokes.last {
                foregroundColor = lastStroke.color
                lineWidth = lastStroke.width
                lineSpacing = lastStroke.spacing
                blurAmount = lastStroke.blur
            }
        } else {
            throw CocoaError(.fileReadCorruptFile)
        }
    }

    func snapshot(contentType: UTType) throws -> [Stroke] {
        oldStrokes
    }

    func fileWrapper(snapshot: [Stroke], configuration: WriteConfiguration) throws -> FileWrapper {
        let data = try JSONEncoder().encode(snapshot)
        return FileWrapper(regularFileWithContents: data)
    }

    // MARK: Drawing interactions

    func add(point: CGPoint) {
        objectWillChange.send()
        currentStroke.points.append(point)
    }

    func finishedStroke() {
        objectWillChange.send()
        addStrokeWithUndo(currentStroke)
    }

    func newStroke() {
        currentStroke = Stroke(color: foregroundColor, width: lineWidth, spacing: lineSpacing, blur: blurAmount)
    }

    // MARK: Undo & Redo support

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
