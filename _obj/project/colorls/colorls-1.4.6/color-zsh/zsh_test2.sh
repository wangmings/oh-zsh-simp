
#!/bin/zsh


dirPath=$(cd `dirname $0`; pwd)
icons_path="$dirPath/rainbow_x11_color.yaml"
paths="$dirPath/rainbow_color.yaml"

echo '' > $icons_path

length=$(cat $paths|awk '{print $1}'|sed '/^$/d'|awk '{ print length, $0}'|sort -rn|head -n 1|awk '{print $1}')
(( length= length + 10 ))

echo $length


for line in $(cat $paths|sed '/^$/d;s/\ /*/g');do
    
    name=$(echo $line|sed 's/\*/ /g'|awk -F ' ' '{print $1}')
    icons=$(echo $line|sed 's/\*/ /g'|awk -F ' ' '{print $2}')
    icons_color=$(echo "$icons"|sed 's/\;/ /g')
  
    hex=$(bash -c "printf \"#%02x%02x%02x\n\" $icons_color")

    name=$(bash -c "printf \"%-${length}s\" $name")

    echo "$name $hex" >> $icons_path
    
done
