package main

import "core:math"
import rl "vendor:raylib"

// Window constants base on pixel game 16:9 ratio 
SCREEN_WIDTH :: 640
SCREEN_HEIGHT :: 360
TARGET_FPS :: 60

main :: proc() {
	rl.SetConfigFlags({.WINDOW_UNDECORATED})
	rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Drag Me Window")
	defer rl.CloseWindow()

	rl.SetTargetFPS(TARGET_FPS)
	rl.SetWindowPosition(rl.GetMonitorWidth(0) / 2, rl.GetMonitorHeight(0) / 2)

	world: World
	deck := get_entity(&world, "deck")
	world.color[deck] = rl.BLUE
	world.frame_box[deck] = rl.Rectangle({100, 100, CARD_WIDTH, CARD_HEIGHT})
	done := get_entity(&world, "done")
	world.color[done] = rl.RED
	world.frame_box[done] = rl.Rectangle({200, 100, CARD_WIDTH, CARD_HEIGHT})
	card := get_entity(&world, "card")
	world.color[card] = rl.PURPLE
	world.frame_box[card] = rl.Rectangle({300, 100, CARD_WIDTH, CARD_HEIGHT})
	waiting := get_entity(&world, "waiting")
	world.color[waiting] = rl.GRAY
	world.frame_box[waiting] = rl.Rectangle({0, SCREEN_HEIGHT - 100, SCREEN_WIDTH, 100})

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		defer rl.EndDrawing()

		rl.ClearBackground(rl.BLACK)
		handle_input(&world)
		render(&world)
	}
}
