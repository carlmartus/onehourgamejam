local time, distance, speed_mul
local particles, part_spawn
local player_x, player_y
local deb, deb_spawn
local realive = 0

local action

function _init()
	start_game()
end

function _update60()
	if action == false then
		realive += 1
		if realive > 200 then
			realive = 0
			start_game()
		end
		return
	end

	time += 1
	speed_mul = get_speed()
	distance += speed_mul
	upd_particles()
	upd_deb()

	if btn(0) then
		player_x -= 1
	elseif btn(1) then
		player_x += 1
	end
end

function _draw()
	if action then
		draw_scene()
	end
end

-- start

function start_game()
	sfx(5)
	time = 0
	distance = 0
	particles = {}
	deb = {}
	part_spawn = 0
	deb_spawn = 0
	speed_mul = 0
	player_x = 64
	player_y = 100
	action = true
end

-- particles

function make_particle()
	return {
		x=rnd(127),
		y=0
	}
end

function upd_particles()
	local part = flr(distance / 4)
	if part >  part_spawn then
		add(particles, make_particle())
		part_spawn = part
	end

	for p in all(particles) do
		p.y += speed_mul
		if p.y > 127 then
			del(particles, p)
		end
	end
end

function draw_particles()
	for p in all(particles) do
		pset(p.x, p.y, 7)
	end
end

-- debries

function make_deb()
	return {
		x = rnd(127),
		y = 0,
		s = 16 + flr(rnd(4))
	}
end

function upd_deb()
	for d in all(deb) do
		d.y += speed_mul

		if
			(player_x > d.x-5) and
			(player_x < d.x + 7) and
			(player_y > d.y-5) and
			(player_y < d.y + 7) then
			kill()
		end

		if d.y > 127 then
			del(deb, d)
		end
	end

	local part = flr(distance / 16)
	if part >  deb_spawn then
		add(deb, make_deb())
		deb_spawn = part
	end
end

function draw_deb()
	for d in all(deb) do
		spr(d.s, d.x, d.y)
	end
end

-- game state

function draw_scene()
	cls(12)
	draw_particles()
	draw_deb()
	spr(1, player_x, player_y)
	print("score: " .. time, 0, 0, 9)
end

function get_speed()
	local a = 1.2 - abs(player_x - 63) / 64
	return time * 0.002 + 1.4 * a
end

function kill()
	action = false
	spr(2, player_x, player_y)
	sfx(6)
end

