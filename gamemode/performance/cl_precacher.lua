function PrecacheDir(dir)
    local files, directories = file.Find(dir .. "*", "THIRDPARTY")
    for _, fdir in pairs(directories) do
        if fdir != ".svn" then
            PrecacheDir(dir .. fdir .. "/")
        end
    end

    for k,v in pairs(files) do
        local fname = string.lower(dir .. v)
        local ismodel = -1
        local isparticle = -1
        local issound = -1
        ismodel = (string.find(fname, ".mdl"))
        isparticle = (string.find(fname, ".pcf"))
        issound = (string.find(fname, ".wav") or string.find(fname, ".mp3")  )
        if isparticle then
            if isparticle >= 0 then
                PrecacheParticleSystem(fname)
            end
        elseif issound then
            if issound >= 0 then
                util.PrecacheSound(fname)
            end
        else
            if ismodel and ismodel >= 0 then
                util.PrecacheModel(fname)
            end
        end
    end
end

function PrecacheAll()
    --Models
    PrecacheDir("models/")
    PrecacheDir("models/weapons/")
    PrecacheDir("models/weapons/akms/")
    PrecacheDir("models/weapons/ar57/")
    PrecacheDir("models/weapons/darky_m/rust/")
    PrecacheDir("models/weapons/fml/")
    PrecacheDir("models/weapons/fml/rifle/")
    PrecacheDir("models/weapons/fml/smg/")
    PrecacheDir("models/weapons/p226/")
    PrecacheDir("models/weapons/smc/qbz97/")
    PrecacheDir("models/weapons/smc/r870/")
    PrecacheDir("models/weapons/tfa_doi/")
    PrecacheDir("models/weapons/tfa_ins2/")
    PrecacheDir("models/weapons/tfa_ins2_vhsd2/")
    PrecacheDir("models/weapons/tfa_inss/")
    PrecacheDir("models/weapons/tfa_l4d2/")
    PrecacheDir("models/weapons/upblitz/")
    PrecacheDir("models/weapons/upgrades_yans_bsp/")
    PrecacheDir("models/weapons/fml/inss/")
    PrecacheDir("models/weapons/fml/le_french/")
    PrecacheDir("models/weapons/tfa_ins/")
    PrecacheDir("models/weapons/tfa_ins2/fn_2000/")
    PrecacheDir("models/weapons/tfa_ins2/m4_9mm/")
    PrecacheDir("models/weapons/tfa_ins2/mp443/")
    PrecacheDir("models/weapons/tfa_ins2/zm_lr300")
    PrecacheDir("models/weapons/tfa_ins2/upgrades/ayykyu_sights/bravo/")
    PrecacheDir("models/weapons/tfa_ins2/upgrades/ayykyu_sights/hunter/")
    PrecacheDir("models/weapons/tfa_ins2/upgrades/ayykyu_sights/leupold_mark4/")
    PrecacheDir("models/weapons/tfa_ins2/upgrades/ayykyu_sights/phantom/")
    PrecacheDir("models/weapons/tfa_ins2/upgrades/ayykyu_sights/pkas/")
    PrecacheDir("models/weapons/tfa_ins2/upgrades/ayykyu_sights/pso/")
    PrecacheDir("models/weapons/tfa_ins2/upgrades/ayykyu_sights/shortdot/")
    PrecacheDir("models/weapons/tfa_ins2/upgrades/ayykyu_sights/susat/")
    PrecacheDir("models/weapons/tfre/")
    PrecacheDir("models/weapons/upgitses/")

    --Particles
    PrecacheDir("particles/")

    --Fonts
    PrecacheDir("resource/fonts/")

    --Sounds
    PrecacheDir("sound/")
    PrecacheDir("sound/hitsound/")
    PrecacheDir("sound/tmui/")
    PrecacheDir("sound/music/ui/")
    PrecacheDir("sound/fml/")
    PrecacheDir("sound/datae/")
    PrecacheDir("sound/mantle/")
    PrecacheDir("sound/mirrorsedge/")
    PrecacheDir("sound/rue_effects/")
    PrecacheDir("sound/vmanip/")
    PrecacheDir("sound/weapons/")
    PrecacheDir("sound/weapons/akms/")
    PrecacheDir("sound/weapons/auga3/")
    PrecacheDir("sound/weapons/bar/")
    PrecacheDir("sound/weapons/barrett_m98b/")
    PrecacheDir("sound/weapons/bf3_g53/")
    PrecacheDir("sound/weapons/bren/")
    PrecacheDir("sound/weapons/bt_mp9/")
    PrecacheDir("sound/weapons/cw_mac10/")
    PrecacheDir("sound/weapons/fal/")
    PrecacheDir("sound/weapons/fas2_ppbizon/")
    PrecacheDir("sound/weapons/fg42/")
    PrecacheDir("sound/weapons/inss_mp5a5/")
    PrecacheDir("sound/weapons/l115a3/")
    PrecacheDir("sound/weapons/lewis/")
    PrecacheDir("sound/weapons/m1a1/")
    PrecacheDir("sound/weapons/m3greasegun/")
    PrecacheDir("sound/weapons/m1911/")
    PrecacheDir("sound/weapons/m1919/")
    PrecacheDir("sound/weapons/mg34/")
    PrecacheDir("sound/weapons/mg42/")
    PrecacheDir("sound/weapons/mosin_nagant/")
    PrecacheDir("sound/weapons/mp40/")
    PrecacheDir("sound/weapons/msr/")
    PrecacheDir("sound/weapons/mw19_hk443_sd_fml/")
    PrecacheDir("sound/weapons/ots33/")
    PrecacheDir("sound/weapons/owen/")
    PrecacheDir("sound/weapons/p99/")
    PrecacheDir("sound/weapons/p230/")
    PrecacheDir("sound/weapons/petushok/")
    PrecacheDir("sound/weapons/qbu88_1/")
    PrecacheDir("sound/weapons/qbz-97/")
    PrecacheDir("sound/weapons/remington_870/")
    PrecacheDir("sound/weapons/rpk74m/")
    PrecacheDir("sound/weapons/rust/")
    PrecacheDir("sound/weapons/rust_mp3/")
    PrecacheDir("sound/weapons/scar_ssr/")
    PrecacheDir("sound/weapons/sten/")
    PrecacheDir("sound/weapons/stg44/")
    PrecacheDir("sound/weapons/sw500/")
    PrecacheDir("sound/weapons/t_m1a1/")
    PrecacheDir("sound/weapons/t_m1928/")
    PrecacheDir("sound/weapons/tfa_doi/")
    PrecacheDir("sound/weapons/tfa_fiveseven_eft/")
    PrecacheDir("sound/weapons/tfa_howa_type_64/")
    PrecacheDir("sound/weapons/tfa_ins_sandstorm_tariq/")
    PrecacheDir("sound/weapons/tfa_ins2/")
    PrecacheDir("sound/weapons/tfa_ins2_br99/")
    PrecacheDir("sound/weapons/tfa_ins2_g36a1/")
    PrecacheDir("sound/weapons/tfa_ins2_gsh18/")
    PrecacheDir("sound/weapons/tfa_ins2_imbelia2/")
    PrecacheDir("sound/weapons/tfa_ins2_imi_uzi/")
    PrecacheDir("sound/weapons/tfa_ins2_sv98/")
    PrecacheDir("sound/weapons/tfa_inss/")
    PrecacheDir("sound/weapons/tfa_l4d2/")
    PrecacheDir("sound/weapons/tfa_minebea_pm9/")
    PrecacheDir("sound/weapons/tfa_nam_1911/")
    PrecacheDir("sound/weapons/tfa_nam_m79/")
    PrecacheDir("sound/weapons/tfa_nam_stevens620/")
    PrecacheDir("sound/weapons/tfa_ppsh41/")
    PrecacheDir("sound/weapons/tfa_tannenberg_type30/")
    PrecacheDir("sound/weapons/tfa_ww1_mp18/")
    PrecacheDir("sound/weapons/trench_club/")
    PrecacheDir("sound/weapons/universal/")
    PrecacheDir("sound/weapons/warface_amp_dsr1/")
    PrecacheDir("sound/weapons/warface_ax308/")
    PrecacheDir("sound/weapons/warface_orsis_t5000/")
    PrecacheDir("sound/weapons/ar15_dmr/")
    PrecacheDir("sound/weapons/bf3_ak74m/")
    PrecacheDir("sound/weapons/blast_pindadss2/")
    PrecacheDir("sound/weapons/cheytac_m200/")
    PrecacheDir("sound/weapons/eft/")
    PrecacheDir("sound/weapons/fml_sr25/")
    PrecacheDir("sound/weapons/fnp/")
    PrecacheDir("sound/weapons/ins2/")
    PrecacheDir("sound/weapons/kelog_mpx/")
    PrecacheDir("sound/weapons/m4 para/")
    PrecacheDir("sound/weapons/mw19_hk443_sd_fml/")
    PrecacheDir("sound/weapons/mw19_m4a1_fml/")
    PrecacheDir("sound/weapons/sr2m_veresk/")
    PrecacheDir("sound/weapons/tfa_doi/")
    PrecacheDir("sound/weapons/tfa_ins2/")
    PrecacheDir("sound/weapons/tfa_ins2_g28/")
    PrecacheDir("sound/weapons/tfa_ins2_rpg7_scoped/")
    PrecacheDir("sound/weapons/tfa_l4d2/")
    PrecacheDir("sound/weapons/tfa_tannenberg_type30/")
    PrecacheDir("sound/weapons/tfa_ww2_pzb39/")
    PrecacheDir("sound/weapons/tfre/winchester/")
end

if GetConVar("tm_developermode"):GetInt() == 0 then PrecacheAll() end