" Vim syntax file the OpenGL Shading Language
" Language:     GLSL
" Author:       Nathan Cournia <nathan@cournia.com> Richard Van Natta <mail@rnvannatta.com>
" Date:         November 17, 2018
" File Types:   .frag .vert .tese .tesc .comp .geom .glsl
" Version:      2.0
" Notes:        Adapted from c.vim - Bram Moolenaar <bram.vim.org>
"               Adapted from cg.vim - Kevin Bjorke <kbjorke@nvidia.com>

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" a bunch of useful keywords
syn keyword         glslConditional     if else switch
syn keyword         glslStatement       break return continue discard
syn keyword         glslLabel           case
syn keyword         glslRepeat          while for do
syn keyword         glslTodo            contained TODO FIXME XXX

" glslCommentGroup allows adding matches for special things in comments
syn cluster         glslCommentGroup    contains=glslTodo

"catch errors caused by wrong parenthesis and brackets
syn cluster         glslParenGroup      contains=glslParenError,glslIncluded,glslSpecial,glslCommentSkip,glslCommentString,glslComment2String,@glslCommentGroup,glslCommentStartError,glslUserCont,glslUserLabel,glslBitField,glslCommentSkip,glslOctalZero,glslCppOut,glslCppOut2,glslCppSkip,glslFormat,glslNumber,glslFloat,glslOctal,glslOctalError,glslNumbersCom
if exists("c_no_bracket_error")
  syn region        glslParen           transparent start='(' end=')' contains=ALLBUT,@glslParenGroup,glslCppParen,glslCppString
  " glslCppParen: same as glslParen but ends at end-of-line; used in glslDefine
  syn region        glslCppParen        transparent start='(' skip='\\$' excludenl end=')' end='$' contained contains=ALLBUT,@glslParenGroup,glslParen,glslString
  syn match         glslParenError      display ")"
  syn match         glslErrInParen      display contained "[{}]"
else
  syn region        glslParen           transparent start='(' end=')' contains=ALLBUT,@glslParenGroup,glslCppParen,glslErrInBracket,glslCppBracket,glslCppString
  " glslCppParen: same as glslParen but ends at end-of-line; used in glslDefine
  syn region        glslCppParen        transparent start='(' skip='\\$' excludenl end=')' end='$' contained contains=ALLBUT,@glslParenGroup,glslErrInBracket,glslParen,glslBracket,glslString
  syn match         glslParenError      display "[\])]"
  syn match         glslErrInParen      display contained "[\]{}]"
  syn region        glslBracket         transparent start='\[' end=']' contains=ALLBUT,@glslParenGroup,glslErrInParen,glslCppParen,glslCppBracket,glslCppString
  " glslCppBracket: same as glslParen but ends at end-of-line; used in glslDefine
  syn region        glslCppBracket      transparent start='\[' skip='\\$' excludenl end=']' end='$' contained contains=ALLBUT,@glslParenGroup,glslErrInParen,glslParen,glslBracket,glslString
  syn match         glslErrInBracket    display contained "[);{}]"
endif

"integer number, or floating point number without a dot and with "f".
syn case ignore
syn match           glslNumbers         display transparent "\<\d\|\.\d" contains=glslNumber,glslFloat,glslOctalError,glslOctal
" Same, but without octal error (for comments)
syn match           glslNumbersCom      display contained transparent "\<\d\|\.\d" contains=glslNumber,glslFloat,glslOctal
syn match           glslNumber          display contained "\d\+\(u\=l\{0,2}\|ll\=u\)\>"
"hex number
syn match           glslNumber          display contained "0x\x\+\(u\=l\{0,2}\|ll\=u\)\>"
" Flag the first zero of an octal number as something special
syn match           glslOctal           display contained "0\o\+\(u\=l\{0,2}\|ll\=u\)\>" contains=glslOctalZero
syn match           glslOctalZero       display contained "\<0"
syn match           glslFloat           display contained "\d\+f"
"floating point number, with dot, optional exponent
syn match           glslFloat           display contained "\d\+\.\d*\(e[-+]\=\d\+\)\=[fl]\="
"floating point number, starting with a dot, optional exponent
syn match           glslFloat           display contained "\.\d\+\(e[-+]\=\d\+\)\=[fl]\=\>"
"floating point number, without dot, with exponent
syn match           glslFloat           display contained "\d\+e[-+]\=\d\+[fl]\=\>"
" flag an octal number with wrong digits
syn match           glslOctalError      display contained "0\o*[89]\d*"
syn case match

if exists("c_comment_strings")
  " A comment can contain glslString, glslCharacter and glslNumber.
  " But a "*/" inside a glslString in a glslComment DOES end the comment!  So we
  " need to use a special type of glslString: glslCommentString, which also ends on
  " "*/", and sees a "*" at the start of the line as glslomment again.
  " Unfortunately this doesn't very well work for // type of comments :-(
  syntax match      glslCommentSkip     contained "^\s*\*\($\|\s\+\)"
  syntax region     glslCommentString   contained start=+L\=\\\@<!"+ skip=+\\\\\|\\"+ end=+"+ end=+\*/+me=s-1 contains=glslSpecial,glslCommentSkip
  syntax region     glslComment2String  contained start=+L\=\\\@<!"+ skip=+\\\\\|\\"+ end=+"+ end="$" contains=glslSpecial
  syntax region     glslCommentL        start="//" skip="\\$" end="$" keepend contains=@glslCommentGroup,glslComment2String,glslCharacter,glslNumbersCom,glslSpaceError
  syntax region     glslComment         matchgroup=glslCommentStart start="/\*" matchgroup=NONE end="\*/" contains=@glslCommentGroup,glslCommentStartError,glslCommentString,glslCharacter,glslNumbersCom,glslSpaceError
else
  syn region        glslCommentL        start="//" skip="\\$" end="$" keepend contains=@glslCommentGroup,glslSpaceError
  syn region        glslComment         matchgroup=glslCommentStart start="/\*" matchgroup=NONE end="\*/" contains=@glslCommentGroup,glslCommentStartError,glslSpaceError
endif
" keep a // comment separately, it terminates a preproc. conditional
syntax match        glslCommentError        display "\*/"
syntax match        glslCommentStartError   display "/\*"me=e-1 contained

syn keyword        glslType                void bool int uint float double atomic_uint
syn match          glslType                display "\<[ubid]\?vec[2-4]\>"
syn keyword        glslType                mat2  mat3  mat4
syn match          glslType                display "\<[ui]\?sampler\([12]D\(Array\)\?\|Cube\(Array\)\?\|3D\|2DRect\|Buffer\|2DMS\(Array\)\?\)\>"
syn match          glslType                display "\<sampler\([12]D\(Array\)\?\|Cube\(Array\)\?\|2DRect\)Shadow\>"

syn keyword        glslStructure           struct buffer

syn keyword        glslStorageClass        const uniform shared invariant patch layout
syn keyword        glslStorageClass        flat noperspective smooth
syn keyword        glslStorageClass        volatile readonly writeonly coherent restrict
syn keyword        glslStorageClass        in out inout

syn keyword        glslConstant            __LINE__ __FILE__ __VERSION__

syn keyword        glslConstant            true false

syn region         glslPreCondit           start="^\s*#\s*\(if\|ifdef\|ifndef\|elif\)\>" skip="\\$" end="$" end="//"me=s-1 contains=glslComment,glslCppString,glslCharacter,glslCppParen,glslParenError,glslNumbers,glslCommentError,glslSpaceError
syn match          glslPreCondit           display "^\s*#\s*\(else\|endif\)\>"
syn region         glslCppOut              start="^\s*#\s*if\s\+0\+\>" end=".\|$" contains=glslCppOut2
syn region         glslCppOut2             contained start="0" end="^\s*#\s*\(endif\>\|else\>\|elif\>\)" contains=glslSpaceError,glslCppSkip
syn region         glslCppSkip             contained start="^\s*#\s*\(if\>\|ifdef\>\|ifndef\>\)" skip="\\$" end="^\s*#\s*endif\>" contains=glslSpaceError,glslCppSkip
"syn match glslLineSkip        "\\$"
syn cluster        glslPreProglslGroup     contains=glslPreCondit,glslIncluded,glslInclude,glslDefine,glslErrInParen,glslErrInBracket,glslUserLabel,glslSpecial,glslOctalZero,glslCppOut,glslCppOut2,glslCppSkip,glslFormat,glslNumber,glslFloat,glslOctal,glslOctalError,glslNumbersCom,glslString,glslCommentSkip,glslCommentString,glslComment2String,@glslCommentGroup,glslCommentStartError,glslParen,glslBracket,glslMulti
syn region         glslDefine              start="^\s*#\s*\(define\|undef\)\>" skip="\\$" end="$" end="//"me=s-1 contains=ALLBUT,@glslPreProglslGroup
syn region         glslPreProc             start="^\s*#\s*\(pragma\>\|line\>\|error\>\|version\>\|extension\>\)" skip="\\$" end="$" keepend contains=ALLBUT,@glslPreProglslGroup

" Highlight User Labels
syn cluster        glslMultiGroup          contains=glslIncluded,glslSpecial,glslCommentSkip,glslCommentString,glslComment2String,@glslCommentGroup,glslCommentStartError,glslUserCont,glslUserLabel,glslBitField,glslOctalZero,glslCppOut,glslCppOut2,glslCppSkip,glslFormat,glslNumber,glslFloat,glslOctal,glslOctalError,glslNumbersCom,glslCppParen,glslCppBracket,glslCppString
syn region         glslMulti               transparent start='?' skip='::' end=':' contains=ALLBUT,@glslMultiGroup
" Avoid matching foo::bar() in C++ by requiring that the next char is not ':'
syn cluster        glslLabelGroup          contains=glslUserLabel,glslDefaultLabel
syn match          glslUserCont            display "^\s*\I\i*\s*:$" contains=@glslLabelGroup
syn match          glslUserCont            display ";\s*\I\i*\s*:$" contains=@glslLabelGroup
syn match          glslUserCont            display "^\s*\I\i*\s*:[^:]"me=e-1 contains=@glslLabelGroup
syn match          glslUserCont            display ";\s*\I\i*\s*:[^:]"me=e-1 contains=@glslLabelGroup

" I wonder if there is a simpler way
syn match          glslUserLabel           display "\I\i*" contained
syn match          glslDefaultLabel        display "default" contained

" Avoid recognizing most bitfields as labels
syn match          glslBitField            display "^\s*\I\i*\s*:\s*[1-9]"me=e-1
syn match          glslBitField            display ";\s*\I\i*\s*:\s*[1-9]"me=e-1

syn keyword        glslState               gl_VertexID gl_InstanceID
syn keyword        glslState               gl_DrawID gl_BaseVertex gl_BaseInstance
syn keyword        glslState               gl_Position gl_PointSize gl_ClipDistance
syn keyword        glslState               gl_PatchVerticesIn gl_PrimitiveID gl_InvocationID
syn keyword        glslState               gl_TessLevelOuter gl_TessLevelInner
syn keyword        glslState               gl_TessCoord gl_PatchVerticesIn gl_PrimitiveID
syn keyword        glslState               gl_PrimitiveIDIn gl_Layer gl_ViewportIndex
syn keyword        glslState               gl_FragCoord gl_FrontFacing gl_PointCoord
syn keyword        glslState               gl_SampleID gl_SamplePosition gl_SampleMaskIn
syn keyword        glslState               gl_FragDepth gl_SampleMask
syn keyword        glslState               glNumWorkGroups gl_WorkGroupID gl_LocalInvocationID
syn keyword        glslState               gl_GlobalInvocationID gl_LocalInvocationIndex


" uniforms
syn keyword        glslUniform             glDepthRange gl_NumSamples

" uniform types
syn keyword        glslType                gl_DepthRangeParameters

" constants
syn keyword        glslConstant            gl_MaxVertexAttribs gl_MaxVertexOutputComponents gl_MaxVertexUniformComponents gl_MaxVertexTextureImageUnits gl_MaxGeometryInputComponents gl_MaxGeometryOutputComponents gl_MaxGeometryUniformComponents gl_MaxGeometryTextureImageUnits gl_MaxGeometryOutputVertices gl_MaxGeometryTotalOutputComponents gl_MaxGeometryVaryingComponents gl_MaxFragmentInputComponents gl_MaxDrawBuffers gl_MaxFragmentUniformComponents gl_MaxTextureImageUnits1 gl_MaxClipDistances gl_MaxCombinedTextureImageUnits gl_MaxTessControlInputComponents gl_MaxTessControlOutputComponents gl_MaxTessControlUniformComponents gl_MaxTessControlTextureImageUnits gl_MaxTessControlTotalOutputComponents gl_MaxTessEvaluationInputComponents gl_MaxTessEvaluationOutputComponents gl_MaxTessEvaluationUniformComponents gl_MaxTessEvaluationTextureImageUnits gl_MaxTessPatchComponents gl_MaxPatchVertices gl_MaxTessGenLevel gl_MaxViewports gl_MaxVertexUniformVectors gl_MaxFragmentUniformVectors gl_MaxVaryingVectors gl_MaxVertexImageUniforms gl_MaxVertexAtomicCounters gl_MaxVertexAtomicCounterBuffers gl_MaxTessControlImageUniforms gl_MaxTessControlAtomicCounters gl_MaxTessControlAtomicCounterBuffers gl_MaxTessEvaluationImageUniforms gl_MaxTessEvaluationAtomicCounters gl_MaxTessEvaluationAtomicCounterBuffers gl_MaxGeometryImageUniforms gl_MaxGeometryAtomicCounters gl_MaxGeometryAtomicCounterBuffers gl_MaxFragmentImageUniforms gl_MaxFragmentAtomicCounters gl_MaxFragmentAtomicCounterBuffers gl_MaxCombinedImageUniforms gl_MaxCombinedAtomicCounters gl_MaxCombinedAtomicCounterBuffers gl_MaxImageUnits gl_MaxCombinedImageUnitsAndFragmentOutputs gl_MaxImageSamples gl_MaxAtomicCounterBindings gl_MaxAtomicCounterBufferSize gl_MinProgramTexelOffset gl_MaxProgramTexelOffset gl_MaxComputeWorkGroupCount gl_MaxComputeWorkGroupSize gl_MaxComputeUniformComponents gl_MaxComputeTextureImageUnits gl_MaxComputeImageUniforms gl_MaxComputeAtomicCounters gl_MaxComputeAtomicCounterBuffers gl_MaxTransformFeedbackBuffers gl_MaxTransformFeedbackInterleavedComponents
" swizzling
syn match          glslSwizzle             /\.[xyzw]\{1,4\}\>/
syn match          glslSwizzle             /\.[rgba]\{1,4\}\>/
syn match          glslSwizzle             /\.[stpq]\{1,4\}\>/

" built in functions
syn keyword        glslFunc                radians degrees sin cos tan asin acos atan sinh cosh tanh asinh acosh atanh
syn keyword        glslFunc                pow exp log exp2 log2 sqrt inversesqrt
syn keyword        glslFunc                abs sign floor trunc round roundEven ceil fract mod modf
syn keyword        glslFunc                min max clamp mix step smoothstep 
syn keyword        glslFunc                floatBitsToInt floatBitsToUint intBitsToFloat uintBitsToFloat fma frexp ldexp
syn match          glslFunc                "\<\(un\)\?pack\([US]norm\(2x16\|4x8\)\|Double2x32\|Half2x16\)\>"
syn keyword        glslFunc                length distance dot cross normalize ftransform faceforward reflect refract
syn keyword        glslFunc                matrixCompMult outerProduct transpose determinant inverse
syn keyword        glslFunc                lessThan lessThanEqual greaterThan greaterThanEqual equal notEqual any all not
syn keyword        glslFunc                uaddCarry usubBorrow umulExtended imulExtended bitfieldExract bitfieldInsert bitfieldReverse bitCount findLSB findMSB
syn keyword        glslFunc                texture textureSize textureQueryLod textureQueryLevels
syn keyword        glslFunc                textureSamples textureProj textureLod textureOffset
syn keyword        glslFunc                texelFetch texelFetchOffset textureProjOffset
syn keyword        glslFunc                textureProjLod textureProjLodOffset textureGrad
syn keyword        glslFunc                textureGradOffset textureProjGrad textureProjGradOffset
syn keyword        glslFunc                textureGather textureGatherOffset textureGatherOffsets
syn keyword        glslFunc                atomicCounterIncrement atomicCounterDecrement atomicCounter
syn keyword        glslFunc                atomicAdd atomicMin atomicMax atomicAnd atomicOr
syn keyword        glslFunc                atomicXor atomicExchange atomicCompSwap
syn keyword        glslFunc                imageSize imageSamples imageLoad imageStore
syn keyword        glslFunc                imageAtomicAdd imageAtomicMin imageAtomicMax
syn keyword        glslFunc                imageAtomicAnd imageAtomicOr imageAtomicXor
syn keyword        glslFunc                imageAtomicExchange imageAtomicCompSwap
syn keyword        glslFunc                dFdx dFdy dFdxFine dFdyFine dFdxCoarse dFdyCoarse
syn keyword        glslFunc                fwidth fwidthFine fwidthCoarse
syn keyword        glslFunc                interpolateAtCentroid interpolateAtSample interpolateAtOffset
syn keyword        glslFunc                EmitStreamVertex EndStreamPrimitive EmitVertex EndPrimitive
syn keyword        glslFunc                barrier memoryBarrier memoryBarrierAtomicCounter
syn keyword        glslFunc                memoryBarrierBuffer memoryBarrierShared memoryBarrierImage
syn keyword        glslFunc                groupMemoryBarrier

" highlight unsupported keywords
syn keyword        glslUnsupported         asm
syn keyword        glslUnsupported         class union enum typedef template this packed
syn keyword        glslUnsupported         goto
syn keyword        glslUnsupported         inline noinline public static extern external interface
syn keyword        glslUnsupported         long short half fixed unsigned
syn keyword        glslUnsupported         input output
syn keyword        glslUnsupported         hvec2 hvec3 hvec4 fvec2 fvec3 fvec4 
syn keyword        glslUnsupported         sampler3DRect
syn keyword        glslUnsupported         sizeof cast
syn keyword        glslUnsupported         namespace using

"wtf?
"let b:c_minlines = 50        " #if 0 constructs can be long
"exec "syn sync ccomment glslComment minlines=" . b:c_minlines

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_glsl_syn_inits")
  if version < 508
    let did_glsl_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink glslFormat                   glslSpecial
  HiLink glslCppString                glslString
  HiLink glslCommentL                 glslComment
  HiLink glslCommentStart             glslComment
  HiLink glslLabel                    Label
  HiLink glslUserLabel                glslError
  HiLink glslDefaultLabel             Label
  HiLink glslConditional              Conditional
  HiLink glslRepeat                   Repeat
  HiLink glslCharacter                Character
  HiLink glslSpecialCharacter         glslSpecial
  HiLink glslNumber                   Number
  HiLink glslOctal                    Number
  HiLink glslOctalZero                PreProc         " link this to Error if you want
  HiLink glslFloat                    Float
  HiLink glslOctalError               glslError
  HiLink glslParenError               glslError
  HiLink glslErrInParen               glslError
  HiLink glslErrInBracket             glslError
  HiLink glslCommentError             glslError
  HiLink glslCommentStartError        glslError
  HiLink glslSpaceError               glslError
  HiLink glslSpecialError             glslError
  HiLink glslOperator                 Operator
  HiLink glslStructure                Structure
  HiLink glslStorageClass             StorageClass
  HiLink glslInclude                  Include
  HiLink glslPreProc                  PreProc
  HiLink glslDefine                   Macro
  HiLink glslIncluded                 glslString
  HiLink glslError                    Error
  HiLink glslStatement                Statement
  HiLink glslPreCondit                PreCondit
  HiLink glslType                     Type
  HiLink glslConstant                 Constant
  HiLink glslCommentString            glslString
  HiLink glslComment2String           glslString
  HiLink glslCommentSkip              glslComment
  HiLink glslString                   String
  HiLink glslComment                  Comment
  HiLink glslSpecial                  SpecialChar
  HiLink glslSwizzle                  SpecialChar
  HiLink glslTodo                     Todo
  HiLink glslCppSkip                  glslCppOut
  HiLink glslCppOut2                  glslCppOut
  HiLink glslCppOut                   Comment
  HiLink glslUniform                  glslType
  HiLink glslState                    glslType
  HiLink glslFunc                     Function
  HiLink glslUnsupported              glslError

  delcommand HiLink
endif

let b:current_syntax = "glsl"

" vim: ts=8
