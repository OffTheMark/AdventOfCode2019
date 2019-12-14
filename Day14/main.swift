//
//  main.swift
//  Day14
//
//  Created by Marc-Antoine Malépart on 2019-12-14.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation

let puzzleInput = """
11 BNMWF, 1 MRVFT, 10 PBNSF => 7 XSFVQ
149 ORE => 4 SMSB
1 XHQDX, 1 SVSTJ, 2 LDHX => 7 JMWQG
12 MJCLX => 9 PBNSF
132 ORE => 7 XPTXL
15 TZMWG, 1 LDHX, 1 PDVR => 7 LBQB
1 HJTD, 8 VFXHC => 2 SVSTJ
5 LBHQ, 6 MTQCB => 4 MHBZ
1 PRXT, 1 FWZN => 2 PBMPL
1 XPTXL => 1 HMRGM
10 XHPHR => 6 NSVJL
3 QZQLZ, 3 MTQCB => 4 TZMWG
5 LBHQ, 2 VPSDV => 3 ZFCD
13 WPFP => 6 ZXMGK
10 MHJMX, 75 LDHX, 52 JMWQG, 4 QWRB, 1 SVNVJ, 17 BNMWF, 18 GHVN => 1 FUEL
4 PFQRG, 14 XVNL => 5 PDCV
11 JMWQG, 10 ZBNCP => 6 NTJZH
14 PBMPL, 12 PRXT, 9 MJQS => 9 XVNL
9 GDNG, 13 LBQB => 9 QWRB
1 CXNM => 6 PFQRG
9 NTJZH, 7 BNMWF, 11 JCHP, 1 MHBZ, 1 SVSTJ, 9 XRDN => 5 SVNVJ
1 XHPHR, 1 GSMP => 4 THRVR
26 FWZN => 4 WPFP
35 VJTFJ, 2 XSFVQ, 6 HJVN, 1 NSVJL, 1 JCHP, 3 MJCLX, 1 QZNCK => 6 GHVN
1 WPFP, 3 XHPHR => 2 HJVN
5 SMSB => 7 HNCDS
111 ORE => 4 GSMP
6 LBHQ => 8 GDNG
2 GDNG, 5 MHBZ => 1 RNMKC
15 THRVR, 4 NWNSH, 1 NSVJL => 7 FDVH
2 HMRGM => 9 FWZN
6 MJQS, 5 JRZXM => 5 NWNSH
14 ZXMGK, 1 JTXWX => 6 DLWT
1 MJQS, 3 FWZN, 2 PRXT => 1 JTXWX
1 GSMP, 4 CXNM => 3 JRZXM
151 ORE => 9 ZNPRL
2 NTJZH, 1 DLWT, 3 ZBNCP => 9 MRVFT
14 SWZCB, 1 VPSDV => 7 XRDN
14 LBHQ, 16 FDVH, 9 PFQRG => 4 PRXT
22 CXNM => 9 HJTD
1 VFXHC, 1 MTQCB => 6 QZQLZ
6 SWZCB, 2 PDCV, 17 RNMKC => 9 LTHFW
4 ZNPRL => 6 CXNM
2 CXNM => 3 LBHQ
8 MHBZ, 2 QZQLZ, 2 LBQB => 3 VJTFJ
3 ZFCD => 1 XHQDX
1 VJTFJ, 7 MHBZ => 8 ZBNCP
5 CXNM => 2 VPSDV
7 MJQS => 9 VFXHC
2 LTHFW, 11 HJVN, 4 XRDN, 8 MRVFT, 3 NSVJL, 3 SVSTJ, 5 XSFVQ, 13 RNMKC => 8 MHJMX
2 HMRGM => 3 XHPHR
1 GDNG, 19 PDVR => 3 SWZCB
18 HMRGM, 10 HNCDS => 2 MJQS
6 HNCDS, 2 HMRGM, 1 LBHQ => 3 MTQCB
16 VJTFJ, 1 WPFP, 6 JMWQG => 6 BNMWF
3 TZMWG, 1 FWZN => 7 PDVR
10 ZXMGK => 4 QZNCK
32 LBQB, 1 ZBNCP => 1 JCHP
27 PDVR, 7 QZQLZ, 7 PBMPL => 3 MJCLX
5 MHBZ, 12 ZFCD => 4 LDHX
"""

let parser = Parser()
let reactions: [Reaction] = parser.reactions(from: puzzleInput)
let reactionsByOutput: [Chemical: Reaction] = reactions
    .reduce(into: [:], { result, reaction in
        result[reaction.output] = reaction
    })

let title = "Day 14"
print(title, String(repeating: "=", count: title.count), separator: "\n", terminator: "\n\n")

let firstSubtitle = "Part 1"
print(firstSubtitle, String(repeating: "-", count: firstSubtitle.count), separator: "\n")

let part1 = Part1(reactionsByOutput: reactionsByOutput)
let part1Solution = part1.solve()
print(part1Solution)