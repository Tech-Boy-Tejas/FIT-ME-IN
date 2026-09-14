# FIT ME IN

A side-scrolling survival game built in Godot 4 where you don't die in one hit —
you die one piece at a time.

You control a blob drifting toward an endless run of pillars. Each pillar has a
gap, and no two gaps are the same shape. Whatever part of you doesn't fit through
the opening gets **cut off and left behind**. The game ends when there isn't
enough of you left to keep going.

---

## The idea

Flappy Bird asks one question: did you hit the pillar, yes or no. One mistake and
the run is over.

FIT ME IN replaces that with a slope. A bad line through a gap costs you 15% of
your body, and you carry that wound into every pillar that follows. You don't
lose because you made a mistake — you lose because of the mistakes you made
thirty seconds ago and never recovered from.

---

## Features

**Dynamic shape damage.** The blob isn't a sprite with a health value. It's a
live polygon, and every cut is a real boolean operation on its geometry. Your
health bar is literally your remaining surface area divided by what you started
with.

**Procedurally generated pillars.** No two are alike. Every pillar is built from
four random numbers — where the gap sits, how much it leans, how tall it is, and
how much it narrows between the entry and the exit. Gaps that pinch shut halfway
through are the ones that hurt.

**Endless scrolling.** Pillars are pooled and recycled. Only a handful of objects
ever exist, so the run can go forever without the memory footprint growing.

**Difficulty that ramps with progress, not time.** Speed, gap size, lean angle
and spacing all scale off your score, so surviving further is what makes it
harder — taking your time doesn't.

**Layered parallax background.** Clouds and birds at four depths, each scrolling
at its own rate.

**Original soundtrack.** A seamless 16-bar ambient loop written for the game —
deliberately calm, so the music stays composed while everything on screen falls
apart.

**Animated sprites.** Hand-built frame animations on the title and game over
screens.

**Score and high score tracking**, with a full menu flow between start screen,
gameplay and game over.

---

## Controls

| Input | Action |
|---|---|
| `Space` | Flap / start the run / restart after dying |

That's it. One button, like the genre demands.

The game waits on the start screen until your first press, so you're never
falling before you're ready.

---

## Running it

1. Open Godot 4
2. Import the project folder
3. Press F5

No external dependencies. No plugins.

---

## Built with

Godot 4 · GDScript

---
