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
    let notes: [Note] = [
        Note(pitch: .E, octave: 3),
//        Note(pitch: .C, octave: 4),
//        Note(pitch: .E, octave: 4),
//        Note(pitch: .G, octave: 4),
//        Note(pitch: .B, octave: 4),
//        Note(pitch: .E, octave: 5),
//        Note(pitch: .F, octave: 4),
//        Note(pitch: .E, octave: 6),
    ]
    
    var body: some View {
        ZStack {
            // Draw the staff lines
            StaffLines()
            
            // Draw a treble clef symbol
            TrebleClefSymbol()
                .position(x: 50, y: 80)
            
            // Draw a note on the staff
            ForEach(notes, id: \.self) { note in
            NoteView(note: note)
        }
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
            .foregroundColor(.white)
    }
}

struct LedgerLines: View {
    let note: Note
    
    var body: some View {
        VStack() {
            if note.staffPosition > 8 {
                // Notes below E4 require ledger lines below the staff
                ForEach(9...((note.staffPosition)), id: \.self) { i in
                    if i % 2 == 0 {
                        Rectangle()
                            .frame(height: 2)
                            .foregroundColor(.black)
                            .offset(y: CGFloat(-i * 20 + 56))
                    }
                }
            } else if note.staffPosition < 0 {
                // Notes above F5 require ledger lines above the staff
                ForEach(0...(-(note.staffPosition / 2) - 3), id: \.self) { i in
                    Rectangle()
                        .frame(height: 2)
                        .foregroundColor(.black)
                        .offset(y: CGFloat(-i * 20 + 56))
                }
            }
        }
    }
}

struct NoteView: View {
    let note: Note
    
    var body: some View {
        ZStack {
            // Draw ledger lines if needed
            LedgerLines(note: note)
            
            // Draw the note
            Ellipse()
                .frame(width: 25, height: 20)
                .foregroundColor(.black)
                .overlay(
                    Circle().stroke(Color.black, lineWidth: 2)
                )
                .position(x: 150, y: CGFloat(note.staffPosition) * 11 + 56)
        }
    }
}

enum Pitch: String, CaseIterable {
    case C, D, E, F, G, A, B
}

struct Note: Hashable {
    let pitch: Pitch
    let octave: Int
    
    // Calculate the vertical position on the staff (y-axis in the UI)
    var staffPosition: Int {
        // This logic assumes that y = 0 is the top line of the staff,
        // and each line/space changes the position by some fixed amount.
        
        // Notes start from E3 (which would be below the first ledger line for treble clef)
        let baseNote = 15
        
        // Mapping notes to their positions relative to E4
        let pitchOffsets: [Pitch: Int] = [
            .E: 0, .F: 1, .G: 2, .A: 3, .B: 4, .C: 5, .D: 6
        ]
        
        // The number of positions moved vertically per octave is 7
        let octaveOffset = (octave - 3) * 7
        
        let y_pos = baseNote - octaveOffset - pitchOffsets[pitch]!
        
        return y_pos
    }
}
