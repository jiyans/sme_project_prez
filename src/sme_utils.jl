module sme_utils
using JSON
export get_fs, get_fs1

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
    return (i, unique(flls))
end

"""
Single check, returns Vector of pairs
"""
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
end
## 
