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
let NUM_TOP_AUX_LINES: Int = 7
let NUM_BOTTOM_AUX_LINES: Int = 3
var STAFF_LINE_SPACING: CGFloat = 20
var STAFF_LINE_WIDTH: CGFloat = 2
var STAFF_LINE_LEAP: CGFloat = 22 //STAFF_LINE_SPACING + STAFF_LINE_WIDTH
var STAFF_HEIGHT: CGFloat = (STAFF_LINE_LEAP) * CGFloat(NUM_STAFF_LINES)
var STAFF_SPACING: CGFloat = 150
var STAFF_FRAME_HEIGHT: CGFloat = (STAFF_LINE_LEAP) * CGFloat(NUM_STAFF_LINES + NUM_TOP_AUX_LINES + NUM_BOTTOM_AUX_LINES)
var BASE_TOP_LINE: Int = NUM_STAFF_LINES + NUM_TOP_AUX_LINES - 2

// Music symbols constants
var TREBLE_CLEF_HEIGHT: CGFloat = STAFF_HEIGHT * 2
var TREBLE_CLEF_OFFSET: CGFloat = -40
var NOTE_HEIGHT: CGFloat = 20
var NOTE_WIDTH: CGFloat = 25

struct ContentView: View {

    var body: some View {
        VStack {
            Text("Random Notes")
                .frame(height: TITLE_HEIGHT)
                .font(.title)
            MusicStaffView()
                .frame(height: STAFF_FRAME_HEIGHT)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

struct MusicStaffView: View {
    let notes: [Note] = [
//        Note(pitch: .E, octave: 3),
//        Note(pitch: .F, octave: 3),
        Note(pitch: .G, octave: 3),
//        Note(pitch: .A, octave: 3),
//        Note(pitch: .B, octave: 3),
//        Note(pitch: .C, octave: 4),
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
//        Note(pitch: .C, octave: 6),
//        Note(pitch: .D, octave: 6),
        Note(pitch: .E, octave: 6),
//        Note(pitch: .F, octave: 6),
//        Note(pitch: .G, octave: 6),
//        Note(pitch: .A, octave: 6),
//        Note(pitch: .B, octave: 6),
//        Note(pitch: .C, octave: 7),
        Note(pitch: .D, octave: 7),
    ]
    
    var body: some View {
        ZStack {
            // Draw the staff lines
            StaffLines()
            
            // Draw a treble clef symbol
            TrebleClefSymbol()
                .position(x: 50, y: StaffLine(line_num: 2).yPos)
            
            // Draw each note on the staff
            GeometryReader { geometry in
                ZStack {
                    StaffLines()
                    
                    // Calculate spacing based on the number of notes and the available width
                    let totalWidth = geometry.size.width - 40 // Leave padding on both sides
                    let spacing = totalWidth / CGFloat(notes.count) // Even spacing
                    
                    ForEach(Array(notes.enumerated()), id: \.element) { index, note in
                        NoteView(note: note, xPos: CGFloat(index) * spacing + 150) // xPosition calculation
                    }
                }
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
            .offset(y: TREBLE_CLEF_OFFSET)
    }
}

struct LedgerLines: View {
    let top_line: Int
    let bottom_line: Int
    let xPos: CGFloat
    
    var body: some View {
        ZStack() {
            ForEach(bottom_line...top_line, id: \.self) { i in
                Rectangle()
                    .frame(width: 40, height: 2)
                    .foregroundColor(.black)
                    .position(x: xPos, y: StaffLine(line_num: i).yPos)
            }
        }
    }
}

struct NoteView: View {
    let note: Note
    let xPos: CGFloat
    
    var body: some View {
        ZStack {
            // Draw ledger lines if needed
            // If the note is above the fifth line/space of the staff, draw ledger lines above the staff
            if note.line_space > 5 {
                LedgerLines(top_line: note.line_space, bottom_line: 5, xPos: xPos)
            }
            if note.line_space < 1 {
                if note.isLine {
                    LedgerLines(top_line: 0, bottom_line: note.line_space, xPos: xPos)
                }else{
                    // If the note is in a space, bottom line is above the note (i.e. note space + 1)
                    LedgerLines(top_line: 0, bottom_line: note.line_space + 1, xPos: xPos)
                }
            }
            // Draw the note
            Ellipse()
                .frame(width: NOTE_WIDTH, height: NOTE_HEIGHT)
                .foregroundColor(.black)
                .overlay(
                    Circle().stroke(Color.black, lineWidth: 2)
                )
                .position(x: xPos, y: note.yPos)
        }
    }
}

enum Pitch: String, CaseIterable {
    case C, D, E, F, G, A, B
}

struct Note: Hashable {
    let pitch: Pitch
    let octave: Int
    
    // Computed property for note index
    var idx: Int {
        let middleC = Note(pitch: .C, octave: 4)
        let pitchOffsets: [Pitch: Int] = [
            .C: 0, .D: 1, .E: 2, .F: 3, .G: 4, .A: 5, .B: 6
        ]
        let octaveOffset = (octave - middleC.octave) * 7
        let note_idx: Int = pitchOffsets[middleC.pitch]! + octaveOffset + pitchOffsets[pitch]!
        
        // Adjust notes with negative indexes, i.e., notes below C4
//        if note_idx < 0 {
//            note_idx = note_idx - 1
//        }
        return note_idx
    }
    
    // Computed property to determine if the note is on a line or space
    var isLine: Bool {
        return idx % 2 == 0
    }
    
    // Computed property for the note's line number
    var line_space: Int {
        if idx <= 0 {
            //  Adjust notes with negative indexes, i.e., notes below C4
            return (idx - 1) / 2
        }else{
            return idx / 2
        }
    }
    

    // Calculate the vertical position on the staff (y-axis in the UI)
    var yPos: CGFloat {
        if isLine {
            // if the note is over a line, calculate based on line number
            return StaffLine(line_num: line_space).yPos
        } else {
            // if the note is over a space, calculate based on space number
            return StaffSpace(space_num: line_space).yPos
        }
    }
}


struct StaffSpace: Hashable {
    let space_num: Int
    
    var yPos: CGFloat {
        // Spaces are numbered from bottom to top starting at the first space below the first line of the staff
        // Base space is the fifth space (i.e. space above the fifth/top line of the staff)
        let baseSpace = 10
        let y_pos = CGFloat((baseSpace - space_num)) * STAFF_LINE_LEAP
        return y_pos
    }
}

struct StaffLine: Hashable {
    let line_num: Int
    
    var yPos: CGFloat {
        // Lines are numbered from bottom to top starting at the first line of the staff
        // Base line is the fifth line of the staff with an offset of STAFF_LINE_LEAP/2
        let y_pos = (CGFloat((BASE_TOP_LINE - line_num)) * STAFF_LINE_LEAP) + STAFF_LINE_LEAP / 2
        return y_pos
    }
}
