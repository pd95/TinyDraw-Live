//
//  ContentView.swift
//  TinyDraw
//
//  Created by Philipp on 11.12.21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var drawing: Drawing

    @State private var showingBrushOptions = false

    var body: some View {
        NavigationView {
            Canvas { context, size in
                // drawing here
                for stroke in drawing.strokes {
                    var path = Path()
                    path.addLines(stroke.points)

                    var contextCopy = context

                    if stroke.blur > 0 {
                        contextCopy.addFilter(.blur(radius: stroke.blur))
                    }

                    contextCopy.stroke(path, with: .color(stroke.color), style: StrokeStyle(lineWidth: stroke.width, lineCap: .round, lineJoin: .round, dash: [1, stroke.spacing * stroke.width]))
                }
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        drawing.add(point: value.location)
                    }
                    .onEnded { _ in
                        drawing.finishedStroke()
                    }
            )
            .ignoresSafeArea()
            .navigationTitle("TinyDraw")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    ColorPicker("Color", selection: $drawing.foregroundColor)
                        .labelsHidden()

                    Button("Brush") {
                        showingBrushOptions.toggle()
                    }
                    .popover(isPresented: $showingBrushOptions) {
                        LazyVGrid(columns: [.init(.flexible()), .init(.flexible())]) {
                            Text("Width: \(Int(drawing.lineWidth))")
                            Slider(value: $drawing.lineWidth, in: 1...100)

                            Text("Softness: \(Int(drawing.blurAmount))")
                            Slider(value: $drawing.blurAmount, in: 0...50)

                            Text("Spacing: \(drawing.lineSpacing, format: .percent)")
                            Slider(value: $drawing.lineSpacing, in: 0...5, step: 0.1)
                        }
                        .frame(width: 400)
                        .monospacedDigit()
                        .padding()
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Drawing())
    }
}
