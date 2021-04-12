using Distributed
using JSON
using Pkg
using Pluto
using DataFrames
using Plots
using Glob
## 
include("src/sme_utils.jl")

## 

Distributed.nprocs()
lily_jsons = Glob.glob("data/exp_raw/SMEデータ共有/リーガルリリー/twetter/regal__lily（1次フォロワーユーザー）/*.json")
nariaki_jsons = Glob.glob("data/exp_raw/SMEデータ共有/Nariaki/nariaki_filtered/*.json")

##
lily_ex_json = JSON.parsefile(lily_jsons[1])
nariaki_ex_json = JSON.parsefile(nariaki_jsons[1])

function get_followers(json_list)
    root_dict = Dict()
    for single_json in json_list
        current_file = JSON.parsefile(single_json)
        names = collect(keys(current_file))
        ret_dict = Dict{String,Vector{String}}(
            name::String => current_file[name]["RootAccount"] for name in names
        )
        merge!(root_dict, ret_dict)
    end
    return root_dict
end

## 
lily_folls = get_followers(lily_jsons)
nariaki_folls = get_followers(nariaki_jsons)
## 
function get_fs1(group1, group2)
    i = 0
    flls = []
    for group_1_follower in keys(group1)
        for group_2_follower in keys(group2)
            if group_1_follower in group2[group_2_follower]
                i += 1
                push!(flls, group_1_follower => group_2_follower)
            end
        end
    end
    return (i, flls)
end

## 
test1_dict = Dict(
    "123" => ["312", "324", "1231231231"],
    "512" => ["1231231111", "324", "245"],
    "999" => ["123"],
    "998" => ["123"],
)

test2_dict = Dict(
    "312" => ["regal__lily"],
    "245" => ["regal__lily"],
    "1312" => ["regal__lily"],
    "324" => ["regal__lily"],
    "123" => ["regal__lily"],
)
@time no_test, test = get_fs(test2_dict, test1_dict)

## 

@time no, lolll = get_fs(lily_folls, nariaki_folls)
## 
for val in values(lily_folls)
    if length(val) != 1
        print(val)
    end
end
## 

Distributed.addprocs(12)