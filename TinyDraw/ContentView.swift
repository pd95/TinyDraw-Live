//
//  ContentView.swift
//  TinyDraw
//
//  Created by Philipp on 11.12.21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var drawing: Drawing

    var body: some View {
        NavigationView {
            Canvas { context, size in
                // drawing here
                for stroke in drawing.strokes {
                    var path = Path()
                    path.addLines(stroke.points)

                    context.stroke(path, with: .color(stroke.color), style: StrokeStyle(lineWidth: stroke.width, lineCap: .round, lineJoin: .round))
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
