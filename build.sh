#!/usr/bin/env bash

gcc_file_name="$1"


build_gcc() {
    FILE_NAME=$1
    SOURCE_FILE="$FILE_NAME.s"
    if [ -f "$SOURCE_FILE" ]; then
        OBJ_FILE="$FILE_NAME.o"
        as --32 --gstabs+ $SOURCE_FILE -o $OBJ_FILE
        ld -m elf_i386 $OBJ_FILE -o $FILE_NAME  #ld -V 查看支持的仿真
    else
        echo $FILE_NAME 'file not exits!'
    fi
}
# aaa.s 只需要 aaa 即可
build_gcc ${gcc_file_name}
