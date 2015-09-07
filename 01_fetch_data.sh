#!/usr/bin/env bash

dbsnp_builds=("b142" "b141")
reference_genome_builds=("GRCh38" "GRCh37")

usage_exit() {
  echo
  echo "Usage: $0 [-d dbsnp_build] [-r reference_genome_build] data_dir"
  echo
  echo "-d dbSNP build version. Set one from (${dbsnp_builds[@]}). Default: ${dbsnp_builds[0]}"
  echo "-r reference genome build version. Set one from (${reference_genome_builds[@]}). Default: ${reference_genome_builds[0]}"
  exit 1
}

in_array() {
  local array="$1[@]"
  local seeking=$2
  local in=1
  for element in "${!array}"; do
    if [[ $element == $seeking ]]; then
      in=0
      break
    fi
  done
  return $in
}

while getopts ":d:r:" OPT; do
  case "${OPT}" in
    d)  dbsnp=${OPTARG}
        ;;
    r)  ref=${OPTARG}
        ;;
    \?) usage_exit
        ;;
  esac
done
shift $((OPTIND - 1))

# Defaults
: ${dbsnp:=${dbsnp_builds[0]}}
: ${ref:=${reference_genome_builds[0]}}

in_array $dbsnp_build $dbsnp && echo ok || usage_exit
in_array $reference_genome_build $ref && echo ok|| usage_exit

data_dir=$1
if [ -z "${data_dir}" ]; then
    usage_exit
fi
mkdir -p ${data_dir}
cd ${data_dir}

database="human_9606_${dbsnp}_${ref}"
echo "[INFO] Fetching data for ${database}..."

wget -c ftp.ncbi.nih.gov/snp/organisms/${database}/database/organism_data/RsMergeArch.bcp.gz{,.md5}                      # 131 MB

declare -A _SNPChrPosOnRef=( \
  ["human_9606_b141_GRCh37"]="b141_SNPChrPosOnRef_GRCh37p13" \
  ["human_9606_b141_GRCh38"]="b141_SNPChrPosOnRef" \
  ["human_9606_b142_GRCh37"]="b142_SNPChrPosOnRef_105" \
  ["human_9606_b142_GRCh38"]="b142_SNPChrPosOnRef_106"
)
wget -c ftp.ncbi.nih.gov/snp/organisms/${database}/database/organism_data/${_SNPChrPosOnRef[${database}]}.bcp.gz{,.md5}  # 481 MB
wget -c ftp.ncbi.nih.gov/snp/database/shared_data/Allele.bcp.gz{,.md5}                                                   # 63.1 MB
wget -c ftp.ncbi.nih.gov/snp/database/shared_data/SnpChrCode.bcp.gz{,.md5}                                               # 767 B

echo "[INFO] Checking md5..."

type openssl >/dev/null 2>&1; is_openssl_cmd_found=$?
type md5sum >/dev/null 2>&1; is_md5sum_cmd_found=$?

for src in *.gz; do
  if [ $is_openssl_cmd_found = 0 ]; then
     diff <(openssl md5 ${src}) <(cat ${src}.md5)
  elif [ $is_md5sum_cmd_found = 0 ]; then
     md5sum -c ${src}.md5
  else
    echo "[WARN] Command `openssl` or `md5sum` not found. Skipping md5 check."
    break
  fi
done

# Unifying bcp name
cp ${_SNPChrPosOnRef[${database}]}.bcp.gz SNPChrPosOnRef.bcp.gz

echo "[INFO] Done"
