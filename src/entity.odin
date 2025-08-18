package main

import "core:fmt"
import rl "vendor:raylib"

Entity :: u32
MAX_ENTITIES: Entity : 20

World :: struct {
	tag_map:   map[string]Entity,
	name_map:  map[Entity]string,
	active:    [MAX_ENTITIES]bool,
	frame_box: [MAX_ENTITIES]rl.Rectangle,
	rotation:  [MAX_ENTITIES]f32,
	color:     [MAX_ENTITIES]rl.Color,
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
