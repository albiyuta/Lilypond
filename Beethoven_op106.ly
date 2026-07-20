\version "2.24.4"
\language "deutsch"

%%% ------------------------------------------------------- DEFINITIONS ---

% Custom bar line: double bar at the end of a line, repeat sign at the start
% of the next one.
\defineBarLine "||.|:" #'("||" ".|:" "||")

% Heading line of a tempo indication (slightly larger than the body text).
#(define-markup-command (headline layout props text) (markup?)
   (interpret-markup layout props #{ \markup \magnify #1.2 #text #}))

% Shift only the next pedal sign horizontally.
pedalShift =
#(define-music-function (dx) (number?)
   #{ \once \override Staff.SustainPedal.extra-offset = #(cons dx 0) #})

pdolce = #(make-dynamic-script
  #{ \markup \with-dimensions-from \dynamic p
       \line { \dynamic p \normal-text \italic \pad-x #0.3 "dolce" } #})

% Run of the first cadenza.
% Used as grace notes (\grace) in \layout, but as ordinary notes in \midi:
% grace notes under \cadenzaOn break MIDI timing, which makes the two hands
% drift apart after the cadenza.
% The dynamics (<, >, cresc.) live in the Dynamics context instead.
cadenzaRun = \relative gis' {
  \tuplet 5/2 {gis8[( e dis e gis)]} \tuplet 5/2 {h8[( gis fisis gis h)]} \override Stem.direction = #DOWN
  \tuplet 5/2 {e8[^( h ais h e)]} \tuplet 5/2 {gis8[^( e dis e gis)]} h_[^( fisis g h dis, e gis ais, h e
  \tempo \markup {
    \column {
      \medium "Nach und nach mehrere Saiten"
      \medium \italic "(Poco a poco tutte le corde)"
    }
  }
  fisis, gis h dis, e)]
  gis^[ e \change Staff = "left" h gis e] h16_[ gis e gis h e] gis^[ h \change Staff = "right" e]
}

% Dynamics laid over the run above. The durations sum to 65/16, which matches
% the total length of the run.
cadenzaDynamics = {
  s1*3/4                                              % quintuplets 1-3
  s1*3/4\<                                            % from the head of quintuplet 4
  s1*1/8\!                                            % ends on dis,
  s1*5/8\>                                            % from the following e
  s1*5/8\!                                            % ends on fisis,
  \crescTextCresc
  \once \override DynamicTextSpanner.style = #'none   % no dashed line after "cresc."
  s1*19/16\cresc                                      % final descending figure
}

% Pedalling for the run above.
%   s1*23/8  : release at the head of the run (gis8)
%   s1*19/16 : depress again on the e where the cresc. starts
cadenzaPedal = { s1*23/8\sustainOff s1*19/16\sustainOn }

%%% -------------------------------------------------------- RIGHT HAND ---

right = \relative c'' {
  <<
    \key a \minor
    \time 2/4
    \tempo \markup {
      \column {
        \headline "Langsam und sehnsuchtvoll"
        \medium \italic "Adagio, ma non troppo, con affetto"
      }
    }
    \relative {
      e'4 e16 \once \override TupletBracket.direction = #DOWN \tuplet 3/2 {f32 e dis} e16 c' | gis8.( h32 a) a8( e') |
      e8( d16 <cis e> <d f>8 <f, b>16 <e a>) | <gis e>8( a16 c e c h8) | h8( g' g c) | s2 | s2 |
      <g,, c g'>8 <a a'>16. <h h'>32 <h f' h>8_( <c e c'>16) \override Rest.staff-position = #0 r16 |
      \once \override MultiMeasureRest.staff-position = #0 R2 | g'4 g16( \tuplet 3/2 {a32 g fis} s16 s16) | s2 |
      s2 | s2 | s4 s8 <fis a dis>16 r16 | s4 s8 <e g cis>16 r16 | s4 s8 <d f h>16 r16 | s2 |
      <e c' e>8_( <d h'_~ d^~> <d h' d>16 <c a' c>8 <c a' c>16) | <cis_~ d_~ fis~ a~ c~>4 <cis d fis a c>16 <cis d fis a c>^( <d fis a> <e gis>) |
    }
    \\
    \relative {
      h8( d) c4 | e4 e8 e | <a~ e>8 <a d,>16 <g e> <a f>8 b,16 c | d8 <e c> <e c'>16 a gis g |
      <g e>8 <h f> <c e g> <e c g'> | <c f c'>8 <f c' f> <f h d f>8. \noBeam \change Staff = "left" \once \override Stem.direction = #UP <h,, f d>16 |
      \change Staff = "right" s2 | s8 f'8 s4 | s2 | d8( f) e g16 <e' g e'>^( | <h d h'>8[ <d f d'> <c e c'>]) \override Rest.staff-position = #0 r8 |
      g'16^( \tuplet 3/2 {a32 g fis} g16 e') e4 | g,16^( \tuplet 3/2 {a32 g fis} g16 e') e8.^( g,16) |
      g8~^( g32 \tuplet 3/2 {a64 g fis} g32 e') e16^( <c dis fis,>) s8 |
      \grace { \temporary \override Stem.direction = #UP f,,32 h d \revert Stem.direction } f8~^( f32 \tuplet 3/2 {g64 f e} f32 d') d16^( <e, g b cis>) s8 |
      \once \override Stem.direction = #UP \grace dis,32 dis'8^~^( dis32 \tuplet 3/2 {h'64 a gis}) \tuplet 3/2 {a32^( c, c')} c16^( <d, g h>) s8 |
      <h gis' h>8 <h~ d^~ h'>^( <h d h'>16 <a c a'>) <e c' e>^.^( <e c' e>^.) | s2 | s2 |
    }
  >>
  \cadenzaOn
  <<
    { \voiceOne <e, gis~>4\fermata }
    \new Voice { \voiceTwo \change Staff = "left" \once \override Stem.direction = #UP <gis, h>4 }
  >>
  \oneVoice
  \tempo \markup {\medium \italic "non presto"}
  \tag #'layout \grace \cadenzaRun
  \tag #'midi \cadenzaRun
  \cadenzaOff
  % \cadenzaRun is a self-contained \relative block, so restore the reference
  % pitch for what follows to the last note of the run.
  \resetRelativeOctave e'
  % In \midi the run consumes real time, so reset the position within the
  % measure to keep the following bar checks aligned.
  \tag #'midi \set Timing.measurePosition = #(ly:make-moment 0)
  \bar "||"
  \break
  <<
    \key a \major
    \time 6/8
    \tempo \markup {
      \column {
        \headline "Zeitmaß des ersten Stückes"
        \medium \italic "Tempo del primo pezzo: tutto il Cembalo, ma piano"
        \medium \magnify #0.9 "Alle Saiten"
      }
    }
    \relative {gis'4( a8 h4 cis8 | e4 d8 h) s8\fermata a8( | a'4 gis8 fis4 e8 | fis4) e8 e cis h |
               s4\fermata e8 e( cis h) |
    }
    \\
    \relative {e'8 h fis' gis e a~ | a fis h gis \override Rest.staff-position = #0 r8 a8~ |
               a a4~ a8 a4~ | a8 a4~ a8 e e | r4 \override Rest.staff-position = #-2 r8 e4. |
    }
  >>
  \stemDown
  r8 r8 fis'8^\markup \italic "stringendo" <fis, fis'>( d' cis) | <a a'>8( fis' e) <cis cis'>( a' gis) |
  \break
  \tempo \markup \headline "Presto"
  \cadenzaOn <e e'>32[ dis' d cis h a gis fis e] d2\trill\fermata dis\trill\fermata \grace dis16 \once \override Script.outside-staff-priority = #500 e2~\startTrillSpan^\fermata \cadenzaOff \bar "||"
  \time 2/4
  \set Score.currentBarNumber = #9
  \tempo \markup {
    \column {
      \headline "Geschwinde, doch nicht zu sehr, und"
      \line {
        \medium \italic "Allegro"
        \hspace #5
        \headline "mit Entschlossenheit"
      }
    }
  }
  e2~ | e2~ | e2~ | e4.\stopTrillSpan <e gis h e>8-. \break
  \repeat volta 2 \bar "||.|:"
  <cis e a cis>4~ <cis e a cis>16 d' e fis | <h,, h'>4 r8 <e e'>8-.
}

%%% ----------------------------------------------------------- DYNAMICS ---

dynamics = {
  \time 2/4
  s2_\markup {
    \column {
      \medium \upright "Mit einer Saite"
      \italic \magnify #0.9 "Sul una corda"
    }
  }
  s2 s2 s2 s2 s2 s2 s2 s2 s2 s2 s2 s2 s2 s2 s2 s2 s2 s2
  \cadenzaOn
  s4\p
  \tag #'layout \grace \cadenzaDynamics
  \tag #'midi \cadenzaDynamics
  \cadenzaOff
  \time 6/8
  s2.\pdolce        % m1
  s2. s2. s2. s2.   % m2-5
  \override DynamicTextSpanner.dash-fraction = #0.1
  s4 s8\cresc s4.   % m6: cresc from beat 3
  s2.               % m7 (cresc continues to Presto)
  \cadenzaOn
  s32\f\> s32 s32 s32 s32 s32 s32 s32 s32   % Presto run: f + decresc
  s2\p                                      % d2: p (ends decresc)
  s2                                        % dis2
  \once \override TextScript.extra-offset = #'(-2 . 0)
  s2_\markup { \italic "cresc." }           % e2: cresc.
  \cadenzaOff
  s4 s8 s8\f s2 s2 s4 s8 s8\f
  s2\sf
}

%%% --------------------------------------------------------- LEFT HAND ---

left = \relative c' {
  \key a \minor
  \time 2/4
  \relative {
    <gis,, gis'>8( <h h'>8 <a a'>4) | <h h'>8( <d d'> <c c'> <a a'>) | <f' f'>8.( <e e'>16 <d d'>8. <c c'>16) |
    <h h'>8( <a a'> e'4) | <e e'>8( <d d'> <c c'> <b b'> | <a a'>8 <as as'> <g g'>4) |
  }
  <<
    \relative {
      <d f h>8( <e g cis> <f a d> <g c>16 <g h>) | e8 d <g, d'>_( <c, c'>16) \override Rest.staff-position = #0 r16 |
      g'4 g16_( \tuplet 3/2 {a32 g fis} g16 e') | g4 g | s2 | s2 | s2 | s4 fis16 a c dis\sustainOn |
      \pedalShift #-4 s4\sustainOff e,16 g b cis\sustainOn |
      \pedalShift #-4 s4\sustainOff d,16 f gis h\sustainOn |
      \pedalShift #-1 d,16\sustainOff e gis h c, e gis a |
      h,16 d e gis a, c dis e | fis,16\sustainOn a c dis fis a c h\sustainOff |
    }
    \\
    \relative {
      <g,, g'>4. <g' e'>16( <f d'>) | e8( d16 g) s4 | s2 | h8( d) c4 | g'4 g16^( \tuplet 3/2 {a32 g fis} g16 e') |
      \once \override Stem.direction = #UP \grace c,32 e'4 g,16^( \tuplet 3/2 {a32 g fis} g16 e') |
      \once \override Stem.direction = #UP \grace h,32 e'4 g,16^( \tuplet 3/2 {a32 g fis} g16 e') |
      \once \override Stem.direction = #UP \grace ais,,32 e''16 cis ais g a,8 s8 |
      \once \override Stem.direction = #UP \grace gis32 d''16 h gis f g,8 s8 |
      \once \override Stem.direction = #UP \grace fis32 c''16 a fis dis f,8 s8 |
      e8 s8 e8 s8 | e8 s8 e8 s8 | e4~ e8. <e gis h e>16 |
    }
  >>
  \cadenzaOn
  \once \override Stem.direction = #DOWN <e,, gis h e>4_\fermata\sustainOn
  \tag #'layout \grace \cadenzaPedal
  \tag #'midi \cadenzaPedal
  \cadenzaOff
  <<
    \key a \major
    \time 6/8
    \relative {e4 dis8 d4 cis8 | h4. e8 \override Rest.staff-position = #0 r8\fermata r8 |
               fis'4 e8 d4 cis8 | cis4. cis8 a gis | r4\fermata cis8~( cis a gis) |
    }
    \\
    \relative {e,2.~ | e4. e8 s8 s | \override Rest.staff-position = #0 r4 r8 a'4. | cis,4 d8 e4. |
               s4 r8 e4. |
    }
  >>
  r8 r8 d''8~( d h a) \clef treble | fis'8( d cis) a'( fis e) |
  \cadenzaOn <e gis h d>4 s32 r4\fermata s4 s2 s2 \cadenzaOff
  r4 r8 <e gis h d>8-. \clef bass | <e, gis h d>4-. r4 | r4 r8 <e gis h d>8-. | <e, gis h d>4-. r8 <e e'>8 ||
  <a a'>8 \noBeam \clef treble <h' h'>8-. <a a'>4~ | <a a'>16 h cis d gis,4 \clef bass |
}

%%% ------------------------------------------------------------ OUTPUT ---

% To label the staff, add instrumentName = "Piano" to the PianoStaff via \with { }.
piano = \new PianoStaff <<
  \new Staff = "right" \with {
    midiInstrument = "acoustic grand"
  } \right
  \new Dynamics \dynamics
  \new Staff = "left" \with {
    midiInstrument = "acoustic grand"
  } { \clef bass \left }
>>

\score {
  \keepWithTag #'layout \piano
  \layout {
    indent = 0
    ragged-last = ##f
    \context {
      \Score
      % Hide the tuplet brackets and show the numbers only.
      \override TupletBracket.bracket-visibility = ##f
      % Tighten the leading of multi-line \column markup (default is 3).
      \override MetronomeMark.baseline-skip = #2
      \override TextScript.baseline-skip = #2
    }
    \context {
      \Staff
      % Print an unbracketed natural when an accidental appears in another octave
      % within the same measure.
      \accidentalStyle "modern"
    }
  }
}

\score {
  \keepWithTag #'midi \piano
  \midi {
    \tempo 4=100
  }
}
