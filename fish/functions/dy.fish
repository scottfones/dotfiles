function dy --wraps='dysk -c label+default+uuid+partuuid -s size-a -a -f disk <> \"\"' --wraps="dysk -c label+default+uuid+partuuid -s size-a -a -f 'disk <>\"\"'" --description "alias dy=dysk -c label+default+uuid+partuuid -s size-a -a -f 'disk <>\"\"'"
    dysk -c label+default+uuid+partuuid -s size-a -a -f 'disk <> ""' $argv

end
