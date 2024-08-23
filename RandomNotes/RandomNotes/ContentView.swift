//
//  ContentView.swift
//  RandomNotes
//
//  Created by Sergio Giraldo on 22/8/24.
//

import SwiftUI
//Window constants
var WINDOW_WIDTH: CGFloat = 400
var WINDOW_HEIGHT: CGFloat = 400

// Title constants
var TITLE_HEIGHT: CGFloat = 50
var TITLE_YPOS: CGFloat = 20
// Staff constants
let NUM_STAFF_LINES: Int = 5
var STAFF_LINE_SPACING: CGFloat = 20
var STAFF_LINE_WIDTH: CGFloat = 2
var STAFF_LINE_LEAP: CGFloat = 22 //STAFF_LINE_SPACING + STAFF_LINE_WIDTH
var STAFF_HEIGHT: CGFloat = (STAFF_LINE_LEAP) * CGFloat(NUM_STAFF_LINES)
var STAFF_SPACING: CGFloat = 150
// Music symbols constants
var TREBLE_CLEF_HEIGHT: CGFloat = STAFF_HEIGHT * 2
var NOTE_HEIGHT: CGFloat = 20
var NOTE_WIDTH: CGFloat = 25

struct ContentView: View {

    var body: some View {
        VStack {
            Text("Random Notes")
                .frame(height: TITLE_HEIGHT)
                .font(.title)
//                .position(y: TITLE_YPOS)
            MusicStaffView()
                .frame(height: STAFF_HEIGHT)
//                .position(y: STAFF_SPACING)
        }
//        .padding()
    }
}

#Preview {
    ContentView()
}

struct MusicStaffView: View {
    let notes: [Note] = [
//        Note(pitch: .E, octave: 3),
//        Note(pitch: .F, octave: 3),
//        Note(pitch: .G, octave: 3),
//        Note(pitch: .A, octave: 3),
//        Note(pitch: .B, octave: 3),
        Note(pitch: .C, octave: 4),
//        Note(pitch: .D, octave: 4),
//        Note(pitch: .E, octave: 4),
//        Note(pitch: .F, octave: 4),
//        Note(pitch: .G, octave: 4),
//        Note(pitch: .A, octave: 4),
//        Note(pitch: .B, octave: 4),
        Note(pitch: .C, octave: 5),
//        Note(pitch: .D, octave: 5),
//        Note(pitch: .E, octave: 5),
//        Note(pitch: .F, octave: 5),
//        Note(pitch: .G, octave: 5),
//        Note(pitch: .A, octave: 5),
//        Note(pitch: .B, octave: 5),
        Note(pitch: .C, octave: 6),
//        Note(pitch: .D, octave: 6),
//        Note(pitch: .E, octave: 6),
//        Note(pitch: .F, octave: 6),
//        Note(pitch: .G, octave: 6),
//        Note(pitch: .A, octave: 6),
//        Note(pitch: .B, octave: 6),
//        Note(pitch: .C, octave: 7),
//        Note(pitch: .D, octave: 7),
    ]
    
    var body: some View {
        ZStack {
            // Draw the staff lines
            StaffLines()
            
            // Draw a treble clef symbol
            TrebleClefSymbol()
                .position(x: 50, y: StaffLine(line_num: 2).staffPosition)
            
            // Draw each note on the staff
            ForEach(notes, id: \.self) { note in
                NoteView(note: note)
            }
        }
    }
}

struct StaffLines: View {
    var body: some View {
        VStack(spacing: STAFF_LINE_SPACING) {
            ForEach(0..<NUM_STAFF_LINES, id: \.self) { _ in
                Rectangle()
                    .frame(height: STAFF_LINE_WIDTH)
                    .foregroundColor(.black)
            }
        }
        .frame(maxHeight: .infinity)
//        .padding(.horizontal, 10)
    }
}

struct TrebleClefSymbol: View {
    var body: some View {
        Text("𝄞") // Unicode for treble clef symbol
            .font(.system(size: TREBLE_CLEF_HEIGHT))
            .foregroundColor(.white)
            .offset(y: -40)
    }
}

//struct LedgerLines: View {
//    let note: Note
    
//    var body: some View {
//        VStack() {
//            if note.staffPosition > 8 {
//                // Notes below E4 require ledger lines below the staff
//                ForEach(9...(Int(note.staffPosition)), id: \.self) { i in
//                    if i % 2 == 0 {
//                        Rectangle()
//                            .frame(height: 2)
//                            .foregroundColor(.black)
//                            .offset(y: CGFloat(-i * 20 + 56))
//                    }
//                }
//            } else if note.staffPosition < 0 {
//                // Notes above F5 require ledger lines above the staff
//                ForEach(0...(-(note.staffPosition / 2) - 3), id: \.self) { i in
//                    Rectangle()
//                        .frame(height: 2)
//                        .foregroundColor(.black)
//                        .offset(y: CGFloat(-i * 20 + 56))
//                }
//            }
//        }
//    }
//}

struct NoteView: View {
    let note: Note
    
    var body: some View {
        ZStack {
            // Draw ledger lines if needed
            // LedgerLines(note: note)
            
            // Draw the note
            Ellipse()
                .frame(width: NOTE_WIDTH, height: NOTE_HEIGHT)
                .foregroundColor(.black)
                .overlay(
                    Circle().stroke(Color.black, lineWidth: 2)
                )
                .position(x: 150, y: note.staffPosition)
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
    var staffPosition: CGFloat {
        
        // Base note is C4 (middle C) and is assigned to index zero. Subsequent notes will increase/decrease from this base note
        let baseNote = 0
        
        // Mapping notes to their positions relative to E4
        let pitchOffsets: [Pitch: Int] = [
            .C: 0, .D: 1, .E: 2, .F: 3, .G: 4, .A: 5, .B: 6
        ]
        
        // The number of positions moved vertically per octave is 7
        let octaveOffset = (octave - 4) * 7
        
        var note_idx: Int = baseNote + octaveOffset + pitchOffsets[pitch]!
        
        // Adjust notes with negative indexes, i.e. notes below C4, to correctly retrieve the negative line/space index
        if note_idx < 0 {
            note_idx = note_idx - 1
        }
        
        if note_idx % 2 == 0 {// if is a note over a line
            let note_line = note_idx / 2
            print(note_line)
            return StaffLine(line_num: note_line).staffPosition
        } else { // is a note over a space
            let note_space = note_idx / 2
            print(note_space)
            return StaffSpace(space_num: note_space).staffPosition
        }
    }
}

struct StaffSpace: Hashable {
    let space_num: Int
    
    var staffPosition: CGFloat {
        // Spaces are numbered from bottom to top starting at the first space below the first line of the staff
        // Base space is the fifth space (i.e. space above the fifth/top line of the staff)
        let baseSpace = 5
        let y_pos = CGFloat((baseSpace - space_num)) * STAFF_LINE_LEAP
        return y_pos
    }
}

struct StaffLine: Hashable {
    let line_num: Int
    
    var staffPosition: CGFloat {
        // Lines are numbered from bottom to top starting at the first line of the staff
        // Base line is the fifth line of the staff with an offset of STAFF_LINE_LEAP/2
        let baseLine = 5
        let y_pos = (CGFloat((baseLine - line_num)) * STAFF_LINE_LEAP) + STAFF_LINE_LEAP / 2
        return y_pos
    }
}
