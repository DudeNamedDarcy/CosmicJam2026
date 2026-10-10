extends Node2D
class_name OrbitManager

@export_group("Radial Movement")

## Objects will settle into an orbit around this radius.
@export var orbit_radius: float = 25.0

## Controls how strongly the object moves toward or away from the target orbit radius.
@export var radial_gain: float = 3.0

## Maximum speed at which the object can move inward toward the center.
@export var max_inward_speed: float = 100.0

## Maximum speed at which the object can move outward from the center.
## Helps prevent objects from drifting too far inward.
@export var max_outward_speed: float = 40.0

@export_group("Swirling Movement")

## Tangential speed when the object is far from the vortex center.
@export var outer_swirl_speed: float = 50.0

## Tangential speed when the object is close to the vortex center.
@export var inner_swirl_speed: float = 220.0

## Distance over which the swirl speed transitions from the outer speed to the inner speed.
@export var swirl_range: float = 300.0
