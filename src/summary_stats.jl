## 
using Pkg; Pkg.add("PlotlyJS")
using Pkg; Pkg.add("DataStructures")
## 
using PlotlyJS
using Statistics
using DataFrames
using JSON
using Glob
using DataStructures
using LightGraphs
using Plots
using .graph_funcs
using UnicodePlots
plotlyjs()

##
decode(mat) = Dict(decoder[i] => p for (i, p) in enumerate(mat))
function getall(jlist)
    ldict = Dict()
    for flwers in jsonlist
        merge!(ldict, JSON.parsefile(flwers))
    end
    return ldict
end

## 

jsonlist = Glob.glob("data/raw/SMEデータ共有/リーガルリリー/twetter/regal__lily（1次フォロワーユーザー）/*.json")
jss = getall(jsonlist)

## To get the name of a person do this
# 58857802
tmp = jss["58857802"]["User"]
tmp["url"]
tmp["screenName"]
tmp["urlentity"]["url"]

## Load the dictionary 

ll = JSON.parsefile("data/raw/SMEデータ共有/1st-2ndMap.json")
ll = Dict(
    parse(Int, string(k)) => [parse(Int, string(fol)) for fol in v] for (k, v) in pairs(ll)
)
# Add main artist to e erything
ll[0] = collect(keys(ll))
# Make graph enc and decoder
(g, encoder, decoder) = make_graph_from_dict(ll)
##  
pagerank(g)
## 
UnicodePlots.spy(LightGraphs.adjacency_matrix(g))
## 
LightGraphs.adjacency_matrix(g)

## 
tmp = pagerank(g)
argmax(tmp)

## 
decoder[argmax(tmp)]

## 
tmp = decode(tmp)

## 

## 
tmp[0]
## 
tmp
## 
SortedDi(tmp)

## 
first(100, tmp)

## 
df = DataFrame("id" => collect(keys(tmp)), "PageRank" => collect(values(tmp)))

## 
sort!(df, :PageRank, rev = true)
## 
tops = df[1:101, :id]

## 
get(jss, string(tops[1]))

## 

getNames

## 

quantiles = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9,0.95, 0.97, 0.99, 0.999, 0.9999]
## 
lengths = length.(values(ll))
## 
UnicodePlots.histogram(lengths)

## 
quants = quantile(lengths, quantiles)
## 
plot(quantiles, quants, legend=false)
## 
print(collect(0.1:0.1:1))

##
quants = quantile(lengths, quantiles)
## 