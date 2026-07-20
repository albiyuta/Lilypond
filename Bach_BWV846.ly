\version "2.24.4"

\language "deutsch"

% Macro for coloring notes
colorMusic =
#(define-music-function (color mus) (color? ly:music?)
  #{
    \override NoteHead.color = #color
    \override Stem.color = #color
    \override Accidental.color = #color

    $mus

    \revert NoteHead.color
    \revert Stem.color
    \revert Accidental.color
  #})

% Macros for adding colored text to the example: jpb = below, jpa = above
jpb =
#(define-music-function (text color) (string? color?)
  #{
    _\markup \override #'(font-name . "IPAexGothic") {
      \with-color #color #text
    }
  #})
jpa =
#(define-music-function (text color) (string? color?)
  #{
    ^\markup \override #'(font-name . "IPAexGothic") {
      \with-color #color #text
    }
  #})

% Color definitions
red    = #(rgb-color 0.8 0.2 0.2)
green  = #(rgb-color 0.2 0.6 0.2)
blue   = #(rgb-color 0.2 0.3 0.85)
orange = #(rgb-color 0.9 0.5 0.1)
purple = #(rgb-color 0.6 0.3 0.7)
cyan   = #(rgb-color 0.1 0.7 0.7)

\paper {
  % Add space for the instrument name
  indent = 18\mm
}

global = {
  \key c \major
  \time 4/4
}

rightOne = \relative c'' {
  \global
  \accidentalStyle modern
  R1 | r2 r8 \colorMusic #blue {g8 \jpa"Answer #2"#blue a h |
  c8. d32 c h8 e a, d ~ d16 e d c} | \colorMusic #purple {h16 \jpa"Countersubject #2"#purple g a h c h c d e d e fis g8 h,|
  c8 a d16 c h a g8.} \colorMusic #cyan {g16 \jpa"Free counterpoint #2"#cyan f16 e f g | a16 g a h c2 h4} |
  
}

rightTwo = \relative c'' {
  \global
  \accidentalStyle modern
  r8 \colorMusic #red { c,8 \jpb"Subject #1"#red d e f8. g32 f e8 a | d, g ~ g16 a g f} \colorMusic #purple {e \jpb"Countersubject #1"#purple f e d c d c h |
  a8 fis' g4 ~ g8 fis16 e fis8 d | g8} \colorMusic #cyan {\jpb"Free counterpoint #1"#cyan f e d c r8 r8 g' ~ |
  g8 f16 e f4 ~ f16 f e8 d4 | c8 f r16 g16 f e f8 d g4 ~} |
  
}

dynamics = {
  \global
  % Dynamics follow here.
  
}

leftOne = \relative c' {
  \global
  \accidentalStyle modern
  R1 | R1 |
  R1 | r8 \colorMusic #blue {g8 \jpa"Answer #3"#blue a h c8. d32 c h8 e |
  a, d ~ d16 e d c} \colorMusic #purple {h8 \jpa"Countersubject #3"#purple c ~ c b | a8 d g, c r16 a16 h c d4} |
}

leftTwo = \relative c' {
  \global
  \accidentalStyle modern
  R1 | R1 |
  R1 | R1 |
  r2 r8 \colorMusic #red {c,8 \jpb"Subject #4"#red d e | f8. g32 f e8 a d, g ~ g16 a g f}
}

\score {
  \new PianoStaff \with {
    instrumentName = "Klavier"
  } <<
    \new Staff = "right" \with {
      midiInstrument = "acoustic grand"
    } << \rightOne \\ \rightTwo >>
    \new Dynamics \dynamics
    \new Staff = "left" \with {
      midiInstrument = "acoustic grand"
    } { \clef bass << \leftOne \\ \leftTwo >> }
  >>
  \layout { }
  \midi {
    \tempo 4=100
  }
}
