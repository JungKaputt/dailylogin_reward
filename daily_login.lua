local db = dbConnect("sqlite", "daily_login.db")
dbExec(db, "CREATE TABLE IF NOT EXISTS player_login (account TEXT PRIMARY KEY, last_login TEXT)")

-- Tambahkan ini di atas file daily_login.lua
DailyLoginConfig = {
    commonReward = 20000,
    rareChance = 100,
    rareVehicles = {
        { model = 520, name = "Hydra" },
        { model = 411, name = "Infernus" }
    }
}

function handleDailyLogin(player)
    local acc = getPlayerAccount(player)
    if not acc or isGuestAccount(acc) then return end

    local accName = getAccountName(acc)
    local today = getRealDate()

    dbQuery(function(qh)
        local result = dbPoll(qh, 0)
        local lastLogin = result and result[1] and result[1].last_login or nil

        if lastLogin == today then
            outputChatBox("[Daily Login] Kamu sudah klaim hadiah hari ini.", player, 255, 255, 0)
            return
        end

        -- Common reward
        exports.WSScommands:giveMoney(player, DailyLoginConfig.commonReward)
        outputChatBox("[Daily Login] Kamu menerima $" .. DailyLoginConfig.commonReward .. " sebagai login reward!", player, 0, 255, 0)

        -- Simpan login ke database
        dbExec(db, "REPLACE INTO player_login (account, last_login) VALUES (?, ?)", accName, today)

        -- Weekend chance reward
        if getWeekDay() == "Friday" or getWeekDay() == "Sunday" then
            if math.random(1, 100) <= DailyLoginConfig.rareRewardChance then
                local reward = DailyLoginConfig.rareRewards[math.random(#DailyLoginConfig.rareRewards)]
                giveVehicleReward(player, reward.vehicleModel, reward.name)
            else
                outputChatBox("[Daily Login] Tidak beruntung untuk rare reward hari ini. Coba lagi besok!", player, 200, 200, 200)
            end
        end
    end, db, "SELECT last_login FROM player_login WHERE account = ?", accName)
end

function getRealDate()
    local t = getRealTime()
    return string.format("%04d-%02d-%02d", t.year + 1900, t.month + 1, t.monthday)
end

function getWeekDay()
    local days = {"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"}
    return days[getRealTime().weekday + 1]
end

function giveVehicleReward(player, model, name)
    triggerEvent("onPlayerPurchaseVehicle", player, model, 0) -- Gunakan sistem kendaraan yang sudah ada
    outputChatBox("[Daily Login] BERUNTUNG! Kamu mendapatkan kendaraan rare: " .. name, player, 0, 255, 255)
end

-- Command untuk klaim reward secara manual
addCommandHandler("dailylogin", function(player)
    handleDailyLogin(player)
end)
