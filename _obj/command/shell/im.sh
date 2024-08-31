#!/bin/sh
# coding: utf-8



# Compile time
function run_time(){

	if [[ "$1" = "end" ]]; 
	then
		# Recording time
		end=`date +%s` 
		echo  "\n编译时间: `expr $end - $start`(秒)"
		
	else
		# The start time
		start=`date +%s`
	fi
	
}

run_time



# Current file path processing
path=`pwd`
this_path=${path//\ /\\ }



#Create the compiled file
function create_folder(){

	bin_file="$1"
	if [[ ! -d "im-compiler" ]]; then
		mkdir im-compiler
		mv $bin_file im-compiler
	else
		# rm -rf im-compiler/*
		mv $bin_file im-compiler
	fi

}





# class-compiler
function class_compiler(){
	
	file="$1"
	get_file="${file##*/}"
	file_path="${file%/*}"
	file_name="${get_file%.*}"
	file_type="${file##*.}"


	if [[ "${file:0:1}" = "/" ]]; then
		cd "$file_path"
	fi


	if [[ $file_type = "c" ]]; then
		gcc "$file" -o $file_name
		if [[ "$?" = "0" ]]; then
			create_folder $file_name
			./im-compiler/$file_name	
		fi

	elif [[ $file_type = "cpp" ]]; then
		g++ -std=c++11 "$file" -o $file_name
		if [[ "$?" = "0" ]]; then
			create_folder $file_name
			./im-compiler/$file_name
		fi

	elif [[ $file_type = "java" ]]; then
		javac $get_file -d ./
		if [[ "$?" = "0" ]]; then
			create_folder "$file_name.class"
			cd im-compiler;java $file_name
		fi	


	elif [[ $file_type = "go" ]]; then
		go+ build $get_file
		if [[ "$?" = "0" ]]; then
			create_folder "$file_name"
			./im-compiler/$file_name
		fi	
 
	elif [[ $file_type = "js" ]]; then
		/Users/mac/.nvm/versions/node/v16.13.2/bin/node $get_file

	elif [[ $file_type = "py" ]]; then
		~/.pyenv/shims/python $get_file

	elif [[ $file_type = "sh" ]]; then
		bash $get_file

	elif [[ $file_type = "scpt" ]]; then

		path=$get_file
		array=(${path//\ / }) 
		len=${#array[*]}
		getFile=$array
		newFile=${getFile//\.scpt/2\.scpt}
		cp -r $getFile $newFile
		if (($len > 1 )); then
		    newFile=$newFile" "${array[1]}
		fi
		osascript $newFile
		rm -rf $newFile

	else
		echo "[ This file type of file does not exist ]"
		echo "[ filePath: $file ]"

	fi
}




# Determine whether the parameter is 0
if [[ $# -ne 0 ]]; then

	echo  "开始编译..............\n"

	#Loop through all the files
	for all in "$@"; do	
		file="$all"	
		if [[ -f "$file" ]]; then
			{
				class_compiler "$file"
			}&
		else
			echo  "not this file\nPath: $file"
			
		fi

	done
	
	wait

	run_time "end"

	# rm -rf ./im-compiler

else
	echo  "IM编译器:\n[<说明: 让编译如此简单！>]\n[<编译说明: 可以同时编译不太同语言>]"

fi




















