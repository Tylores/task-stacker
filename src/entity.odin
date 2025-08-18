package main

import "core:fmt"
import "core:time"
import rl "vendor:raylib"

CARD_WIDTH :: 25
CARD_HEIGHT :: 35
Entity :: u32
MAX_ENTITIES: Entity : 20

World :: struct {
	tag_map:     map[string]Entity,
	name_map:    map[Entity]string,
	is_dragging: bool,
	active:      [MAX_ENTITIES]bool,
	frame_box:   [MAX_ENTITIES]rl.Rectangle,
	rotation:    [MAX_ENTITIES]f32,
	color:       [MAX_ENTITIES]rl.Color,
	dragging:    [MAX_ENTITIES]bool,
	holding:     [MAX_ENTITIES]bool,
	working:     [MAX_ENTITIES]bool,
}

cleanup :: proc(using ecs: ^World) {
	clear(&tag_map)
	clear(&name_map)
	for e in 0 ..< len(active) {
		active[e] = false
	}

}

get_entity :: proc(using ecs: ^World, tag: string) -> Entity {
	for i in 0 ..< len(active) {
		e := Entity(i)
		if !active[e] {
			active[e] = true
			tag_map[tag] = e
			name_map[e] = tag
			return e
		}
	}
	return MAX_ENTITIES
}

handle_input :: proc(using ecs: ^World) {
	mouse_pos := rl.GetMousePosition()
	if rl.IsKeyPressed(rl.KeyboardKey.N) {
		t := time.now()
		tag := fmt.tprintf("card_%d", time.to_unix_nanoseconds(t))
		fmt.println(tag)

		card := get_entity(ecs, tag)
		ecs.color[card] = rl.PURPLE
		ecs.frame_box[card] = rl.Rectangle({mouse_pos.x, mouse_pos.y, CARD_WIDTH, CARD_HEIGHT})
	}
	for i in 0 ..< len(active) {
		e := Entity(i)
		if !active[e] {
			continue
		}

		if !is_dragging &&
		   rl.IsMouseButtonDown(rl.MouseButton.LEFT) &&
		   rl.CheckCollisionPointRec(mouse_pos, frame_box[e]) {
			is_dragging = true
			dragging[e] = true
		}

		if is_dragging && dragging[e] {
			frame_box[e].x = mouse_pos.x - CARD_WIDTH / 2
			frame_box[e].y = mouse_pos.y - CARD_HEIGHT / 2
		} else {
			if !rl.IsMouseButtonDown(rl.MouseButton.LEFT) {
				dragging[e] = false
				is_dragging = false
			}
		}
	}
}

render :: proc(using ecs: ^World) {
	player := tag_map["player"]
	for i in 0 ..< len(active) {
		e := Entity(i)
		if !active[e] {
			continue
		}
		rl.DrawRectanglePro(frame_box[e], {0, 0}, rotation[e], color[e])
	}
}
