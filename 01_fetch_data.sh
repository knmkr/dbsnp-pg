#!/usr/bin/env bash

dbsnp_builds=("b144" "b142")
reference_genome_builds=("GRCh38" "GRCh37")

usage_exit() {
  echo
  echo "Usage: $0 [-d dbsnp_build] [-r reference_genome_build] data_dir"
  echo
  echo "-d dbSNP build version. Set one from (${dbsnp_builds[@]}). Default: ${dbsnp_builds[0]}"
  echo "-r reference genome build version. Set one from (${reference_genome_builds[@]}). Default: ${reference_genome_builds[0]}"
  exit 1
}

# Parse args
while getopts ":d:r:" OPT; do
  case "${OPT}" in
    d)  dbsnp=${OPTARG};;
    r)  ref=${OPTARG};;
     \?) usage_exit;;
  esac
done
shift $((OPTIND - 1))

# Set defaults
: ${dbsnp:=${dbsnp_builds[0]}}
: ${ref:=${reference_genome_builds[0]}}

# TODO: check dbsnp_builds and reference_genome_builds in choices
# Check args
data_dir=$1
if [ -z "${data_dir}" ]; then
    usage_exit
fi

mkdir -p ${data_dir}
cd ${data_dir}

database="human_9606_${dbsnp}_${ref}"
echo "[INFO] Fetching data for ${database} to ${data_dir}..."

declare -A fpt_name=( \
  ["human_9606_b142_GRCh37"]="human_9606_b142_GRCh37p13" \
  ["human_9606_b142_GRCh38"]="human_9606_b142_GRCh38"    \
  ["human_9606_b144_GRCh37"]="human_9606_b144_GRCh37p13" \
  ["human_9606_b144_GRCh38"]="human_9606_b144_GRCh38p2"
)
declare -A SNPChrPosOnRef=( \
  ["human_9606_b142_GRCh37"]="b142_SNPChrPosOnRef_105" \
  ["human_9606_b142_GRCh38"]="b142_SNPChrPosOnRef_106" \
  ["human_9606_b144_GRCh37"]="b144_SNPChrPosOnRef_105" \
  ["human_9606_b144_GRCh38"]="b144_SNPChrPosOnRef_107"
)

wget -c ftp.ncbi.nih.gov/snp/organisms/${fpt_name[${database}]}/database/organism_data/RsMergeArch.bcp.gz{,.md5}                     # ~150 MB
wget -c ftp.ncbi.nih.gov/snp/organisms/${fpt_name[${database}]}/database/organism_data/${SNPChrPosOnRef[${database}]}.bcp.gz{,.md5}  # ~500 MB
wget -c ftp.ncbi.nih.gov/snp/database/shared_data/Allele.bcp.gz{,.md5}                                                               #  ~70 MB
wget -c ftp.ncbi.nih.gov/snp/database/shared_data/SnpChrCode.bcp.gz{,.md5}                                                           #   ~1 KB

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
cp ${SNPChrPosOnRef[${database}]}.bcp.gz SNPChrPosOnRef.bcp.gz

echo "[INFO] Done"
