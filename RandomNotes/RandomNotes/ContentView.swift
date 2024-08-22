//
//  ContentView.swift
//  RandomNotes
//
//  Created by Sergio Giraldo on 22/8/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Random Notes")
                .font(.title)
                .padding()
            MusicStaffView()
                .frame(height: 200)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

struct MusicStaffView: View {
    var body: some View {
        ZStack {
            // Draw the staff lines
            StaffLines()
            
            // Draw a treble clef symbol
            TrebleClefSymbol()
                .position(x: 50, y: 80)
            
            // Draw a note on the staff (for example, Middle C)
            NoteView()
                .position(x: 150, y: 170) // Middle C on the treble clef is positioned
        }
    }
}

struct StaffLines: View {
    var body: some View {
        VStack(spacing: 20) {
            ForEach(0..<5) { _ in
                Rectangle()
                    .frame(height: 2)
                    .foregroundColor(.black)
            }
        }
        .frame(maxHeight: .infinity)
        .padding(.horizontal, 10)
    }
}

struct TrebleClefSymbol: View {
    var body: some View {
        Text("𝄞") // Unicode for treble clef symbol
            .font(.system(size: 222))
            .foregroundColor(.black)
    }
}

struct NoteView: View {
    var body: some View {
        Circle()
            .frame(width: 20, height: 20)
            .foregroundColor(.black)
            .overlay(
                Circle().stroke(Color.black, lineWidth: 2)
            )
    }
}
