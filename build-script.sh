server="http://localhost:8081/repository"
repo="mt-snapshot"
name="spring-boot-crud"
artifact="com/mt/$name"
buildversion="1.1.0-SNAPSHOT"
path=$server/$repo/$artifact/$buildversion
echo $path/maven-metadata.xml
mvnMetadata=$(curl -s "$path/maven-metadata.xml")
jar=""
version=$( echo "$mvnMetadata" | xpath -e "//versioning/release/text()" 2> /dev/null)
if [[ $version = *[!\ ]* ]]; then
  jar=$name-$version.jar
else
  version=$(echo "$mvnMetadata" | xpath -e "//versioning/versions/version[last()]/text()")
  snapshotMetadata=$(curl -s "$path/$version/maven-metadata.xml")
  timestamp=$(echo "$snapshotMetadata" | xpath -e "//snapshot/timestamp/text()")
  buildNumber=$(echo "$snapshotMetadata" | xpath -e "//snapshot/buildNumber/text()")
  snapshotVersion=$(echo "$buildversion" | sed 's/\(-SNAPSHOT\)*$//g')
  jar=$name-$snapshotVersion-$timestamp-$buildNumber.jar
fi
jarUrl=$path/$version/$jar
echo $jarUrl
mkdir -p /Users/Shared/$name
wget -O /Users/Shared/$name/$name.jar -q -N $jarUrl

