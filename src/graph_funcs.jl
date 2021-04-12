module graph_funcs
export make_graph_from_dict, make_edgelist, get_followers

using LightGraphs
using Serialization
using JSON
using Glob
using DataFrames

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


"""
Assembles graph from our convenience functions.
"""
function make_graph_from_dict(foldict)
    foldict[0] = collect(keys(foldict))
    el = make_edgelist(foldict)
    encoder = make_nomenclature(el)
    decoder  = Dict(v => k for (k, v) in pairs(encoder))
    encoded_el = map((person_id) -> encoder[person_id], el)
    # With the below iterator, the first edge points to the second,
    # The list that we have is that of the people that are followed,
    # Thus we construct the graph like this.
    return (SimpleDiGraphFromIterator(i for i in Edge.(encoded_el[:, 2], encoded_el[:, 1])), encoder, decoder)
end

"""
Convenience function to get all the followers 
"""
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
This function makes an edgelist from our network.
It is easier to work with Edgelists than most other stuff.    
"""
function make_edgelist(fol_dict)
    vec_1 = Vector{Int}()
    vec_2 = Vector{Int}()
    for (k, val_list) in pairs(fol_dict)
        for val in val_list
            push!(vec_1, k)
            push!(vec_2, val)
        end
    end
    return [vec_1 vec_2]
end

"""
This function basically encodes all of the people in the network.
It is just a convenience function to work with LightGraphs.
"""
function make_nomenclature(elist)
    nomenclature = Dict{Int,Int}()
    i = 1
    for row in elist
        for val in row
            if !(val in keys(nomenclature))
                push!(nomenclature, val => i)
                i += 1
            end
        end
    end
    return nomenclature
end

end 