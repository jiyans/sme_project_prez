# *** Distribution of Degrees $p(k)$
# Pretty obvious
# *** Distribution of shortest paths $h$
# **** Shortest path (also geodesic)
# In undirected graphs the distance is not symmetric.
# **** Diameter
# Is maximum shortest length of two nodes in a graph.
# But this might be fragile, because a single outlier can skew everything
# **** Average Path length
# そのまま
## 
using LightGraphs
## 
using PlotlyJS
using Statistics
using DataFrames
using JSON
using Glob
using DataStructures
using StaticGraphs
using LightGraphs
using Plots
include("graph_funcs.jl")
using UnicodePlots
## 
decode(mat) = Dict(decoder[i] => p for (i, p) in enumerate(mat))

"""
これだっけ
"""
function getall(jlist)
    ldict = Dict()
    for flwers in jsonlist
        merge!(ldict, JSON.parsefile(flwers))
    end
    return ldict
end

## 

jsonlist = Glob.glob("../../data/raw/SMEデータ共有/リーガルリリー/twetter/regal__lily（1次フォロワーユーザー）/*.json")
jss = getall(jsonlist)
##

## To get the name of a person do this
# 58857802
tmp = jss["58857802"]["User"]
tmp["url"]
tmp["screenName"]
tmp["urlentity"]["url"]

## Load the dictionary 

ll = JSON.parsefile("../data/raw/SMEデータ共有/1st-2ndMap.json")
ll = Dict(
    parse(Int, string(k)) => [parse(Int, string(fol)) for fol in v] for (k, v) in pairs(ll)
)
# Add main artist to e erything
ll[0] = collect(keys(ll))
# Make graph enc and decoder
(g, encoder, decoder) = graph_funcs.make_graph_from_dict(ll)
UnicodePlots.spy(LightGraphs.adjacency_matrix(g))
## Single component ( Because thats how it was defined )
connected_components(g)
## 
p = Plots.plot(degree_histogram(g, indegree))
Plots.title!(p, "入次数", fontfamily="Hiragino Sans")
save(p, "../plots/in_degrees.svg")
## 
p = Plots.plot(degree_histogram(g, outdegree))
Plots.title!(p, "出次数", fontfamily="Hiragino Sans")
save(p, "../plots/out_degrees.svg")
# 
# diameter(g)
##

g =  squash(g)
##

global_clustering_coefficient(g)
## 

## 
using GraphIO
## 

savegraph("regal_lily", g, EdgeListFormat())
##
import JSON

##
JSON.write("lily_decoder.json", decoder)
##
decode_string = JSON.json(decoder)
## 
open("decoder.json", decode_string)
