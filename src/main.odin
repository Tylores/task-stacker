package main

import "core:math"
import rl "vendor:raylib"

// Window constants base on pixel game 16:9 ratio 
SCREEN_WIDTH :: 640
SCREEN_HEIGHT :: 360
TARGET_FPS :: 60


WindowState :: struct {
	position:      rl.Vector2,
	is_dragging:   bool,
	last_position: rl.Vector2,
	window_center: rl.Vector2,
}

main :: proc() {

	rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Drag Me Window")
	defer rl.CloseWindow()

	rl.SetWindowState({.WINDOW_UNDECORATED})
	rl.SetTargetFPS(TARGET_FPS)

	state := WindowState {
		position = {
			f32(rl.GetMonitorWidth(0) / 2 - SCREEN_WIDTH / 2),
			f32(rl.GetMonitorHeight(0) / 2 - SCREEN_HEIGHT / 2),
		},
	}
	state.last_position = state.position
	state.window_center = {f32(SCREEN_WIDTH) / 2, f32(SCREEN_HEIGHT) / 2}

	rl.SetWindowPosition(i32(state.position.x), i32(state.position.y))


	for !rl.WindowShouldClose() {
		if rl.IsMouseButtonPressed(.LEFT) {
			state.is_dragging = true
			state.last_position = state.position
		}

		if state.is_dragging {
			mouse_pos := rl.GetMousePosition()

			state.position = {f32(mouse_pos.x), f32(mouse_pos.y)}

			// Recenter the mouse
			if !rl.IsMouseButtonDown(.LEFT) {
				state.is_dragging = false
			}
		}

		// Rendering
		rl.BeginDrawing()
		defer rl.EndDrawing()

		rl.ClearBackground(rl.BLANK)
		new_x := i32(state.position.x)
		new_y := i32(state.position.y)
		rl.DrawRectangle(0, SCREEN_HEIGHT - 70, SCREEN_WIDTH, 70, rl.GRAY)
		rl.DrawRectangle(0, 0, 50, SCREEN_HEIGHT, rl.GREEN)
		rl.DrawRectangle(SCREEN_WIDTH - 50, 0, 50, SCREEN_HEIGHT, rl.RED)
		rl.DrawRectangle(new_x, new_y, 25, 35, rl.PURPLE)
	}
}
