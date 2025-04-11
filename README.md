# 🎁 Daily Reward Login System (MTA:SA)

A simple **Daily Login Reward** system for MTA:SA servers. This resource provides a foundational implementation for granting players daily rewards upon login.

> ⚠️ Status: **Basic / Initial Version**  
> Designed for future expansion such as UI integration, streak tracking, and external database support.

---

## 📌 Features

- ✅ Daily login detection per player
- ✅ Default reward (e.g., in-game money — configurable)
- ✅ Weekend support with random chance for rare rewards (Saturday & Sunday)
- ✅ Simple and readable reward configuration (Lua-based)
- ✅ Uses built-in `SQLite` for storing last login timestamps

---

## 📂 File Structure

| File              | Description                                                                 |
|-------------------|-----------------------------------------------------------------------------|
| `server.lua`      | Core logic: login validation, reward distribution, timestamp storage        | 
| `meta.xml`        | Standard MTA:SA resource metadata                                           |

---

## 🚀 How to Use

1. Place the `daily_reward_login` folder inside your server's `resources` directory.
2. Start the resource:
   ```bash
   start daily_reward_login
