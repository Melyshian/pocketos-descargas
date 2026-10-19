--[[
    ============================================================
    Hospital Corazón 🏥 — Instalador (Plugin de Roblox Studio)
    ------------------------------------------------------------
    CÓMO USARLO (solo una vez):
      1. Copia este archivo a tu carpeta de plugins:
         %LOCALAPPDATA%\\Roblox\\Plugins\\
         (En tu PC: abre el Explorador de Windows, pega arriba
         %LOCALAPPDATA%\\Roblox\\Plugins y presiona Enter.
         Si la carpeta Plugins no existe, créala tú.)
      2. Cierra y vuelve a abrir Roblox Studio.
      3. Arriba verás la pestaña "Hospital Corazón 🏥" con el botón
         "Instalar todo". Tócalo con tu lugar abierto.
      4. ¡Listo! Crea los 13 scripts y los 8 RemoteEvents en sus
         lugares. El Config NO se toca si ya existe (así no
         pierdes tus IDs de pases y productos).
    ============================================================
]]

local toolbar = plugin:CreateToolbar("Hospital Corazón \u{1F3E5}")
local boton = toolbar:CreateButton(
    "Instalar todo",
    "Crea los 13 scripts y 8 RemoteEvents del juego Hospital Corazón",
    ""
)

local function destino(nombre)
    if nombre == "ReplicatedStorage" then
        return game:GetService("ReplicatedStorage")
    elseif nombre == "ServerScriptService" then
        return game:GetService("ServerScriptService")
    elseif nombre == "StarterGui" then
        return game:GetService("StarterGui")
    end
end

local ARCHIVOS = {
    { archivo = "Config.luau", nombre = "Config", clase = "ModuleScript",
      servicio = "ReplicatedStorage", preservar = true,
      codigo = [===[
--[[
    ============================================================
    Config (ModuleScript)
    DÓNDE VA: ReplicatedStorage
    Cómo crearlo a mano: clic derecho en ReplicatedStorage
    → Insert Object → ModuleScript → llámalo "Config".
    ------------------------------------------------------------
    ⚠️ ESTE ES EL ÚNICO ARCHIVO DONDE DEBES CAMBIAR COSAS.
    Aquí van tus IDs de pases y productos de Robux (cuando los
    crees en la web de Roblox). Mientras un ID sea 0, ese botón
    dirá "Próximamente 💤" en la tienda del juego.
    Los 30 trabajos están aquí con su sueldo y su posición.
    ============================================================
]]

local Config = {}

-- 👤 TU USUARIO DE ROBLOX (ya viene el tuyo).
Config.ADMIN_USERNAME = "Melyshian" -- << tu usuario, sin @

-- 💼 LOS 30 TRABAJOS: nombre, sueldo por tarea, zona y posición del pad.
-- Cada 20 tareas subes de nivel (máx 5): +20% de sueldo por nivel.
-- Cooldown entre tareas: 6 segundos.
Config.TRABAJOS = {
	-- 🏥 Hospital (8)
	{ nombre = "Médico",         sueldo = 80,  zona = "Hospital",   pos = {-20, 1.6, -70} },
	{ nombre = "Enfermera",      sueldo = 60,  zona = "Hospital",   pos = {-10, 1.6, -70} },
	{ nombre = "Cirujano",       sueldo = 120, zona = "Hospital",   pos = {20, 10.6, -80}, vip = true },
	{ nombre = "Paramédico",      sueldo = 70,  zona = "Hospital",   pos = {30, 1.6, -52} },
	{ nombre = "Recepcionista",   sueldo = 40,  zona = "Hospital",   pos = {0, 1.6, -58} },
	{ nombre = "Farmacéutico",    sueldo = 55,  zona = "Hospital",   pos = {-28, 1.6, -85} },
	{ nombre = "Limpieza",        sueldo = 35,  zona = "Hospital",   pos = {10, 1.6, -60} },
	{ nombre = "Camillero",       sueldo = 45,  zona = "Hospital",   pos = {24, 1.6, -66} },
	-- 🍔 McCorazón (3)
	{ nombre = "Cocinero",        sueldo = 50,  zona = "McCorazón",     pos = {94, 1.6, 12} },
	{ nombre = "Cajero",          sueldo = 45,  zona = "McCorazón",     pos = {86, 1.6, 12} },
	{ nombre = "Repartidor",      sueldo = 65,  zona = "McCorazón",     pos = {90, 0.6, 24} },
	-- 🐾 Veterinaria (2)
	{ nombre = "Veterinario",     sueldo = 75,  zona = "Veterinaria", pos = {-90, 1.6, 10}, vip = true },
	{ nombre = "Cuidador de mascotas", sueldo = 40, zona = "Veterinaria", pos = {-96, 1.6, 10} },
	-- 🏙️ Ciudad (9)
	{ nombre = "Taxista",         sueldo = 60,  zona = "Ciudad",     pos = {-40, 0.6, -14} },
	{ nombre = "Conductor de bus", sueldo = 55, zona = "Ciudad",     pos = {40, 0.6, -14} },
	{ nombre = "Policía",         sueldo = 70,  zona = "Ciudad",     pos = {-20, 0.6, -14} },
	{ nombre = "Bombero",         sueldo = 75,  zona = "Ciudad",     pos = {20, 0.6, -14} },
	{ nombre = "Panadero",        sueldo = 50,  zona = "Ciudad",     pos = {-50, 0.6, 60} },
	{ nombre = "Barista",         sueldo = 45,  zona = "Ciudad",     pos = {-44, 0.6, 60} },
	{ nombre = "Florista",        sueldo = 40,  zona = "Ciudad",     pos = {44, 0.6, 100} },
	{ nombre = "Peluquero",       sueldo = 55,  zona = "Ciudad",     pos = {50, 0.6, 60} },
	{ nombre = "Mecánico",        sueldo = 60,  zona = "Ciudad",     pos = {30, 0.6, 60} },
	-- 🌾 Campo y parque (4)
	{ nombre = "Agricultor",      sueldo = 45,  zona = "Campo",      pos = {-130, 0.6, -50} },
	{ nombre = "Pescador",        sueldo = 50,  zona = "Campo",      pos = {-118, 0.6, -38} },
	{ nombre = "Leñador",         sueldo = 45,  zona = "Campo",      pos = {-142, 0.6, -62} },
	{ nombre = "Jardinero",       sueldo = 40,  zona = "Parque",     pos = {60, 0.6, 110} },
	-- 🎪 Tianguis (4)
	{ nombre = "Vendedor de ropa",   sueldo = 55, zona = "Tianguis", pos = {-84, 0.6, 104} },
	{ nombre = "Vendedor de comida", sueldo = 50, zona = "Tianguis", pos = {-70, 0.6, 104} },
	{ nombre = "Vendedor de arte",   sueldo = 60, zona = "Tianguis", pos = {-56, 0.6, 104} },
	{ nombre = "Músico",             sueldo = 45, zona = "Tianguis", pos = {-70, 0.6, 118} },
}
-- Debe haber exactamente 30. Si agregas o quitas uno, el juego lo nota solo.
assert(#Config.TRABAJOS == 30, "Config: debe haber 30 trabajos, hay " .. #Config.TRABAJOS)

Config.TAREAS_POR_NIVEL = 20  -- tareas para subir de nivel
Config.NIVEL_MAX = 5          -- nivel máximo por trabajo
Config.BONUS_POR_NIVEL = 0.2  -- +20% de sueldo por nivel
Config.COOLDOWN_TRABAJO = 6   -- segundos entre tareas
Config.XP_CURAR_DOCTOR = 50   -- lo que gana el doctor por curar
Config.XP_CURAR_ENFERMERA = 30

-- 🏠 CASAS: precio y posiciones (las construye el WorldBuilder).
Config.PRECIO_CASA = 5000
Config.CASAS = { "Casa1", "Casa2", "Casa3", "Casa4", "Casa5", "Casa6" }

-- 🎪 TIANGUIS: renta del local (dura toda la sesión y se guarda).
Config.RENTA_LOCAL = 500
Config.IMPUESTO_VENTA = 0.10 -- 10% de impuesto, el dueño recibe el 90%
Config.ARTICULOS_TIANGUIS = { "Ropa 👕", "Comida 🍎", "Flor 🌸", "Cuadro 🖼️", "Juguete 🧸", "Sombrero 🎩" }

-- 🍔 MCCORAZÓN: precios y curación.
Config.HAMBURGUESA = { precio = 30, cura = 40, nombre = "Hamburguesa 🍔" }
Config.PAPAS = { precio = 15, cura = 20, nombre = "Papas 🍟" }

-- 💰 PASES DE ROBUX (pon aquí los IDs que te da la web de Roblox).
Config.GAMEPASS_2X_ID   = 0 -- 💰 2x sueldo en todos los trabajos, para siempre
Config.GAMEPASS_VIP_ID  = 0 -- ⭐ Cirujano y Veterinario pagan el DOBLE
Config.GAMEPASS_CASA_ID = 0 -- 🏠 Casa dorada exclusiva

-- 🛒 PRODUCTOS DE ROBUX (se pueden comprar muchas veces).
Config.DEVPRODUCT_DINERO_1 = 0 -- 10,000 monedas
Config.DEVPRODUCT_DINERO_2 = 0 -- 50,000 monedas

-- No toques nada debajo de esta línea.
return Config
]===] },
    { archivo = "HospitalState.luau", nombre = "HospitalState", clase = "ModuleScript",
      servicio = "ServerScriptService", preservar = false,
      codigo = [===[
--[[
    ============================================================
    HospitalState (ModuleScript)
    DÓNDE VA: ServerScriptService
    ------------------------------------------------------------
    Estado compartido del juego: dinero, niveles de trabajo,
    casas, roles, guardado (DataStore) y pases de Robux.
    Los demás scripts lo usan con:
        local State = require(game.ServerScriptService.HospitalState)
    ============================================================
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local DataStoreService = game:GetService("DataStoreService")

local Config = require(ReplicatedStorage:WaitForChild("Config"))

local State = {}
State.datos = {}       -- [player] = { dinero, niveles = { [trabajo] = {nivel, xp} }, casa, rol }
State.paseCache = {}   -- [userId_passId] = true/false

local tienda = nil
pcall(function()
	tienda = DataStoreService:GetDataStore("HospitalCorazonV1")
end)
if not tienda then
	warn("[Hospital] DataStore no disponible (en Studio activa 'Enable Studio Access to API Services'). El progreso no se guardará en esta prueba.")
end

-- Crea (o devuelve) un RemoteEvent en ReplicatedStorage.
function State.getEvent(nombre)
	local ev = ReplicatedStorage:FindFirstChild(nombre)
	if not ev then
		ev = Instance.new("RemoteEvent")
		ev.Name = nombre
		ev.Parent = ReplicatedStorage
	end
	return ev
end

function State.aviso(player, texto)
	State.getEvent("Aviso"):FireClient(player, texto)
end

function State.hud(player)
	local d = State.datos[player]
	if not d then return end
	State.getEvent("HudRefresh"):FireClient(player, {
		dinero = d.dinero,
		rol = d.rol or "—",
		trabajo = d.ultimoTrabajo or "—",
		nivel = d.ultimoNivel or 0,
	})
end

function State.nuevoDato()
	return { dinero = 0, niveles = {}, casa = nil, rol = nil,
	         ultimoTrabajo = nil, ultimoNivel = 0 }
end

function State.cargar(player)
	local d = State.nuevoDato()
	if tienda then
		local ok, guardado = pcall(function()
			return tienda:GetAsync("jugador_" .. player.UserId)
		end)
		if ok and type(guardado) == "table" then
			d.dinero = tonumber(guardado.dinero) or 0
			d.niveles = type(guardado.niveles) == "table" and guardado.niveles or {}
			d.casa = guardado.casa
			d.rol = guardado.rol
		end
	end
	State.datos[player] = d
	-- leaderstats
	local ls = Instance.new("Folder")
	ls.Name = "leaderstats"
	local dinero = Instance.new("IntValue")
	dinero.Name = "Dinero"
	dinero.Value = d.dinero
	dinero.Parent = ls
	ls.Parent = player
	State.hud(player)
end

function State.guardar(player)
	local d = State.datos[player]
	if not d or not tienda then return end
	pcall(function()
		tienda:SetAsync("jugador_" .. player.UserId, {
			dinero = d.dinero,
			niveles = d.niveles,
			casa = d.casa,
			rol = d.rol,
		})
	end)
end

function State.darDinero(player, cantidad, motivo)
	local d = State.datos[player]
	if not d then return end
	cantidad = math.floor(cantidad)
	d.dinero += cantidad
	local ls = player:FindFirstChild("leaderstats")
	if ls then
		local v = ls:FindFirstChild("Dinero")
		if v then v.Value = d.dinero end
	end
	if motivo then
		State.aviso(player, "+$" .. cantidad .. "  " .. motivo)
	end
	State.hud(player)
end

function State.quitarDinero(player, cantidad)
	local d = State.datos[player]
	if not d or d.dinero < cantidad then return false end
	d.dinero -= cantidad
	local ls = player:FindFirstChild("leaderstats")
	if ls then
		local v = ls:FindFirstChild("Dinero")
		if v then v.Value = d.dinero end
	end
	State.hud(player)
	return true
end

-- XP de trabajo: cada 20 tareas sube de nivel (máx 5). Devuelve el nivel actual.
function State.sumarTarea(player, trabajo)
	local d = State.datos[player]
	if not d then return 1 end
	local n = d.niveles[trabajo]
	if not n then
		n = { nivel = 1, xp = 0 }
		d.niveles[trabajo] = n
	end
	n.xp += 1
	if n.xp >= Config.TAREAS_POR_NIVEL and n.nivel < Config.NIVEL_MAX then
		n.nivel += 1
		n.xp = 0
		State.aviso(player, "🎉 ¡Nivel " .. n.nivel .. " en " .. trabajo .. "! +20% de sueldo")
	end
	d.ultimoTrabajo = trabajo
	d.ultimoNivel = n.nivel
	return n.nivel
end

function State.getNivel(player, trabajo)
	local d = State.datos[player]
	if not d then return 1 end
	local n = d.niveles[trabajo]
	return n and n.nivel or 1
end

function State.multNivel(nivel)
	return 1 + Config.BONUS_POR_NIVEL * (nivel - 1)
end

-- ¿Tiene el pase de Robux? (con caché y pcall; si el ID es 0 = no existe)
function State.tienePase(player, passId)
	if passId == 0 then return false end
	local clave = player.UserId .. "_" .. passId
	if State.paseCache[clave] ~= nil then
		return State.paseCache[clave]
	end
	local ok, tiene = pcall(function()
		return MarketplaceService:UserOwnsGamePassAsync(player.UserId, passId)
	end)
	State.paseCache[clave] = ok and tiene or false
	return State.paseCache[clave]
end

-- Autoguardado cada 2 minutos.
function State.iniciarGuardado()
	task.spawn(function()
		while true do
			task.wait(120)
			for _, p in ipairs(Players:GetPlayers()) do
				State.guardar(p)
			end
		end
	end)
	Players.PlayerRemoving:Connect(function(p)
		State.guardar(p)
		State.datos[p] = nil
	end)
	game:BindToClose(function()
		for _, p in ipairs(Players:GetPlayers()) do
			State.guardar(p)
		end
	end)
end

return State
]===] },
    { archivo = "WorldBuilder.luau", nombre = "WorldBuilder", clase = "Script",
      servicio = "ServerScriptService", preservar = false,
      codigo = [===[
--[[
    ============================================================
    WorldBuilder (Script)
    DÓNDE VA: ServerScriptService (Script normal)
    ------------------------------------------------------------
    Construye TODO el mapa por código: hospital de 2 pisos,
    McCorazón, veterinaria, ciudad, parqueadero, tianguis, parque,
    6 casas + casa dorada, granja y los 30 pads de trabajo.
    No necesitas poner nada a mano: al darle Play aparece todo.
    ============================================================
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local Config = require(ReplicatedStorage:WaitForChild("Config"))

local mundo = Instance.new("Folder")
mundo.Name = "HospitalCorazonWorld"
mundo.Parent = workspace

-- Parte básica anclada.
local function P(size, pos, color, mat, sinColision)
	local p = Instance.new("Part")
	p.Size = Vector3.new(size[1], size[2], size[3])
	p.Position = Vector3.new(pos[1], pos[2], pos[3])
	p.Color = Color3.fromRGB(color[1], color[2], color[3])
	p.Material = mat or Enum.Material.SmoothPlastic
	p.Anchored = true
	p.CanCollide = not sinColision
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	p.Parent = mundo
	return p
end

-- Letrero con texto (SurfaceGui).
local function letrero(texto, size, pos, fondo, cara)
	local p = P(size, pos, fondo or {25, 25, 35}, Enum.Material.SmoothPlastic, true)
	p.CanCollide = false
	local gui = Instance.new("SurfaceGui")
	gui.Face = cara or Enum.NormalId.Front
	gui.Parent = p
	local t = Instance.new("TextLabel")
	t.Size = UDim2.new(1, 0, 1, 0)
	t.BackgroundTransparency = 1
	t.Text = texto
	t.TextScaled = true
	t.Font = Enum.Font.GothamBold
	t.TextColor3 = Color3.new(1, 1, 1)
	t.TextStrokeTransparency = 0.5
	t.Parent = gui
	return p
end

-- Muro rectangular.
local function pared(cx, cz, ancho, prof, alto, yBase, color)
	return P({ancho, alto, prof}, {cx, yBase + alto / 2, cz}, color or {235, 235, 240})
end

-- Silla simple.
local function silla(x, z, yBase)
	P({2, 0.6, 2}, {x, yBase + 0.6, z}, {120, 160, 220}, Enum.Material.SmoothPlastic)
	P({2, 1.8, 0.4}, {x, yBase + 1.5, z - 0.9}, {120, 160, 220}, Enum.Material.SmoothPlastic)
end

-- Camilla.
local function camilla(x, z, yBase)
	P({2.6, 1, 6}, {x, yBase + 1, z}, {250, 250, 252})
	P({1.6, 0.5, 1.2}, {x, yBase + 1.6, z - 2}, {220, 235, 250})
end

-- ============================================================
-- 🌍 BASE Y CALLES
-- ============================================================
P({500, 1, 500}, {0, -0.5, 20}, {110, 190, 110}, Enum.Material.Grass) -- pasto
-- Calle principal (este-oeste)
P({320, 0.2, 12}, {0, 0.1, -20}, {70, 70, 75}, Enum.Material.Asphalt, true)
for x = -150, 150, 16 do
	P({6, 0.25, 0.6}, {x, 0.12, -20}, {240, 200, 60}, Enum.Material.SmoothPlastic, true)
end
-- Calle norte-sur
P({12, 0.2, 120}, {60, 0.1, -20}, {70, 70, 75}, Enum.Material.Asphalt, true)

-- Spawn invisible frente al hospital
local spawn = Instance.new("SpawnLocation")
spawn.Name = "SpawnCorazon"
spawn.Size = Vector3.new(6, 1, 6)
spawn.Position = Vector3.new(0, 2, -38)
spawn.Anchored = true
spawn.Transparency = 1
spawn.CanCollide = false
spawn.Neutral = true
spawn.AllowTeamChangeOnTouch = false
spawn.TopSurface = Enum.SurfaceType.Smooth
spawn.Parent = mundo

-- ============================================================
-- 🏥 HOSPITAL (x -35..35, z -92..-48, 2 pisos)
-- ============================================================
local BLANCO = {235, 235, 240}
local AZULH = {60, 130, 200}

P({72, 2, 46}, {0, 0, -70}, {210, 210, 215}, Enum.Material.Marble) -- piso 1
-- Paredes piso 1 (y 1..9), puerta al frente (x -3..3)
pared(-19, -48, 32, 1, 8, 1, BLANCO)
pared(19, -48, 32, 1, 8, 1, BLANCO)
pared(0, -48, 7, 1, 2.5, 6.5, BLANCO) -- dintel sobre la puerta
pared(0, -92, 70, 1, 8, 1, BLANCO)
pared(-35, -70, 1, 44, 8, 1, BLANCO)
pared(35, -70, 1, 44, 8, 1, BLANCO)
-- Piso 2 y techo
P({72, 1, 46}, {0, 9.5, -70}, {210, 210, 215}, Enum.Material.Marble)
pared(0, -48, 70, 1, 8, 10, BLANCO)
pared(0, -92, 70, 1, 8, 10, BLANCO)
pared(-35, -70, 1, 44, 8, 10, BLANCO)
pared(35, -70, 1, 44, 8, 10, BLANCO)
P({74, 1, 48}, {0, 18.5, -70}, AZULH) -- techo azul
-- Letrero gigante
letrero("🏥 HOSPITAL CORAZÓN", {44, 6, 1}, {0, 13.5, -47.2}, AZULH)

-- Escaleras (lado este, suben de y=1 a y=10)
for i = 0, 11 do
	P({5, 0.75, 1.4}, {28, 1 + 0.375 + i * 0.75, -86 + i * 1.15}, {180, 180, 190})
end

-- Recepción
P({10, 2.4, 2}, {0, 2.2, -58}, AZULH)
letrero("📋 RECEPCIÓN", {10, 2, 0.6}, {0, 4.6, -58.8}, {40, 90, 150})
-- Sala de espera: 12 sillas + 2 mesas
for i, x in ipairs({-25, -15, -5, 5, 15, 25}) do
	silla(x, -64, 1)
	silla(x, -70, 1)
end
P({6, 0.5, 3}, {-15, 1.9, -67}, {150, 110, 80}, Enum.Material.Wood)
P({6, 0.5, 3}, {15, 1.9, -67}, {150, 110, 80}, Enum.Material.Wood)
letrero("🪑 SALA DE ESPERA", {14, 2, 0.6}, {0, 6.5, -66}, {40, 90, 150})
-- Emergencias: 3 camillas + cruz roja
camilla(20, -80, 1); camilla(25, -80, 1); camilla(30, -80, 1)
letrero("🚨 EMERGENCIAS", {14, 2.4, 0.6}, {25, 6.5, -84}, {200, 40, 40})
P({3, 3, 0.5}, {25, 8, -83.5}, {220, 220, 225}, Enum.Material.SmoothPlastic, true)
P({1, 3, 0.6}, {25, 8, -83.5}, {220, 30, 30}, Enum.Material.SmoothPlastic, true)
P({3, 1, 0.6}, {25, 8, -83.5}, {220, 30, 30}, Enum.Material.SmoothPlastic, true)
-- Farmacia
P({12, 2.4, 2}, {-24, 2.2, -86}, AZULH)
for i = 0, 2 do
	P({8, 4, 1.5}, {-24, 3, -89.5 - i * 0}, {150, 110, 80}, Enum.Material.Wood)
end
letrero("💊 FARMACIA", {10, 2, 0.6}, {-24, 4.6, -86.8}, {40, 90, 150})

-- Piso 2: divisiones de consultorios
pared(-12, -70, 1, 44, 8, 10, BLANCO)
pared(12, -70, 1, 44, 8, 10, BLANCO)
for i, cx in ipairs({-23, 0, 23}) do
	camilla(cx - 3, -76, 10)
	P({4, 2, 2}, {cx + 4, 11, -84}, {150, 110, 80}, Enum.Material.Wood)
	letrero("🩺 CONSULTORIO " .. i, {10, 1.8, 0.6}, {cx, 14, -60}, {40, 90, 150})
end
-- Quirófano (cuarto este)
P({3, 1.6, 7}, {24, 10.8, -70}, {180, 220, 240})
P({0.4, 4, 0.4}, {24, 14, -70}, {150, 150, 155})
P({3, 0.6, 3}, {24, 16.2, -70}, {255, 255, 240}, Enum.Material.Neon, true)
letrero("🔬 QUIRÓFANO", {10, 1.8, 0.6}, {24, 14, -60}, {40, 90, 150})

-- ============================================================
-- 🍔 MCCORAZÓN (centro 90, 0, 10 — 24x18)
-- ============================================================
P({26, 2, 20}, {90, 0, 10}, {225, 225, 230}, Enum.Material.Marble)
pared(90, 19, 24, 1, 8, 1, {240, 240, 245})
pared(78, 10, 1, 18, 8, 1, {240, 240, 245})
pared(102, 10, 1, 18, 8, 1, {240, 240, 245})
pared(84, 1, 8, 1, 8, 1, {240, 240, 245})
pared(96, 1, 8, 1, 8, 1, {240, 240, 245})
pared(90, 1, 5, 1, 2.5, 6.5, {240, 240, 245})
P({28, 1, 22}, {90, 9.5, 10}, {220, 40, 40}) -- techo rojo
letrero("🍔 McCorazón", {18, 4, 1}, {90, 7, 0.4}, {220, 40, 40})
letrero("M", {5, 5, 1}, {90, 12, 0.2}, {240, 180, 20})
local mostrador = P({10, 2.4, 2}, {90, 2.2, 8}, {120, 80, 50}, Enum.Material.Wood)
mostrador.Name = "MostradorMc"
P({3, 1.4, 2}, {86, 1.7, 14}, {90, 90, 95}, Enum.Material.SmoothPlastic) -- parrilla
P({3, 1.4, 2}, {94, 1.7, 14}, {90, 90, 95}, Enum.Material.SmoothPlastic)

-- ============================================================
-- 🐾 VETERINARIA (centro -90, 0, 10 — 24x18)
-- ============================================================
P({26, 2, 20}, {-90, 0, 10}, {225, 225, 230}, Enum.Material.Marble)
pared(-90, 19, 24, 1, 8, 1, {245, 235, 220})
pared(-102, 10, 1, 18, 8, 1, {245, 235, 220})
pared(-78, 10, 1, 18, 8, 1, {245, 235, 220})
pared(-96, 1, 8, 1, 8, 1, {245, 235, 220})
pared(-84, 1, 8, 1, 8, 1, {245, 235, 220})
pared(-90, 1, 5, 1, 2.5, 6.5, {245, 235, 220})
P({28, 1, 22}, {-90, 9.5, 10}, {120, 180, 120})
letrero("🐾 VETERINARIA", {16, 4, 1}, {-90, 7, 0.4}, {80, 140, 80})
P({10, 2.4, 2}, {-90, 2.2, 8}, {150, 110, 80}, Enum.Material.Wood)
for i, cx in ipairs({-96, -84}) do -- 2 jaulas
	P({4, 0.4, 4}, {cx, 1.2, 14}, {160, 160, 165})
	for _, dx in ipairs({-1.8, 1.8}) do
		P({0.3, 3, 0.3}, {cx + dx, 2.8, 12.2}, {160, 160, 165})
		P({0.3, 3, 0.3}, {cx + dx, 2.8, 15.8}, {160, 160, 165})
	end
	P({4, 0.4, 4}, {cx, 4.4, 14}, {160, 160, 165})
end

-- ============================================================
-- 🅿️ PARQUEADERO (0, 0, 60 — 60x30, 12 cajones)
-- ============================================================
P({60, 0.2, 30}, {0, 0.1, 60}, {80, 80, 85}, Enum.Material.Asphalt, true)
for fila = 0, 1 do
	local z = 52 + fila * 16
	for i = 0, 5 do
		local x = -25 + i * 10
		P({0.4, 0.25, 14}, {x - 5, 0.15, z}, {240, 240, 240}, Enum.Material.SmoothPlastic, true)
	end
	P({58, 0.25, 0.4}, {0, 0.15, z - 7}, {240, 240, 240}, Enum.Material.SmoothPlastic, true)
	P({58, 0.25, 0.4}, {0, 0.15, z + 7}, {240, 240, 240}, Enum.Material.SmoothPlastic, true)
end
letrero("🅿️ PARQUEADERO", {12, 3, 0.6}, {0, 4, 44}, {40, 90, 150})

-- ============================================================
-- 🎪 TIANGUIS (-70, 0, 110 — 70x40, 8 puestos)
-- ============================================================
P({70, 0.2, 40}, {-70, 0.1, 110}, {210, 180, 140}, Enum.Material.Sand, true)
letrero("🎪 TIANGUIS CORAZÓN", {20, 3.5, 0.8}, {-70, 5, 89.4}, {180, 100, 40})

local puestosFolder = Instance.new("Folder")
puestosFolder.Name = "Puestos"
puestosFolder.Parent = mundo

local function puesto(indice, x, z, cara)
	local m = Instance.new("Model")
	m.Name = "Puesto" .. indice
	for _, dx in ipairs({-3, 3}) do
		for _, dz in ipairs({-2, 2}) do
			local poste = Instance.new("Part")
			poste.Size = Vector3.new(0.6, 6, 0.6)
			poste.Position = Vector3.new(x + dx, 3, z + dz)
			poste.Color = Color3.fromRGB(150, 110, 80)
			poste.Material = Enum.Material.Wood
			poste.Anchored = true
			poste.Parent = m
		end
	end
	for i = 0, 5 do -- techo de lona a rayas
		local tira = Instance.new("Part")
		tira.Size = Vector3.new(1.2, 0.3, 5.4)
		tira.Position = Vector3.new(x - 3 + i * 1.2, 6.4, z)
		if i % 2 == 0 then
			tira.Color = Color3.fromRGB(220, 60, 60)
		else
			tira.Color = Color3.fromRGB(250, 250, 250)
		end
		tira.Anchored = true
		tira.TopSurface = Enum.SurfaceType.Smooth
		tira.Parent = m
	end
	local mesa = Instance.new("Part")
	mesa.Size = Vector3.new(5, 1.6, 3)
	mesa.Position = Vector3.new(x, 1.4, z)
	mesa.Color = Color3.fromRGB(150, 110, 80)
	mesa.Material = Enum.Material.Wood
	mesa.Anchored = true
	mesa.Name = "Mesa"
	mesa.Parent = m
	local sig = Instance.new("Part")
	sig.Size = Vector3.new(6, 2, 0.4)
	sig.Position = Vector3.new(x, 4.6, z + (cara == "norte" and -2.4 or 2.4))
	sig.Color = Color3.fromRGB(25, 25, 35)
	sig.Anchored = true
	sig.CanCollide = false
	sig.Name = "Letrero"
	sig.Parent = m
	local gui = Instance.new("SurfaceGui")
	gui.Face = cara == "norte" and Enum.NormalId.Back or Enum.NormalId.Front
	gui.Parent = sig
	local t = Instance.new("TextLabel")
	t.Size = UDim2.new(1, 0, 1, 0)
	t.BackgroundTransparency = 1
	t.Text = "RENTA $500"
	t.TextScaled = true
	t.Font = Enum.Font.GothamBold
	t.TextColor3 = Color3.new(1, 1, 1)
	t.TextStrokeTransparency = 0.5
	t.Name = "Texto"
	t.Parent = gui
	m.Parent = puestosFolder
	return m
end

local n = 0
for _, z in ipairs({102, 118}) do
	for _, x in ipairs({-98, -84, -70, -56}) do
		n += 1
		puesto(n, x, z, z == 102 and "sur" or "norte")
	end
end

-- ============================================================
-- 🌳 PARQUE (60, 0, 110) + 6 DECOR_SLOTs
-- ============================================================
P({50, 0.2, 40}, {60, 0.1, 110}, {120, 200, 120}, Enum.Material.Grass, true)
letrero("🌳 PARQUE", {10, 2.5, 0.6}, {60, 3.5, 89.6}, {60, 140, 60})
for i = 1, 6 do
	local slot = P({6, 0.5, 6}, {42 + (i - 1) * 7, 0.4, 118}, {255, 170, 220}, Enum.Material.Neon, true)
	slot.Transparency = 0.6
	slot.Name = "DECOR_SLOT_" .. i
end
for _, bx in ipairs({50, 60, 70}) do -- bancas
	P({4, 0.5, 1.5}, {bx, 1, 102}, {150, 110, 80}, Enum.Material.Wood)
	P({4, 1.2, 0.4}, {bx, 1.6, 101.4}, {150, 110, 80}, Enum.Material.Wood)
end

-- ============================================================
-- 🏠 CASAS (6 + dorada VIP)
-- ============================================================
local casasFolder = Instance.new("Folder")
casasFolder.Name = "Casas"
casasFolder.Parent = mundo

local function casa(nombre, x, z, dorada)
	local m = Instance.new("Model")
	m.Name = nombre
	local colPared = dorada and {240, 200, 80} or {245, 240, 230}
	local colTecho = dorada and {220, 170, 40} or {200, 90, 90}
	local function pm(size, pos, color, mat)
		local p = Instance.new("Part")
		p.Size = Vector3.new(size[1], size[2], size[3])
		p.Position = Vector3.new(pos[1], pos[2], pos[3])
		p.Color = Color3.fromRGB(color[1], color[2], color[3])
		p.Material = mat or Enum.Material.SmoothPlastic
		p.Anchored = true
		p.TopSurface = Enum.SurfaceType.Smooth
		p.Parent = m
		return p
	end
	pm({18, 1, 16}, {x, 0.5, z}, {200, 200, 205}, Enum.Material.Marble) -- piso
	pm( {7, 7, 1}, {x - 5.5, 4.5, z + 8}, colPared) -- frente izq
	pm( {7, 7, 1}, {x + 5.5, 4.5, z + 8}, colPared) -- frente der
	pm( {4, 2, 1}, {x, 7, z + 8}, colPared) -- dintel puerta
	pm({18, 7, 1}, {x, 4.5, z - 8}, colPared) -- atrás
	pm( {1, 7, 16}, {x - 9, 4.5, z}, colPared) -- izq
	pm( {1, 7, 16}, {x + 9, 4.5, z}, colPared) -- der
	pm({20, 1, 18}, {x, 8.5, z}, colTecho) -- techo
	pm({14, 1.5, 12}, {x, 9.7, z}, colTecho)
	local puerta = pm({4, 5, 0.6}, {x, 3.5, z + 8}, dorada and {200, 150, 30} or {140, 100, 70}, Enum.Material.Wood)
	puerta.Name = "Puerta"
	-- ventanitas
	pm({3, 2.5, 0.3}, {x - 5.5, 5, z + 8.1}, {170, 220, 240}, Enum.Material.Glass)
	pm({3, 2.5, 0.3}, {x + 5.5, 5, z + 8.1}, {170, 220, 240}, Enum.Material.Glass)
	local sig = pm({10, 2, 0.4}, {x, 10.5, z + 8.4}, {25, 25, 35})
	sig.CanCollide = false
	sig.Name = "LetreroCasa"
	local gui = Instance.new("SurfaceGui")
	gui.Parent = sig
	local t = Instance.new("TextLabel")
	t.Size = UDim2.new(1, 0, 1, 0)
	t.BackgroundTransparency = 1
	if dorada then
		t.Text = "🏠 CASA DORADA 👑 (pase VIP)"
	else
		t.Text = "🏠 SE VENDE $5,000"
	end
	t.TextScaled = true
	t.Font = Enum.Font.GothamBold
	t.TextColor3 = Color3.new(1, 1, 1)
	t.TextStrokeTransparency = 0.5
	t.Name = "Texto"
	t.Parent = gui
	m.Parent = casasFolder
	return m
end

local i = 0
for _, z in ipairs({-70, -115}) do
	for _, x in ipairs({110, 135, 160}) do
		i += 1
		casa("Casa" .. i, x, z, false)
	end
end
casa("CasaDorada", 195, -90, true)
letrero("🏘️ COLONIA CORAZÓN", {16, 3, 0.6}, {135, 5, -52}, {90, 120, 200})

-- ============================================================
-- 🌾 GRANJA (-130, 0, -50): cultivos, estanque, árboles
-- ============================================================
P({40, 0.2, 30}, {-130, 0.1, -50}, {150, 110, 70}, Enum.Material.Ground, true)
for fila = 0, 3 do
	for c = 0, 7 do
		P({1.5, 1, 1.5}, {-144 + c * 4, 0.6, -60 + fila * 6}, {80, 170, 80}, Enum.Material.Grass, true)
	end
end
P({20, 0.2, 16}, {-112, 0.12, -34}, {80, 160, 230}, Enum.Material.SmoothPlastic, true) -- estanque
for _, tx in ipairs({-148, -140, -132, -124, -116, -150}) do
	local tronco = P({1.2, 5, 1.2}, {tx, 2.5, -66}, {140, 100, 70}, Enum.Material.Wood)
	local copa = P({4, 4, 4}, {tx, 6.5, -66}, {70, 160, 70}, Enum.Material.Grass)
	copa.Shape = Enum.PartType.Ball
end
letrero("🌾 GRANJA", {10, 2.5, 0.6}, {-130, 3.5, -33.6}, {120, 150, 60})

-- ============================================================
-- 💼 LOS 30 PADS DE TRABAJO
-- ============================================================
local padsFolder = Instance.new("Folder")
padsFolder.Name = "JobPads"
padsFolder.Parent = mundo

local COLOR_ZONA = {
	Hospital = {60, 130, 200},
	["McCorazón"] = {220, 60, 60},
	Veterinaria = {90, 170, 90},
	Ciudad = {240, 180, 60},
	Campo = {120, 180, 70},
	Parque = {120, 180, 70},
	Tianguis = {200, 120, 220},
}

for _, job in ipairs(Config.TRABAJOS) do
	local m = Instance.new("Model")
	m.Name = job.nombre
	local pad = Instance.new("Part")
	pad.Shape = Enum.PartType.Cylinder
	pad.Size = Vector3.new(0.6, 7, 7)
	pad.CFrame = CFrame.new(job.pos[1], job.pos[2], job.pos[3]) * CFrame.Angles(0, 0, math.rad(90))
	local c = COLOR_ZONA[job.zona] or {200, 200, 200}
	pad.Color = Color3.fromRGB(c[1], c[2], c[3])
	pad.Material = Enum.Material.Neon
	pad.Anchored = true
	pad.CanCollide = false
	pad.TopSurface = Enum.SurfaceType.Smooth
	pad.Name = "Pad"
	pad.Parent = m
	-- poste con letrero
	local poste = Instance.new("Part")
	poste.Size = Vector3.new(0.4, 4, 0.4)
	poste.Position = Vector3.new(job.pos[1] + 4.5, job.pos[2] + 2, job.pos[3])
	poste.Color = Color3.fromRGB(100, 100, 105)
	poste.Anchored = true
	poste.Parent = m
	local sig = Instance.new("Part")
	sig.Size = Vector3.new(7, 2.4, 0.4)
	sig.Position = Vector3.new(job.pos[1] + 4.5, job.pos[2] + 4.6, job.pos[3])
	sig.Color = Color3.fromRGB(25, 25, 35)
	sig.Anchored = true
	sig.CanCollide = false
	sig.Parent = m
	local gui = Instance.new("SurfaceGui")
	gui.Parent = sig
	local t = Instance.new("TextLabel")
	t.Size = UDim2.new(1, 0, 1, 0)
	t.BackgroundTransparency = 1
	t.Text = "💼 " .. job.nombre .. "\n$" .. job.sueldo .. "/tarea" .. (job.vip and " ⭐" or "")
	t.TextScaled = true
	t.Font = Enum.Font.GothamBold
	t.TextColor3 = Color3.new(1, 1, 1)
	t.TextStrokeTransparency = 0.5
	t.Parent = gui
	m.Parent = padsFolder
end

-- ============================================================
-- 💡 ILUMINACIÓN
-- ============================================================
Lighting.ClockTime = 15
Lighting.Brightness = 2
Lighting.Ambient = Color3.fromRGB(150, 140, 130)
Lighting.OutdoorAmbient = Color3.fromRGB(150, 140, 130)
for _, fx in ipairs({"BloomEffect", "SunRaysEffect", "DepthOfFieldEffect"}) do
	local f = Lighting:FindFirstChildOfClass(fx)
	if f then f:Destroy() end
end

print("[HospitalCorazon] Mundo construido: hospital, McCorazón, vet, ciudad, tianguis, 6 casas + dorada, 30 trabajos 🏥")
]===] },
    { archivo = "JobSystem.luau", nombre = "JobSystem", clase = "Script",
      servicio = "ServerScriptService", preservar = false,
      codigo = [===[
--[[
    ============================================================
    JobSystem (Script)
    DÓNDE VA: ServerScriptService (Script normal)
    ------------------------------------------------------------
    Los 30 pads de trabajo: te acercas, dejas presionado
    "Trabajar" y ganas el sueldo. Cada 20 tareas subes de nivel
    (máx 5, +20% de sueldo por nivel). Hay cooldown de 6 s.
    Los trabajos ⭐ (Cirujano, Veterinario) pagan doble con el
    pase VIP. El pase 2x duplica todo.
    ============================================================
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage:WaitForChild("Config"))
local State = require(game:GetService("ServerScriptService"):WaitForChild("HospitalState"))

local cooldowns = {} -- [userId_trabajo] = timestamp

local function puedeTrabajar(player, trabajo)
	local clave = player.UserId .. "_" .. trabajo
	local ahora = os.clock()
	if cooldowns[clave] and ahora - cooldowns[clave] < Config.COOLDOWN_TRABAJO then
		return false
	end
	cooldowns[clave] = ahora
	return true
end

local function trabajar(player, job)
	if not puedeTrabajar(player, job.nombre) then
		State.aviso(player, "⏳ Espera un momento...")
		return
	end
	local nivel = State.sumarTarea(player, job.nombre)
	local sueldo = job.sueldo * State.multNivel(nivel)
	-- Pase 2x sueldo
	if State.tienePase(player, Config.GAMEPASS_2X_ID) then
		sueldo *= 2
	end
	-- Trabajos VIP pagan doble con el pase VIP
	if job.vip and State.tienePase(player, Config.GAMEPASS_VIP_ID) then
		sueldo *= 2
	end
	State.darDinero(player, sueldo, "💼 " .. job.nombre .. " (Nv." .. nivel .. ")")
end

-- Conecta los prompts cuando el mundo ya existe.
local function conectar()
	local pads = workspace:WaitForChild("HospitalCorazonWorld"):WaitForChild("JobPads")
	for _, job in ipairs(Config.TRABAJOS) do
		local modelo = pads:WaitForChild(job.nombre)
		local pad = modelo:WaitForChild("Pad")
		local prompt = Instance.new("ProximityPrompt")
		prompt.ActionText = "Trabajar"
		prompt.ObjectText = job.nombre .. " — $" .. job.sueldo .. "/tarea"
		prompt.HoldDuration = 0.8
		prompt.MaxActivationDistance = 12
		prompt.RequiresLineOfSight = false
		prompt.Parent = pad
		prompt.Triggered:Connect(function(player)
			trabajar(player, job)
		end)
	end
	print("[HospitalCorazon] 30 trabajos conectados 💼")
end

-- Carga de jugadores + guardado.
local Players = game:GetService("Players")
Players.PlayerAdded:Connect(function(p)
	State.cargar(p)
end)
for _, p in ipairs(Players:GetPlayers()) do
	State.cargar(p)
end
State.iniciarGuardado()

-- Espera al mundo (el WorldBuilder corre al inicio del servidor).
task.spawn(function()
	local ok = pcall(function()
		workspace:WaitForChild("HospitalCorazonWorld", 30)
	end)
	if ok then
		conectar()
	else
		warn("[HospitalCorazon] No se encontró el mundo para conectar trabajos.")
	end
end)
]===] },
    { archivo = "RoleSystem.luau", nombre = "RoleSystem", clase = "Script",
      servicio = "ServerScriptService", preservar = false,
      codigo = [===[
--[[
    ============================================================
    RoleSystem (Script)
    DÓNDE VA: ServerScriptService (Script normal)
    ------------------------------------------------------------
    Roles: al entrar eliges Doctor 🩺, Enfermera 💉 o Paciente 🤒.
    Doctor y Enfermera reciben la herramienta "Curar": tócala y
    luego toca a otro jugador para curarlo (el que cura gana $).
    Puedes cambiar de rol cuando quieras desde el HUD.
    ============================================================
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Config = require(ReplicatedStorage:WaitForChild("Config"))
local State = require(ServerScriptService:WaitForChild("HospitalState"))

local CURA = {
	Doctor = { cura = 50, paga = Config.XP_CURAR_DOCTOR, emoji = "🩺" },
	Enfermera = { cura = 30, paga = Config.XP_CURAR_ENFERMERA, emoji = "💉" },
}

-- Herramienta "Curar" con su script de servidor adentro.
local function darHerramientaCurar(player, rol)
	local info = CURA[rol]
	if not info then return end
	-- Quita la anterior si existe.
	local vieja = player.Backpack:FindFirstChild("Curar")
	if vieja then vieja:Destroy() end
	local ch = player.Character
	if ch then
		local eq = ch:FindFirstChild("Curar")
		if eq then eq:Destroy() end
	end
	local tool = Instance.new("Tool")
	tool.Name = "Curar"
	tool.RequiresHandle = false
	tool.ToolTip = "Toca para curar al jugador más cercano"
	tool.CanBeDropped = false
	local scr = Instance.new("Script")
	scr.Name = "CurarServer"
	scr.Source = [[
		local CURA = ]] .. info.cura .. [[
		local PAGA = ]] .. info.paga .. [[
		local tool = script.Parent
		tool.Activated:Connect(function()
			local ch = tool.Parent
			if not ch then return end
			local hrp = ch:FindFirstChild("HumanoidRootPart")
			if not hrp then return end
			local State = require(game.ServerScriptService:WaitForChild("HospitalState"))
			local mejor, mejorDist = nil, 15
			for _, p in ipairs(game.Players:GetPlayers()) do
				if p ~= game.Players:GetPlayerFromCharacter(ch) then
					local oc = p.Character
					local oh = oc and oc:FindFirstChildOfClass("Humanoid")
					local orp = oc and oc:FindFirstChild("HumanoidRootPart")
					if oh and orp and oh.Health < oh.MaxHealth then
						local d = (orp.Position - hrp.Position).Magnitude
						if d < mejorDist then
							mejor, mejorDist = oh, d
						end
					end
				end
			end
			if mejor then
				mejor.Health = math.min(mejor.MaxHealth, mejor.Health + CURA)
				local doc = game.Players:GetPlayerFromCharacter(ch)
				if doc then
					State.darDinero(doc, PAGA, "🩺 curaste a un paciente")
				end
			end
		end)
	]]
	scr.Parent = tool
	tool.Parent = player.Backpack
end

local function asignarRol(player, rol)
	local d = State.datos[player]
	if not d then
		State.cargar(player)
		d = State.datos[player]
	end
	if not d then return end
	d.rol = rol
	-- Quita herramienta de curar si ya no aplica.
	local bp = player:FindFirstChild("Backpack")
	if bp then
		local vieja = bp:FindFirstChild("Curar")
		if vieja then vieja:Destroy() end
	end
	local ch = player.Character
	if ch then
		local eq = ch:FindFirstChild("Curar")
		if eq then eq:Destroy() end
	end
	if rol == "Doctor" or rol == "Enfermera" then
		darHerramientaCurar(player, rol)
	end
	local emoji = rol == "Doctor" and "🩺" or (rol == "Enfermera" and "💉" or "🤒")
	State.aviso(player, emoji .. " Ahora eres: " .. rol)
	State.hud(player)
	State.guardar(player)
end

State.getEvent("ElegirRol").OnServerEvent:Connect(function(player, rol)
	if rol == "Doctor" or rol == "Enfermera" or rol == "Paciente" then
		asignarRol(player, rol)
	end
end)

-- Si reaparece, devuelve la herramienta de su rol.
Players.PlayerAdded:Connect(function(p)
	p.CharacterAdded:Connect(function()
		task.wait(1)
		local d = State.datos[p]
		if d and (d.rol == "Doctor" or d.rol == "Enfermera") then
			darHerramientaCurar(p, d.rol)
		end
	end)
end)

print("[HospitalCorazon] RoleSystem listo 🎭")
]===] },
    { archivo = "HouseSystem.luau", nombre = "HouseSystem", clase = "Script",
      servicio = "ServerScriptService", preservar = false,
      codigo = [===[
--[[
    ============================================================
    HouseSystem (Script)
    DÓNDE VA: ServerScriptService (Script normal)
    ------------------------------------------------------------
    Casas comprables: toca la puerta.
    • Si está en venta y tienes $5,000 → es tuya (se guarda).
    • Si es tuya → la puerta se abre 3 segundos.
    • La Casa Dorada solo se puede comprar con el pase VIP.
    ============================================================
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage:WaitForChild("Config"))
local State = require(game:GetService("ServerScriptService"):WaitForChild("HospitalState"))

local function textoCasa(modelo, texto)
	local sig = modelo:FindFirstChild("LetreroCasa")
	if sig then
		local t = sig:FindFirstChild("Texto", true)
		if t then t.Text = texto end
	end
end

local function conectar()
	local mundo = workspace:WaitForChild("HospitalCorazonWorld")
	local casas = mundo:WaitForChild("Casas")
	for _, modelo in ipairs(casas:GetChildren()) do
		if modelo:IsA("Model") then
			local puerta = modelo:WaitForChild("Puerta")
			local esDorada = modelo.Name == "CasaDorada"
			local prompt = Instance.new("ProximityPrompt")
			prompt.ActionText = "Puerta"
			prompt.HoldDuration = 0.5
			prompt.MaxActivationDistance = 10
			prompt.RequiresLineOfSight = false
			prompt.Parent = puerta
			prompt.Triggered:Connect(function(player)
				local dueno = modelo:GetAttribute("Dueño")
				if dueno == nil then
					-- En venta
					if esDorada and not State.tienePase(player, Config.GAMEPASS_CASA_ID) then
						State.aviso(player, "👑 La Casa Dorada necesita el pase VIP (tienda del HUD)")
						return
					end
					if State.quitarDinero(player, Config.PRECIO_CASA) then
						modelo:SetAttribute("Dueño", player.Name)
						modelo:SetAttribute("DueñoId", player.UserId)
						local d = State.datos[player]
						if d then d.casa = modelo.Name end
						State.guardar(player)
						if esDorada then
							textoCasa(modelo, "👑 Casa de " .. player.Name)
						else
							textoCasa(modelo, "🏠 Casa de " .. player.Name)
						end
						prompt.ObjectText = "Casa de " .. player.Name
						State.aviso(player, "🏠 ¡Felicidades! Esta casa es tuya")
					else
						State.aviso(player, "💸 Te faltan monedas (cuesta $" .. Config.PRECIO_CASA .. ")")
					end
				elseif dueno == player.Name then
					-- Abrir mi puerta 3 segundos
					puerta.CanCollide = false
					task.delay(3, function()
						puerta.CanCollide = true
					end)
					State.aviso(player, "🚪 ¡Bienvenido a casa!")
				else
					State.aviso(player, "🔒 Esta casa es de " .. dueno)
				end
			end)
		end
	end
	print("[HospitalCorazon] Casas conectadas 🏠")
end

task.spawn(function()
	local ok = pcall(function()
		workspace:WaitForChild("HospitalCorazonWorld", 30)
	end)
	if ok then conectar() end
end)
]===] },
    { archivo = "MarketSystem.luau", nombre = "MarketSystem", clase = "Script",
      servicio = "ServerScriptService", preservar = false,
      codigo = [===[
--[[
    ============================================================
    MarketSystem (Script)
    DÓNDE VA: ServerScriptService (Script normal)
    ------------------------------------------------------------
    Tianguis: 8 locales rentables.
    • Toca el puesto: si está libre lo rentas por $500.
    • Eliges qué vender y a qué precio (se abre la ventanita).
    • Otros jugadores lo compran tocando el puesto: tú recibes
      el 90% y el 10% es impuesto.
    • Toca de nuevo tu puesto para quitar la venta o desocupar.
    ============================================================
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage:WaitForChild("Config"))
local State = require(game:GetService("ServerScriptService"):WaitForChild("HospitalState"))

-- [indice] = { ["dueño"] = UserId|nil, nombre = "", articulo = nil, precio = 0 }
local puestos = {}

local function textoPuesto(i)
	local mundo = workspace:FindFirstChild("HospitalCorazonWorld")
	if not mundo then return end
	local modelo = mundo:FindFirstChild("Puestos") and mundo.Puestos:FindFirstChild("Puesto" .. i)
	if not modelo then return end
	local t = modelo:FindFirstChild("Texto", true)
	if not t then return end
	local p = puestos[i]
	if not p then return end
	if p["dueño"] == nil then
		t.Text = "RENTA $500"
	elseif p.articulo == nil then
		t.Text = "🎪 " .. p.nombre .. "\n(elige qué vender)"
	else
		t.Text = p.articulo .. "\n$" .. p.precio .. "\nde " .. p.nombre
	end
end

local function darBolsa(player, articulo)
	local tool = Instance.new("Tool")
	tool.Name = "Bolsa " .. articulo
	tool.RequiresHandle = false
	tool.ToolTip = "Comprado en el tianguis 🎪"
	tool.CanBeDropped = false
	if articulo:find("Comida") then
		local scr = Instance.new("Script")
		scr.Name = "ComerServer"
		scr.Source = [[
			local tool = script.Parent
			tool.Activated:Connect(function()
				local ch = tool.Parent
				local h = ch and ch:FindFirstChildOfClass("Humanoid")
				if h then
					h.Health = math.min(h.MaxHealth, h.Health + 10)
					tool:Destroy()
				end
			end)
		]]
		scr.Parent = tool
	end
	tool.Parent = player.Backpack
end

local function conectar()
	local mundo = workspace:WaitForChild("HospitalCorazonWorld")
	local folder = mundo:WaitForChild("Puestos")
	for i = 1, 8 do
		local modelo = folder:WaitForChild("Puesto" .. i)
		puestos[i] = { ["dueño"] = nil, nombre = "", articulo = nil, precio = 0 }
		local mesa = modelo:WaitForChild("Mesa")
		local prompt = Instance.new("ProximityPrompt")
		prompt.ActionText = "Puesto"
		prompt.ObjectText = "Tianguis"
		prompt.HoldDuration = 0.5
		prompt.MaxActivationDistance = 12
		prompt.RequiresLineOfSight = false
		prompt.Parent = mesa
		prompt.Triggered:Connect(function(player)
			local p = puestos[i]
			if p["dueño"] == nil then
				-- Rentar
				if State.quitarDinero(player, Config.RENTA_LOCAL) then
					p["dueño"] = player.UserId
					p.nombre = player.Name
					textoPuesto(i)
					State.aviso(player, "🎪 ¡Local rentado! Elige qué vender")
					State.getEvent("AbrirMercado"):FireClient(player, i)
				else
					State.aviso(player, "💸 La renta cuesta $" .. Config.RENTA_LOCAL)
				end
			elseif p["dueño"] == player.UserId then
				if p.articulo == nil then
					State.getEvent("AbrirMercado"):FireClient(player, i)
				else
					-- Quitar venta (el local sigue siendo suyo)
					p.articulo = nil
					p.precio = 0
					textoPuesto(i)
					State.aviso(player, "📦 Venta retirada. En la ventanita puedes poner otra o desocupar")
				end
			else
				if p.articulo ~= nil then
					-- Comprar a otro jugador
					if State.quitarDinero(player, p.precio) then
						local vendedor = game:GetService("Players"):GetPlayerByUserId(p["dueño"])
						local gana = math.floor(p.precio * (1 - Config.IMPUESTO_VENTA))
						if vendedor then
							State.darDinero(vendedor, gana, "🎪 vendiste " .. p.articulo)
						end
						darBolsa(player, p.articulo)
						State.aviso(player, "🛍️ Compraste " .. p.articulo .. " por $" .. p.precio)
						p.articulo = nil
						p.precio = 0
						textoPuesto(i)
					else
						State.aviso(player, "💸 No te alcanza ($" .. p.precio .. ")")
					end
				else
					State.aviso(player, "🎪 Este local ya está rentado")
				end
			end
		end)
		-- Toca de nuevo tu puesto (sin venta) para abrir la ventanita:
		-- ahí pones otra venta o desocupas el local.
	end

	-- El dueño pone artículo + precio desde la ventanita.
	State.getEvent("PonerVenta").OnServerEvent:Connect(function(player, indice, articulo, precio)
		local p = puestos[indice]
		if not p or p["dueño"] ~= player.UserId then return end
		-- Desocupar el local
		if articulo == "" then
			puestos[indice] = { ["dueño"] = nil, nombre = "", articulo = nil, precio = 0 }
			textoPuesto(indice)
			State.aviso(player, "👋 Local desocupado. ¡Gracias por vender aquí!")
			return
		end
		local valido = false
		for _, a in ipairs(Config.ARTICULOS_TIANGUIS) do
			if a == articulo then valido = true break end
		end
		precio = math.floor(tonumber(precio) or 0)
		if not valido or precio <= 0 or precio > 100000 then
			State.aviso(player, "⚠️ Elige un artículo y un precio válido")
			return
		end
		p.articulo = articulo
		p.precio = precio
		textoPuesto(indice)
		State.aviso(player, "🏷️ En venta: " .. articulo .. " por $" .. precio)
	end)

	print("[HospitalCorazon] Tianguis conectado 🎪")
end

task.spawn(function()
	local ok = pcall(function()
		workspace:WaitForChild("HospitalCorazonWorld", 30)
	end)
	if ok then conectar() end
end)
]===] },
    { archivo = "FoodSystem.luau", nombre = "FoodSystem", clase = "Script",
      servicio = "ServerScriptService", preservar = false,
      codigo = [===[
--[[
    ============================================================
    FoodSystem (Script)
    DÓNDE VA: ServerScriptService (Script normal)
    ------------------------------------------------------------
    🍔 McCorazón: toca el mostrador para comprar Hamburguesa ($30,
    cura 40) o Papas ($15, cura 20). Te da la comida en la mano:
    tócala (clic) para comerla y recuperar vida.
    ============================================================
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage:WaitForChild("Config"))
local State = require(game:GetService("ServerScriptService"):WaitForChild("HospitalState"))

local function darComida(player, info)
	local tool = Instance.new("Tool")
	tool.Name = info.nombre
	tool.RequiresHandle = false
	tool.ToolTip = "Toca para comer (+ " .. info.cura .. " de vida)"
	tool.CanBeDropped = false
	local scr = Instance.new("Script")
	scr.Name = "ComerServer"
	scr.Source = [[
		local CURA = ]] .. info.cura .. [[
		local tool = script.Parent
		tool.Activated:Connect(function()
			local ch = tool.Parent
			local h = ch and ch:FindFirstChildOfClass("Humanoid")
			if h and h.Health < h.MaxHealth then
				h.Health = math.min(h.MaxHealth, h.Health + CURA)
				tool:Destroy()
			end
		end)
	]]
	scr.Parent = tool
	tool.Parent = player.Backpack
	State.aviso(player, "🍔 ¡Buen provecho! Toca la comida para comerla")
end

local function conectar()
	local mundo = workspace:WaitForChild("HospitalCorazonWorld")
	local mostrador = mundo:WaitForChild("MostradorMc")

	local p1 = Instance.new("ProximityPrompt")
	p1.ActionText = "Comprar Hamburguesa $30"
	p1.ObjectText = "🍔 cura 40"
	p1.HoldDuration = 0.5
	p1.MaxActivationDistance = 10
	p1.RequiresLineOfSight = false
	p1.Parent = mostrador
	p1.Triggered:Connect(function(player)
		if State.quitarDinero(player, Config.HAMBURGUESA.precio) then
			darComida(player, Config.HAMBURGUESA)
		else
			State.aviso(player, "💸 La hamburguesa cuesta $30")
		end
	end)

	local p2 = Instance.new("ProximityPrompt")
	p2.ActionText = "Comprar Papas $15"
	p2.ObjectText = "🍟 cura 20"
	p2.HoldDuration = 0.5
	p2.MaxActivationDistance = 10
	p2.RequiresLineOfSight = false
	p2.Parent = mostrador
	p2.Triggered:Connect(function(player)
		if State.quitarDinero(player, Config.PAPAS.precio) then
			darComida(player, Config.PAPAS)
		else
			State.aviso(player, "💸 Las papas cuestan $15")
		end
	end)
	print("[HospitalCorazon] McCorazón conectado 🍔")
end

task.spawn(function()
	local ok = pcall(function()
		workspace:WaitForChild("HospitalCorazonWorld", 30)
	end)
	if ok then conectar() end
end)
]===] },
    { archivo = "Monetizacion.luau", nombre = "Monetizacion", clase = "Script",
      servicio = "ServerScriptService", preservar = false,
      codigo = [===[
--[[
    ============================================================
    Monetizacion (Script)
    DÓNDE VA: ServerScriptService (Script normal)
    ------------------------------------------------------------
    Pases y productos de Robux. Los IDs se ponen en el Config.
    Mientras un ID sea 0, el botón dice "Próximamente 💤".
    • Pase 2x: doble sueldo en los 30 trabajos, para siempre.
    • Pase VIP ⭐: Cirujano y Veterinario pagan el DOBLE.
    • Pase Casa 👑: puedes comprar la Casa Dorada.
    • Productos: 10,000 y 50,000 monedas (se compran las veces
      que quieras).
    ============================================================
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local Config = require(ReplicatedStorage:WaitForChild("Config"))
local State = require(game:GetService("ServerScriptService"):WaitForChild("HospitalState"))

local PASES = {
	["2X"] = { id = function() return Config.GAMEPASS_2X_ID end, nombre = "💰 2x Sueldo" },
	["VIP"] = { id = function() return Config.GAMEPASS_VIP_ID end, nombre = "⭐ Trabajos VIP" },
	["CASA"] = { id = function() return Config.GAMEPASS_CASA_ID end, nombre = "👑 Casa Dorada" },
}
local PRODUCTOS = {
	["DINERO1"] = { id = function() return Config.DEVPRODUCT_DINERO_1 end, nombre = "10,000 monedas", monto = 10000 },
	["DINERO2"] = { id = function() return Config.DEVPRODUCT_DINERO_2 end, nombre = "50,000 monedas", monto = 50000 },
}

State.getEvent("ComprarPase").OnServerEvent:Connect(function(player, cual)
	local pase = PASES[cual]
	if not pase then return end
	local id = pase.id()
	if id == 0 then
		State.aviso(player, "💤 " .. pase.nombre .. ": Próximamente")
		return
	end
	pcall(function()
		MarketplaceService:PromptGamePassPurchase(player, id)
	end)
end)

State.getEvent("ComprarProducto").OnServerEvent:Connect(function(player, cual)
	local prod = PRODUCTOS[cual]
	if not prod then return end
	local id = prod.id()
	if id == 0 then
		State.aviso(player, "💤 " .. prod.nombre .. ": Próximamente")
		return
	end
	pcall(function()
		MarketplaceService:PromptProductPurchase(player, id)
	end)
end)

-- Cuando se compra un producto de dinero, se acredita.
MarketplaceService.ProcessReceipt = function(info)
	local player = Players:GetPlayerByUserId(info.PlayerId)
	if not player then
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end
	for _, prod in pairs(PRODUCTOS) do
		if info.ProductId == prod.id() and prod.id() ~= 0 then
			State.darDinero(player, prod.monto, "🛒 " .. prod.nombre)
			return Enum.ProductPurchaseDecision.PurchaseGranted
		end
	end
	return Enum.ProductPurchaseDecision.NotProcessedYet
end

print("[HospitalCorazon] Monetización lista 💰")
]===] },
    { archivo = "RoleGui.luau", nombre = "RoleGui", clase = "LocalScript",
      servicio = "StarterGui", preservar = false,
      codigo = [===[
--[[
    ============================================================
    RoleGui (LocalScript)
    DÓNDE VA: StarterGui (LocalScript)
    ------------------------------------------------------------
    Al entrar al juego aparece para elegir tu rol:
    Doctor 🩺, Enfermera 💉 o Paciente 🤒.
    También se abre desde el botón "🎭 Rol" del HUD.
    ============================================================
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local elegirRol = ReplicatedStorage:WaitForChild("ElegirRol")

local gui = Instance.new("ScreenGui")
gui.Name = "RoleGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local fondo = Instance.new("Frame")
fondo.Size = UDim2.new(1, 0, 1, 0)
fondo.BackgroundColor3 = Color3.fromRGB(20, 25, 40)
fondo.BackgroundTransparency = 0.35
fondo.Parent = gui

local caja = Instance.new("Frame")
caja.Size = UDim2.new(0, 420, 0, 340)
caja.Position = UDim2.new(0.5, -210, 0.5, -170)
caja.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
caja.Parent = fondo
local esq = Instance.new("UICorner")
esq.CornerRadius = UDim.new(0, 18)
esq.Parent = caja

local titulo = Instance.new("TextLabel")
titulo.Size = UDim2.new(1, 0, 0, 60)
titulo.BackgroundTransparency = 1
titulo.Text = "🏥 Elige tu rol"
titulo.Font = Enum.Font.GothamBold
titulo.TextSize = 30
titulo.TextColor3 = Color3.fromRGB(40, 90, 160)
titulo.Parent = caja

local roles = {
	{ nombre = "Doctor", emoji = "🩺", desc = "Cura jugadores y gana $50 por cura" },
	{ nombre = "Enfermera", emoji = "💉", desc = "Cura jugadores y gana $30 por cura" },
	{ nombre = "Paciente", emoji = "🤒", desc = "Te pueden curar · haz cualquier trabajo" },
}

for i, r in ipairs(roles) do
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1, -40, 0, 74)
	b.Position = UDim2.new(0, 20, 0, 66 + (i - 1) * 84)
	b.BackgroundColor3 = Color3.fromRGB(60, 130, 200)
	b.Text = r.emoji .. "  " .. r.nombre .. "\n" .. r.desc
	b.Font = Enum.Font.GothamBold
	b.TextSize = 17
	b.TextColor3 = Color3.new(1, 1, 1)
	b.AutoButtonColor = true
	b.Parent = caja
	local e = Instance.new("UICorner")
	e.CornerRadius = UDim.new(0, 12)
	e.Parent = b
	b.MouseButton1Click:Connect(function()
		elegirRol:FireServer(r.nombre)
		fondo.Visible = false
	end)
end

-- El HUD puede reabrir esta ventanita.
local abrir = Instance.new("BindableEvent")
abrir.Name = "AbrirRoles"
abrir.Parent = gui
abrir.Event:Connect(function()
	fondo.Visible = true
end)
]===] },
    { archivo = "MarketGui.luau", nombre = "MarketGui", clase = "LocalScript",
      servicio = "StarterGui", preservar = false,
      codigo = [===[
--[[
    ============================================================
    MarketGui (LocalScript)
    DÓNDE VA: StarterGui (LocalScript)
    ------------------------------------------------------------
    Ventanita del tianguis: cuando rentas un local, aquí eliges
    qué vender (Ropa, Comida, Flor, Cuadro, Juguete, Sombrero)
    y a qué precio. También puedes desocupar el local.
    ============================================================
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local ponerVenta = ReplicatedStorage:WaitForChild("PonerVenta")
local abrirMercado = ReplicatedStorage:WaitForChild("AbrirMercado")

local ARTICULOS = { "Ropa 👕", "Comida 🍎", "Flor 🌸", "Cuadro 🖼️", "Juguete 🧸", "Sombrero 🎩" }

local gui = Instance.new("ScreenGui")
gui.Name = "MarketGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local fondo = Instance.new("Frame")
fondo.Size = UDim2.new(1, 0, 1, 0)
fondo.BackgroundColor3 = Color3.fromRGB(20, 25, 40)
fondo.BackgroundTransparency = 0.35
fondo.Visible = false
fondo.Parent = gui

local caja = Instance.new("Frame")
caja.Size = UDim2.new(0, 400, 0, 440)
caja.Position = UDim2.new(0.5, -200, 0.5, -220)
caja.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
caja.Parent = fondo
local esq = Instance.new("UICorner")
esq.CornerRadius = UDim.new(0, 18)
esq.Parent = caja

local titulo = Instance.new("TextLabel")
titulo.Size = UDim2.new(1, 0, 0, 50)
titulo.BackgroundTransparency = 1
titulo.Text = "🎪 Mi local"
titulo.Font = Enum.Font.GothamBold
titulo.TextSize = 26
titulo.TextColor3 = Color3.fromRGB(150, 80, 180)
titulo.Parent = caja

local indiceActual = 0
local articuloSel = ARTICULOS[1]

local y = 60
for _, a in ipairs(ARTICULOS) do
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0.5, -30, 0, 44)
	b.Position = UDim2.new((a == ARTICULOS[1] or a == ARTICULOS[3] or a == ARTICULOS[5]) and 0 or 0.5, 20, 0, y)
	b.BackgroundColor3 = Color3.fromRGB(235, 225, 245)
	b.Text = a
	b.Font = Enum.Font.GothamBold
	b.TextSize = 16
	b.TextColor3 = Color3.fromRGB(90, 50, 120)
	b.Parent = caja
	local e = Instance.new("UICorner")
	e.CornerRadius = UDim.new(0, 10)
	e.Parent = b
	b.MouseButton1Click:Connect(function()
		articuloSel = a
		for _, otro in ipairs(caja:GetChildren()) do
			if otro:IsA("TextButton") and otro ~= b and otro.Name ~= "VenderBtn"
				and otro.Name ~= "DesocuparBtn" and otro.Name ~= "CerrarBtn" then
				otro.BackgroundColor3 = Color3.fromRGB(235, 225, 245)
			end
		end
		b.BackgroundColor3 = Color3.fromRGB(180, 130, 220)
	end)
	if a == ARTICULOS[2] or a == ARTICULOS[4] or a == ARTICULOS[6] then
		y += 52
	end
end

local etiqueta = Instance.new("TextLabel")
etiqueta.Size = UDim2.new(1, -40, 0, 24)
etiqueta.Position = UDim2.new(0, 20, 0, y + 8)
etiqueta.BackgroundTransparency = 1
etiqueta.Text = "Precio ($):"
etiqueta.Font = Enum.Font.GothamBold
etiqueta.TextSize = 16
etiqueta.TextColor3 = Color3.fromRGB(60, 60, 70)
etiqueta.TextXAlignment = Enum.TextXAlignment.Left
etiqueta.Parent = caja

local precioBox = Instance.new("TextBox")
precioBox.Size = UDim2.new(1, -40, 0, 44)
precioBox.Position = UDim2.new(0, 20, 0, y + 36)
precioBox.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
precioBox.Text = "100"
precioBox.Font = Enum.Font.GothamBold
precioBox.TextSize = 18
precioBox.TextColor3 = Color3.fromRGB(40, 40, 50)
precioBox.Parent = caja
local ep = Instance.new("UICorner")
ep.CornerRadius = UDim.new(0, 10)
ep.Parent = precioBox

local vender = Instance.new("TextButton")
vender.Name = "VenderBtn"
vender.Size = UDim2.new(1, -40, 0, 50)
vender.Position = UDim2.new(0, 20, 0, y + 92)
vender.BackgroundColor3 = Color3.fromRGB(90, 170, 90)
vender.Text = "🏷️ Poner a la venta"
vender.Font = Enum.Font.GothamBold
vender.TextSize = 18
vender.TextColor3 = Color3.new(1, 1, 1)
vender.Parent = caja
local ev = Instance.new("UICorner")
ev.CornerRadius = UDim.new(0, 12)
ev.Parent = vender
vender.MouseButton1Click:Connect(function()
	ponerVenta:FireServer(indiceActual, articuloSel, tonumber(precioBox.Text) or 0)
	fondo.Visible = false
end)

local desocupar = Instance.new("TextButton")
desocupar.Name = "DesocuparBtn"
desocupar.Size = UDim2.new(0.5, -25, 0, 44)
desocupar.Position = UDim2.new(0, 20, 0, y + 150)
desocupar.BackgroundColor3 = Color3.fromRGB(220, 90, 90)
desocupar.Text = "👋 Desocupar"
desocupar.Font = Enum.Font.GothamBold
desocupar.TextSize = 16
desocupar.TextColor3 = Color3.new(1, 1, 1)
desocupar.Parent = caja
local ed = Instance.new("UICorner")
ed.CornerRadius = UDim.new(0, 10)
ed.Parent = desocupar
desocupar.MouseButton1Click:Connect(function()
	ponerVenta:FireServer(indiceActual, "", 0)
	fondo.Visible = false
end)

local cerrar = Instance.new("TextButton")
cerrar.Name = "CerrarBtn"
cerrar.Size = UDim2.new(0.5, -25, 0, 44)
cerrar.Position = UDim2.new(0.5, 5, 0, y + 150)
cerrar.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
cerrar.Text = "Cerrar"
cerrar.Font = Enum.Font.GothamBold
cerrar.TextSize = 16
cerrar.TextColor3 = Color3.new(1, 1, 1)
cerrar.Parent = caja
local ec = Instance.new("UICorner")
ec.CornerRadius = UDim.new(0, 10)
ec.Parent = cerrar
cerrar.MouseButton1Click:Connect(function()
	fondo.Visible = false
end)

abrirMercado.OnClientEvent:Connect(function(indice)
	indiceActual = indice
	fondo.Visible = true
end)
]===] },
    { archivo = "HudGui.luau", nombre = "HudGui", clase = "LocalScript",
      servicio = "StarterGui", preservar = false,
      codigo = [===[
--[[
    ============================================================
    HudGui (LocalScript)
    DÓNDE VA: StarterGui (LocalScript)
    ------------------------------------------------------------
    Barra superior: tu dinero 💰, tu rol 🎭 y tu último trabajo.
    Botones: 🎭 cambiar de rol, 🛒 tienda de Robux (pases y
    productos). Todo con esquinas redondeadas y colores del
    hospital (blanco y azul).
    ============================================================
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local hudRefresh = ReplicatedStorage:WaitForChild("HudRefresh")
local comprarPase = ReplicatedStorage:WaitForChild("ComprarPase")
local comprarProducto = ReplicatedStorage:WaitForChild("ComprarProducto")

local gui = Instance.new("ScreenGui")
gui.Name = "HudGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local barra = Instance.new("Frame")
barra.Size = UDim2.new(1, -20, 0, 56)
barra.Position = UDim2.new(0, 10, 0, 10)
barra.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
barra.BackgroundTransparency = 0.08
barra.Parent = gui
local eb = Instance.new("UICorner")
eb.CornerRadius = UDim.new(0, 14)
eb.Parent = barra

local function etiqueta(xp, ancho)
	local t = Instance.new("TextLabel")
	t.Size = UDim2.new(0, ancho, 1, 0)
	t.Position = UDim2.new(0, xp, 0, 0)
	t.BackgroundTransparency = 1
	t.Font = Enum.Font.GothamBold
	t.TextSize = 17
	t.TextColor3 = Color3.fromRGB(40, 90, 160)
	t.TextXAlignment = Enum.TextXAlignment.Left
	t.Parent = barra
	return t
end

local dineroLbl = etiqueta(16, 200)
local rolLbl = etiqueta(220, 220)
local trabajoLbl = etiqueta(440, 320)

local function boton(texto, xp)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0, 120, 0, 40)
	b.Position = UDim2.new(1, xp, 0, 8)
	b.BackgroundColor3 = Color3.fromRGB(60, 130, 200)
	b.Text = texto
	b.Font = Enum.Font.GothamBold
	b.TextSize = 16
	b.TextColor3 = Color3.new(1, 1, 1)
	b.Parent = barra
	local e = Instance.new("UICorner")
	e.CornerRadius = UDim.new(0, 10)
	e.Parent = b
	return b
end

local rolBtn = boton("🎭 Rol", -260)
local tiendaBtn = boton("🛒 Tienda", -130)

rolBtn.MouseButton1Click:Connect(function()
	local rg = player.PlayerGui:FindFirstChild("RoleGui")
	local abrir = rg and rg:FindFirstChild("AbrirRoles")
	if abrir then abrir:Fire() end
end)

-- ---------- Tienda ----------
local fondoT = Instance.new("Frame")
fondoT.Size = UDim2.new(1, 0, 1, 0)
fondoT.BackgroundColor3 = Color3.fromRGB(20, 25, 40)
fondoT.BackgroundTransparency = 0.35
fondoT.Visible = false
fondoT.Parent = gui

local cajaT = Instance.new("Frame")
cajaT.Size = UDim2.new(0, 400, 0, 430)
cajaT.Position = UDim2.new(0.5, -200, 0.5, -215)
cajaT.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
cajaT.Parent = fondoT
local et = Instance.new("UICorner")
et.CornerRadius = UDim.new(0, 18)
et.Parent = cajaT

local titT = Instance.new("TextLabel")
titT.Size = UDim2.new(1, 0, 0, 50)
titT.BackgroundTransparency = 1
titT.Text = "🛒 Tienda de Robux"
titT.Font = Enum.Font.GothamBold
titT.TextSize = 24
titT.TextColor3 = Color3.fromRGB(40, 90, 160)
titT.Parent = cajaT

local function itemTienda(texto, desc, yy, fn)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1, -40, 0, 58)
	b.Position = UDim2.new(0, 20, 0, yy)
	b.BackgroundColor3 = Color3.fromRGB(60, 130, 200)
	b.Text = texto .. "\n" .. desc
	b.Font = Enum.Font.GothamBold
	b.TextSize = 16
	b.TextColor3 = Color3.new(1, 1, 1)
	b.Parent = cajaT
	local e = Instance.new("UICorner")
	e.CornerRadius = UDim.new(0, 10)
	e.Parent = b
	b.MouseButton1Click:Connect(fn)
end

itemTienda("💰 2x Sueldo (pase)", "Doble sueldo para siempre", 60,
	function() comprarPase:FireServer("2X") end)
itemTienda("⭐ Trabajos VIP (pase)", "Cirujano y Veterinario pagan doble", 126,
	function() comprarPase:FireServer("VIP") end)
itemTienda("👑 Casa Dorada (pase)", "Compra la casa dorada exclusiva", 192,
	function() comprarPase:FireServer("CASA") end)
itemTienda("💵 10,000 monedas", "Producto (se puede repetir)", 258,
	function() comprarProducto:FireServer("DINERO1") end)
itemTienda("💵 50,000 monedas", "Producto (se puede repetir)", 324,
	function() comprarProducto:FireServer("DINERO2") end)

local cerrarT = Instance.new("TextButton")
cerrarT.Size = UDim2.new(1, -40, 0, 44)
cerrarT.Position = UDim2.new(0, 20, 0, 388 - 8)
cerrarT.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
cerrarT.Text = "Cerrar"
cerrarT.Font = Enum.Font.GothamBold
cerrarT.TextSize = 16
cerrarT.TextColor3 = Color3.new(1, 1, 1)
cerrarT.Parent = cajaT
local ect = Instance.new("UICorner")
ect.CornerRadius = UDim.new(0, 10)
ect.Parent = cerrarT
cerrarT.MouseButton1Click:Connect(function()
	fondoT.Visible = false
end)

tiendaBtn.MouseButton1Click:Connect(function()
	fondoT.Visible = true
end)

-- ---------- Actualización ----------
hudRefresh.OnClientEvent:Connect(function(info)
	dineroLbl.Text = "💰 $" .. (info.dinero or 0)
	rolLbl.Text = "🎭 " .. (info.rol or "—")
	local tr = info.trabajo or "—"
	if tr ~= "—" then
		tr = tr .. " Nv." .. (info.nivel or 1)
	end
	trabajoLbl.Text = "💼 " .. tr
	-- Pop animado en el dinero
	TweenService:Create(dineroLbl, TweenInfo.new(0.18), { TextSize = 21 }):Play()
	task.delay(0.2, function()
		TweenService:Create(dineroLbl, TweenInfo.new(0.18), { TextSize = 17 }):Play()
	end)
end)
]===] },
    { archivo = "AvisoGui.luau", nombre = "AvisoGui", clase = "LocalScript",
      servicio = "StarterGui", preservar = false,
      codigo = [===[
--[[
    ============================================================
    AvisoGui (LocalScript)
    DÓNDE VA: StarterGui (LocalScript)
    ------------------------------------------------------------
    Avisos flotantes en pantalla: "+$80 💼 Panadero",
    "🎉 ¡Nivel 2!", etc. Aparecen abajo, suben con animación
    suave y se desvanecen. Los manda el servidor.
    ============================================================
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local avisoEv = ReplicatedStorage:WaitForChild("Aviso")

local gui = Instance.new("ScreenGui")
gui.Name = "AvisoGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local contenedor = Instance.new("Frame")
contenedor.Size = UDim2.new(0, 360, 0, 200)
contenedor.Position = UDim2.new(0.5, -180, 1, -230)
contenedor.BackgroundTransparency = 1
contenedor.Parent = gui
local lista = Instance.new("UIListLayout")
lista.SortOrder = Enum.SortOrder.LayoutOrder
lista.Padding = UDim.new(0, 6)
lista.HorizontalAlignment = Enum.HorizontalAlignment.Center
lista.Parent = contenedor

avisoEv.OnClientEvent:Connect(function(texto)
	local f = Instance.new("Frame")
	f.Size = UDim2.new(0, 340, 0, 40)
	f.BackgroundColor3 = Color3.fromRGB(30, 35, 55)
	f.BackgroundTransparency = 0.15
	f.LayoutOrder = -os.clock()
	f.Parent = contenedor
	local e = Instance.new("UICorner")
	e.CornerRadius = UDim.new(0, 12)
	e.Parent = f
	local t = Instance.new("TextLabel")
	t.Size = UDim2.new(1, -20, 1, 0)
	t.Position = UDim2.new(0, 10, 0, 0)
	t.BackgroundTransparency = 1
	t.Text = texto
	t.Font = Enum.Font.GothamBold
	t.TextSize = 16
	t.TextColor3 = Color3.new(1, 1, 1)
	t.Parent = f
	-- Sube y se desvanece
	task.delay(2.2, function()
		local tw = TweenService:Create(f, TweenInfo.new(0.6),
			{ BackgroundTransparency = 1 })
		tw:Play()
		TweenService:Create(t, TweenInfo.new(0.6), { TextTransparency = 1 }):Play()
		tw.Completed:Wait()
		f:Destroy()
	end)
end)
]===] },
}

local EVENTOS = { "Aviso", "HudRefresh", "ComprarPase", "ComprarProducto", "ElegirRol", "Curar", "PonerVenta", "AbrirMercado" }

boton.Click:Connect(function()
    local creados, actualizados = 0, 0

    -- 1) RemoteEvents
    local rs = game:GetService("ReplicatedStorage")
    for _, nombre in ipairs(EVENTOS) do
        if not rs:FindFirstChild(nombre) then
            local ev = Instance.new("RemoteEvent")
            ev.Name = nombre
            ev.Parent = rs
            creados += 1
        end
    end

    -- 2) Scripts
    for _, a in ipairs(ARCHIVOS) do
        local lugar = destino(a.servicio)
        local obj = lugar:FindFirstChild(a.nombre)
        if obj and obj:IsA(a.clase) then
            if a.preservar then
                -- El Config ya existe: no se toca (ahí están tus IDs).
                print("[HospitalCorazon] " .. a.nombre .. " ya existe, no lo toco.")
            else
                obj.Source = a.codigo
                actualizados += 1
            end
        else
            if obj then obj:Destroy() end -- había algo con otro tipo; se reemplaza
            local nuevo = Instance.new(a.clase)
            nuevo.Name = a.nombre
            nuevo.Source = a.codigo
            nuevo.Parent = lugar
            creados += 1
        end
    end

    print("[HospitalCorazon] Listo: " .. creados .. " creados, " .. actualizados .. " actualizados.")
    print("[HospitalCorazon] Presiona Play \u{25B6} para probar tu juego 🏥")
end)

print("[HospitalCorazon] Plugin cargado. Toca 'Instalar todo' en la barra Hospital Corazón.")
