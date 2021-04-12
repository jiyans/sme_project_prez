include("graph_funcs.jl")
using LightGraphs
using Serialization
using JSON
using Glob
using DataFrames
using .graph_funcs

##
function main()
    ll = JSON.parsefile("data/raw/SMEデータ共有/1st-2ndMap.json")
    ll = Dict(
        parse(Int, string(k)) => [parse(Int, string(fol)) for fol in v] for (k, v) in pairs(ll)
    )
    analysis_cycle(ll, "リーガルリリー")
    println("-------------")
    nariaki_jsons = Glob.glob("data/raw/SMEデータ共有/Nariaki/nariaki_filtered/*.json")
    nariaki_folls = get_followers(nariaki_jsons)
    nariaki_folls = Dict(
        parse(Int, string(k)) => [parse(Int, string(fol)) for fol in v] for (k, v) in pairs(nariaki_folls)
    )
    analysis_cycle(nariaki_folls, "小袋成彬")
end

"""
This function is only for displaying stuff and so on.
"""
function analysis_cycle(foldict, artist_name)
    println("$artist_name")
    println("")
    foldict[0] = collect(keys(foldict))
    println("$(artist_name)のフォロワー数：$(length(foldict[0]))")
    g = make_graph_from_dict(foldict)
    println("ノード数：$(nv(g))\tエッジ数：$(ne(g))")
    相互フォロー = length((simplecycles_limited_length(g, 2)))
    println("フォロワーの中での相互フォロー: $(相互フォロー)")
end



## 
main()