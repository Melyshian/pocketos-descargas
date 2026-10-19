--[[
    ============================================================
    Parkour Imposible 💖 — Instalador (Plugin de Roblox Studio)
    ------------------------------------------------------------
    CÓMO USARLO (solo una vez):
      1. Copia este archivo a tu carpeta de plugins:
         %LOCALAPPDATA%\\Roblox\\Plugins\\
         (En tu PC: abre el Explorador de Windows, pega arriba
         %LOCALAPPDATA%\\Roblox\\Plugins y presiona Enter.
         Si la carpeta Plugins no existe, créala tú.)
      2. Cierra y vuelve a abrir Roblox Studio.
      3. Arriba verás la pestaña "Parkour Imposible 💖" con el botón
         "Instalar todo". Tócalo con tu lugar abierto.
      4. ¡Listo! Crea los 7 scripts y los 4 RemoteEvents en sus
         lugares. El Config NO se toca si ya existe (ahí van
         tus IDs de pases y productos cuando los crees).
    ============================================================
]]

local toolbar = plugin:CreateToolbar("Parkour Imposible 💖")
local boton = toolbar:CreateButton(
    "Instalar todo",
    "Crea los 7 scripts y 4 RemoteEvents del juego Parkour Imposible",
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
      servicio = "ReplicatedStorage", preservar = false,
      codigo = [===[
--[[
    ============================================================
    Config (ModuleScript) -> ReplicatedStorage
    Ajustes del Parkour Imposible. NO se sobrescribe al
    reinstalar (ahí guardas tus IDs de pases y productos).
    ============================================================
]]

local Config = {}

-- Tu usuario de Roblox (admin)
Config.ADMIN = "Melyshian"

-- Cantidad de niveles
Config.NUM_NIVELES = 500

-- DataStore donde se guarda el checkpoint de cada jugador
Config.DATASTORE = "ParkourImposibleV1"

-- Paleta LLAMATIVA: colores saturados que resaltan en el pasto.
-- Se ciclan por nivel (nivel 1 = magenta, 2 = cian, etc.)
Config.COLORES = {
    {255, 45, 120},   -- magenta eléctrico
    {0, 200, 255},     -- cian
    {140, 255, 0},     -- lima ácido
    {255, 140, 0},     -- naranja vivo
    {150, 60, 255},    -- morado
    {255, 230, 0},     -- amarillo
}

-- ============================================================
-- MONETIZACIÓN: pega aquí los IDs cuando crees los pases y el
-- producto en create.roblox.com. Mientras estén en 0, la tienda
-- muestra "Próximamente 💤".
-- ============================================================
Config.PASE_SKIP_ID = 0       -- ⏭️ Brinca Nivel (pase)
Config.PASE_SPEED_ID = 0      -- ⚡ Bobina Veloz (pase)
Config.PASE_GRAVITY_ID = 0    -- 🌙 Bobina Lunar (pase)
Config.PRODUCTO_REVIVIR_ID = 0 -- 💖 Revivir (producto)
Config.PRODUCTO_GIGANTE_ID = 0 -- 🦣 Gigante x5 min (producto)

Config.NOMBRES = {
    skip = "⏭️ Brinca Nivel",
    speed = "⚡ Bobina Veloz",
    gravity = "🌙 Bobina Lunar",
    revivir = "💖 Revivir",
    gigante = "🦣 Gigante x5 min",
}

Config.DESCRIPCIONES = {
    skip = "Salta directo al siguiente checkpoint. ¡Sin espera!",
    speed = "Corre rapidísimo con tu bobina neón.",
    gravity = "Salta altísimo con tu bobina lunar.",
    revivir = "Vuelve a tu último checkpoint al instante.",
    gigante = "Sé gigante 5 minutos más. ¡Que todos te vean!",
}

return Config
]===] },
    { archivo = "StageBuilder.luau", nombre = "StageBuilder", clase = "Script",
      servicio = "ServerScriptService", preservar = false,
      codigo = [===[
--[[
    ============================================================
    StageBuilder (Script) -> ServerScriptService
    Construye 500 niveles de parkour IMPOSIBLE pero ganable,
    sin piso (vacío: caerse = muerte), 10 zonas temáticas,
    10 tipos de obstáculos variados. Checkpoints cada nivel.
    ============================================================
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage:WaitForChild("Config"))

local mundo = Instance.new("Folder")
mundo.Name = "ParkourImposibleWorld"
mundo.Parent = workspace

-- ---------- sin piso: vacío ----------
-- (FallenPartsDestroyHeight se configura en el instalador, no aquí)
local base = workspace:FindFirstChild("Baseplate")
if base then
    base:Destroy()
end

-- ---------- cielo ----------
local light = game:GetService("Lighting")
light.ClockTime = 15
light.Brightness = 2
for _, e in ipairs(light:GetChildren()) do
    if e:IsA("BloomEffect") or e:IsA("SunRaysEffect") then
        e:Destroy()
    end
end

-- ---------- helpers ----------
local function P(size, pos, color, mat)
    local p = Instance.new("Part")
    p.Size = Vector3.new(size[1], size[2], size[3])
    p.Position = Vector3.new(pos[1], pos[2], pos[3])
    p.Color = color
    p.Material = mat or Enum.Material.SmoothPlastic
    p.Anchored = true
    p.TopSurface = Enum.SurfaceType.Smooth
    p.BottomSurface = Enum.SurfaceType.Smooth
    p.Parent = mundo
    return p
end

local function killBrick(size, pos)
    local k = P(size, pos, Color3.fromRGB(255, 25, 25), Enum.Material.Neon)
    k.Name = "Kill"
    return k
end

local function checkpointPad(n, pos)
    local c = P({6, 1, 6}, pos, Color3.fromRGB(0, 255, 150), Enum.Material.Neon)
    c.Name = "Checkpoint_" .. n
    local gui = Instance.new("BillboardGui")
    gui.Size = UDim2.new(0, 120, 0, 60)
    gui.StudsOffset = Vector3.new(0, 4, 0)
    gui.AlwaysOnTop = true
    gui.Parent = c
    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(1, 0, 1, 0)
    t.BackgroundTransparency = 1
    t.Text = "✔ " .. n
    t.Font = Enum.Font.GothamBold
    t.TextScaled = true
    t.TextColor3 = Color3.new(1, 1, 1)
    t.TextStrokeTransparency = 0
    t.Parent = gui
    return c
end

local function letrero(texto, pos, colorFondo, tam)
    local p = P(tam or {13, 7, 1}, pos, colorFondo or Color3.fromRGB(15, 15, 25), Enum.Material.SmoothPlastic)
    local gui = Instance.new("SurfaceGui")
    gui.Parent = p
    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(1, 0, 1, 0)
    t.BackgroundTransparency = 1
    t.Text = texto
    t.Font = Enum.Font.GothamBold
    t.TextScaled = true
    t.TextColor3 = Color3.new(1, 1, 1)
    t.Parent = gui
    local ancho = (tam and tam[1] or 13)
    P({0.8, 9, 0.8}, {pos[1] - ancho / 2 - 0.5, pos[2] - 7, pos[3]}, Color3.fromRGB(255, 45, 120), Enum.Material.Neon)
    P({0.8, 9, 0.8}, {pos[1] + ancho / 2 + 0.5, pos[2] - 7, pos[3]}, Color3.fromRGB(255, 45, 120), Enum.Material.Neon)
    return p
end

-- pad de rebote (divertido)
local function rebotePad(pos)
    local b = P({4, 0.8, 4}, pos, Color3.fromRGB(255, 200, 40), Enum.Material.Neon)
    b.Touched:Connect(function(hit)
        local hum = hit.Parent and hit.Parent:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health > 0 then
            local root = hit.Parent:FindFirstChild("HumanoidRootPart")
            if root then
                root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X * 0.5, 95, root.AssemblyLinearVelocity.Z * 0.5)
            end
        end
    end)
    return b
end

local hieloFisica = PhysicalProperties.new(0.08, 0.2, 0.5)

-- ---------- spawn ----------
local spawn = Instance.new("SpawnLocation")
spawn.Size = Vector3.new(6, 1, 6)
spawn.Position = Vector3.new(0, 2, -14)
spawn.Anchored = true
spawn.Transparency = 1
spawn.CanCollide = false
spawn.Neutral = true
spawn.Parent = mundo
P({10, 1, 10}, {0, 0.5, -14}, Color3.fromRGB(40, 40, 60), Enum.Material.SmoothPlastic)

letrero("💖 PARKOUR IMPOSIBLE 💖", {0, 11, -26})
letrero("⭐ Creado por Melyshian ⭐", {0, 4.2, -26}, Color3.fromRGB(90, 20, 60), {10, 3, 1})

-- ---------- 10 zonas temáticas ----------
local TEMAS = {
    { nombre = "ARCOIRIS 🌈", colores = {{255,80,120},{255,160,40},{255,230,60},{80,220,120},{80,160,255},{170,90,255}} },
    { nombre = "FUEGO 🔥", colores = {{200,40,30},{235,90,20},{250,150,30},{120,25,20},{255,200,80},{180,60,10}} },
    { nombre = "HIELO ❄️", colores = {{180,230,255},{120,200,250},{220,245,255},{150,180,230},{90,160,220},{200,240,250}} },
    { nombre = "DULCE 🍭", colores = {{255,150,200},{255,200,220},{200,120,255},{255,120,150},{255,220,240},{180,100,220}} },
    { nombre = "ESPACIO 🚀", colores = {{40,30,90},{70,40,140},{100,60,200},{30,20,70},{130,90,255},{20,40,120}} },
    { nombre = "SELVA 🌿", colores = {{30,120,60},{60,160,80},{20,90,50},{120,180,70},{40,140,90},{90,200,100}} },
    { nombre = "DESIERTO 🏜️", colores = {{230,190,120},{210,160,90},{240,210,140},{190,140,70},{250,230,170},{170,120,60}} },
    { nombre = "OCEANO 🌊", colores = {{20,100,180},{40,140,220},{10,70,140},{80,180,255},{0,50,110},{120,200,255}} },
    { nombre = "NEON 💜", colores = {{255,0,200},{0,255,255},{150,0,255},{255,255,0},{0,255,150},{255,0,120}} },
    { nombre = "LEYENDA 👑", colores = {{255,210,60},{200,160,40},{255,230,120},{150,110,30},{255,240,180},{180,140,50}} },
}

local function colorTema(ti, i)
    local c = TEMAS[ti].colores[((i - 1) % 6) + 1]
    return Color3.fromRGB(c[1], c[2], c[3])
end

-- ---------- 10 tipos de obstáculos ----------
-- Cada uno recibe (x, z, dir, tam, salto, col) y regresa el nuevo x.
local function gPrecision(x, z, dir, tam, salto, col)
    for _ = 1, 3 do
        x = x + dir * salto
        P({tam, 1, tam}, {x, 1, z}, col, Enum.Material.SmoothPlastic)
    end
    return x
end

local function gViga(x, z, dir, tam, salto, col)
    x = x + dir * 13
    P({24, 0.7, 1.6}, {x, 1, z}, col, Enum.Material.SmoothPlastic)
    return x + dir * 13
end

local function gFantasma(x, z, dir, tam, salto, col)
    for _ = 1, 3 do
        x = x + dir * salto
        local b = P({tam + 1.2, 1, tam + 1.2}, {x, 1, z}, col, Enum.Material.Neon)
        b.Name = "Fantasma"
    end
    return x
end

local function gCuerda(x, z, dir, tam, salto, col)
    x = x + dir * 11
    P({20, 0.5, 0.8}, {x, 1, z}, col, Enum.Material.Wood)
    x = x + dir * 11
    P({0.8, 0.5, 20}, {x, 1, z}, col, Enum.Material.Wood)
    return x + dir * 11
end

local function gRebote(x, z, dir, tam, salto, col)
    x = x + dir * salto
    rebotePad({x, 1, z})
    x = x + dir * (salto + 6)
    P({tam + 2, 1, tam + 2}, {x, 1, z}, col, Enum.Material.SmoothPlastic)
    return x
end

local function gHielo(x, z, dir, tam, salto, col)
    for _ = 1, 2 do
        x = x + dir * salto
        local b = P({tam + 3, 1, tam + 3}, {x, 1, z}, Color3.fromRGB(180, 230, 255), Enum.Material.Glass)
        b.CustomPhysicalProperties = hieloFisica
    end
    return x
end

local function gMuro(x, z, dir, tam, salto, col)
    x = x + dir * salto
    -- muro de kill con hueco en medio para pasar saltando
    killBrick({10, 5, 1}, {x - 5.5, 3, z})
    killBrick({10, 5, 1}, {x + 5.5, 3, z})
    killBrick({22, 1.2, 1}, {x, 6.5, z})
    P({3.5, 1, 3.5}, {x, 1, z}, col, Enum.Material.SmoothPlastic)
    return x + dir * salto
end

local function gZigzag(x, z, dir, tam, salto, col)
    for i = 1, 4 do
        x = x + dir * (salto * 0.7)
        local dz = (i % 2 == 1) and 6 or -6
        P({tam, 1, tam}, {x, 1, z + dz}, col, Enum.Material.SmoothPlastic)
    end
    return x
end

local function gEscalera(x, z, dir, tam, salto, col)
    for i = 1, 4 do
        x = x + dir * 6
        P({tam + 1, 1, tam + 1}, {x, 1 + i * 2.2, z}, col, Enum.Material.SmoothPlastic)
    end
    x = x + dir * salto
    P({tam + 2, 1, tam + 2}, {x, 1 + 4 * 2.2, z}, col, Enum.Material.SmoothPlastic)
    return x
end

local function gMixto(x, z, dir, tam, salto, col)
    x = gPrecision(x, z, dir, tam, salto, col)
    x = x + dir * 4
    x = gViga(x, z, dir, tam, salto, col)
    return x
end

local GRUPOS = { gPrecision, gViga, gFantasma, gCuerda, gRebote, gHielo, gMuro, gZigzag, gEscalera, gMixto }

-- ---------- plataformas móviles (te llevan) ----------
local moviles = {}
local Players = game:GetService("Players")

local function gMovil(x, z, dir, tam, salto, col)
    x = x + dir * salto
    local p = P({5, 1, 5}, {x, 1, z}, col, Enum.Material.SmoothPlastic)
    table.insert(moviles, {
        parte = p,
        centro = Vector3.new(x, 1, z),
        eje = Vector3.new(0, 0, 1),
        rango = 8,
        fase = math.random() * 6.28,
        velocidad = 1.2,
    })
    x = x + dir * (salto + 4)
    P({tam + 2, 1, tam + 2}, {x, 1, z}, col, Enum.Material.SmoothPlastic)
    return x
end
table.insert(GRUPOS, gMovil)

-- ---------- 4 tiers de dificultad ----------
local TIERS = {
    { nombre = "FÁCIL 🟢", desde = 1 },
    { nombre = "MEDIO 🟡", desde = 126 },
    { nombre = "DIFÍCIL 🔴", desde = 251 },
    { nombre = "ULTRA DIFÍCIL 💀", desde = 376 },
}
local function tierDe(n)
    if n >= 376 then return 4
    elseif n >= 251 then return 3
    elseif n >= 126 then return 2
    else return 1 end
end

-- ---------- construir los 500 niveles ----------
local ESP = 55
for n = 1, Config.NUM_NIVELES do
    local ti = math.floor((n - 1) / 50) + 1
    local t = tierDe(n)
    local prog = (n - TIERS[t].desde) / 125
    local z = (n - 1) * ESP
    local dir = (n % 2 == 1) and 1 or -1
    local xBase = (dir == 1) and 0 or 130
    -- dificultad ganable por tier (siempre posible)
    local tam, salto
    if t == 1 then tam = 4.6 - prog * 0.6; salto = 11 + prog * 1
    elseif t == 2 then tam = 4.0 - prog * 0.8; salto = 12 + prog * 1.5
    elseif t == 3 then tam = 3.2 - prog * 0.6; salto = 13.5 + prog * 1.5
    else tam = 2.6 - prog * 0.4; salto = 15 + prog * 1 end

    -- cartel de zona cada 50 niveles
    if (n - 1) % 50 == 0 then
        letrero("ZONA: " .. TEMAS[ti].nombre, {xBase, 12, z - 16}, Color3.fromRGB(15, 15, 25), {20, 8, 1})
    end

    -- cartel de tier al cambiar de dificultad
    if n == TIERS[t].desde then
        letrero("DIFICULTAD: " .. TIERS[t].nombre, {xBase, 20, z - 16}, Color3.fromRGB(15, 15, 25), {24, 8, 1})
    end

    letrero("NIVEL " .. n, {xBase, 10, z - 11}, colorTema(ti, n))

    local x = xBase
    local col = colorTema(ti, n)
    P({7, 1, 7}, {x, 1, z}, col, Enum.Material.SmoothPlastic)
    checkpointPad(n, {x, 2.2, z})
    x = x + dir * 7
    -- 3 grupos distintos por nivel (rotando para no repetir)
    for g = 1, 3 do
        local f = GRUPOS[((n + g * 3 - 1) % 11) + 1]
        x = f(x, z, dir, tam, salto, colorTema(ti, n + g))
    end
    -- puente al siguiente nivel
    local zSig = n * ESP
    P({6, 1, 6}, {x, 1, z}, colorTema(ti, n + 4), Enum.Material.SmoothPlastic)

    -- META FINAL: después del nivel 500
    if n == Config.NUM_NIVELES then
        local mx = x + dir * 14
        local meta = P({10, 1.2, 10}, {mx, 1, z}, Color3.fromRGB(255, 210, 60), Enum.Material.Neon)
        meta.Name = "MetaFinal"
        letrero("🏆 ¡META FINAL! 🏆", {mx, 11, z - 6}, Color3.fromRGB(120, 90, 10), {18, 8, 1})
    end
end

print("[ParkourImposible] Mundo construido: " .. Config.NUM_NIVELES .. " niveles, 10 zonas, sin piso 💖")

-- mover plataformas y llevar a los jugadores parados encima
task.spawn(function()
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    while true do
        local dt = task.wait(0.05)
        for _, m in ipairs(moviles) do
            m.fase = m.fase + dt * m.velocidad
            local nuevaPos = m.centro + m.eje * (math.sin(m.fase) * m.rango)
            local delta = nuevaPos - m.parte.Position
            m.parte.Position = nuevaPos
            for _, plr in ipairs(Players:GetPlayers()) do
                local char = plr.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if root and hum and hum.Health > 0 then
                    params.FilterDescendantsInstances = { char }
                    local ray = workspace:Raycast(root.Position, Vector3.new(0, -6, 0), params)
                    if ray and ray.Instance == m.parte then
                        root.CFrame = root.CFrame + delta
                    end
                end
            end
        end
    end
end)
]===] },
    { archivo = "CheckpointSystem.luau", nombre = "CheckpointSystem", clase = "Script",
      servicio = "ServerScriptService", preservar = false,
      codigo = [===[
--[[
    ============================================================
    CheckpointSystem (Script) -> ServerScriptService
    Guarda el checkpoint de cada jugador (DataStore) y al morir
    reaparece en su último checkpoint. Comando admin: /resetsave
    ============================================================
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DSS = game:GetService("DataStoreService")
local Config = require(ReplicatedStorage:WaitForChild("Config"))

local store = nil
pcall(function()
    store = DSS:GetDataStore(Config.DATASTORE)
end)
local memoria = {} -- respaldo si el DataStore falla

local mundo = workspace:WaitForChild("ParkourImposibleWorld", 30)
local hud = ReplicatedStorage:WaitForChild("HudRefresh")
local aviso = ReplicatedStorage:WaitForChild("Aviso")

local function claveDe(jugador)
    return "pk_" .. jugador.UserId
end

local function leerDato(jugador)
    local clave = claveDe(jugador)
    if memoria[clave] ~= nil then
        return memoria[clave]
    end
    if store then
        local ok, dato = pcall(function()
            return store:GetAsync(clave)
        end)
        if ok then
            memoria[clave] = dato
            return dato
        end
    end
    return nil
end

local function guardarDato(jugador, dato)
    local clave = claveDe(jugador)
    memoria[clave] = dato
    if store then
        pcall(function()
            store:SetAsync(clave, dato)
        end)
    end
end

local function posDeCheckpoint(n)
    local pad = mundo:FindFirstChild("Checkpoint_" .. n)
    if pad then
        return pad.Position + Vector3.new(0, 3, 0)
    end
    return nil
end

local function nivelDe(jugador)
    local v = jugador:FindFirstChild("NivelActual")
    if v then
        return v.Value
    end
    return 0
end

local function llevarACheckpoint(jugador)
    local char = jugador.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then
        return
    end
    local n = nivelDe(jugador)
    if n > 0 then
        local pos = posDeCheckpoint(n)
        if pos then
            root.CFrame = CFrame.new(pos)
        end
    end
end

-- pads: al tocarlos se guarda el progreso
local debounce = {}
for _, pad in ipairs(mundo:GetChildren()) do
    if pad.Name:match("^Checkpoint_") then
        local n = tonumber(pad.Name:match("%d+"))
        pad.Touched:Connect(function(hit)
            local char = hit.Parent
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not hum then
                return
            end
            local jugador = Players:GetPlayerFromCharacter(char)
            if not jugador then
                return
            end
            local ahora = os.clock()
            if debounce[jugador] and ahora - debounce[jugador] < 2 then
                return
            end
            debounce[jugador] = ahora
            if nivelDe(jugador) < n then
                guardarDato(jugador, {nivel = n})
                local v = jugador:FindFirstChild("NivelActual")
                if v then
                    v.Value = n
                end
                aviso:FireClient(jugador, "✅ ¡Checkpoint! Nivel " .. n .. "/" .. Config.NUM_NIVELES)
                hud:FireClient(jugador, n)
            end
        end)
    end
end

local function alEntrar(jugador)
    local v = Instance.new("IntValue")
    v.Name = "NivelActual"
    v.Value = 0
    v.Parent = jugador
    local dato = leerDato(jugador)
    if dato and dato.nivel then
        v.Value = dato.nivel
    end
    jugador.CharacterAdded:Connect(function()
        task.wait(0.3)
        llevarACheckpoint(jugador)
        hud:FireClient(jugador, v.Value)
    end)
    jugador.Chatted:Connect(function(msg)
        if jugador.Name:lower() == Config.ADMIN:lower() and msg == "/resetsave" then
            memoria[claveDe(jugador)] = nil
            if store then
                pcall(function()
                    store:RemoveAsync(claveDe(jugador))
                end)
            end
            v.Value = 0
            aviso:FireClient(jugador, "🧹 Progreso borrado. ¡De nuevo desde cero!")
            hud:FireClient(jugador, 0)
        end
    end)
end

Players.PlayerAdded:Connect(alEntrar)
for _, j in ipairs(Players:GetPlayers()) do
    alEntrar(j)
end

print("[ParkourImposible] CheckpointSystem listo ✅")
]===] },
    { archivo = "KillSystem.luau", nombre = "KillSystem", clase = "Script",
      servicio = "ServerScriptService", preservar = false,
      codigo = [===[
--[[
    ============================================================
    KillSystem (Script) -> ServerScriptService
    Los kill bricks (rojo neón, nombre "Kill") matan al tocarlos.
    Caerse al vacío = muerte normal de Roblox.
    ============================================================
]]

local Players = game:GetService("Players")

local mundo = workspace:WaitForChild("ParkourImposibleWorld", 30)

local ultimoGolpe = {}

for _, k in ipairs(mundo:GetDescendants()) do
    if k.Name == "Kill" and k:IsA("BasePart") then
        k.Touched:Connect(function(hit)
            local char = hit.Parent
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not hum or hum.Health <= 0 then
                return
            end
            local jugador = Players:GetPlayerFromCharacter(char)
            local clave = jugador and jugador.UserId or 0
            local ahora = os.clock()
            if ultimoGolpe[clave] and ahora - ultimoGolpe[clave] < 1 then
                return
            end
            ultimoGolpe[clave] = ahora
            hum.Health = 0
        end)
    end
end

print("[ParkourImposible] KillSystem listo ☠️")
]===] },
    { archivo = "Monetizacion.luau", nombre = "Monetizacion", clase = "Script",
      servicio = "ServerScriptService", preservar = false,
      codigo = [===[
--[[
    ============================================================
    Monetizacion (Script) -> ServerScriptService
    Procesa los 3 pases (skip, bobina veloz, bobina lunar) y el
    producto Revivir. Las bobinas son herramientas que al
    equiparlas dan el boost y al quitarlas lo retiran.
    ============================================================
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Marketplace = game:GetService("MarketplaceService")
local Config = require(ReplicatedStorage:WaitForChild("Config"))

local mundo = workspace:WaitForChild("ParkourImposibleWorld", 30)
local comprarPase = ReplicatedStorage:WaitForChild("ComprarPase")
local comprarProducto = ReplicatedStorage:WaitForChild("ComprarProducto")
local aviso = ReplicatedStorage:WaitForChild("Aviso")

local IDS = {
    skip = Config.PASE_SKIP_ID,
    speed = Config.PASE_SPEED_ID,
    gravity = Config.PASE_GRAVITY_ID,
}

local function tienePase(jugador, id)
    if id == 0 then
        return false
    end
    local ok, tiene = pcall(function()
        return Marketplace:UserOwnsGamePassAsync(jugador.UserId, id)
    end)
    return ok and tiene
end

local function teleportANivel(jugador, n)
    local char = jugador.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local pad = mundo:FindFirstChild("Checkpoint_" .. n)
    if root and pad then
        root.CFrame = CFrame.new(pad.Position + Vector3.new(0, 3, 0))
        return true
    end
    return false
end

local function nivelActual(jugador)
    local v = jugador:FindFirstChild("NivelActual")
    if v then
        return v.Value
    end
    return 0
end

local function crearBobina(nombre, color)
    local tool = Instance.new("Tool")
    tool.Name = nombre
    tool.RequiresHandle = true
    tool.CanBeDropped = false
    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(1, 3, 1)
    handle.Color = color
    handle.Material = Enum.Material.Neon
    handle.Parent = tool
    return tool
end

local function darBobinas(jugador, char)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then
        return
    end
    local mochila = jugador:FindFirstChildOfClass("Backpack")
    if not mochila then
        return
    end
    if tienePase(jugador, Config.PASE_SPEED_ID) then
        if not mochila:FindFirstChild("Bobina Veloz") then
            local t = crearBobina("Bobina Veloz", Color3.fromRGB(0, 200, 255))
            t.Equipped:Connect(function()
                hum.WalkSpeed = 32
            end)
            t.Unequipped:Connect(function()
                hum.WalkSpeed = 16
            end)
            t.Parent = mochila
        end
    end
    if tienePase(jugador, Config.PASE_GRAVITY_ID) then
        if not mochila:FindFirstChild("Bobina Lunar") then
            local t = crearBobina("Bobina Lunar", Color3.fromRGB(150, 60, 255))
            t.Equipped:Connect(function()
                hum.JumpPower = 80
            end)
            t.Unequipped:Connect(function()
                hum.JumpPower = 50
            end)
            t.Parent = mochila
        end
    end
end

local function alEntrar(jugador)
    jugador.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        darBobinas(jugador, char)
    end)
end

Players.PlayerAdded:Connect(alEntrar)
for _, j in ipairs(Players:GetPlayers()) do
    alEntrar(j)
end

-- comprar / usar pases desde la tienda
comprarPase.OnServerEvent:Connect(function(jugador, cual)
    local id = IDS[cual]
    if not id or id == 0 then
        return
    end
    if cual == "skip" and tienePase(jugador, id) then
        -- ya lo tiene: usarlo = brincar al siguiente checkpoint
        local n = math.min(nivelActual(jugador) + 1, Config.NUM_NIVELES)
        if teleportANivel(jugador, n) then
            local v = jugador:FindFirstChild("NivelActual")
            if v then
                v.Value = n
            end
            aviso:FireClient(jugador, "⏭️ ¡Brincaste al nivel " .. n .. "!")
        end
    else
        Marketplace:PromptGamePassPurchase(jugador, id)
    end
end)

Marketplace.PromptGamePassPurchaseFinished:Connect(function(jugador, id, comprado)
    if not comprado then
        return
    end
    if id == Config.PASE_SKIP_ID then
        local n = math.min(nivelActual(jugador) + 1, Config.NUM_NIVELES)
        if teleportANivel(jugador, n) then
            local v = jugador:FindFirstChild("NivelActual")
            if v then
                v.Value = n
            end
            aviso:FireClient(jugador, "⏭️ ¡Brincaste al nivel " .. n .. "!")
        end
    elseif id == Config.PASE_SPEED_ID then
        aviso:FireClient(jugador, "⚡ ¡Bobina Veloz activada! Reaparece para recibirla")
    elseif id == Config.PASE_GRAVITY_ID then
        aviso:FireClient(jugador, "🌙 ¡Bobina Lunar activada! Reaparece para recibirla")
    end
end)

-- producto: revivir
comprarProducto.OnServerEvent:Connect(function(jugador, cual)
    if cual == "revivir" and Config.PRODUCTO_REVIVIR_ID ~= 0 then
        Marketplace:PromptProductPurchase(jugador, Config.PRODUCTO_REVIVIR_ID)
    elseif cual == "gigante" and Config.PRODUCTO_GIGANTE_ID ~= 0 then
        Marketplace:PromptProductPurchase(jugador, Config.PRODUCTO_GIGANTE_ID)
    end
end)

Marketplace.ProcessReceipt = function(info)
    local jugador = Players:GetPlayerByUserId(info.PlayerId)
    if jugador and info.ProductId == Config.PRODUCTO_REVIVIR_ID then
        local n = nivelActual(jugador)
        if n > 0 and teleportANivel(jugador, n) then
            aviso:FireClient(jugador, "💖 ¡Revivido en tu checkpoint!")
        end
        return Enum.ProductPurchaseDecision.PurchaseGranted
    end
    if jugador and info.ProductId == Config.PRODUCTO_GIGANTE_ID then
        local be = ReplicatedStorage:FindFirstChild("GiganteExtra")
        if be then
            be:Fire(jugador)
        end
        return Enum.ProductPurchaseDecision.PurchaseGranted
    end
    return Enum.ProductPurchaseDecision.NotProcessedYet
end

print("[ParkourImposible] Monetización lista 💰")
]===] },
    { archivo = "GiganteSystem.luau", nombre = "GiganteSystem", clase = "Script",
      servicio = "ServerScriptService", preservar = false,
      codigo = [===[
--[[
    ============================================================
    GiganteSystem (Script) -> ServerScriptService
    El que llega a la MetaFinal se vuelve GIGANTE por 1 minuto.
    Cola por orden de llegada. Con el producto "Gigante x5 min"
    se agregan 5 minutos más (solo si eres el gigante actual).
    ============================================================
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local mundo = workspace:WaitForChild("ParkourImposibleWorld", 30)
local aviso = ReplicatedStorage:WaitForChild("Aviso")

local eventoExtra = Instance.new("BindableEvent")
eventoExtra.Name = "GiganteExtra"
eventoExtra.Parent = ReplicatedStorage

local TIEMPO_GIGANTE = 60
local TIEMPO_EXTRA = 300

local cola = {}
local giganteActual = nil

local function hacerGigante(jugador, escala)
    local char = jugador.Character
    if not char then
        return false
    end
    local ok = pcall(function()
        char:ScaleTo(escala)
    end)
    if not ok then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            pcall(function()
                for _, nombre in ipairs({ "BodyHeightScale", "BodyWidthScale", "BodyDepthScale", "HeadScale" }) do
                    local v = hum:FindFirstChild(nombre)
                    if v then
                        v.Value = escala
                    end
                end
            end)
        end
    end
    return true
end

local function enCola(userId)
    if giganteActual and giganteActual.userId == userId then
        return true
    end
    for _, e in ipairs(cola) do
        if e.userId == userId then
            return true
        end
    end
    return false
end

local function procesarCola()
    if giganteActual then
        return
    end
    local siguiente = table.remove(cola, 1)
    if not siguiente then
        return
    end
    local jugador = Players:GetPlayerByUserId(siguiente.userId)
    if not jugador or not jugador.Character then
        procesarCola()
        return
    end
    hacerGigante(jugador, 3)
    giganteActual = { jugador = jugador, userId = siguiente.userId, termina = os.clock() + TIEMPO_GIGANTE }
    aviso:FireAllClients("🏆 " .. jugador.DisplayName .. " llegó a la meta. ¡GIGANTE por 1 minuto!")
end

-- compra del producto: +5 min si eres el gigante actual
eventoExtra.Event:Connect(function(jugador)
    if giganteActual and giganteActual.jugador == jugador then
        giganteActual.termina = giganteActual.termina + TIEMPO_EXTRA
        aviso:FireClient(jugador, "🦣 ¡+5 minutos de gigante!")
    else
        aviso:FireClient(jugador, "Llega a la meta primero para ser gigante 🦣")
    end
end)

-- si el gigante muere o se va, liberar
Players.PlayerRemoving:Connect(function(jugador)
    if giganteActual and giganteActual.jugador == jugador then
        giganteActual = nil
        procesarCola()
    end
end)

task.spawn(function()
    while true do
        task.wait(1)
        if giganteActual then
            local j = giganteActual.jugador
            local char = j and j.Parent and j.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not hum or hum.Health <= 0 then
                giganteActual = nil
                procesarCola()
            elseif os.clock() >= giganteActual.termina then
                pcall(function()
                    char:ScaleTo(1)
                end)
                giganteActual = nil
                aviso:FireAllClients("El gigante volvió a su tamaño normal.")
                procesarCola()
            end
        end
    end
end)

-- pad de meta
local meta = mundo:WaitForChild("MetaFinal", 30)
if meta and meta:IsA("BasePart") then
    local debounce = {}
    meta.Touched:Connect(function(hit)
        local char = hit.Parent
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hum then
            return
        end
        local jugador = Players:GetPlayerFromCharacter(char)
        if not jugador then
            return
        end
        if debounce[jugador.UserId] and os.clock() - debounce[jugador.UserId] < 3 then
            return
        end
        debounce[jugador.UserId] = os.clock()
        if enCola(jugador.UserId) then
            aviso:FireClient(jugador, "Ya estás en la cola de gigantes 🏆")
            return
        end
        table.insert(cola, { userId = jugador.UserId })
        local pos = #cola
        if pos == 1 and not giganteActual then
            procesarCola()
        else
            aviso:FireClient(jugador, "🏆 ¡Meta! Eres el #" .. pos .. " en la cola de gigantes")
        end
    end)
end

print("[ParkourImposible] GiganteSystem listo 🏆")
]===] },
    { archivo = "HudGui.luau", nombre = "HudGui", clase = "LocalScript",
      servicio = "StarterGui", preservar = false,
      codigo = [===[
--[[
    ============================================================
    HudGui (LocalScript) -> StarterGui
    Muestra: nivel actual, muertes y tiempo. Botón de tienda.
    ============================================================
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage:WaitForChild("Config"))
local jugador = Players.LocalPlayer

local hudEvent = ReplicatedStorage:WaitForChild("HudRefresh")

local gui = Instance.new("ScreenGui")
gui.Name = "ParkourHud"
gui.ResetOnSpawn = false
gui.Parent = jugador:WaitForChild("PlayerGui")

local barra = Instance.new("Frame")
barra.Size = UDim2.new(0, 460, 0, 52)
barra.Position = UDim2.new(0.5, -230, 0, 12)
barra.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
barra.BackgroundTransparency = 0.15
barra.Parent = gui
local esq = Instance.new("UICorner")
esq.CornerRadius = UDim.new(0, 14)
esq.Parent = barra

local function etiqueta(x, texto)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(0, 110, 1, 0)
    l.Position = UDim2.new(0, x, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = texto
    l.Font = Enum.Font.GothamBold
    l.TextSize = 17
    l.TextColor3 = Color3.new(1, 1, 1)
    l.Parent = barra
    return l
end

local nivelLbl = etiqueta(10, "⚡ Nivel 0/" .. Config.NUM_NIVELES)
local muertesLbl = etiqueta(125, "💀 0")
local tiempoLbl = etiqueta(240, "⏱️ 00:00")

local tiendaBtn = Instance.new("TextButton")
tiendaBtn.Size = UDim2.new(0, 96, 1, -12)
tiendaBtn.Position = UDim2.new(1, -102, 0, 6)
tiendaBtn.BackgroundColor3 = Color3.fromRGB(255, 45, 120)
tiendaBtn.Text = "🛒 Tienda"
tiendaBtn.Font = Enum.Font.GothamBold
tiendaBtn.TextSize = 16
tiendaBtn.TextColor3 = Color3.new(1, 1, 1)
tiendaBtn.Parent = barra
local esq2 = Instance.new("UICorner")
esq2.CornerRadius = UDim.new(0, 10)
esq2.Parent = tiendaBtn
tiendaBtn.MouseButton1Click:Connect(function()
    local pg = jugador:WaitForChild("PlayerGui")
    local tg = pg:WaitForChild("TiendaGui", 5)
    if tg then
        tg.Enabled = not tg.Enabled
    end
end)

hudEvent.OnClientEvent:Connect(function(nivel)
    nivelLbl.Text = "⚡ Nivel " .. (nivel or 0) .. "/" .. Config.NUM_NIVELES
end)

local muertes = 0
local function vigilar(char)
    local hum = char:WaitForChild("Humanoid", 10)
    if not hum then
        return
    end
    hum.Died:Connect(function()
        muertes += 1
        muertesLbl.Text = "💀 " .. muertes
    end)
end
jugador.CharacterAdded:Connect(vigilar)
if jugador.Character then
    vigilar(jugador.Character)
end

local inicio = os.clock()
task.spawn(function()
    while true do
        task.wait(1)
        local s = math.floor(os.clock() - inicio)
        tiempoLbl.Text = string.format("⏱️ %02d:%02d", math.floor(s / 60), s % 60)
    end
end)

-- ---------- pantalla de bienvenida ----------
local splash = Instance.new("ScreenGui")
splash.Name = "Bienvenida"
splash.ResetOnSpawn = false
splash.DisplayOrder = 100
splash.Parent = jugador:WaitForChild("PlayerGui")

local fondo = Instance.new("Frame")
fondo.Size = UDim2.new(1, 0, 1, 0)
fondo.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
fondo.BackgroundTransparency = 0.25
fondo.Parent = splash

local titulo = Instance.new("TextLabel")
titulo.Size = UDim2.new(1, 0, 0, 80)
titulo.Position = UDim2.new(0, 0, 0.35, -40)
titulo.BackgroundTransparency = 1
titulo.Text = "💖 PARKOUR IMPOSIBLE 💖"
titulo.Font = Enum.Font.GothamBold
titulo.TextSize = 48
titulo.TextColor3 = Color3.fromRGB(255, 80, 160)
titulo.Parent = fondo

local creditos = Instance.new("TextLabel")
creditos.Size = UDim2.new(1, 0, 0, 50)
creditos.Position = UDim2.new(0, 0, 0.35, 50)
creditos.BackgroundTransparency = 1
creditos.Text = "⭐ Creado por Melyshian ⭐"
creditos.Font = Enum.Font.GothamBold
creditos.TextSize = 30
creditos.TextColor3 = Color3.new(1, 1, 1)
creditos.Parent = fondo

task.delay(4, function()
    for i = 1, 10 do
        fondo.BackgroundTransparency = 0.25 + i * 0.075
        titulo.TextTransparency = i / 10
        creditos.TextTransparency = i / 10
        task.wait(0.05)
    end
    splash:Destroy()
end)
]===] },
    { archivo = "TiendaGui.luau", nombre = "TiendaGui", clase = "LocalScript",
      servicio = "StarterGui", preservar = false,
      codigo = [===[
--[[
    ============================================================
    TiendaGui (LocalScript) -> StarterGui
    Ventanita para comprar pases y productos. Si el ID es 0
    muestra "Próximamente 💤".
    ============================================================
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage:WaitForChild("Config"))
local jugador = Players.LocalPlayer

local comprarPase = ReplicatedStorage:WaitForChild("ComprarPase")
local comprarProducto = ReplicatedStorage:WaitForChild("ComprarProducto")

local gui = Instance.new("ScreenGui")
gui.Name = "TiendaGui"
gui.ResetOnSpawn = false
gui.Enabled = false
gui.Parent = jugador:WaitForChild("PlayerGui")

local ventana = Instance.new("Frame")
ventana.Size = UDim2.new(0, 340, 0, 482)
ventana.Position = UDim2.new(0.5, -170, 0.5, -241)
ventana.BackgroundColor3 = Color3.fromRGB(18, 18, 30)
ventana.Parent = gui
local esq = Instance.new("UICorner")
esq.CornerRadius = UDim.new(0, 16)
esq.Parent = ventana

local titulo = Instance.new("TextLabel")
titulo.Size = UDim2.new(1, 0, 0, 54)
titulo.BackgroundTransparency = 1
titulo.Text = "🛒 Tienda"
titulo.Font = Enum.Font.GothamBold
titulo.TextSize = 26
titulo.TextColor3 = Color3.new(1, 1, 1)
titulo.Parent = ventana

local cerrar = Instance.new("TextButton")
cerrar.Size = UDim2.new(0, 40, 0, 40)
cerrar.Position = UDim2.new(1, -46, 0, 8)
cerrar.BackgroundColor3 = Color3.fromRGB(255, 45, 120)
cerrar.Text = "✖"
cerrar.Font = Enum.Font.GothamBold
cerrar.TextSize = 18
cerrar.TextColor3 = Color3.new(1, 1, 1)
cerrar.Parent = ventana
local esqC = Instance.new("UICorner")
esqC.CornerRadius = UDim.new(0, 10)
esqC.Parent = cerrar
cerrar.ZIndex = 10
cerrar.Activated:Connect(function()
    gui.Enabled = false
end)

local y = 66
local function fila(nombre, descripcion, id, accion, clave)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -24, 0, 74)
    f.Position = UDim2.new(0, 12, 0, y)
    f.BackgroundColor3 = Color3.fromRGB(28, 28, 45)
    f.Parent = ventana
    local e = Instance.new("UICorner")
    e.CornerRadius = UDim.new(0, 12)
    e.Parent = f

    local n = Instance.new("TextLabel")
    n.Size = UDim2.new(1, -110, 0, 26)
    n.Position = UDim2.new(0, 10, 0, 6)
    n.BackgroundTransparency = 1
    n.Text = nombre
    n.Font = Enum.Font.GothamBold
    n.TextSize = 16
    n.TextColor3 = Color3.new(1, 1, 1)
    n.TextXAlignment = Enum.TextXAlignment.Left
    n.Parent = f

    local d = Instance.new("TextLabel")
    d.Size = UDim2.new(1, -110, 0, 34)
    d.Position = UDim2.new(0, 10, 0, 32)
    d.BackgroundTransparency = 1
    d.Text = descripcion
    d.Font = Enum.Font.Gotham
    d.TextSize = 13
    d.TextColor3 = Color3.fromRGB(200, 200, 215)
    d.TextXAlignment = Enum.TextXAlignment.Left
    d.TextWrapped = true
    d.Parent = f

    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 92, 0, 40)
    b.Position = UDim2.new(1, -100, 0.5, -20)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Parent = f
    local eb = Instance.new("UICorner")
    eb.CornerRadius = UDim.new(0, 10)
    eb.Parent = b

    if id == 0 then
        b.Text = "Próximamente 💤"
        b.TextSize = 11
        b.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
        b.AutoButtonColor = false
    else
        b.Text = "Comprar"
        b.BackgroundColor3 = Color3.fromRGB(0, 200, 120)
        b.MouseButton1Click:Connect(function()
            if accion == "pase" then
                comprarPase:FireServer(clave)
            else
                comprarProducto:FireServer(clave)
            end
        end)
    end
    y += 82
end

fila(Config.NOMBRES.skip, Config.DESCRIPCIONES.skip, Config.PASE_SKIP_ID, "pase", "skip")
fila(Config.NOMBRES.speed, Config.DESCRIPCIONES.speed, Config.PASE_SPEED_ID, "pase", "speed")
fila(Config.NOMBRES.gravity, Config.DESCRIPCIONES.gravity, Config.PASE_GRAVITY_ID, "pase", "gravity")
fila(Config.NOMBRES.revivir, Config.DESCRIPCIONES.revivir, Config.PRODUCTO_REVIVIR_ID, "producto", "revivir")
fila(Config.NOMBRES.gigante, Config.DESCRIPCIONES.gigante, Config.PRODUCTO_GIGANTE_ID, "producto", "gigante")
]===] },
}

local EVENTOS = { "Aviso", "HudRefresh", "ComprarPase", "ComprarProducto" }

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
                print("[ParkourImposible] " .. a.nombre .. " ya existe, no lo toco.")
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

    print("[ParkourImposible] Listo: " .. creados .. " creados, " .. actualizados .. " actualizados.")
    print("[ParkourImposible] Presiona Play ▶ para probar tu juego ⚡")
    -- el vacío mata rápido (el plugin sí tiene permiso)
    pcall(function()
        game:GetService("Workspace").FallenPartsDestroyHeight = -50
    end)
end)

print("[ParkourImposible] Plugin cargado. Toca 'Instalar todo' en la barra Parkour Imposible.")
