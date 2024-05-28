if exists(":CompilerSet") != 2
    command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=bundle\ exec\ ruby\ -Itest\ %

CompilerSet errorformat=\%W\ %\\+%\\d%\\+)\ Failure:,
                \%Z%m\ [%f:%l]:,
                \%E%>\ %\\+%\\d%\\+)\ Error:,
                \%C%m:,
                \%C\ \ \ \ %f:%l:%.%#,
                \%C%m,
                \%Z\ %#,
                \%E%>Traceback%.%#,
                \%C%>\ %\\+%\\d%\\+:\ from\ %s,
                \%Z%>%f:%l:%m,
                \%+G---\ expected,
                \%+G+++\ actual,
                \%+G@@%*[^@]@@,
                \%+G\ \"%.%#,
                \%+G-\"%.%#,
                \%+G+\"%.%#,
                \%-G%.%#,
                \%-G%.%#,
