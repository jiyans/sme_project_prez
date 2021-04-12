using StatsPlots
using Glob
using LaTeXStrings
using SparseArrays
using Plots
using JSON
##
include("no_vertices.jl")
##
ll = JSON.parsefile("data/raw/SMEデータ共有/1st-2ndMap.json")
ll = Dict(
    parse(Int, string(k)) => [parse(Int, string(fol)) for fol in v] for (k, v) in pairs(ll)
)

    println!("{:?}", a    println!("{:?}", a

sum(length.(values(ll)))

## 
gr()
default(
    titlefont = (20, "Helvetica"),
    legendfontsize = 18,
    guidefont = (15, :black, "Helvetica"),
    tickfont = (12, :black),
    framestyle = :zerolines,
    yminorgrid = true,
)

## 
function plothists(vals; artist = "リーガルリリー")
    title =
        plot(title = artist, grid = false, showaxis = false, bottom_margin = -50Plots.px)

    a = histogram(
        vals,
        size=(750, 750),
        xaxis = (text = "フォロワー数"),
        bins = 300,
        yaxis = (text = "頻度"),
        legend = false,
    )
    b = histogram(
        log10.(vals),
        size=(750, 750),
        bins = 300,
        xaxis = (text = "フォロワー数(log10)"),
        yaxis = (text = "頻度"),
        legend = false,
    )
    plot(title, a, b, layout = @layout([A{0.004h}; [B;C]]))
    savefig("plots/$(artist)_follower_hist.svg")
end
## 

vals = length.(values(ll)) .+ 1
plothists(vals; artist="リーガルリリー")
@show sum(length.(values(ll)))
## 

nariaki_jsons = Glob.glob("data/raw/SMEデータ共有/Nariaki/nariaki_filtered/*.json")
nariaki_folls = get_followers(nariaki_jsons)
nariaki_folls = Dict(
    parse(Int, string(k)) => [parse(Int, string(fol)) for fol in v] for (k, v) in pairs(nariaki_folls)
)
## 
vals = length.(values(nariaki_folls)) .+ 1
plothists(vals, artist = "小袋成彬")
@show sum(length.(values(nariaki_folls)))
## 


## 
@show length(Set(Iterators.flatten(collect(values(ll)))))
@show length(Set(Iterators.flatten(collect(values(nariaki_folls)))))
## 