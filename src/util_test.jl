## This file is just showcasing some algos
using Test
"""
Double check, returns Vector of sets
"""
function get_fs(group1, group2)
    i = 0
    flls = []
    for group_1_follower in keys(group1)
        for group_2_follower in keys(group2)
            if group_1_follower in group2[group_2_follower] && group_2_follower in group1[group_1_follower]
                i += 1
                if group_1_follower != group_2_follower
                    push!(flls, Set([group_1_follower, group_2_follower]))
                end
            end
        end
    end
    return (i, unique(Set(flls)))
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
## 
function test_counter()
    llytmp = Dict(123 => [122, 121, 134, 2], 132 => [1, 2], 1324 => [908], 12312 => [])
    nartmp = Dict(2 => [123, 12312], 908 => [1324], 999 => [])
end

## (2, [2 => 123, 1324 => 908])

llytmp = Dict(123 => [122, 121, 134, 2], 132 => [1, 2], 1324 => [908], 12312 => [])
nartmp = Dict(2 => [123, 12312], 908 => [1324], 999 => [])
a = get_fs(llytmp, nartmp)
b = get_fs1(llytmp, nartmp)
@show(a, b)
## 
llytmp = Dict(123 => [999, 888], 1324 => [1000], 12312 => [])
nartmp = Dict(2 => [123, 12312], 908 => [1324], 999 => [])
a = get_fs(llytmp, nartmp)
b = get_fs1(llytmp, nartmp)
@show(a, b)
## 
llytmp = Dict(123 => [999, 888], 1324 => [1000], 12312 => [])
nartmp = Dict(2 => [123, 12312], 908 => [1500], 999 => [])
a = get_fs(llytmp, nartmp)
b = get_fs1(llytmp, nartmp)
@show(a, b)
## 
llytmp = Dict(123 => [999, 888], 1324 => [1000], 12312 => [])
nartmp = Dict(2 => [123, 12312], 908 => [1500], 999 => [908])
a = get_fs(llytmp, nartmp)
b = get_fs1(llytmp, nartmp)
@show(a, b)
## 人 => フォロワー (有方向)
llytmp = Dict(1 => [2, 4, 3], 2 => [6, 3], 3 => [1, 2, 3, 4], 7=>[], 8 => [7])
nartmp = Dict(4 => [1, 2, 3], 5 => [2], 3 => [1, 2, 3, 4], 1 => [2, 4, 3], 7 => [])
a = get_fs(llytmp, nartmp)
b = get_fs1(llytmp, nartmp)
@show(a, b)
## 人 <=> 人関係が存在している (無方向)
no, res = get_fs(llytmp, nartmp)

## ３は自分をフォローしているが、カウントしていない

unique(res)

