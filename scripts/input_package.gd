class_name InputPackage
extends Node

var pressed_actions : Array[StringName] = []
var released_actions : Array[StringName] = []
var held_actions : Array[StringName] = []

var move_direction : Vector2 = Vector2.ZERO
var look_direction : Vector2 = Vector2.ZERO
var mouse_direction : Vector2 = Vector2.ZERO
