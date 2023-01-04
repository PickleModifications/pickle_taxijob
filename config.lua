Config = {}

Config.Debug = true

Config.Language = "en"

Config.Businesses = {
    {
        info = { 
            id = "pickle_taxi",
            society = "taxi",
            label = "Pickle's Taxi Company",
        },
        blip = {
            Label = "Pickle's Taxi Company",
            Location = vector3(912.0522, -174.0470, 74.2908),
            ID = 198,
            Display = 4,
            Scale = 0.75,
            Color = 5
        },
        groups = {
            ["taxi"] = 0,
        },
        bossgroups = {
            ["taxi"] = 4,
        },
        vehicles = {
            {
                label = "Taxi", 
                model = `taxi`, 
                groups = {
                    ["taxi"] = 0,
                }
            },
            {
                label = "Limo", 
                model = `stretch`, 
                groups = {
                    ["taxi"] = 0,
                }
            },
        },
        locations = {
            vehicle = vector4(916.0678, -163.4347, 74.6782, 152.6545),
            boss = vector3(895.5319, -179.3002, 74.7003),
            duty = vector3(900.5847, -171.5111, 74.0756)
        }
    }
}

Config.Missions = {
    loop = false, -- Keep doing missions until /taxijob is used.
    reward = {name = "money", min = 10, max = 50, miles = 2.0}, -- multiples reward by miles traveled.
    models = {
        `s_m_m_cntrybar_01`,
        `u_f_y_comjane`,
        `a_f_y_hipster_04`,
        `s_m_m_highsec_02`,
        `a_m_y_hipster_03`,
    },
    locations = {
        vector4(946.3250, -171.7351, 74.5242, 56.1620),
        vector4(963.3705, -149.6545, 73.9146, 239.3231), -- REMOVE THIS
        vector4(397.9923, -870.3594, 29.2102, 322.1986),
        vector4(59.2745, -1483.8176, 29.2773, 270.6085),
        vector4(1246.3237, -1453.9513, 34.9354, 344.2509),
        vector4(-289.3166, -1847.9614, 26.2498, 4.3302),
        vector4(-45.8459, -1029.7800, 28.6224, 71.5370),
        vector4(181.9603, -322.1017, 43.9382, 211.4422),
        vector4(-514.8563, -260.6308, 35.5337, 211.8925),
        vector4(-1284.6191, 297.2318, 64.9439, 154.2817),
        vector4(-1440.0933, -773.8246, 23.4396, 343.2090),
    }
}