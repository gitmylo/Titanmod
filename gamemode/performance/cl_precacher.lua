function PrecacheDir(dir)
    local files, directories = file.Find( dir.."*", "THIRDPARTY" )
    for _, fdir in pairs(directories) do
        if fdir != ".svn" then
            PrecacheDir(dir..fdir.."/")
        end
    end

    for k,v in pairs(files) do
        local fname = string.lower(dir..v)
        local ismodel = -1
        local ismaterial = -1
        local isparticle = -1
        local issound = -1
        ismodel = (string.find(fname,".mdl"))
        ismaterial = (string.find(fname,".vtf") or string.find(fname,".vmt"))
        isparticle = (string.find(fname,".pcf"))
        issound = (string.find(fname,".wav") or string.find(fname,".mp3")  )
        if ismaterial then
            if ismaterial >= 0 then
                local tmpmat = Material(fname,"mips")
            end
        elseif isparticle then
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
    PrecacheDir("materials/cards/accolades/")
    PrecacheDir("materials/cards/color/")
    PrecacheDir("materials/cards/default/")
    PrecacheDir("materials/cards/kills/")
    PrecacheDir("materials/cards/leveling/")
    PrecacheDir("materials/cards/mastery/")
    PrecacheDir("materials/cards/pride/")
    PrecacheDir("materials/arleitiss/riotshield/")
    PrecacheDir("materials/cw2/attachments/pistolrail/")
    PrecacheDir("materials/cw2/attachments/pistolrail/")
    PrecacheDir("materials/models/eft/fiveseven/")
    PrecacheDir("materials/models/eft/fiveseven/vmt")
    PrecacheDir("materials/models/darky_m/rust_weapons/melee/")
    PrecacheDir("materials/models/howa_type_64/")
    PrecacheDir("materials/models/teh_herper/csgo_aug3/")
    PrecacheDir("materials/models/weapons/1911/")
    PrecacheDir("materials/models/weapons/akms/")
    PrecacheDir("materials/models/weapons/ar57/")
    PrecacheDir("materials/models/weapons/ararebedo/")
    PrecacheDir("materials/models/weapons/as_val/")
    PrecacheDir("materials/models/weapons/bocw_mac10/")
    PrecacheDir("materials/models/weapons/br99/")
    PrecacheDir("materials/models/weapons/custom_g36_cursed/")
    PrecacheDir("materials/models/weapons/fas2_ppbizon/")
    PrecacheDir("materials/models/weapons/glk17/")
    PrecacheDir("materials/models/weapons/gsh/")
    PrecacheDir("materials/models/weapons/imbel/")
    PrecacheDir("materials/models/weapons/imi_uzi/")
    PrecacheDir("materials/models/weapons/ins2_sandstorm/")
    PrecacheDir("materials/models/weapons/ins2_sandstorm/buis/")
    PrecacheDir("materials/models/weapons/ins2_sandstorm/mp5a5/")
    PrecacheDir("materials/models/weapons/ins2_sandstorm/sup/")
    PrecacheDir("materials/models/weapons/ins2_sandstorm/vhs/")
    PrecacheDir("materials/models/weapons/m4a1/")
    PrecacheDir("materials/models/weapons/micro/")
    PrecacheDir("materials/models/weapons/mosin_nagant/")
    PrecacheDir("materials/models/weapons/mr96/")
    PrecacheDir("materials/models/weapons/mro/")
    PrecacheDir("materials/models/weapons/mw2019red_dot/")
    PrecacheDir("materials/models/weapons/nam/doi/")
    PrecacheDir("materials/models/weapons/nam/m79/")
    PrecacheDir("materials/models/weapons/nam/ppsh/")
    PrecacheDir("materials/models/weapons/nam/stevens620/")
    PrecacheDir("materials/models/weapons/optics/")
    PrecacheDir("materials/models/weapons/ots33/")
    PrecacheDir("materials/models/weapons/p99/")
    PrecacheDir("materials/models/weapons/p320/")
    PrecacheDir("materials/models/weapons/pm9/")
    PrecacheDir("materials/models/weapons/sandstorm/mk17/")
    PrecacheDir("materials/models/weapons/sandstorm_tariq/")
    PrecacheDir("materials/models/weapons/scar_ssr/")
    PrecacheDir("materials/models/weapons/smc/sandstorm/r870/ ")
    PrecacheDir("materials/models/weapons/sv98_ins/")
    PrecacheDir("materials/models/weapons/tanto/")
    PrecacheDir("materials/models/weapons/tfa_doi/enfield/")
    PrecacheDir("materials/models/weapons/tfa_doi/enfield_sling/")
    PrecacheDir("materials/models/weapons/tfa_doi/optics/")
    PrecacheDir("materials/models/weapons/tfa_doi/upgrades/")
    PrecacheDir("materials/models/weapons/tfa_doi/webley/")
    PrecacheDir("materials/models/weapons/tfa_doi_wap/bar/")
    PrecacheDir("materials/models/weapons/tfa_doi_wap/bren/")
    PrecacheDir("materials/models/weapons/tfa_doi_wap/fg42/")
    PrecacheDir("materials/models/weapons/tfa_doi_wap/lewis/")
    PrecacheDir("materials/models/weapons/tfa_doi_wap/m3greasegun/")
    PrecacheDir("materials/models/weapons/tfa_doi_wap/m1919/")
    PrecacheDir("materials/models/weapons/tfa_doi_wap/mg34/")
    PrecacheDir("materials/models/weapons/tfa_doi_wap/mg42/")
    PrecacheDir("materials/models/weapons/tfa_doi_wap/mp40/")
    PrecacheDir("materials/models/weapons/tfa_doi_wap/owen/")
    PrecacheDir("materials/models/weapons/tfa_doi_wap/sten/")
    PrecacheDir("materials/models/weapons/tfa_doi_wap/stg44/")
    PrecacheDir("materials/models/weapons/tfa_doi_wap/thompson/")
    PrecacheDir("materials/models/weapons/tfa_doi_wap/thompson_m1a1/")
    PrecacheDir("materials/models/weapons/tfa_ins2/1911/")
    PrecacheDir("materials/models/weapons/tfa_ins2/abakan/")
    PrecacheDir("materials/models/weapons/tfa_ins2/aek971/")
    PrecacheDir("materials/models/weapons/tfa_ins2/ak_pack/aks74u/")
    PrecacheDir("materials/models/weapons/tfa_ins2/ak_pack/kv_04/")
    PrecacheDir("materials/models/weapons/tfa_ins2/ak_pack/pbs1/")
    PrecacheDir("materials/models/weapons/tfa_ins2/ak_pack/pbs4/")
    PrecacheDir("materials/models/weapons/tfa_ins2/ak_pack/tgpa/")
    PrecacheDir("materials/models/weapons/tfa_ins2/ak12/")
    PrecacheDir("materials/models/weapons/tfa_ins2/ak400/")
    PrecacheDir("materials/models/weapons/tfa_ins2/akz/")
    PrecacheDir("materials/models/weapons/tfa_ins2/aug_a3_fm/")
    PrecacheDir("materials/models/weapons/tfa_ins2/cz75b/")
    PrecacheDir("materials/models/weapons/tfa_ins2/cz805/")
    PrecacheDir("materials/models/weapons/tfa_ins2/deserteagle/")
    PrecacheDir("materials/models/weapons/tfa_ins2/doublebarrel/")
    PrecacheDir("materials/models/weapons/tfa_ins2/fal/")
    PrecacheDir("materials/models/weapons/tfa_ins2/famas/")
    PrecacheDir("materials/models/weapons/tfa_ins2/ksg/")
    PrecacheDir("materials/models/weapons/tfa_ins2/l85a2/")
    PrecacheDir("materials/models/weapons/tfa_ins2/m9/")
    PrecacheDir("materials/models/weapons/tfa_ins2/m14/")
    PrecacheDir("materials/models/weapons/tfa_ins2/mk18/")
    PrecacheDir("materials/models/weapons/tfa_ins2/mk23/")
    PrecacheDir("materials/models/weapons/tfa_ins2/mp5/")
    PrecacheDir("materials/models/weapons/tfa_ins2/mp7/")
    PrecacheDir("materials/models/weapons/tfa_ins2/nova/")
    PrecacheDir("materials/models/weapons/tfa_ins2/pm/")
    PrecacheDir("materials/models/weapons/tfa_ins2/rfb/")
    PrecacheDir("materials/models/weapons/tfa_ins2/sks/")
    PrecacheDir("materials/models/weapons/tfa_ins2/swmodel10/")
    PrecacheDir("materials/models/weapons/tfa_ins2/ump9/")
    PrecacheDir("materials/models/weapons/tfa_ins2/ump45/")
    PrecacheDir("materials/models/weapons/tfa_ins2/upgrades/cmore/")
    PrecacheDir("materials/models/weapons/tfa_ins2/upgrades/holords/")
    PrecacheDir("materials/models/weapons/tfa_ins2/upgrades/mwr/")
    PrecacheDir("materials/models/weapons/tfa_ins2/upgrades/opk7/")
    PrecacheDir("materials/models/weapons/tfa_ins2/upgrades/optic_compm4s/")
    PrecacheDir("materials/models/weapons/tfa_ins2/usp_match/")
    PrecacheDir("materials/models/weapons/tfa_ins2/xm8/")
    PrecacheDir("materials/models/weapons/tfa_ins2_m16/")
    PrecacheDir("materials/models/weapons/tfa_inss/asval/")
    PrecacheDir("materials/models/weapons/tfa_l4d2/skorpion/")
    PrecacheDir("materials/models/weapons/uar556/")
    PrecacheDir("materials/models/weapons/upgrades/")
    PrecacheDir("materials/models/weapons/upgrades/ahos_446/")
    PrecacheDir("materials/models/weapons/upgrades/eotech_556/")
    PrecacheDir("materials/models/weapons/v_models/ar16/")
    PrecacheDir("materials/models/weapons/v_models/ax308/")
    PrecacheDir("materials/models/weapons/v_models/bf3_g53/")
    PrecacheDir("materials/models/weapons/v_models/dsr1/")
    PrecacheDir("materials/models/weapons/v_models/fx_shared_shells/")
    PrecacheDir("materials/models/weapons/v_models/l115a3/")
    PrecacheDir("materials/models/weapons/v_models/mp9/")
    PrecacheDir("materials/models/weapons/v_models/msr/")
    PrecacheDir("materials/models/weapons/v_models/petushok/")
    PrecacheDir("materials/models/weapons/v_models/rpk74m/")
    PrecacheDir("materials/models/weapons/v_models/smg_mp5k/")
    PrecacheDir("materials/models/weapons/v_models/sniper_rifles/")
    PrecacheDir("materials/models/weapons/v_models/sr16/")
    PrecacheDir("materials/models/weapons/v_models/sw500/")
    PrecacheDir("materials/models/weapons/v_models/t5000/")
    PrecacheDir("materials/models/weapons/w_models/rpk74m/")
    PrecacheDir("materials/models/weapons/w_models/smg_mp5k/")
    PrecacheDir("materials/models/weapons/ww1_mp18_remake/")
    PrecacheDir("materials/models/vgui/hud/")
    PrecacheDir("materials/models/aimingfx/vignette/")
    PrecacheDir("materials/models/effects/")
    PrecacheDir("materials/models/particles/")
    PrecacheDir("materials/models/rue_effects/")
    PrecacheDir("materials/models/tfre/weapons/maresleg/")
    PrecacheDir("materials/models/weapons/acrc/")
    PrecacheDir("materials/models/weapons/flashlight/")
    PrecacheDir("materials/models/weapons/fnp45/")
    PrecacheDir("materials/models/weapons/g28_casboi/")
    PrecacheDir("materials/models/weapons/km2000/")
    PrecacheDir("materials/models/weapons/laser black/")
    PrecacheDir("materials/models/weapons/mlg_hollenkatze_oyster_pzb39/")
    PrecacheDir("materials/models/weapons/opgits/")
    PrecacheDir("materials/models/weapons/opgits/acog/")
    PrecacheDir("materials/models/weapons/opgits/ar25/")
    PrecacheDir("materials/models/weapons/opgits/combo/")
    PrecacheDir("materials/models/weapons/opgits/comp/")
    PrecacheDir("materials/models/weapons/opgits/crosman/")
    PrecacheDir("materials/models/weapons/opgits/diotech/")
    PrecacheDir("materials/models/weapons/opgits/graftmagni/")
    PrecacheDir("materials/models/weapons/opgits/micro/")
    PrecacheDir("materials/models/weapons/opgits/minicon/")
    PrecacheDir("materials/models/weapons/opgits/pns/")
    PrecacheDir("materials/models/weapons/opgits/qps1/")
    PrecacheDir("materials/models/weapons/opgits/qps2/")
    PrecacheDir("materials/models/weapons/opgits/schism/")
    PrecacheDir("materials/models/weapons/rpg7_new_scoped/")
    PrecacheDir("materials/models/weapons/sr2_veresk/")
    PrecacheDir("materials/models/weapons/tfa_doi/garand/")
    PrecacheDir("materials/models/weapons/tfa_ins2/aa12/")
    PrecacheDir("materials/models/weapons/tfa_ins2/attachments/")
    PrecacheDir("materials/models/weapons/tfa_ins2/colt_9mm/")
    PrecacheDir("materials/models/weapons/tfa_ins2/fn_2000/")
    PrecacheDir("materials/models/weapons/tfa_ins2/groza/")
    PrecacheDir("materials/models/weapons/tfa_ins2/krissv/")
    PrecacheDir("materials/models/weapons/tfa_ins2/lr300/")
    PrecacheDir("materials/models/weapons/tfa_ins2/m16a4/")
    PrecacheDir("materials/models/weapons/tfa_ins2/mc255/")
    PrecacheDir("materials/models/weapons/tfa_ins2/minimi/")
    PrecacheDir("materials/models/weapons/tfa_ins2/mk18/")
    PrecacheDir("materials/models/weapons/tfa_ins2/mp443/")
    PrecacheDir("materials/models/weapons/tfa_ins2/mwr_cq300/")
    PrecacheDir("materials/models/weapons/tfa_ins2/mx4/")
    PrecacheDir("materials/models/weapons/tfa_ins2/optics/")
    PrecacheDir("materials/models/weapons/tfa_ins2/optics/ayykyu_sights/bravo/")
    PrecacheDir("materials/models/weapons/tfa_ins2/optics/ayykyu_sights/hunter/")
    PrecacheDir("materials/models/weapons/tfa_ins2/optics/ayykyu_sights/hybrid/")
    PrecacheDir("materials/models/weapons/tfa_ins2/optics/ayykyu_sights/leupold_mark4/")
    PrecacheDir("materials/models/weapons/tfa_ins2/optics/ayykyu_sights/phantom/")
    PrecacheDir("materials/models/weapons/tfa_ins2/optics/ayykyu_sights/pkas/")
    PrecacheDir("materials/models/weapons/tfa_ins2/optics/ayykyu_sights/pso/")
    PrecacheDir("materials/models/weapons/tfa_ins2/optics/ayykyu_sights/shortdot/")
    PrecacheDir("materials/models/weapons/tfa_ins2/optics/ayykyu_sights/susat/")
    PrecacheDir("materials/models/weapons/tfa_ins2/qsz92/")
    PrecacheDir("materials/models/weapons/tfa_ins2/rpg/")
    PrecacheDir("materials/models/weapons/tfa_ins2/saiga_spike/")
    PrecacheDir("materials/models/weapons/tfa_ins2/scorpion_evo/")
    PrecacheDir("materials/models/weapons/tfa_ins2/spas12_bri/")
    PrecacheDir("materials/models/weapons/tfa_ins2/spectre/")
    PrecacheDir("materials/models/weapons/tfa_ins2/typhoon12/")
    PrecacheDir("materials/models/weapons/tfa_ins2/upgrades/ayykyu_sights/bravo/")
    PrecacheDir("materials/models/weapons/tfa_ins2/upgrades/ayykyu_sights/hunter/")
    PrecacheDir("materials/models/weapons/tfa_ins2/upgrades/ayykyu_sights/hybrid/")
    PrecacheDir("materials/models/weapons/tfa_ins2/upgrades/ayykyu_sights/leupold_mark4/")
    PrecacheDir("materials/models/weapons/tfa_ins2/upgrades/ayykyu_sights/phantom/")
    PrecacheDir("materials/models/weapons/tfa_ins2/upgrades/ayykyu_sights/pkas/")
    PrecacheDir("materials/models/weapons/tfa_ins2/upgrades/ayykyu_sights/pso/")
    PrecacheDir("materials/models/weapons/tfa_ins2/upgrades/ayykyu_sights/shortdot/")
    PrecacheDir("materials/models/weapons/tfa_ins2/upgrades/ayykyu_sights/susat/")
    PrecacheDir("materials/models/weapons/tfa_ins2/upgrades/titanfall/")
    PrecacheDir("materials/models/weapons/tfa_ins2/v_models/m4_9mm/")
    PrecacheDir("materials/models/weapons/tfa_l4d2/osp18/")
    PrecacheDir("materials/models/weapons/v_models/blast_ss2/")
    PrecacheDir("materials/models/weapons/v_models/fx_shared_shells/")
    PrecacheDir("materials/models/weapons/v_models/m200/")
    PrecacheDir("materials/models/weapons/w_models/blast_ss2/")

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

    PrecacheDir("particles/")

    PrecacheDir("resource/fonts/")

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

--PrecacheAll()