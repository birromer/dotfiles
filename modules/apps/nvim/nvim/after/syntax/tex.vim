" ~/.config/nvim/after/syntax/tex.vim

" Define a highlight group that we will use to hide command wrappers.
highlight default link MyTexConceal Conceal

" ==============================================================================
" === Rules generated from 000-macros.sty
" ==============================================================================

" -- Text
syntax region texDemphArg matchgroup=MyTexConceal start="\\demph{" end="}" contains=@texCluster concealends
highlight link texDemphArg texStyleBold
syntax region texRemphArg matchgroup=MyTexConceal start="\\remph{" end="}" contains=@texCluster concealends
highlight link texRemphArg texStyleItal
syntax keyword texMacroIE \\ie conceal

" -- Basic Math
syntax keyword texMacroGeq      \\geq      conceal cchar=≥
syntax keyword texMacroLeq      \\leq      conceal cchar=≤
syntax keyword texMacroEpsilon  \\epsilon  conceal cchar=ε
syntax keyword texMacroEmptySet \\emptyset conceal cchar=∅
syntax keyword texMacroID       \\id       conceal
syntax region texMacroPrns      matchgroup=MyTexConceal start="\\prns{"      end="}" contains=@texCluster concealends
syntax region texMacroFloors    matchgroup=MyTexConceal start="\\floors{"    end="}" contains=@texCluster concealends
syntax region texMacroBraces    matchgroup=MyTexConceal start="\\braces{"    end="}" contains=@texCluster concealends
syntax region texMacroBrackets  matchgroup=MyTexConceal start="\\brackets{"  end="}" contains=@texCluster concealends
syntax region texMacroAngles    matchgroup=MyTexConceal start="\\angles{"    end="}" contains=@texCluster concealends
syntax keyword texMacroLA       \\la       conceal cchar=⟨
syntax keyword texMacroRA       \\ra       conceal cchar=⟩
syntax region texMacroSub       matchgroup=MyTexConceal start="\\Sub{"       end="}" contains=@texCluster concealends
syntax region texMacroSup       matchgroup=MyTexConceal start="\\Sup{"       end="}" contains=@texCluster concealends
syntax region texMacroBar       matchgroup=MyTexConceal start="\\bar{"       end="}" contains=@texCluster concealends " Note: No standard overline style
syntax region texMacroHat       matchgroup=MyTexConceal start="\\hat{"       end="}" contains=@texCluster concealends
syntax keyword texMathSymbolR   \\R        conceal cchar=ℝ
syntax keyword texMathSymbolN   \\N        conceal cchar=ℕ
syntax keyword texMathSymbolI   \\I        conceal cchar=𝕀
syntax keyword texMacroPowerset \\powerset conceal cchar=℘

" -- Category Theory
syntax region texMacroCat       matchgroup=MyTexConceal start="\\Cat{"       end="}" contains=@texCluster concealends
highlight link texMacroCat texStyleBold
syntax region texMacroFun       matchgroup=MyTexConceal start="\\Fun{"       end="}" contains=@texCluster concealends
highlight link texMacroFun texStyleItal " Using Ital for \mathcal
syntax region texMacroOb        matchgroup=MyTexConceal start="\\Ob{"        end="}" contains=@texCluster concealends
highlight link texMacroOb texStyleBold
syntax region texMacroIdn       matchgroup=MyTexConceal start="\\Idn{"       end="}" contains=@texCluster concealends
syntax region texMacroMor       matchgroup=MyTexConceal start="\\Mor{"       end="}" contains=@texCluster concealends
highlight link texMacroMor texStyleBold
syntax keyword texMacroTo       \\To       conceal cchar=→
" Other multi-arg or complex macros like \Prod, \Homs are skipped for simplicity.

" -- Robot Models
syntax keyword texMacroOBLOT    \\OBLOT    conceal
syntax keyword texMacroLUMI     \\LUMI     conceal

" ==============================================================================
" === Rules generated from 000-notions.kl
" ==============================================================================

" -- Math
syntax keyword texKnowledgeProj     \\proj      conceal cchar=π

" -- Preliminaries (distributed computing)
syntax keyword texKnowledgeState    \\state     conceal cchar=𝑠
syntax keyword texKnowledgeStates   \\states    conceal cchar=𝗦
syntax keyword texKnowledgeInit     \\init      conceal cchar=𝗜
syntax keyword texKnowledgeAction   \\action    conceal cchar=𝗮
syntax keyword texKnowledgeActions  \\actions   conceal cchar=𝗔
syntax keyword texKnowledgeTrans    \\transition conceal cchar=τ
syntax keyword texKnowledgeEnabled  \\enabled   conceal cchar=◇ " Def: \operatorname{enabled}
syntax keyword texKnowledgeDInfty   \\dinfty    conceal cchar=◇ " Def: d_{\infty}
syntax keyword texKnowledgeDIncl    \\dinclusion conceal cchar=𝔽

" -- Robot (time)
syntax keyword texKnowledgeTPath    \\tpath     conceal cchar=ρ
syntax keyword texKnowledgeTPaths   \\tpaths    conceal cchar=𝒫

" -- Robot (general)
syntax keyword texKnowledgeSimSt    \\simst     conceal cchar=≤
syntax keyword texKnowledgeSimEx    \\simex     conceal cchar=preceq
syntax keyword texKnowledgeDisc     \\disc      conceal cchar=Ψ

" -- Robot (dyn)
syntax keyword texKnowledgeTot      \\tot       conceal cchar=𝘇
syntax keyword texKnowledgeOnc      \\onc       conceal cchar=𝗼
syntax keyword texKnowledgeEpi      \\epi       conceal cchar=𝗲
syntax keyword texKnowledgeFOnc     \\fonc      conceal cchar=𝑓
syntax keyword texKnowledgeFEpi     \\fepi      conceal cchar=𝜑
syntax keyword texKnowledgeObs      \\obs       conceal cchar=𝘆
syntax keyword texKnowledgeCtl      \\ctl       conceal cchar=𝘂
syntax keyword texKnowledgeGObs     \\gobs      conceal cchar=𝑔
syntax keyword texKnowledgeGCtl     \\gctl      conceal cchar=ℎ
syntax keyword texKnowledgePer      \\per       conceal cchar=ô
syntax keyword texKnowledgeCom      \\com       conceal cchar=ê
syntax keyword texKnowledgeGPer     \\gper      conceal cchar=𝜂
syntax keyword texKnowledgeGCom     \\gcom      conceal cchar=𝜆
syntax keyword texKnowledgeONC      \\ONC       conceal cchar=𝗢
syntax keyword texKnowledgeEPI      \\EPI       conceal cchar=𝗘
syntax keyword texKnowledgeFONC     \\FONC      conceal cchar=𝐹
syntax keyword texKnowledgeFEPI     \\FEPI      conceal cchar=Φ
syntax keyword texKnowledgeOBS      \\OBS       conceal cchar=𝗬
syntax keyword texKnowledgeCTL      \\CTL       conceal cchar=𝗨
syntax keyword texKnowledgeGOBS     \\GOBS      conceal cchar=𝐺
syntax keyword texKnowledgeGCTL     \\GCTL      conceal cchar=𝐻
syntax keyword texKnowledgeTraj     \\traj      conceal cchar=𝜉
syntax keyword texKnowledgeSolset   \\solset    conceal cchar=Ξ

" -- Robot (lcm)
syntax keyword texKnowledgeSystem   \\system    conceal cchar=𝗦
syntax keyword texKnowledgeRobot    \\robot     conceal cchar=𝗿
syntax keyword texKnowledgeRobots   \\robots    conceal cchar=ℛ
syntax keyword texKnowledgeARobots  \\arobots   conceal cchar=◇ " Def: \mathcal{A}
syntax keyword texKnowledgeEnv      \\env       conceal cchar=ℰ
syntax keyword texKnowledgeAdv      \\adv       conceal cchar=ℬ
syntax keyword texKnowledgeScheduler \\scheduler conceal cchar=𝒮
syntax keyword texKnowledgeExec     \\exec      conceal cchar=𝜎
syntax keyword texKnowledgeRun      \\run       conceal cchar=Σ
syntax keyword texKnowledgeAlgo     \\algo      conceal cchar=𝒜
syntax keyword texKnowledgeProtocol \\protocol  conceal cchar=𝒫
syntax keyword texKnowledgeGStates  \\gstates   conceal cchar=𝗖
syntax keyword texKnowledgeGState   \\gstate    conceal cchar=𝗰
syntax keyword texKnowledgeGCfg     \\gcfg      conceal cchar=◇ " Def: < >
syntax keyword texKnowledgeSEpi     \\Sepi      conceal cchar=𝗘
syntax keyword texKnowledgeSIni     \\Sini      conceal cchar=𝗜
syntax keyword texKnowledgeSAct     \\Sact      conceal cchar=𝗔
syntax keyword texKnowledgeSObs     \\Sobs      conceal cchar=𝗬
syntax keyword texKnowledgeSCtl     \\Sctl      conceal cchar=𝗨
syntax keyword texKnowledgeSGobs    \\Sgobs     conceal cchar=𝜸
syntax keyword texKnowledgeSgctl    \\Sgctl     conceal cchar=𝜶
syntax keyword texKnowledgeSfepi    \\Sfepi     conceal cchar=𝝉
syntax keyword texKnowledgeSFONC    \\SFONC     conceal cchar=𝝉
syntax keyword texKnowledgeSGOBS    \\SGOBS     conceal cchar=𝜸
syntax keyword texKnowledgeSenv     \\Senv      conceal cchar=𝗢

" -- Knowledge & Sheaves
syntax keyword texKnowledgeSFrame   \\sframe    conceal cchar=𝒦
syntax keyword texKnowledgeSF       \\SF        conceal cchar=◇ " Def: \Cat{SF}
