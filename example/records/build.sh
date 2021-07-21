#!/usr/bin/env bash

as --32 write_records.s -o write_records.o
as --32 write_record.s -o write_record.o
ld -m elf_i386 write_record.o write_records.o -o write_records