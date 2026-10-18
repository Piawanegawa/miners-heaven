# Räumliche Tiefe für die Minenansicht

**Datum:** 2026-10-18  
**Status:** Vom Nutzer bestätigt; Prototyp-Design, keine Implementierung

## Ziel

Die Minenansicht soll sich visuell in Richtung Stardew Valley bewegen, ohne das vorhandene quadratische Bewegungsraster aufzugeben. Die Räumlichkeit soll aus 3/4-Pixelgrafik, sichtbaren Vorderseiten und einer glaubwürdigen Zeichenreihenfolge entstehen. Die Spielfigur soll klar auf dem Boden stehen und vor oder hinter hohen Objekten vorbeilaufen können.

## Ausgangspunkt

Das Projekt hat eine Godot-4-Minenszene mit kontinuierlicher Bewegung in acht Richtungen, einem `CharacterBody2D` mit quadratischem Platzhalter und einer direkt folgenden Kamera bei 2x Zoom. Es gibt noch keine Blickrichtungsanimation oder Y-Sortierung. Bewegungsregeln liegen getrennt von der Präsentation in `scripts/gameplay/player_movement.gd`; `scripts/presentation/player_controller.gd` liest die Eingabe und bewegt den Körper.

## Entwurf

Das Bewegungsraster und die Kameraperspektive bleiben zunächst bestehen. Beim Spieler wird die Grafik vom Physikkörper getrennt: Ein Sprite-Knoten erhält den Ursprung an den Füßen, während der `CharacterBody2D` und eine kompakte Kollisionsfläche die Bewegung und Hindernisse behandeln. Eine 3/4-Figur mit Vorder-, Rück- und Seitenansichten macht die Blickrichtung lesbar, ohne Bewegungsnormalisierung oder Rasterkoordinaten zu verändern.

Boden und flache Details werden unterhalb einer gemeinsamen Y-Sort-Ebene gezeichnet. Spielfigur und hohe Objekte teilen sich diese Ebene. Der Sortierursprung eines Objekts liegt am Bodenkontakt oder Sockel, nicht in der Bildmitte; die hohe Grafik ist ein Kind dieses Ursprungs. So kann die Figur beim Weg nach oben hinter einem Felsen und beim Weg nach unten davor erscheinen. Große Strukturen können später zusätzlich eine Vordergrundgrafik verwenden.

## Erster Prototyp

Erprobe den Stil in der bestehenden Minenszene mit Boden, der Figur, einem hohen Felsen und einem Erzobjekt. Die Figur läuft am Felsen sowohl oberhalb als auch unterhalb vorbei. Die bestehende Bewegung und Kamera bleiben dabei erhalten. Der Prototyp soll die visuelle Lesbarkeit bestätigen, bevor weitere Weltgrafiken erstellt werden.

## Prüfkriterien

- Die Figur wirkt beim Laufen sichtbar auf dem Boden verankert.
- Beim Vorbeilaufen wechselt die Überdeckung am Bodenursprung korrekt zwischen vor und hinter dem Felsen.
- Die Kollisionsfläche bleibt am Fußbereich kompakt und blockiert weiterhin an der physischen Objektfläche.
- Die vorhandene Bewegungslogik und ihr Verhalten bleiben unverändert.
- Die Ansicht wird in der laufenden Godot-Szene visuell geprüft; die Sortierung lässt sich nicht allein durch einen Headless-Ladecheck beurteilen.

## Umfang und offene Details

Dieser Prototyp ändert weder das Raster noch die Bewegungsart oder die Kameraverfolgung. Er führt keine weiteren Spielsysteme ein. Pixelgrafiken können zunächst Platzhalter sein; konkrete Maße und Animationen werden beim Einbau der ersten Figur und des Felsens festgelegt.
