local Vector3 = CS.UnityEngine.Vector3
local TransitionManager = CS.TransitionManager
local UIManager = CS.UIManager
local PlayerUtilities = CS.PlayerUtilities
local GameObject = CS.UnityEngine.GameObject
local Color = CS.UnityEngine.Color

---@class TutorialClass:CS.Akequ.Base.PlayerClass
TutorialClass = {}

function TutorialClass:Init()
    player = self.main.player
    local success, color = CS.UnityEngine.ColorUtility.TryParseHtmlString("#ff007d")
    player:InitHealth(100, color, "Обучение")
    player:SetHitbox(Vector3(0.8, 1.8, 0.8), Vector3.zero)
    if player.isLocalPlayer then
        player:PlayBellSound(1)
        UIManager.SetMobileButtons({ "Move", "Rotate", "Pause", "PlayerList", "Interact", "Jump", "Run", "Inventory",
            "Voice", "Shoot", "Crouch" })
        TransitionManager.ShowClass("#ff007d",
            "Обучение",
            "Класс для админ разборок и т.п.",
            "ADMIN", "SCPIcon")
        PlayerUtilities.SetVoiceChat(PlayerUtilities.CreateValueTuple("3D", true), PlayerUtilities.CreateValueTuple("Intercom", false))
    end
    self.main.playerModel = player:SpawnHumanoidModel("ply_guard")
    playerModel = self.main.playerModel
    playerModel.transform.localPosition = Vector3(0, -0.83, 0)
    PlayerUtilities.SpawnHitboxes(player, playerModel)

    local renderers = playerModel:GetComponentsInChildren(typeof(CS.UnityEngine.SkinnedMeshRenderer))
    for i = 0, renderers.Length - 1 do
        local renderer = renderers[i]
        if renderer ~= nil then
            local mats = renderer.materials
            if mats ~= nil then
                for j = 0, mats.Length - 1 do
                    local mat = mats[j]
                    if mat ~= nil and mat.name ~= nil then
                        if mat.name:find("Mask") or mat.name:find("Glove") or mat.name:find("Hat") or mat.name:find("Shoe") or mat.name:find("Bottom") or mat.name:find("Top") or mat.name:find("Body") or mat.name:find("Eye") then
                            mats[j].color = Color(1, 0, 0.2, 1)
                        end
                    end
                end
                renderer.materials = mats
            end
        end
    end

    if player.isServer then
        netrooms = GameObject.FindObjectsOfType(typeof(CS.NetRoom))
        for i = 0, netrooms.Length - 1 do 
            room = netrooms[i].roomObj
            if room.name == "Map_Exits(Clone)" then   
                player:Teleport(Vector3(112, -355, 8.7), netrooms[i])
                break
            end
        end
    end

    player:SetSpeed(3, 6.5, 1.1)
    player:SetJumpPower(3.5)
    player.godMode = true
end

function TutorialClass:GetSpectatorBone()
    return "DeathCam"
end
function TutorialClass:OnStop()
    if self.main.playerModel ~= nil then
        GameObject.Destroy(self.main.playerModel)
    end
    self.main.player.godMode = false
end
function TutorialClass:OnOpenInventory()
    return true
end
function TutorialClass:IgnoreSCP()
    return true
end
function TutorialClass:GetName()
    return "Обучение"
end
function TutorialClass:GetTeamID()
    return "None"
end
function TutorialClass:GetClassColor()
    return "ff007d"
end

return TutorialClass