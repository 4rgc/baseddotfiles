if exists(":CompilerSet") != 2
    command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=bundle\ exec\ ruby\ -Itest\ %

" CompilerSet errorformat=\%W\ %\\+%\\d%\\+)\ Failure:,
"                 \%Z%m\ [%f:%l]:,
"                 \%E\ %\\+%\\d%\\+)\ Error:,
"                 \%C%m:,
"                 \%C\ \ \ \ %f:%l:%.%#,
"                 \%C%m,
"                 \%Z\ %#,
"                 \%f:%l:%m,
"                 \\ %\\+%\\d%\\+):\ from\ %f:%l:%m,
"                 \%+G\ %\\+%\\d%\\+):\ from\ %.%#,
"                 \%+GTraceback%.%#,
"                 \%+G---\ expected,
"                 \%+G+++\ actual,
"                 \%+G@@%*[^@]@@,
"                 \%+G\ \"%.%#,
"                 \%+G-\"%.%#,
"                 \%+G+\"%.%#,
"                 \%-G%.%#,
"                 \%-G%.%#,

CompilerSet errorformat=\%W\ %\\+%\\d%\\+)\ Failure:,
                \%Z%m\ [%f:%l]:,
                \%E\ %\\+%\\d%\\+)\ Error:,
                \%C%m:,
                \%C\ \ \ \ %f:%l:%.%#,
                \%C%m,
                \%Z\ %#,
                \%[\ %\\d:from]%\\@<!%f:%l:%m,
                \%+GTraceback%.%#,
                \%+G---\ expected,
                \%+G+++\ actual,
                \%+G@@%*[^@]@@,
                \%+G\ \"%.%#,
                \%+G-\"%.%#,
                \%+G+\"%.%#,
                \%-G%.%#,
                \%-G%.%#,

"| ✕ Verbose mode
"| ✕ Profiling mode (slow test reporting)
"| ✕ Fail-fast mode
"| ✕ Test suites shuffling
"| ✕ Randomized tests
"| ✕ Code coverage (SimpleCov)
"|Logging to console (STDOUT)
"|Traceback (most recent call last):
"|        1: from test/unit/mim/mim_field_service_test.rb:2:in `<main>'
"|test/unit/mim/mim_field_service_test.rb:2:in `require_relative': cannot load such file -- /Users/bohda/Projects/test/helpers/sg_on_mim/sg_on_mim_fixtures (LoadError)


" \%+G\ %\\+%\\d%\\+:\ from\ %f:%l:%m,

