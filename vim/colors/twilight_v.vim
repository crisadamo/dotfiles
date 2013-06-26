set background=dark

hi clear
 
if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "Twilight"
 
hi Cursor guifg=NONE guibg=#fffd00 gui=NONE
hi Visual guifg=NONE guibg=#919309 gui=NONE
hi CursorLine guifg=NONE guibg=#1b1b1b gui=NONE
hi CursorColumn guifg=NONE guibg=#1b1b1b gui=NONE
hi LineNr guifg=#868686 guibg=#141414 gui=NONE
hi VertSplit guifg=#3f3f3f guibg=#3f3f3f gui=NONE
hi MatchParen guifg=#cda869 guibg=NONE gui=NONE
hi StatusLine guifg=#f8f8f8 guibg=#3f3f3f gui=bold
hi StatusLineNC guifg=#f8f8f8 guibg=#3f3f3f gui=NONE
hi Pmenu guifg=#9b703f guibg=NONE gui=NONE
hi PmenuSel guifg=NONE guibg=#919309 gui=NONE
hi IncSearch guifg=NONE guibg=#343a44 gui=NONE
hi Search guifg=NONE guibg=#343a44 gui=NONE
hi Directory guifg=#cf6a4c guibg=NONE gui=NONE
hi Folded guifg=#5f5a60 guibg=#141414 gui=NONE
 
hi Normal guifg=#CDA869 guibg=#141414 gui=NONE
hi Boolean guifg=#cf6a4c guibg=NONE gui=NONE
hi Character guifg=#cf6a4c guibg=NONE gui=NONE
hi Comment guifg=#5f5a60 guibg=NONE gui=italic
hi Conditional guifg=#cda869 guibg=NONE gui=NONE
hi Constant guifg=#cf6a4c guibg=NONE gui=NONE
hi Define guifg=#cda869 guibg=NONE gui=NONE
hi ErrorMsg guifg=NONE guibg=NONE gui=NONE
hi WarningMsg guifg=NONE guibg=NONE gui=NONE
hi Float guifg=#cf6a4c guibg=NONE gui=NONE
hi Function guifg=#9b703f guibg=NONE gui=NONE
hi Identifier guifg=#f9ee98 guibg=NONE gui=NONE
hi Keyword guifg=#cda869 guibg=NONE gui=NONE
hi Label guifg=#8f9d6a guibg=NONE gui=NONE
hi NonText guifg=#4f4f4f guibg=#1b1b1b gui=NONE
hi Number guifg=#cf6a4c guibg=NONE gui=NONE
hi Operator guifg=#cda869 guibg=NONE gui=NONE
hi PreProc guifg=#cda869 guibg=NONE gui=NONE
hi Special guifg=#f8f8f8 guibg=NONE gui=NONE
hi SpecialKey guifg=#4f4f4f guibg=#1b1b1b gui=NONE
hi Statement guifg=#cda869 guibg=NONE gui=NONE
hi StorageClass guifg=#f9ee98 guibg=NONE gui=NONE
hi String guifg=#8f9d6a guibg=NONE gui=NONE
hi Tag guifg=#9b703f guibg=NONE gui=NONE
hi Title guifg=#f8f8f8 guibg=NONE gui=bold
hi Todo guifg=#5f5a60 guibg=NONE gui=inverse,bold,italic
hi Type guifg=#9b703f guibg=NONE gui=NONE
hi Underlined guifg=NONE guibg=NONE gui=underline


" Ruby Syntax
hi rubyClass guifg=#cda869 guibg=NONE gui=NONE
hi rubyFunction guifg=#9b703f guibg=NONE gui=NONE
hi rubyInterpolationDelimiter guifg=NONE guibg=NONE gui=NONE
hi rubySymbol guifg=#cf6a4c guibg=NONE gui=NONE
hi rubyConstant guifg=#9b859d guibg=NONE gui=NONE
hi rubyStringDelimiter guifg=#8f9d6a guibg=NONE gui=NONE
hi rubyBlockParameter guifg=#7587a6 guibg=NONE gui=NONE
hi rubyInstanceVariable guifg=#7587a6 guibg=NONE gui=NONE
hi rubyInclude guifg=#cda869 guibg=NONE gui=NONE
hi rubyGlobalVariable guifg=#7587a6 guibg=NONE gui=NONE
hi rubyRegexp guifg=#e9c062 guibg=NONE gui=NONE
hi rubyRegexpDelimiter guifg=#e9c062 guibg=NONE gui=NONE
hi rubyEscape guifg=#cf6a4c guibg=NONE gui=NONE
hi rubyControl guifg=#cda869 guibg=NONE gui=NONE
hi rubyClassVariable guifg=#7587a6 guibg=NONE gui=NONE
hi rubyOperator guifg=#cda869 guibg=NONE gui=NONE
hi rubyException guifg=#cda869 guibg=NONE gui=NONE
hi rubyPseudoVariable guifg=#7587a6 guibg=NONE gui=NONE
hi rubyRailsUserClass guifg=#9b859d guibg=NONE gui=NONE
hi rubyRailsARAssociationMethod guifg=#dad085 guibg=NONE gui=NONE
hi rubyRailsARMethod guifg=#dad085 guibg=NONE gui=NONE
hi rubyRailsRenderMethod guifg=#dad085 guibg=NONE gui=NONE
hi rubyRailsMethod guifg=#dad085 guibg=NONE gui=NONE
hi erubyDelimiter guifg=NONE guibg=NONE gui=NONE
hi erubyComment guifg=#5f5a60 guibg=NONE gui=italic
hi erubyRailsMethod guifg=#dad085 guibg=NONE gui=NONE

" Ruby Syntax
hi htmlTag guifg=#ac885b guibg=NONE gui=NONE
hi htmlEndTag guifg=#ac885b guibg=NONE gui=NONE
hi htmlTagName guifg=#ac885b guibg=NONE gui=NONE
hi htmlArg guifg=#ac885b guibg=NONE gui=NONE
hi htmlSpecialChar guifg=#cf6a4c guibg=NONE gui=NONE

" JS Syntax
hi javaScriptFunction guifg=#f9ee98 guibg=NONE gui=NONE
hi javaScriptRailsFunction guifg=#dad085 guibg=NONE gui=NONE
hi javaScriptBraces guifg=NONE guibg=NONE gui=NONE

" YAML Syntax
hi yamlKey guifg=#9b703f guibg=NONE gui=NONE
hi yamlAnchor guifg=#7587a6 guibg=NONE gui=NONE
hi yamlAlias guifg=#7587a6 guibg=NONE gui=NONE
hi yamlDocumentHeader guifg=#8f9d6a guibg=NONE gui=NONE

" CSS Syntax
hi cssURL guifg=#7587a6 guibg=NONE gui=NONE
hi cssFunctionName guifg=#dad085 guibg=NONE gui=NONE
hi cssColor guifg=#cf6a4c guibg=NONE gui=NONE
hi cssPseudoClassId guifg=#9b703f guibg=NONE gui=NONE
hi cssClassName guifg=#9b703f guibg=NONE gui=NONE
hi cssValueLength guifg=#cf6a4c guibg=NONE gui=NONE
hi cssCommonAttr guifg=#cf6a4c guibg=NONE gui=NONE
hi cssBraces guifg=NONE guibg=NONE gui=NONE

" PHP Syntax
hi phpComment guifg=#cf6a4c guibg=NONE gui=italic
hi phpSuperglobals guifg=#7587A6 guibg=NONE gui=NONE
hi phpMagicConstants guifg=#CF6A4C guibg=NONE gui=NONE
hi phpServerVars guifg=#CF6A4C guibg=NONE gui=NONE
hi phpConstants guifg=#CF6A4C guibg=NONE gui=NONE
hi phpBoolean guifg=#CF6A4C guibg=NONE gui=NONE
hi phpNumber guifg=#CF6A4C guibg=NONE gui=NONE

hi phpStringSingle guifg=#8F9D6A guibg=NONE gui=NONE
hi phpStringDouble guifg=#8F9D6A guibg=NONE gui=NONE
hi phpBacktick guifg=#8F9D6A guibg=NONE gui=NONE
hi phpHereDoc guifg=#8F9D6A guibg=NONE gui=NONE
hi phpNowDoc guifg=#8F9D6A guibg=NONE gui=NONE

hi phpFunctions guifg=#F9EE98 guibg=NONE gui=NONE
hi phpClasses guifg=#9B859D guibg=NONE gui=NONE
hi phpMethods guifg=#F9EE98 guibg=NONE gui=NONE
hi phpIdentifier guifg=#7587A6 guibg=NONE gui=NONE
hi phpIdentifierSimply guifg=#F9EE98 guibg=NONE gui=NONE

hi phpStatement guifg=#F9EE98 guibg=NONE gui=NONE
hi phpStructure guifg=#F9EE98 guibg=NONE gui=NONE
hi phpException guifg=#F9EE98 guibg=NONE gui=NONE
hi phpStorageClass guifg=#F9EE98 guibg=NONE gui=NONE

hi phpOperator guifg=#9B703F guibg=NONE gui=NONE
hi phpVarSelector guifg=#7587A6 guibg=NONE gui=NONE

" hi phpInclude  
hi phpDefine guifg=#F9EE98 guibg=NONE gui=NONE        
hi phpSpecial guifg=#F9EE98 guibg=NONE gui=NONE

hi phpSCKeyword guifg=#F9EE98 guibg=NONE gui=NONE
hi phpFCKeyword guifg=#F9EE98 guibg=NONE gui=NONE
hi phpType guifg=#F9EE98 guibg=NONE gui=NONE        
     
" hi phpMemberSelector   Type

hi phpSpecialChar guifg=#DAEFA3 guibg=NONE gui=NONE 
hi phpStrEsc guifg=#DAEFA3 guibg=NONE gui=NONE
hi phpParent guifg=#F8F8F8 guibg=NONE gui=NONE

" hi phpParentError      
" hi phpOctalError       Error

" hi phpTodo             Todo
