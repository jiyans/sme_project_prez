##
using DrWatson
@quickactivate(".")
##
using Pkg
using StatsBase
using Distributed
using JSON

## 
"""
Double check, returns Vector of sets
"""
function get_fs(group1, group2)
    i = 0
    flls = []
    for group_1_follower in keys(group1)
        for group_2_follower in keys(group2)
            if group_1_follower in group2[group_2_follower] &&
               group_2_follower in group1[group_1_follower]
                i += 1
                if group_1_follower != group_2_follower
                    push!(flls, Set([group_1_follower, group_2_follower]))
                end
            end
        end
    end
    flls = Set(flls)
    return (length(flls), flls)
end
## 

##  Parse Jsons
lillies = JSON.parsefile(datadir("exp_raw/SMEデータ共有/1st-2ndMap.json"))

lillies = Dict(
    parse(Int, string(k)) => [parse(Int, string(fol)) for fol in v] for (k, v) in pairs(df)
)

nariaki_jsons = Glob.glob("data/raw/SMEデータ共有/Nariaki/nariaki_filtered/*.json")
nar_folls = get_followers(nariaki_jsons)
nar_folls = Dict(
    parse(Int, string(k)) => [parse(Int, string(fol)) for fol in v] for (k, v) in pairs(nar_folls)
)

## 
llytmp = Dict(123 => [122, 121, 134, 2], 132 => [1, 2], 1324 => [908], 12312 => [])
nartmp = Dict(2 => [123, 12312], 908 => [1324], 999 => [])

## 
# Notation: Person => [ Follower ]
# This means that "Person" is followed by each Follower
# In the above example
# Pairs: (2, 123), (908, 1324), either get the pairs or get the number 
# (get pairs first maybe will probably be needed at some point)
# 12312 follows 2, but is not followed back so they are not friends.
@time get_fs(llytmp, nartmp)

## 
リーガル例 = Dict(1 => [2, 4, 3], 2 => [6, 3], 3 => [1, 2, 3, 4], 7 => [], 8 => [7])
なりあき例 = Dict(1 => [2, 4, 3], 7 => [], 4 => [1, 2, 3], 5 => [2], 3 => [1, 2, 3, 4])
a = get_fs(リーガル例, なりあき例)
b = get_fs(なりあき例,リーガル例)

@show(a)
## 
@show(b)
## 
@show(a == b)
## 
@time res = get_fs(lillies, nar_folls)
@time res1 = get_fs(nar_folls, lillies)
##

@show(res == res1)

##

688583 in keys(lillies)
## 

## 
