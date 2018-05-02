#/bin/bash
if [ "${#}" -ne 2 ]; then
	echo "Usage: ${0} <NewProjectName> <GitRepoURL>"
	exit
fi

find . -name "MyApp*" | xargs rename -S "MyApp" "${1}" 2>/dev/null
find . -name "MyApp*" | xargs rename -S "MyApp" "${1}"
ack --literal --files-with-matches "MyApp" | xargs sed -i "" "s/MyApp/${1}/g"
rm -rf ./.git
git init
git add .
git commit -m "Initial commit of ${1}"
git remote add origin ${2}
git remote -v
if [ ${?} -ne 0 ]; then
	echo "Error creating repo ${2}"
	exit
fi

git push -u origin master


